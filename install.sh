#!/bin/bash
# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done
# install R
amazon-linux-extras install R4 -y
# download Rstudio connect package
curl -O https://cdn.rstudio.com/connect/2022.05/rstudio-connect-2022.05.0.amazonlinux2.x86_64.rpm
yum install rstudio-connect-2022.05.0.amazonlinux2.x86_64.rpm -y
#adjust config
sed -ie "s+Listen = \":3939\"+Listen = \":80\"+g" /etc/rstudio-connect/rstudio-connect.gcfg
