# BANDIT Level 26 -> 27


## GOAL
To retrieve the next password by breaking out from a fake shell.


## CONTEXT
The effective user ID (EUID) is the user identity a process actually uses when checking permissions on a Linux or Unix-like system. While a process also has a real user ID (the account that started it), the EUID determines what files, commands, and resources the process is allowed to access at runtime. 

This distinction becomes especially important with setUID programs (like in level 19), where an executable temporarily runs with the permissions of its owner rather than the user who launched it. For example, a program owned by root with the setUID bit enabled can execute with an EUID of root even when started by a normal user, allowing it to perform privileged actions securely on the user's behalf.


## STEPS
Now that we have obtained a working shell, we can finally run our usual shell commands:

```bash
ls -l
```

We find the `text.txt` file that was mentioned in the previous writeup and learn that there is a `bandit27-do` executable file with a familiar set of permissions. 

The output when we try to read it (`cat bandit27-do`) is pure gibberish, but when we run it...

```bash
./bandit27-do
```

...we are told to run a command as another user:

```bash
./bandit27-do id
```

This command returns the following line:

```
uid=11026(bandit26) gid=11026(bandit26) euid=11027(bandit27) groups=11026(bandit26)
```

This means that we can execute commands as if we were bandit27:

```bash
./bandit27-do whoami #returns bandit27
```

Therefore, we can simply read the file that contains the password like we have done for previous levels:

```bash
./bandit27-do cat /etc/bandit_pass/bandit27
```

To exit, we can do the following:

```bash
exit #in Bash
:qa! #in Vim
#Then, click the down arrow to advance the page and exit the level
```

## SUMMARY
We have learnt how use EUID to retrieve the password.
