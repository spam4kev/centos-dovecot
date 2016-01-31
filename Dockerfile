FROM centos:latest
MAINTAINER "kev" spam4kev@gmail.com
#
EXPOSE 143 993 25 

RUN yum update -y
RUN yum install -y dovecot && \
    sed -i 's/#protocols =/protocols =/' /etc/dovecot/dovecot.conf && \
    sed -i 's/CN=imap.example.com/CN=dovecot.fitznet.local/' /etc/dovecot/dovecot.conf && \
    sed -i 's/emailAddress=postmaster@example.com/emailAddress=spam4kev@gmail.com/' /etc/dovecot/dovecot.conf && \
    mv /etc/pki/dovecot/certs/dovecot.pem /tmp && \
    /usr/libexec/dovecot/mkcert.sh
