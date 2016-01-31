FROM centos:latest
MAINTAINER "kev" spam4kev@gmail.com

EXPOSE 143 993 25 

RUN yum update
RUN yum install -y wget \
		   dovecot
