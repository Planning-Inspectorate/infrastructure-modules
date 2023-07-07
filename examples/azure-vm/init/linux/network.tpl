# set hostname in hosts
ip4=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
if ! grep -Fq "$${ip4} $(hostname).${dns_suffix} $(hostname)" /etc/hosts ; then
  echo "$${ip4} $(hostname).${dns_suffix} $(hostname)" >> /etc/hosts
fi

# Ensure Hiscox Domain search is setup using NetworkManager
NM_UUID=$(/bin/nmcli -f UUID con show | grep -v UUID)
 
/bin/nmcli | grep "domains: ${dns_suffix} hiscox.com" > /dev/null 2>&1
if [ $? != 0 ]
then
  for i in $NM_UUID
  do
    /bin/nmcli con modify $i ipv4.dns-search "${dns_suffix} hiscox.com" > /dev/null 2>&1
    /bin/nmcli con modify $i ipv4.dns-options "options ndots:2 timeout:2 attempts:2" > /dev/null 2>&1
    /bin/nmcli con up $i  > /dev/null 2>&1
  done
fi

# turn off local firewall as we have subnet and NIC level NSGs
systemctl stop firewalld.service
systemctl disable firewalld.service

# do the proxy thing...
if [[ "${proxy_url}" != "no_proxy" ]]; then
  # set yum proxy
  if grep -Fq "proxy=" /etc/yum.conf ; then
    sed -i "s/^\(proxy\s*=\s*\).*$/\1\"${proxy_url}\"/" /etc/yum.conf
  else
    echo "proxy=${proxy_url}" >> /etc/yum.conf
  fi
fi

# yum update
yum update -y --disablerepo='*' --enablerepo='*microsoft*'
yum clean all

echo "Waiting for RPM lock to release"
while true; do
  sleep 60
  pgrep rpm > /dev/null
  if [ $? -ne 0 ]
  then
    echo "RPM lock released continuing to next step"
    break
  fi
done

yum update -y -q -e 0