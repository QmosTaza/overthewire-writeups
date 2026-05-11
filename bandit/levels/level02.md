# BANDIT Level 2 -> 3


## GOAL
To open a file in the home directory with spaces in its filename


## CONTEXT
In the shell, certain characters have special meanings and must be handled carefully. Special characters such as `*`, `?`, `$`, `|`, and `&` are used for pattern matching, variables, pipes, and background processes. Understanding how to quote or escape these characters is essential when working with filenames and command-line arguments. 

Please note that spaces ` ` and linebreaks `\n` are also special characters.

## STEPS

After connecting to the level and listing the contents of the home directory, you will find a file with spaces in its filename. 

Spaces separate command arguments, so a filename like 'my file.txt' is interpreted as two separate words unless it is quoted (`"my file.txt"` or `'my file.txt'`) or the space is escaped (`my\ file.txt`). 

```bash
cat ~/"--spaces in this filename--"
```

By doing this, you obtain the password to the next level.


## EXTRA STEPS
ALternatively, you may write the beginning of the file path (`cat ~/--sp`) and press `Tab` so it autocompletes. This will give you the following alternative solution:

```bash
cat ~/--spaces\ in\ this\ filename--
```

In this solution, instead of quotation marks, we use the backlash `\`, which escapes spaces and other special characters, so Bash knows to treat them as ordinary characters.


## SUMMARY
We have used `cat`, file paths and `"` to retrieve a password from a file.
