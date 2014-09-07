
# SFTP Server


### How does this work?

We create a container per organization. A port is assigned per organization.
Each container runs an ssh server. The container has a single user called `42-data`.
This user cannot SSH into the container, but it can use to SFTP. The SFTP folder is
jailed to the container folder `/sftp`.

All public keys contained in `/sftp/keys` will be used for authentication. For our own
purposes, the container will mount a volume that will contain our (42) public keys, and
match against those. This allows us to SFTP into the container.

The container's `/sftp` folder is actually available to the host via host mounts.
The `sftp-run.sh` script sets up the host mounting. You will have to give it a root directory
that it will use to build the mount directory structure.


### Configuration

1. Create a folder that will contain the sftp data:

```
mkdir /home/core/sftp/data
```

The container will mount this directory under `/sftp`. When you invoke the `sftp-run.sh`
script, it will create a subdirectory that follows: `/data/<organization>`



2. Create a folder that will contain the 42 public keys:

```
mkdir /home/core/sftp/keys
```

The container will mount this directory under `/keys`, and will validate against
all the files contained in this directory.



### Building the docker image

```
docker build -t 42technologies/sftp .
```


### Creating docker containers

Let's create an sftp container for organization `jacobmarks` that will
run on port `1000`:

```
./sftp-run.sh /home/core jacobmarks 10000
```

This creates a container that exposes it's SSH server via port `10000`. You
SFTP into the server by using `42-data` as the username, and port `10000`.


### Creating temporary containers, for testing

```
docker run -i -t -p \
1234:22 \
-v /home/core/keys:/keys \
42technologies/sftp bash
```

That should give you a shell with the sftp environment. To run SSHD in debug mode, do this:

```
/usr/sbin/sshd -d
```


### Connecting to the SFTP server

On some random machine, you can connect to the SFTP server by doing:

```
sftp -i <private key> -P <port> 42-data@<host>
```


### Generating a key pair

Just as a reference, here's how you can generate keys using `ssh-keygen`:

```
ssh-keygen -b 4096
```