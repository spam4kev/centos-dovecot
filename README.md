# centos-dovecot
MTA IMAP Email server

-  for deploying in a CentOS7 VM in openstack, pass this as userdata (confirmed working with RDO packstack deploy of Liberty release)
```bash
#!/bin/sh
dhclient
curl https://raw.githubusercontent.com/spam4kev/centos-dovecot/master/userData.sh -o userdata.sh
chmod +x ./userdata.sh
./userdata.sh
```
