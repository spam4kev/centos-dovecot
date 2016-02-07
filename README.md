# centos-dovecot
MTA IMAP Email server

-  for deploying in a CentOS7 VM in openstack, pass this as userdata (confirmed working with RDO packstack deploy of Liberty release)a
  -  change the pub key in yml file to your own before deploy
  -  If your ISP requires authentication for relay, uncomment the sasl commands and after deploy use the random pw in sasl_passwd to set an ISP sub account.
  -  copy paste the userData.yml into the userdata field in openstack when creating the instance.
  -  log in after deploy and set the spam4kev user password so mail clients will have a pw to use when connecting
