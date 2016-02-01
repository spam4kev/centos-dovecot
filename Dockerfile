FROM centos:latest
MAINTAINER "kev" spam4kev@gmail.com
#
EXPOSE 143 993 25 

RUN yum update -y
RUN yum install -y dovecot \
                   postfix && \
    useradd -u 2002 fitzhenk && \
    sed -i 's/#protocols =/protocols =/' /etc/dovecot/dovecot.conf && \
    echo 'postmaster_address = spam4kev@gmail.com' >> /etc/dovecot/dovecot.conf && \
    sed -i 's/CN=imap.example.com/CN=dovecot.fitznet.local/' /etc/pki/dovecot/dovecot-openssl.cnf && \
    sed -i 's/emailAddress=postmaster@example.com/emailAddress=spam4kev@gmail.com/' /etc/pki/dovecot/dovecot-openssl.cnf && \
    sed -i 's/#mail_location =/mail_location = mbox:~\/mail:INBOX=\/var\/mail\/\%u/' /etc/dovecot/conf.d/10-mail.conf && \
    sed -i 's/#mail_privileged_group =/mail_privileged_group = mail/' /etc/dovecot/conf.d/10-mail.conf && \
    sed -i 's/auth_mechanisms = plain/auth_mechanisms = plain login/' /etc/dovecot/conf.d/10-auth.conf && \
    sed -i '/unix_listener \/var\/spool\/postfix\/private\/auth/,/  #\}/{s/#/ /g;}' /etc/dovecot/conf.d/10-master.conf && \
    sed -i 's/#mydomain = domain.tld/mydomain = fitznet.local/' /etc/postfix/main.cf && \
    sed -i 's/#myorigin/myorigin/' /etc/postfix/main.cf && \
    sed -i 's/#myhostname = host.domain.tld/myhostname = dovecot.fitznet.local/' /etc/postfix/main.cf && \
    sed -i 's/#mynetworks = 168.100.189.0\/28/mynetworks = 10.11.11.0\/24/' /etc/postfix/main.cf && \
    sed -i 's/inet_interfaces = localhost/inet_interfaces = all/' /etc/postfix/main.cf && \
    echo "0.0.0.0 OK" >> /etc/postfix/access && \
    echo "smtpd_sasl_type = dovecot" >> /etc/postfix/main.cf && \
    echo "smtpd_sasl_path = private/auth" >> /etc/postfix/main.cf && \
    echo "smtpd_sasl_auth_enable = yes" >> /etc/postfix/main.cf && \
    echo "broken_sasl_auth_clients = yes" >> /etc/postfix/main.cf && \
    echo "smtpd_recipient_restrictions =" >> /etc/postfix/main.cf && \
    echo "   permit_mynetworks" >> /etc/postfix/main.cf && \
    echo "   permit_sasl_authenticated" >> /etc/postfix/main.cf && \
    echo "   reject_unauth_destination " >> /etc/postfix/main.cf && \
    echo "smtpd_tls_key_file = /etc/ssl/certs/smtpd.key" >> /etc/postfix/main.cf && \
    echo "smtpd_tls_cert_file = /etc/ssl/certs/smtpd.crt" >> /etc/postfix/main.cf && \
    mv /etc/pki/dovecot/certs/dovecot.pem /tmp && \
    mv /etc/pki/dovecot/private/dovecot.pem /tmp && \
    /usr/libexec/dovecot/mkcert.sh && \
    touch /etc/ssl/certs/smtpd.key && \
    chmod 600 /etc/ssl/certs/smtpd.key && \
    openssl genrsa 1024 > /etc/ssl/certs/smtpd.key && \
    openssl req -new -key /etc/ssl/certs/smtpd.key -x509 -days 3650 -config /etc/pki/dovecot/dovecot-openssl.cnf -out /etc/ssl/certs/smtpd.key && \
    echo 'mailbox_command = /usr/libexec/dovecot/dovecot-lda -f "$SENDER" -a "$RECIPIENT"' >> /etc/postfix/main.cf && \
    echo "root:           fitzhenk" >> /etc/aliases && \
    newaliases
CMD postfix start && /usr/sbin/dovecot -F -c /etc/dovecot/dovecot.conf
