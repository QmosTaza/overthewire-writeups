# BANDIT Level 1 -> 2


# GOAL
To read a file named "-" in the home directory.


# CONTEXT
In Bash commands, hyphens (-) are used to introduce options or flags that modify how a command behaves. For example, `ls -l` tells the ls command to show a detailed (long) listing, while `rm -r` tells the remove command to delete recursively (everything contained within a directory, for instance). These flags are shorthand ways to customize a command's functionality.


# STEPS

```bash
ssh bandit1@bandit.labs.overthewire.org -p 2220
ls -l
cat -
```

This time when we try to read the filename, it doesn't do anything. This is because it is waiting for modification of the command after the hyphen. Adding `"` in between will not work either. What we have to do is search for a more complete version of the file path, such as one that includes the home directory (`~`)

```bash
cat ~/-
```

This way we can retrieve the password and move on to the next level.


# SUMMARY
We have learnt a little bit about file paths and how commands work in bash.
