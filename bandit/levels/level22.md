# BANDIT Level 22 -> 23


## GOAL
To find the next password by analysing a running cronjob.


## CONTEXT
MD5 is a hashing algorithm that converts any input (a file, a string, or any sequence of bytes) into a fixed 128-bit value, usually displayed as a 32-character hexadecimal string. The same input always produces the same hash, while even a tiny change in the input produces a completely different result. 

MD5 is commonly used to verify file integrity, although it is no longer considered secure for cryptographic purposes because collisions can be generated. By comparing hashes, we can check whether two files are identical or whether a file has been altered.


## STEPS
The start of this level is basically the same as the previous one, so we will skim through the first commands...

```bash
cd /etc/cron.d/
ls -l
cat cronjob_bandit23
cat /usr/bin/cronjob_bandit23.sh
```

... to arrive to the following code:

```bash
#!/bin/bash

myname=$(whoami)
mytarget=$(echo I am user $myname | md5sum | cut -d ' ' -f 1)

echo "Copying passwordfile /etc/bandit_pass/$myname to /tmp/$mytarget"

cat /etc/bandit_pass/$myname > /tmp/$mytarget
```

We should be somewhat familiar with most commands aside from `md5sum`, which we can read on its manual computes an MD5 message digest (aka. a hash of a file) and prints both the hash and the filename.

The script saves the user's name (in this case `bandit23`, since the cronjob is being run by this user) as a variable "myname". Then, it computes the hash to "I am user bandit23" and saves said hash as "mytarget". Finally, it copies the password we need to a `/tmp/**mytarget**` file. Meaning that if we compute "mytarget" ourselves, we will learn of the location of the file:

```bash
TARGET=$(echo I am user bandit23 | md5sum | cut -d ' ' -f 1)
# Remember to keep only the hash with cut
cat /tmp/$TARGET

# Alternatively, in one line
cat /tmp/$(echo I am user bandit23 | md5sum | cut -d ' ' -f 1)
```

Thus, the password should be retrieved successfully.


## SUMMARY
We have learnt how `md5sum` works and we have interpreted a Bash script to retrieve the password.
