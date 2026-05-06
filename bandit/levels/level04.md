# BANDIT Level 4 -> 5


# GOAL
To find the only human-readable file in the 'inhere' directory


# CONTEXT
Human-readable files are files stored in plain text so people can open and understand them without special software. They're commonly used for configuration, logs, or documentation (like `.txt`, `.md`, or `.json` files), making it easy to view, edit, and troubleshoot them directly.


# STEPS
First, we must enter the directory "inhere". We can do this with the command `cd`:

```bash
cd inhere
```

We are told that the file we're looking for is the only human-readable file. We can find out which types of files there are by using the comman `file` followed by the file itself. To learn the names of the files, we can do the following:

```bash
ls -l
```

We learn that all files follow the pattern `-fileXX`, with XX being numbers from 00 to 09. We can avoid using the command on each file individually by using a pattern:

```bash
file ./-file*
```

We learn that file '-file07' is the only one that includes ASCII text, while the rest are data files or other types. We read this file to obtain the password:

```bash
cat ./-file07
```


# EXTRA STEPS
We might want to obtain the password with a single command (from the 'inhere' directory, for simplicity's sake) We can do this by receiving the output of file and reading the one file that outputs 'ASCII':

```bash
file ./-file* | grep ASCII
```

Here, we obtain the output "file07: ASCII text". We will use the same logic as in "level00.md" to trim the output and obtain the first element with 'head':

```bash
file ./-file* | grep ASCII | tr ':' '\n' | head -n 1
```

Now, we just have to read from the file. However, we cannot just pipe to cat, as this command doesn't create the file but instead it finds and prints its name. Since we want to use this output as an argument, we will have to use command substitution:

```bash
cat "$(file ./-file* | grep ASCII | tr ':' '\n' | head -n 1)"
```

This way, we obtain the password with one command (two if we count `cd inhere`)


# SUMMARY
We have used `file` to retrieve the password from the only human-readable file.
