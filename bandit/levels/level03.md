# BANDIT Level 3 -> 4


# GOAL
To open a hidden file in the home directory


# CONTEXT
Hidden files are files whose names start with a dot, which keeps them out of normal directory listings. They're typically used to store configuration settings and preferences for programs, such as `.bashrc` or `.gitignore`, so they don't clutter everyday file views while still being easily accessible when needed.


# STEPS
First, we must enter the directory "inhere". We can do this with the command `cd`:

```bash
cd inhere
```

We are told that the file we're looking for is hidden in this directory. Therefore, we will not be able to find it with a simple `ls`
We can find this hidden file by simply adding the option `-a` to the command `ls`:

```bash
ls -a
```

We learn the name of the hidden file, which we can `cat` as usual:

```bash
cat ./...Hidden-From-You
```

There, you can obtain the password.


# EXTRA STEPS
To understand how to use each command, we can always use `man` followed by said command to open its manual:

```bash
man ls
```

We could have searched for the hidden file and read it without accessing the directory "inhere" directly, by utilizing file paths:

```bash
ls -a inhere
cat inhere/...Hidden-From-You
```

Additionally, by writing the `cat inhere/` and pressing Tab, the name of the hidden file autofills 


# SUMMARY
We have used `ls` and `man` to retrieve the password from a hidden file.
