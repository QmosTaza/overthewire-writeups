# BANDIT Level 13 -> 14


## GOAL
To find the password by connecting to another user with a private SSH key.


## CONTEXT
SSH keys are a pair of cryptographic files used to authenticate securely to a remote system without typing a password. The private key is kept secret on your computer, while the public key is copied to the server and stored in the '~/.ssh/authorized_keys' file. When you connect, SSH proves that you possess the private key that matches the public key, allowing access without transmitting a password over the network. 

SSH keys are more secure and more convenient than password-based authentication and are widely used for server administration, automation, and services like GitHub and GitLab.


## STEPS
In this level, we are meant to take a given, private SSH key and use it to connect into the bandit14 user to retrieve the password from a given file path (only bandit14 has the needed permissions to read said file).

To do that, because of the restrictions put in place by the overthewire.org team, we will need to copy the SSH key to our own computer and connect from there like we would do normally, only this time using the private key instead of the password.

We are able to do this with the command `scp`, which allows you to copy files from a server to another securely. In our **local machine** (*outside the server*), we will run the following command:

```bash
scp -P 2220 bandit13@bandit.labs.overthewire.org:~/sshkey.private ./
# You will be asked to introduce the password to level 13

# Alternatively, you may use:
#       sshpass -p *password here* scp -P [...]
# to not have to write the password
```

That will copy the private SSH key to your own computer. We will use this private key to connect through SSH by adding a modification to our usual `ssh` command.

```bash
ssh -i ./sshkey.private -p 2220 bandit14@bandit.labs.overthewire.org
```

Unfortunately, this command will give us an error, since the current key saved into your computer is readable by people in your group, and we only want it to be readable by the owner (user). To change this, we can use the command `chmod` which modifies the ownership of a file or directory (see 'ADDITIONAL CONTEXT'). In this case we want the owner to have read/write permissions and everyone else to have no permissions. We can do this as follows:

```bash
chmod 600 ./sshkey.private
```

Afterwards, completing the level should be quite simple:

```bash
ssh -i ./sshkey.private -p 2220 bandit14@bandit.labs.overthewire.org
cat /etc/bandit_pass/bandit14
```


## ADDITIONAL CONTEXT
As explained before, the `chmod` command changes the permissions of files and directories in Linux. 

Permissions can be specified numerically, such as `chmod 755 file`, where the digits represent read (4), write (2), and execute (1) permissions for the owner, group, and others (in this order). For example, `7` means read, write, and execute (4+2+1) and `700` means that the owner has all three permissions while everyone else has none. 

Permissions can also be modified symbolically, such as `chmod +r` file to add read permission for everyone or `chmod u-x` file to remove execute permission from the owner only. This makes it easy either to set all permissions explicitly or to adjust specific permissions as time goes on.


## SUMMARY
We have used a private SSH key to connect to another user and retrieve the password.
