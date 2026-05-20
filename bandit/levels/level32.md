# BANDIT Level 31 -> 32


## GOAL
To retrieve the next password by escaping an uppercase shell.


## CONTEXT
Shells like `sh`, `bash`, and `zsh` are conventionally named in lowercase, while uppercase names are typically reserved for environment variables rather than executables. If you encounter a system that enforces uppercase input, it's usually an artificial restriction.

In our case, the uppercase "shell" is not a separate program, but rather a normal shell being accessed under unusual input constraints that force creative use of variables, expansions, or existing environment values.


## STEPS
We are back to escaping shells! This time, we find ourselves restricted by a shell that enforces uppercase input only, meaning our usual commands are unavailable (for example, `cd` turns into `CD`, which is unusable)

We can connect to the previous level (bandit31) to check out what is going on with bandit32:

```bash
ssh bandit31@bandit.labs.overthewire.org -p 2220
grep bandit32 /etc/passwd
```

It seems bandit32 is using an `uppershell` executable under its own home directory. Unfortunately, we cannot use it or run it ourselves. However, we can note that the executable is owned by user bandit33 with setUID on.

```bash
ls -l ../bandit32
```

By reading the manual for `sh`, we find a list of environmental variables (such as $PATH or $HOME) which are all uppercase. We can also use special characters and numbers in the restricted shell.

We are interested in finding some way of entering a `bash` shell without executing `/bin/bash` directly. If we echo typical environmental variables/parameters while connected to bandit31, we will eventually find the one we are looking for:

```bash
echo $0 #returns -bash
```

The special shell postional parameter `$0` contains the name of the program used to launch the current shell. In this case it resolves to "-bash", meaning the session is already being run by a Bash process.

Even though the current level places us in a restricted environment, this is useful because it shows that a normal Bash shell is still being used underneath the restrictions.

Note that if you use `$SHELL` in bandit32 instead of `$0`, you will open another restricted shell. This is because the restriction layer is not a shell but a wrapper on top of it. So `$SHELL` re-enters the wrapper while `$0` relaunches the underlying shell, escaping the wrapper.

Now, we simply need to run `$0` in bandit32:

```bash
$0
whoami #in the new shell
```

Note how we have opened a Bash shell as user bandit33. This is because of the active setUID from the wrapper we saw earlier. From here, we can simply read our new user's password:

```bash
cat /etc/bandit_pass/bandit32
```

And... we are done!! Congrats on solving all currently available!! I hope you enjoyed this series of writeups for Bandit. Please consider donating to the lovely people that created these levels so we can enjoy them for free:
https://overthewire.org/information/donate.html

Also consider star-ing this repository if you have enjoyed reading it :))

## SUMMARY
We have learnt what `$0` is and how to use it to escape a restricted shell. 

Like that, we have finished all Bandit levels :D
