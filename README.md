
# SFTP Server


### How does this work?

We create a container per organization. A port is assigned per organization.
Each container runs an ssh server. The container has a single user called `42-data`.
This user cannot SSH into the container, it only works for SFTP. The SFTP root is
jailed to the container folder `/sftp`.

The SFTP folder should contain two directories:

- `/sftp/data`, for data files
- `/sftp/keys`, for public keys

The `/sftp` folder is actually a volume that is shared with the host. The container's
`/keys` directory, which contains the 42 public keys, is also shared.

We use the `AuthorizedKeysCommand` directive to get the list of authorized public keys.
The directive calls the `/get-keys.sh` script, which concatenates the files in `/keys`
with the ones in `/sftp/keys`.


### Initial host configuration

#### Creating folders

```
mkdir -p /home/core/sftp/{data, keys}
```

When you run the scripts, the `<root>` argument refers to `/home/core/sftp` in this example.


#### Building the docker image

```
docker build -t 42technologies/sftp .
```


### Creating docker containers

Let's create an sftp container for organization `jacobmarks` that will
run on port `10000`:

```
./sftp-run.sh /home/core/sftp jacobmarks 10000
```

This creates a container that exposes it's SSH server via port `10000`. You
SFTP into the server by using `42-data` as the username, and port `10000`.

The `sftp-run.sh` script will create the directory `<root>/data/jacobmarks`.
That folder will contain the folders/files in the container's `/sftp` directory.


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


### Setting password

Call the `sftp-passwd.sh` script:

```
./sftp-passwd.sh <root> <organization>
```


### Connecting to the SFTP server

On some random machine, you can connect to the SFTP server by doing:

```
sftp -i <private key> -P <port> 42-data@<host>
```

Note that the private key is not necessary if you have set a password.


### Generating a key pair

Just as a reference, here's how you can generate keys using `ssh-keygen`:

```
ssh-keygen -b 4096
```
