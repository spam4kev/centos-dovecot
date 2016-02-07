# centos-dovecot
MTA IMAP Email server

-  for deploying in a CentOS7 VM in openstack, pass this as userdata (confirmed working with RDO packstack deploy of Liberty release)a
  -  If your ISP requires authentication for relay, uncomment the sasl commands and after deploy use the random pw in sasl_passwd to set an ISP sub account.
  -  copy paste the userData.yml into the userdata field in openstack when creating the instance.
