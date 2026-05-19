# BANDIT Level 25 -> 26


## GOAL
To break out from a fake shell and obtain access to `/bin/bash`.


## CONTEXT
### 1
`/etc/passwd` is a fundamental system file on Unix-like operating systems that stores information about user accounts. Each line in the file represents a user and contains fields such as the username, user ID (UID), group ID (GID), home directory, and login shell. Despite its name, it no longer stores passwords themselves on modern systems; those are kept in the more secure `/etc/shadow` file.

### 2
System administrators can create restricted by assigning a user's login shell in `/etc/passwd` to a program other than a standard shell like `/bin/bash`. Instead of giving an interactive environment, that program might launch a controlled tool such as a menu system, a logging wrapper, or a pager like `more` or `less`, and limit what commands can be executed.

These setups are used to enforce restricted access for service accounts, enforce workflows, reduce the risk of accidental system changes or provide a controlled interface for users who don't need full shell access. In security training environments, they're also used intentionally to simulate misconfigurations and teach how user environments can be constrained or escaped when permissions and tooling are misunderstood.


## STEPS
When we connect to `bandit25`, we find a private SSH key which we can use to connect to the next level, just like we did previously for `bandit13`.

Locally, we can run this command to retrieve the private key:

```bash
scp -P 2220 bandit25@bandit.labs.overthewire.org:~/bandit26.sshkey ./
```

And connect to the next level:

```bash
ssh -i <private key path> -p 2220 bandit26@bandit.labs.overthewire.org
```

You will find that you are disconnected from the level before you can do anything. The introduction to this level already warned us of this:

```
Logging in to bandit26 from bandit25 should be fairly easy… The shell for user bandit26 is not /bin/bash, but something else. Find out what it is, how it works and how to break out of it.
```

So we should first find out what shell `bandit26` is using. The 'CONTEXT' section for this level already told us that the shell each user uses is defined under `/etc/passwd`, which we can read by connecting as `bandit25` and running...

```bash
grep bandit26 /etc/passwd
```

...which returns:

```
bandit26:x:11026:11026:bandit level 26:/home/bandit26:/usr/bin/showtext
```

We can read this 'showtext' file, which contains the following code:

```
#!/bin/sh

export TERM=linux

exec more ~/text.txt
exit 0
```

This executable tells the minimal shell `sh` that it is running the basic terminal type `linux` so that it can run the command `more`. Said command runs the pager program to display the file 'text.txt' and, when executed like above, replaces the current shell with the process `more`. Then, it exits the connection.

Notice how when you try to connect to `bandit26`, it prints a rendition of the user's name and immediately disconnects you. This 'bandit26' drawing is the contents of the 'text.txt'

Note that we cannot change the contents of the `/usr/bin/showtext` file nor of the `/etc/passwd` file as we do not have access to 'root'. So our only hope is extending our connection to `bandit26` and trying to escape from there.

We can start by connecting back to `bandit26`, but this time we make the terminal window much smaller, so we can force the `more` command to show the text for longer and maintain the connection.

A fun fact about `more`, which we find by reading its manual, is that we can launch an editor by pressing `v`. This editor is by default `vi` or Vim (read the 'ADDITIONAL CONTEXT' section to obtain more information).

We can then use Vim to run Vim internal commands by simply typing `:`.

In Vim, `:shell` relies on Vim's configured “shell” setting to decide what program to launch. In our restricted environment, the default shell Vim uses (`sh`) is limited, so spawning it directly will not give a usable session.

Other alternatives like `:!bash` or `/bin/bash` don't reliably work because the former runs as a non-interactive subprocess and the latter is interpreted as a Vim search, rather than opening a proper interactive shell session.

By explicitly setting the shell to `/bin/bash` with `:set shell`, we ensure that Vim uses a full interactive shell when `:shell` is executed:

```
:set shell=/bin/bash
:shell
```

After running this, you should be able to obtain a shell.

## ADDITIONAL CONTEXT
Vim is a highly configurable terminal-based text editor that runs in the shell and is widely used on Unix-like systems. Unlike simpler editors like `nano`, it operates in multiple modes, such as normal mode for navigation and command execution, and insert mode for editing text.

Because it can execute commands from within the editor (for example using `:!`), it is powerful but also potentially risky if misused, especially in restricted environments.

## SUMMARY
We have learnt how to break from a restricted shell with `more` and Vim.
