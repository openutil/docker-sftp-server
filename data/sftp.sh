#!/bin/sh

set -e
set -o xtrace

mkdir -p /sftp/data
mkdir -p /sftp/keys

chown -R 42-data:sftpusers /sftp
chown root:sftpusers /sftp
chmod -R 750 /sftp

exec /usr/sbin/sshd -D