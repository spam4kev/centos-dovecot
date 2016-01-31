FROM centos:latest
MAINTAINER "kev" spam4kev@gmail.com
#
EXPOSE 143 993 25 

RUN yum update -y
RUN yum install -y dovecot && \
    sed -i 's/#protocols =/protocols =/' /etc/dovecot/dovecot.conf && \
    sed -i 's/CN=imap.example.com/CN=dovecot.fitznet.local/' /etc/pki/dovecot/dovecot-openssl.cnf && \
    sed -i 's/emailAddress=postmaster@example.com/emailAddress=spam4kev@gmail.com/' /etc/pki/dovecot/dovecot-openssl.cnf && \
    sed -i 's/#mail_location =/mail_location = mbox:~\/mail:INBOX=\/var\/mail\/\%u/' /etc/dovecot/conf.d/10-mail.conf && \
    sed -i 's/#mail_privileged_group =/mail_privileged_group = mail/' /etc/dovecot/conf.d/10-mail.conf && \
    sed -i 's/auth_mechanisms = plain/auth_mechanisms = plain login/' /etc/dovecot/conf.d/10-auth.conf && \
    sed -i '/unix_listener \/var\/spool\/postfix\/private\/auth/,/  #\}/{s/#/ /g;}' /etc/dovecot/conf.d/10-master.conf && \
    mv /etc/pki/dovecot/certs/dovecot.pem /tmp && \
    mv /etc/pki/dovecot/private/dovecot.pem /tmp && \
    /usr/libexec/dovecot/mkcert.sh
