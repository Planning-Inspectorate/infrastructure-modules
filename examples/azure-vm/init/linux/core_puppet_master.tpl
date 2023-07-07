set -e

# Extend /usr & /var logical volumes
lvextend -L +10G /dev/rootvg/usrlv
lvextend -L +12G /dev/rootvg/varlv

# Extend /usr & /var filesystems
xfs_growfs /dev/rootvg/usrlv
xfs_growfs /dev/rootvg/varlv

# Create LVM physical volume
pvcreate /dev/sdc

# Create volume group
vgcreate datavg /dev/sdc

# Calculate logical volume sizes 
VG_FREESPACE=`vgdisplay datavg | grep "Free  PE" | awk '{print $5}'`
(( LV_SIZE = VG_FREESPACE /4 ))

# Create logical volumes
lvcreate -l $LV_SIZE -n puppetlv01 datavg
lvcreate -l 100%FREE -n puppetlv02 datavg

# Create filsystems
mkfs.xfs /dev/datavg/puppetlv01
mkfs.xfs /dev/datavg/puppetlv02

# Update /etc/fstab and create mount points
echo "/dev/mapper/datavg-puppetlv01 /etc/puppetlabs       xfs   defaults         0 0" >> /etc/fstab
echo "/dev/mapper/datavg-puppetlv02 /opt/puppetlabs       xfs   defaults         0 0" >> /etc/fstab
mkdir -p /etc/puppetlabs
mkdir -p /opt/puppetlabs

# Mount filesystems
mount /etc/puppetlabs
mount /opt/puppetlabs

# Setup Puppetmaster Replica if role puppetmaster_replica
if [[ ${pe_console_url} =~ .*production* ]] && [ ${pe_puppet_role} = puppetmaster_replica ]
then
  set +e
  if [[ ${pe_console_url} =~ .*northeurope* ]]
  then
    puppet_master=`echo ${pe_console_url} | sed 's/northeurope/westeurope/g'`
  elif [[ ${pe_console_url} =~ .*westeurope* ]]
  then
    puppet_master=`echo ${pe_console_url} | sed 's/westeurope/northeurope/g'`
  fi

  echo "Waiting for Primary Master to come online"
  while true; do
    curl -s -k https://$${puppet_master}:8140/status/v1/simple/pe-master | grep running
    if [ $? -eq 0 ]
    then
      curl -k https://$${puppet_master}:8140/packages/current/install.bash | sudo bash -s main:dns_alt_names=${pe_console_url} main:environment=production custom_attributes:challengePassword=${puppet_autosign_key} extension_requests:pp_role=${pe_puppet_role}
      # Setup Skip Hardening true whilst we build puppetmasters
      echo "skip_hardening: true" > /opt/puppetlabs/facter/facts.d/skip_hardening.yaml
      break
    fi
    printf "." > /dev/console
    sleep 1
  done
  exit 0
fi
     
# Control Repo
control_repo_url="git@bitbucket.org:${bitbucket_team}/${control_repo_name}.git"

# Control prefix
control_prefix=`echo ${control_repo_name} | sed 's/^puppet-//'`

# Download Puppet Enterprise installer
pe_source="https://s3.amazonaws.com/pe-builds/released/${pe_version}/puppet-enterprise-${pe_version}-el-7-x86_64.tar.gz"
curl --location $pe_source | tar xz --strip-components=1 --directory /tmp

# Create keys
mkdir -p /etc/puppetlabs/puppetserver/ssh
ssh-keygen -f /etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa -N ''

# Create csr attributes
mkdir -p /etc/puppetlabs/puppet
cat > /etc/puppetlabs/puppet/csr_attributes.yaml << YAML
extension_requests:
  pp_role: ${pe_puppet_role}
YAML

# Install Puppet Enterprise"
cat > /tmp/pe.conf <<-EOF 
{
"console_admin_password": "${pe_console_admin_password}",
"puppet_enterprise::puppet_master_host": "$(hostname --fqdn)",
"pe_install::puppet_master_dnsaltnames": ["puppet", "${pe_console_url}"],
"puppet_enterprise::profile::master::code_manager_auto_configure": true,
"puppet_enterprise::master::code_manager::sources": {
    "$${control_prefix}": {
        "remote": "$${control_repo_url}",
        "prefix": false,
    }
}
"puppet_enterprise::master::code_manager::git_settings": {
    "private-key": "/etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa",
}
"puppet_enterprise::profile::master::code_manager::timeouts_sync": "1200",
"puppet_enterprise::profile::master::code_manager::timeouts_deploy": "1200",
"puppet_enterprise::profile::master::code_manager::timeouts_wait": "1200",
"puppet_enterprise::master::code_manager::deploy_pool_size": 10,
"puppet_enterprise::master::code_manager::download_pool_size": 8,
"puppet_enterprise::puppetdb_port": "8091",
}
EOF

/tmp/puppet-enterprise-installer -c /tmp/pe.conf

# Add deploy key to control repo
curl -X POST --user "${bitbucket_username}:${bitbucket_password}" \
"https://api.bitbucket.org/2.0/repositories/${bitbucket_team}/${control_repo_name}/deploy-keys" \
--data-urlencode "key=$(cat /etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa.pub)" \
--data-urlencode "label=${pe_console_url}"

# Read Puppetfile and add deploy key to all repos
curl -X GET --user "${bitbucket_username}:${bitbucket_password}" \
"https://api.bitbucket.org/2.0/repositories/${bitbucket_team}/${control_repo_name}/src/production/Puppetfile" \
| grep -oP "^[^#].+ssh:\/{2}git@bitbucket\.org\/${bitbucket_team}\/\K.+(?=\.git)" | while read -r repo; do
  curl -X POST --user "${bitbucket_username}:${bitbucket_password}" \
  "https://api.bitbucket.org/2.0/repositories/${bitbucket_team}/$repo/deploy-keys" \
  --data-urlencode "key=$(cat /etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa.pub)" \
  --data-urlencode "label=${pe_deploy_key_label}"
