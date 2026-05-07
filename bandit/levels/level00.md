# BANDIT Level 0 -> 1


## GOAL
To log into the game with SSH and open a file in the home directory


## CONTEXT
SSH (Secure Shell Protocol) is a network protocol used to securely connect to another computer over an unsecured network. It encrypts all communication between the client and the remote system, protecting data like passwords and commands from interception. In practice, SSH is commonly used by system administrators and developers to remotely manage servers, deploy applications, transfer files securely, and troubleshoot systems without needing physical access to the machine.


## STEPS

```bash
ssh bandit0@bandit.labs.overthewire.org -p 2220
```

Connect to user bandit0 from the host bandit.labs.overthewire.org on port 2220. 
You will be asked to introduce the password bandit0

```bash
ls -l
```

List everything in the home directory. You will find a readme file, which you can read with `cat`.

```bash
cat readme
```

The file includes a short introduction from the team and the password to the next level.


## EXTRA STEPS

### 1
We could have also connected to SSH by adding the password automatically with `sshpass`. In the real world, this would be quite insecure and a bad practice but it is fun to know:

```bash
sshpass -p "bandit0" ssh bandit0@bandit.labs.overthewire.org -p 2220
```

In real life, it is more common to generate a key, copy it into the server and connect without a password.


### 2
It's an interesting challenge to get only the password from the text, so let's try.
One way of doing this is with the `tail` and `awk`. THe former prints the last X lines of each file to stdout, the latter allows you to use the awk programming language.
My first solution was:

```bash
cat readme | tail -n 2 | awk '{print $NF}'
```

We pipe the output of the readme file, print the last 2 lines (the last line is blank) and the print the predefined value NF, which is the number of fields in the current record, which is automatically updated by awk. If we had just used `awk`, the output would have been all the final words in each paragraph.
To make the solution a little more elegant, we can get rid of the linebreaks with `tr`:

```bash
cat readme | tr -d '\n' | tail -n 1 | awk '{print $NF}'
```

Alternatively, we could output the only string that matches the amount of characters that the password can have, which is 32. In this solution, we will first need to output all the words in the paragraph as separate lines with `tr` and then obtain all words of length 32 with `grep`:

```bash
cat readme | tr ' ' '\n' | grep '^[a-zA-Z0-9]\{32\}$'
```

We translate all spaces into linebreaks with `tr`. With `grep`, we use a regex expression that basically means that from start (`^`) to finish (`$`), the line must contain only letters and numbers (`[a-zA-Z0-9]`) and be of length 32. 
For a cleaner look, we could use `grep -E`, which allows us to interpret patterns as regex expressions and not add `\` next to the brackets:

```bash
cat readme | tr ' ' '\n' | grep -E '^[a-zA-Z0-9]{32}$'
```


## SUMMARY
We have used basic SSH, `ls` and `cat` to retrieve a password from a file.
