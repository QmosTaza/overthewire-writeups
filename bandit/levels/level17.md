# BANDIT Level 17 -> 18


## GOAL
To find the next password by finding the difference between two given files.


## CONTEXT
Finding the difference between two files is useful for identifying exactly what has changed between versions of data, code, or configuration. This is especially important in debugging, version control, and system administration, where small changes can cause different behavior or errors.

Tools exist that help highlight additions, deletions, or modifications line by line, making it easier to track updates, review changes made by others, or verify that files match expected outputs (useful, for example, in competitive programming).

## STEPS
After solving the previous levels, this one seems like a piece of cake. We simply need to learn how to use `diff`, a command which highlights the difference between two files.

```bash
diff passwords.old passwords.new
```

The command should output the only password that has changed: the old version followed by the new version (the order of the output depends on the order of the arguments for the command). The new version corresponds with the password for the next level.

If we wish to retrieve only the password, a simply way of doing it would be this:

```bash
diff passwords.old passwords.new | grep '>' | awk '{print $NF}'
```

## SUMMARY
We have used `diff` to find the difference between two given files and retrieve the new password.
