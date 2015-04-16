FROM ubuntu:14.04

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN groupadd sftpusers
RUN useradd --shell /sbin/nologin --home-dir /sftp --no-create-home -G sftpusers data
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
