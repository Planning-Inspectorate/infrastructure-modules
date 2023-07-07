# install puppet agent
# check if puppet is already installed
if ! rpm -qa | grep -q puppet ; then

  # if puppet master is specified then connect to it
  if [ ! -z "${puppet_master}" ]; then

    # create puppet environment directory if not production
    if [ ! -z "${puppet_agent_environment}" -a "${puppet_agent_environment}" != 'production' ]; then
      mkdir -p /etc/puppetlabs/code/environments/${puppet_agent_environment}
    fi

    # install puppet agent frictionless
    curl -k https://${puppet_master}:8140/packages/current/install.bash | sudo bash -s agent:environment=${puppet_agent_environment} custom_attributes:challengePassword=${puppet_autosign_key} extension_requests:pp_role=${puppet_role}
    
  fi
fi