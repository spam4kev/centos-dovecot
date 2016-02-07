# centos-dovecot
MTA IMAP Email server

-  for deploying in a CentOS7 VM in openstack, pass this as userdata (confirmed working with RDO packstack deploy of Liberty release)a
  -  because this setup uses an ISP SMTP as a send relay, the sasl-passwords.db file must contain an active account username/password
  -  copy paste the userData.yml into the userdata field in openstack when creating the instance.
