# BANDIT Level 27 -> 28


## GOAL
To retrieve the next password by cloning a Git repository with SSH.


## CONTEXT
Git is a distributed version control system used to track changes in files and coordinate development across projects. Its main purpose is to maintain a history of modifications, allowing users to save snapshots of their work through commits, restore previous versions, and collaborate safely with others. Git also supports branching and merging, which lets developers work on separate features or fixes independently before combining them into the main project. 

Because of its speed, reliability, and collaboration features, Git has become the standard tool for modern software development and source code management.


## STEPS
To solve this level, we must first learn how to use Git. In this case, `man git` on its own is not the most recommendable way of learning, as it contains a myriad of functionalities that are not needed for this level. Instead, we can read the shorter version of the manual:

```bash
man giteveryday
```

We find that, to copy a git repository onto our local machine, we can use `git clone`. This command can be used with SSH. However, if we do this:

```bash
git clone ssh://bandit27-git@bandit.labs.overthewire.org/home/bandit27-git/repo
```

We will receive the usual error message on us connecting with SSH to OverTheWire using the wrong port. The option `-p` does not exist for `git clone` either. Instead, we must use the `ssh://` syntax (`git clone ssh://user@host:PORT/path/to/repo.git`):

```bash
git clone ssh://bandit27-git@bandit.labs.overthewire.org:2220/home/bandit27-git/repo
```

After, a new folder called "repo" should appear in our local machine. We can simply enter said folder and read the 'README' file to obtain the password.

```bash
cd repo
cat README
```

## SUMMARY
We have learnt how use `clone` in Git to retrieve the password.
