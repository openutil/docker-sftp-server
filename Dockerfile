FROM ubuntu:14.04

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN useradd --shell /sbin/nologin --home-dir /sftp --no-create-home 42-data

RUN mkdir -p /sftp

ADD ./data/sshd_config /etc/ssh/sshd_config
ADD ./data/get-keys.sh /get-keys.sh
ADD ./data/sftp.sh     /sftp.sh

RUN chmod +x /sftp.sh
RUN chmod +x /get-keys.sh

VOLUME /sftp
VOLUME /config

EXPOSE 22

CMD ["/sftp.sh"]
