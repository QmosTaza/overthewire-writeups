# BANDIT Level 1 -> 2


## GOAL
To read a file named "-" in the home directory.


## CONTEXT
In Bash commands, hyphens (-) are used to introduce options or flags that modify how a command behaves. For example, `ls -l` tells the ls command to show a detailed (long) listing, while `rm -r` tells the remove command to delete recursively (everything contained within a directory, for instance). These flags are shorthand ways to customize a command's functionality.


## STEPS
We could follow the same steps we followed in the previous level:

```bash
ssh bandit1@bandit.labs.overthewire.org -p 2220
ls -l
cat -
```

Now, when we try to read the filename, it doesn't do anything. This is because it is waiting for modification of the command after the hyphen. Note that adding quotation marks `"` in between the file name will not work either. 

We are meant to utilize a more complete version of the file path, one that includes the home directory (`~`). To learn more about file paths, read the 'ADDITIONAL CONTEXT' section under this writeup.

```bash
cat ~/-
```

This way, we can retrieve the password and move on to the next level.


## ADITIONAL CONTEXT
A filepath specifies the location of a file or directory within a filesystem. It can be absolute, starting from the root directory (something like `/home/user/file.txt`), or relative, based on the current working directory (like `docs/file.txt`). Filepaths are used in commands to tell the system exactly where to find or place files.


## SUMMARY
We have learnt a little bit about file paths and how commands work in bash.
