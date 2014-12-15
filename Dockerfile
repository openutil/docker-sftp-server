FROM ubuntu:14.04

MAINTAINER Nicolas Porter <nick@42technologies.com>

# RUN sed -i 's/trusty/vivid/g' /etc/apt/sources.list
# RUN echo nameserver 8.8.8.8 > /etc/resolv.conf
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN groupadd sftpusers
RUN useradd --shell /sbin/nologin --home-dir /sftp --no-create-home -G sftpusers 42-data
RUN mkdir -p /sftp

ADD ./data/sshd_config /etc/ssh/sshd_config
ADD ./data/sshd.conf   /etc/rsyslog.d/sshd.conf
ADD ./data/get-keys.sh /get-keys.sh
ADD ./data/sftp.sh     /sftp.sh
ADD ./data/readme.txt  /sftp/readme.txt

RUN chmod +x /sftp.sh
RUN chmod +x /get-keys.sh

VOLUME /etc
VOLUME /sftp

EXPOSE 22

CMD ["/sftp.sh"]