done

# Hiera eyaml keys provided from keyvault
mkdir -p /etc/puppetlabs/puppet/eyaml
echo "${pe_eyaml_private_key}" | sed 's/- /-\n/g; s/ -/\n-/g' | sed '/RSA/! s/ /\n/g' > /etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem
echo "${pe_eyaml_public_key}" | sed 's/- /-\n/g; s/ -/\n-/g' | sed '/CERTIFICATE/! s/ /\n/g' > /etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem
service pe-puppetserver reload
chown -R pe-puppet:pe-puppet /etc/puppetlabs/puppet/eyaml
chmod -R 0500 /etc/puppetlabs/puppet/eyaml
chmod 0400 /etc/puppetlabs/puppet/eyaml/*.pem

# Login to puppet and generate token
echo "${pe_console_admin_password}" | puppet access login --username admin --lifetime=10y

# add webhook to control repo
token=`cat /.puppetlabs/token`
webhook="https://${pe_public_ip}:8170/code-manager/v1/webhook?type=bitbucket&token=$token"
curl -X POST --user "${bitbucket_username}:${bitbucket_password}" -H 'Content-Type: application/json' \
"https://api.bitbucket.org/2.0/repositories/${bitbucket_team}/${control_repo_name}/hooks" --data "
{
  \"description\": \"${pe_webhook_label}\",
  \"url\": \"$webhook\",
  \"active\": true,
  \"skip_cert_verification\": true,
  \"events\": [
    \"repo:push\"
  ]
}"

# Change ownership of SSH Key
chown -R pe-puppet:pe-puppet /etc/puppetlabs/puppetserver/ssh

# Puppet Code Deploy 
/opt/puppetlabs/bin/puppet-code deploy production --wait --token-file=/.puppetlabs/token

# Cleanup
rm -rf /tmp/pe.conf
rm -rf /tmp/keys
rm -rf /tmp/puppet-enterprise-installer
rm -rf /tmp/puppet-enterprise-uninstaller

# Setup Skip Hardening true whilst we build puppetmasters
echo "skip_hardening: true" > /opt/puppetlabs/facter/facts.d/skip_hardening.yaml

# Wait for puppet console ui
end=$((SECONDS+1500))
echo "Waiting for $(hostname --fqdn) Console UI"
set +e
while [ $SECONDS -lt $end ]; do
  if curl -sk "https://${pe_console_url}/auth/login?redirect=/" | grep -q 'Log In | Puppet Enterprise' ; then
    # run puppet agent a few times to complete configuration
    /opt/puppetlabs/bin/puppet agent --onetime --no-daemonize
    /opt/puppetlabs/bin/puppet agent -t
    break
  fi
  printf "." > /dev/console
  sleep 1
done
echo "Console UI ready"

if [[ ${pe_console_url} =~ .*production* ]] && [ ${pe_puppet_role} = puppetmaster_primary ]
then
  set +e
  if [[ ${pe_console_url} =~ .*northeurope* ]]
  then
    pe_puppetmaster_replica_cname=`echo ${pe_console_url} | sed 's/northeurope/westeurope/g'`
  elif [[ ${pe_console_url} =~ .*westeurope* ]]
  then
    pe_puppetmaster_replica_cname=`echo ${pe_console_url} | sed 's/westeurope/northeurope/g'`
  fi

  # Sign certificate for puppetmaster replica
  /opt/puppetlabs/bin/puppetserver ca sign --certname ${pe_puppetmaster_replica}

  # Wait for Puppetmaster Replica to be ready
  echo "Waiting for puppet master replica to check in"
  auth_header="X-Authentication: $(/opt/puppetlabs/bin/puppet-access show --token-file=/.puppetlabs/token)"
  uri="https://${pe_console_url}:8143/orchestrator/v1/inventory"    
  while true; do
    curl -s --insecure --header "$auth_header" "$uri" | grep ${pe_puppetmaster_replica}
    if [ $? -eq 0 ]
    then

      sleep 60
      pe_puppetmaster_primary_cname=`echo ${pe_console_url}`
    
      echo "Provision Puppet Master Primary and Replica partnership"
      /opt/puppetlabs/bin/puppet infrastructure provision replica ${pe_puppetmaster_replica} --token-file=/.puppetlabs/token \
      --enable \
      --topology mono \
      --yes \
      --agent-server-urls       $${pe_puppetmaster_primary_cname}:8140,$${pe_puppetmaster_replica_cname}:8140 \
      --infra-agent-server-urls $${pe_puppetmaster_primary_cname}:8140,$${pe_puppetmaster_replica_cname}:8140 \
      --pcp-brokers             $${pe_puppetmaster_primary_cname}:8142,$${pe_puppetmaster_replica_cname}:8142 \
      --infra-pcp-brokers       $${pe_puppetmaster_primary_cname}:8142,$${pe_puppetmaster_replica_cname}:8142 \
      --master-uris             $${pe_puppetmaster_primary_cname}:8140,$${pe_puppetmaster_replica_cname}:8140 \
      --infra-master-uris       $${pe_puppetmaster_primary_cname}:8140,$${pe_puppetmaster_replica_cname}:8140 \
      --puppetdb-termini        $${pe_puppetmaster_primary_cname}:8091,$${pe_puppetmaster_replica_cname}:8091 \
      --classifier-termini      $${pe_puppetmaster_primary_cname}:4433,$${pe_puppetmaster_replica_cname}:4433 
      break
    fi
    printf "." > /dev/console
    sleep 1
  done
fi