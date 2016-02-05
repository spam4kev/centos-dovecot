# centos-dovecot
MTA IMAP Email server

-  for using in openstack, pass this as userdata
#!/bin/sh
curl https://raw.githubusercontent.com/spam4kev/centos-dovecot/master/userData.sh -o userdata.sh
chmod +x ./userdata.sh
./userdata.sh
