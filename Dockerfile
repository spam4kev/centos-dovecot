FROM centos:latest
MAINTAINER "kev" spam4kev@gmail.com
#
EXPOSE 143 993 25 

RUN yum update -y
RUN yum install -y wget \
		   dovecot
