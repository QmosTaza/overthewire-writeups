# BANDIT Level 18 -> 19


## GOAL
To find the next password despite the '.bashrc' logging us out when we log in with SSH.


## CONTEXT
The `.bashrc` file is a shell configuration script that is executed whenever a new interactive Bash session starts (aka. whenever you open a Bash terminal). It is commonly used to define environment variables, aliases, shell functions, and custom prompt settings so that your preferred configuration is loaded automatically each time you open a terminal. By editing it, you can personalize your command-line environment and avoid having to retype frequently used settings or commands.

## STEPS
Just as the introduction to the level says, when we try to connect normally through SSH...

```bash
ssh bandit18@bandit.labs.overthewire.org -p 2220
```

... we are kicked out unceremoniously.

From the 'Commands you may need' section we can derive that the key to solving this level probably involves a deeper dive into the `ssh` command.

By reading the first paragraphs in the manual, we find the following information:

```
If a command is specified, it will be executed on the remote host instead  of a login shell.  A complete command line may be specified as command, or it may have additional  arguments.   If  supplied,  the  arguments will be appended to the command, separated by spaces, before it is sent to the server to be executed.
```

So apparently, we can add full commands to our `ssh` call and they should run in the host. Let's try:

```bash
ssh bandit18@bandit.labs.overthewire.org -p 2220 ls -l
```

You'll find some information on a 'readme' file, just as we were told. From here, solving this level should be really simple:


```bash
ssh bandit18@bandit.labs.overthewire.org -p 2220 cat readme
```


## SUMMARY
We have used command directly in the `ssh` call to be able to read the password despite the restrictions in place.
