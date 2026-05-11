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


## EXTRA STEPS
ALternatively, you may use write the beginning of the file path ("cat ~/--sp") and press `Tab` so it autocompletes. This will give you the following alternative solution:

```bash
cat ~/--spaces\ in\ this\ filename--
```

In this solution, instead of quotation marks, we use the backlash `\`, which escapes spaces and other special characters, so Bash treats them as ordinary characters.


## SUMMARY
We have used `cat`, file paths and `"` to retrieve a password from a file.
