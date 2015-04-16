
For every data dump, please create a subfolder in /data that is named to the
current ISO timestamp.

The folder structure should look like:

    /data/<current iso timestamp>/[the datafiles here]

For example, a new dump on sept 7 would look like:

    /data/2014-09-07T16:45:31Z/datafile.csv

Here's a command that can be used to get the current ISO timestamp:

    date -u +"%Y-%m-%dT%H:%M:%SZ"



Any public key contained in the /keys directory will be used for authentication
If you want to login using another key, simply drop the public key file in the
directory.

Keys can be generated using the following command:

    ssh-keygen -b 4096

If ssh-keygen is unavailable, you can use openssl:

    openssl genrsa -out private_key.pem 4096
    openssl rsa -pubout -in private_key.pem -out public_key.pem

Just drop the public key file in the /keys directory. You can also append it to
an existing file.