# BANDIT Level 19 -> 20


## GOAL
To find the next password by running a file with setuid.


## CONTEXT
Setuid and setgid are special permission bits in Unix-like systems that allow a program to run with the privileges of its owner or group rather than those of the user executing it. If a file has the setuid bit set, the program runs with the file owner's permissions (often root), while setgid makes it run with the file's group permissions. 

These bits are commonly used for system utilities that need temporary elevated access, such as changing passwords, while still restricting direct access to sensitive files. They are displayed as `s` in the execute permission fields (for example, if you run `ls -l` you might read `-rwsr-xr-x`) and must be used carefully because they can introduce security risks if the program is vulnerable.

## STEPS
After connecting to the level, we find a file with interesting permissions:

```bash
ls -l
```

Please note the `s` for the owner where there would usually be an `x`for `execute`. This shows that this file has setuid permissions, meaning we can execute it as if we were the owner (who, for this file, is bandit20).

If we try running it...

```bash
./bandit20-do
```

... we are told to run the command `whoami` with it and see what happens. This command returns the name of the current user. If we ran it on its own, we would receive `bandit19`, the user we are connected as. But, what happens when we run it like this?:

```bash
./bandit20-do whoami
```

It responds with `bandit20`. This means that we can run commands as bandit20. From here on, the solution is simply reading the one file that contains the password for the next level that only `bandit20` can read:

```bash
./bandit20-do cat /etc/bandit_pass/bandit20
```


## SUMMARY
We have used a file with setuid activated to read a restricted file and retrieve the password.
