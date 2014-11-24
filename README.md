
# SFTP Server

### Quickstart

On your host machine:

```bash
# cloning this repository
cd /opt
git clone https://github.com/42technologies/docker-sftp-server.git

# making initial directory structure
# - "data" directory will hold the data from sftp servers
# - "keys" directory can hold public keys that will allow login to ALL sftp servers
mkdir -p ./sftp/{data,keys}

# (optional) creating a key for global login
ssh-keygen -b 4096 -f ./sftp/sftp.key -q -N ""
cp ./sftp/sftp.key.pub ./sftp/keys

# building the docker image
docker build -t 42technologies/sftp docker-sftp-server

# running the sftp server
./docker-sftp-server/sftp-run.sh /opt/sftp jacobmarks 9000

# (optional) you can install public keys to allow login into the "jacobmarks" container
# cp jacobmarks.key.pub ./sftp/data/jacobmarks/keys

# (optional) or you can use the script to set a text password
# ./sftp-passwd.sh /opt/sftp jacobmarks

# connecting to the sftp server
sftp -i ./sftp/sftp.key -P 9000 42-data@localhost
```


### Detailed Installation Instructions

#### Clone this repo and stick it somewhere

```
cd /opt
git clone https://github.com/42technologies/docker-sftp-server.git
```

#### Create initial folder structure

```
mkdir -p /opt/sftp/{data, keys}
```

In the scripts, there is mention of a `<root>` argument. In this example, the `<root>` is `/opt/sftp`.

- The `/opt/sftp/data` directory will contain the data from the SFTP servers.
- The `/opt/sftp/keys` directory can hold public keys that will allow login to ALL sftp servers

#### Building the docker image

```
docker build -t 42technologies/sftp docker-sftp-server
```


### Creating an SFTP server for an organization 

Let's create an sftp container for organization `jacobmarks` that will
run on port `10000`:

```
/opt/docker-sftp-server/sftp-run.sh /opt/sftp jacobmarks 10000
```

This creates a container that exposes it's SSH server via port `10000`. You
SFTP into the server by using `42-data` as the username, and port `10000`.

The `sftp-run.sh` script will create the directory `<root>/data/jacobmarks`.
That folder will contain the folders/files in the container's `/sftp` directory.


### Authentication

#### Global Login

Access to all SFTP servers can be done by placing your public key in the `/opt/sftp/keys` folder.
This folder can contain any number of keys.

#### Per-Organization Login

After running the `sftp-run.sh` script for an organization, the organization's directory structure
will be initialized. You will then be able to place public keys in the `/opt/sftp/data/<organization>/keys`
directory.

If you want to use password-based authentication, you can use the `sftp-passwd.sh` script:

```
./sftp-passwd.sh <root> <organization>
```

#### Generating a key pair

Just as a reference, here's how you can generate keys using `ssh-keygen`:

```
ssh-keygen -b 4096
```


### Creating temporary containers, for testing

```
docker run -it \
-p <port>:22 \
-v /etc \
-v /home/core/sftp/keys:/keys \
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

Note that the private key is not necessary if you have set a password.


### How does this work?

We create a container per organization. A port is assigned per organization.
Each container runs an ssh server. The container has a single user called `42-data`.
This user cannot SSH into the container, it only works for SFTP. The SFTP root is
jailed to the container folder `/sftp`.

The SFTP folder should contain two directories:

- `/sftp/data`, for data files
- `/sftp/keys`, for public keys (this will let you log into ALL sftp servers)

The `/sftp` folder is actually a volume that is shared with the host. The container's
`/keys` directory, which contains the 42 public keys, is also shared.

We use the `AuthorizedKeysCommand` directive to get the list of authorized public keys.
The directive calls the `/get-keys.sh` script, which concatenates the files in `/keys`
with the ones in `/sftp/keys`.




