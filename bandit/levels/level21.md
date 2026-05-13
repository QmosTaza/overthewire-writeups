# BANDIT Level 21 -> 22


## GOAL
To find the next password by analysing a running cron job.


## ADDITIONAL CONTEXT
Cron is a job scheduler in Unix-like systems that automatically runs commands or scripts at specified times or intervals. Scheduled tasks are defined in files called 'crontabs', where each entry indicates when a command should be executed (for example, every minute, every day, or every Sunday at midnight).

Cron is commonly used for maintenance tasks such as backups, log rotation, and automated scripts, allowing programs to run in the background without manual intervention.


## STEPS
If we list the contents of our home directory, we will find that it is empty. We are told to got to `/etc/cron.d/` and learn about the program running at regular intervals.

```bash
cd /etc/cron.d/
ls -l
```

We find a `cronjob_bandit22` file that has 'read' permissions activated for others, meaning we can read it: 

```bash
cat cronjob_bandit22
```

The referenced script is located in `/usr/bin/` and all its output is being dumped in `/dev/null`. The script is run as user `bandit22`. The asteriscs next to the user indicate that this script is being executed every minute (\*) of every hour (\* \*) of every day (\* \* \*) of every month (\* \* \* \*) regardless of the day of the week (\* \* \* \* \*).

Luckily, we can read the contents of the script...

```bash
cat /usr/bin/cronjob_bandit22.sh
```

... which runs the following code (or something similar):

```bash
#!/bin/bash
chmod 644 /tmp/t7O6lds9S0RqQh9aMcz6ShpAoZKF7fgv
cat /etc/bandit_pass/bandit22 > /tmp/t7O6lds9S0RqQh9aMcz6ShpAoZKF7fgv
```

The first line of code is a shebang or hashbang, which tells the operating system which program should be used to interpret and execute the file. In this case, it should run using GNU Bash, located in `/bin/bash`. When you make a script executable with `chmod +x script.sh` and run it as `./script.sh`, the operating system reads the first line, sees `#!/bin/bash`, and launches `/bin/bash` to execute the script.

We already know that chmod modifies the permissions, in this case allowing the owner of the file to read and write, and everyone else to just read.

The contents of the `/etc/bandit_pass/bandit22` file (which contains the password we're looking for) are redirected to the `/tmp/...` file. Note that this command is being run as bandit22, who does have the permission to read the password file.

Since we can read the `/tmp/...` file, we can easily retrieve the password:

```bash
cat /tmp/t7O6lds9S0RqQh9aMcz6ShpAoZKF7fgv
```


## SUMMARY
We have learnt how cronjobs work and we have interpreted a Bash script to retrieve the password.
