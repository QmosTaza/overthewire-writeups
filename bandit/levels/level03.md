# BANDIT Level 3 -> 4


## GOAL
To open a hidden file in the home directory


## CONTEXT
Hidden files are files whose names start with a dot, which keeps them out of normal directory listings. They're typically used to store configuration settings and preferences for programs, such as `.bashrc` or `.gitignore`, so they don't clutter everyday file views while still being easily accessible when needed.


## STEPS
First, we must enter the directory "inhere". We can do this with the command `cd` (Change Directory), which lets us navigate through the directories by using the command line only. This is specially useful when you do not have access to a Graphic User Interface that manages navigation for you, like when you connect remotely to a different host.

```bash
cd inhere
```

We are told that the file we're looking for is hidden in this directory. Therefore, we will not be able to find it with a simple `ls`. If we read the manual for the command `ls`, we can learn of different options that may allow us to list more information than we would normally.

We can find this hidden file by simply adding the option `-a` to the command `ls`:

```bash
ls -a
```

We learn the name of the hidden file, which we can read as usual:

```bash
cat ./...Hidden-From-You
```

There, you can obtain the password.


## EXTRA STEPS

### 1
To understand how to use each command, we can always use `man` followed by said command to open its manual:

```bash
man ls
```

### 2
We could have searched for the hidden file and read it without accessing the directory "inhere" directly, by utilizing file paths:

```bash
ls -a inhere
cat inhere/...Hidden-From-You
```

Additionally, by writing the `cat inhere/` and pressing Tab, the name of the hidden file autofills, just as it did in the previous level.


## SUMMARY
We have used `ls` and `man` to retrieve the password from a hidden file.
