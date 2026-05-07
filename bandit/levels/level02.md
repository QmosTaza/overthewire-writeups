# BANDIT Level 2 -> 3


## GOAL
To open a file in the home directory with spaces in its filename


## CONTEXT
A filepath specifies the location of a file or directory within a filesystem. It can be absolute, starting from the root directory (something like `/home/user/file.txt`), or relative, based on the current working directory (like `docs/file.txt`). Filepaths are used in commands to tell the system exactly where to find or place files.

## STEPS
```bash
ls -l
```

You will find a file with spaces in its filename. It can be read by adding `"` to its file path, similarly to the previous level.

```bash
cat ~/"--spaces in this filename--"
```

There, you can obtain the password.


## SUMMARY
We have used `cat`, file paths and `"` to retrieve a password from a file.
