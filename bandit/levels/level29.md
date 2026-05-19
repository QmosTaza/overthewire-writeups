# BANDIT Level 29 -> 30


## GOAL
To retrieve the next password by cloning a Git repository and looking through its logs and branches.


## CONTEXT
In Git, a branch is a movable reference to a specific commit that represents an independent line of development. Creating a branch allows you to work on new features, bug fixes, or experiments without affecting the main codebase. 

As new commits are made, the branch pointer advances to the latest commit in that sequence. Later, branches can be merged to combine their changes, enabling multiple versions of a project to evolve in parallel while preserving a complete history of how they diverged and were reconciled.


## STEPS
We already know how to obtain the repository:

```bash
git clone ssh://bandit29-git@bandit.labs.overthewire.org:2220/home/bandit29-git/repo
```

The README file looks quite similar to last level's except this time, when we review the logs in the main branch, no information seems to have been leaked from them:

```bash
git log
git diff <new log> <old log>
```

If we look into `.git` folder, we see that it looks quite similar to the previous level. However, if we read every file we can (without looking into the subfolders)...

```bash
cat *
```

...we will find some interesting information coming from the file `packed-refs`. In this occassion, the file references multiple branches other than "main" or "master": one named "dev" and another one named "sploits-dev".

The latter seems more interesting, so lets check out which commits have been made in it. We can do this using `log <branch>`:

```bash
git log remotes/origin/sploits-dev
```

We find a commit that talks about an exploit added for no reason. We can once again find the difference between the previous commit and that one...

```bash
git diff <old log> <new log>
```

...only to find that the "/exploits/horde5.md" that has been added is completely empty.

However, we still have another branch to check out:

```bash
git log remotes/origin/dev
git diff <old log> <new log>
```

We learn that the real password has been added to the 'README.md' file in that branch, completely uncensored. We can copy said password from the output and connect to the next level.


## SUMMARY
We have learnt how use `log` and `diff` in branches other than main to retrieve the password.
