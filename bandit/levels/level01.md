# BANDIT Level 1 -> 2

# GOAL
To read a file named "-" in the home directory.

# STEPS
```bash
ssh bandit1@bandit.labs.overthewire.org -p 2220
ls -l
cat -
```
This time when we try to read '-', it doesn't do anything. This is because it is waiting for a command after the dash. Adding `"`in between will not work either. What we have to do is search for a more complete version of the file path, such as one that includes the home directory (`~`)
```bash
cat ~/-
```
This way we can retrieve the password and move on to the next level.

# SUMMARY
We have learnt a little bit about file paths and how commands work in bash.
