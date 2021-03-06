#!/bin/sh

dhclient
yum install dovecot postfix cyrus-sasl cyrus-sasl-plain mailx -y
sed -i 's/#protocols =/protocols =/' /etc/dovecot/dovecot.conf
sed -i 's/emailAddress=postmaster@example.com/emailAddress=spam4kev@thefitz1.ddns.net/' /etc/pki/dovecot/dovecot-openssl.cnf
sed -i 's/CN=imap.example.com/CN=thefitz1.ddns.net/' /etc/pki/dovecot/dovecot-openssl.cnf
sed -i 's/#mail_location =/mail_location = mbox:~\/mail:INBOX=\/var\/mail\/\%u/' /etc/dovecot/conf.d/10-mail.conf
sed -i 's/#mail_privileged_group =/mail_privileged_group = mail/' /etc/dovecot/conf.d/10-mail.conf
sed -i 's/auth_mechanisms = plain/auth_mechanisms = plain login/' /etc/dovecot/conf.d/10-auth.conf
sed -i '/unix_listener \/var\/spool\/postfix\/private\/auth/,/  #\}/{s/#/ /g;}' /etc/dovecot/conf.d/10-master.conf
sed -i 's/#mydomain = domain.tld/mydomain = thefitz1.ddns.net/' /etc/postfix/main.cf
sed -i 's/#myorigin = $mydomain/myorigin = $mydomain/' /etc/postfix/main.cf
sed -i 's/#myhostname = host.domain.tld/myhostname = thefitz1.ddns.net/' /etc/postfix/main.cf
sed -i 's/#mynetworks = 168.100.189.0\/28/mynetworks = 0.0.0.0\/0/' /etc/postfix/main.cf
sed -i 's/inet_interfaces = localhost/inet_interfaces = all/' /etc/postfix/main.cf
sed -i 's/#relayhost = \[gateway.my.domain\]/relayhost = [smtp.verizon.net]/' /etc/postfix/main.cf
echo "0.0.0.0 OK" >> /etc/postfix/access
echo "# SASL " >> /etc/postfix/main.cf
echo "smtp_sasl_auth_enable = yes" >> /etc/postfix/main.cf
echo "smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd" >> /etc/postfix/main.cf
echo "smtpd_sasl_type = dovecot" >> /etc/postfix/main.cf
echo "smtpd_sasl_path = private/auth" >> /etc/postfix/main.cf
echo "broken_sasl_auth_clients = yes" >> /etc/postfix/main.cf
echo "smtp_sasl_security_options = noanonymous" >> /etc/postfix/main.cf
echo "smtpd_recipient_restrictions =" >> /etc/postfix/main.cf
echo "   permit_mynetworks" >> /etc/postfix/main.cf
echo "   permit_sasl_authenticated" >> /etc/postfix/main.cf
echo "   reject_unauth_destination " >> /etc/postfix/main.cf
echo "# TLS " >> /etc/postfix/main.cf
echo "smtpd_use_tls = yes" >> /etc/postfix/main.cf
echo "smtpd_tls_auth_only = yes" >> /etc/postfix/main.cf
echo "smtpd_tls_key_file = /etc/ssl/certs/smtpd.key" >> /etc/postfix/main.cf
echo "smtpd_tls_cert_file = /etc/ssl/certs/smtpd.crt" >> /etc/postfix/main.cf
echo "smtpd_tls_security_level = may" >> /etc/postfix/main.cf
echo "smtpd_tls_loglevel = 1" >> /etc/postfix/main.cf
echo "smtpd_tls_received_header = yes" >> /etc/postfix/main.cf
mv /etc/pki/dovecot/certs/dovecot.pem /tmp
mv /etc/pki/dovecot/private/dovecot.pem /tmp
/usr/libexec/dovecot/mkcert.sh
touch /etc/ssl/certs/smtpd.key
chmod 600 /etc/ssl/certs/smtpd.key
openssl genrsa 1024 > /etc/ssl/certs/smtpd.key
openssl req -new -key /etc/ssl/certs/smtpd.key -x509 -days 3650 -config /etc/pki/dovecot/dovecot-openssl.cnf -out /etc/ssl/certs/smtpd.crt
echo 'mailbox_command = /usr/libexec/dovecot/dovecot-lda -f "$SENDER" -a "$RECIPIENT"' >> /etc/postfix/main.cf
echo "root:           spam4kev" >> /etc/aliases
newaliases
firewall-offline-cmd --add-service=smtp
firewall-offline-cmd --add-service=ldap
firewall-offline-cmd --add-service=ldaps
firewall-offline-cmd --add-port=143/tcp
firewall-offline-cmd --add-service=imaps
echo "[smtp.verizon.net] dovecot1:$(openssl rand -base64 32)" > /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd 
chmod 600 /etc/postfix/sasl_passwd.db /etc/postfix/sasl_passwd
systemctl enable dovecot.service
systemctl enable postfix.service
systemctl start postfix.service
systemctl start dovecot.service
