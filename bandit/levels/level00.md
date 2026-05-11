# BANDIT Level 0 -> 1


## GOAL
To log into the game with SSH and open a file in the home directory


## CONTEXT
SSH (Secure Shell Protocol) is a network protocol used to securely connect to another computer over an unsecured network. It encrypts all communication between the client and the remote system, protecting data like passwords and commands from interception. In practice, SSH is commonly used by system administrators and developers to remotely manage servers, deploy applications, transfer files securely, and troubleshoot systems without needing physical access to the machine.


## STEPS

To connect through SSH to the user `bandit0` from the host `bandit.labs.overthewire.org` on port `2220`, you must open your terminal of choice (in Linux, you may simply press `Ctrl` + `Alt` + `T`) and type in the following command:

```bash
ssh bandit0@bandit.labs.overthewire.org -p 2220
```

This command requires you to follow the template `ssh USER@HOST -p PORT` to connect to the appropiate level. Usually, you could not specify the port by simply doing `ssh USER@HOST`, but this particular host does not allow connections outside of port `2220` for this level. If you do not specify the port, you would be connecting through port `22`, which will return an error.

You will be asked to introduce the password 'bandit0'. You may write it as it is (note that you will not see the characters being written for security reasons) or you may paste it onto the terminal (which you can do by pressing `Ctrl` + `Shift` + `V`) and press `Enter`.

Now you are logged into the user `bandit0` remotely, and you can see everything in the user's home directory (which we call `~`). You can list everything in the home directory by using the command `ls`. By adding the option `-l`, you will see a more detailed output, though that is not necessary for now.

```bash
ls  #Alternatively, you could write ls -l
```

You will find a readme file, which you can read with `cat`. This command outputs the contents of a file onto 'stdout' (Standard Output), which you can read on your terminal.

```bash
cat readme
```

The file includes a short introduction from the team and the password to the next level, which you can copy by pressing `Ctrl` + `Shift` + `C`.

You can exit the connection by simply typing the `exit` command, which will take you back to the directory from which you executed `ssh`:

```bash
exit
```

## EXTRA STEPS

### 1
We could have also connected to SSH by adding the password automatically with `sshpass`. In the real world, this would be quite insecure and a bad practice but it is fun to know:

```bash
sshpass -p "bandit0" ssh bandit0@bandit.labs.overthewire.org -p 2220
```

In real life, it is more common to generate a key, copy it into the server and connect without a password. We will see how this works in later levels.


### 2
It is an interesting challenge to retrieve only the password from the text (excluding everything else), so let's try!

One not-very-intuitive way of doing this is by using the `tail` and `awk` commands. The former prints the last X lines of each file to stdout, the latter allows you to use the awk programming language, which lets you print the last element (`$NF`) of the text that you have received.

We can connect both commands by using a pipe (`|`), which we will learn in more detail later down the line, but basically converts the output of the first command into the input of the second command. So `tail` receives the output of `cat readme` (aka. the contents of the file) and `awk` receives the last 2 lines of the readme file:


```bash
cat readme | tail -n 2 | awk '{print $NF}'
```

Please note that we are piping the last 2 lines (not just 1) onto `awk` because the last line is blank. Also note that if we had just used `awk`, the output would have been all the final words in each paragraph.

We could make the solution a little more elegant by getting rid of the linebreaks with `tr`. This command translates a character to another or eliminates all instances of one character (in this case all linebreaks `\n`) with the option `-d`. Then we can select only the final line `-n 1`:

```bash
cat readme | tr -d '\n' | tail -n 1 | awk '{print $NF}'
```

Alternatively, we could output the only string that matches the amount of characters that the password can have, which is 32. In this solution, we will first need to output all the words in the paragraph as separate lines with `tr` (translating the spaces `' '`to linebreaks `'\n'`) and then obtain all words of length 32 with `grep`:

```bash
cat readme | tr ' ' '\n' | grep '^[a-zA-Z0-9]\{32\}$'
```

With `grep`, we use a regex expression that basically means that from start (`^`) to finish (`$`), the line must contain only letters and numbers (`[a-zA-Z0-9]`) and be of length 32. Don't be scared if you do not fully grasp how `grep` or regex expressions work, we will use them in more detail in later levels.

For a cleaner look, we could use the option `-E`, which allows us to interpret patterns as regex expressions directly. Therefore, we do not have to add `\` next to the brackets:

```bash
cat readme | tr ' ' '\n' | grep -E '^[a-zA-Z0-9]{32}$'
```

In the following levels, we will explore these commands further. Nevertheless, it is recommendable for you to play with the commands we've introduced on your own.

## SUMMARY
We have used basic SSH, `ls` and `cat` to retrieve a password from a file.
