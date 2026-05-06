# BANDIT Level 5 -> 6


# GOAL
To find a file that is human-readable, 1033 bytes in size, not executable in the 'inhere' directory.


# CONTEXT
Finding files based on their characteristics is useful when working in big systems where many files are mixed together, such as servers or project directories, and you need to quickly locate specific types like images, logs, or configuration files. It helps with tasks like cleanup, debugging, security checks, and organizing data efficiently without manually opening each file.


# STEPS
We are told the characteristics of the file we are looking for. By reading the manual for the command `find`, we learn how to filter by size (in this case, 'c' means bytes) (`-size Nc`) and by it being executable (`-executable`). We can negate this last filter by adding (`-not`). 

```bash
find -size 1033c -not -executable
```

We don't need to check for whether it is human-readable or not to obtain the file path we are looking for. However, we can make sure that the path we have obtained is the right one like this:

```bash
file "$(find -size 1033c -not -executable)" | grep ASCII
```

We can `cat` the file path that we just received.

```bash
cat ./inhere/maybehere07/.file2
```


# EXTRA STEPS
For some reason, this particular password is followed by many spaces. We can eliminate these spaces by using the command `head`:

```bash
cat ./inhere/maybehere07/.file2 | head -n 1
```


# SUMMARY
We have used `find` to retrieve the password from a series of given characteristics.
