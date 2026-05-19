# BANDIT Level 28 -> 29


## GOAL
To retrieve the next password by cloning a Git repository and looking through its logs.


## CONTEXT
The `git log` command displays the commit history of a repository, showing each commit's unique hash, author, date, and message. This history provides a chronological record of all changes made to the project, making it possible to trace when a feature was added, identify the source of a bug, or understand how the codebase evolved over time.


## STEPS
The first steps are identical to the last level's, where we cloned a repository onto our local machine:

```bash
git clone ssh://bandit28-git@bandit.labs.overthewire.org:2220/home/bandit28-git/repo
```

This time, the README file does not seem that helpful, since the password has been censored. 

If we look into the hidden files (`ls -la`), we will find a `.git` folder.
It contains all the information Git needs to track and manage the project, including the complete commit history, references to branches and tags, configuration settings, and the object database that stores file contents and snapshots. It also includes metadata such as the current branch (refered to as "HEAD"), remote repository definitions, etc.

This folder is huge and we could learn what each subfolder does. For now, however, we can turn our attention to the `.git/objects/pack` path. It contains Git packfiles, which are used to store repository objects efficiently (see 'ADDITIONAL CONTEXT' for more information)

The presence of packfiles indicates that the repository contains multiple Git objects, strongly suggest that the repository has a history. To see said history, we can run the following command:

```bash
git log
```
The commit history shows that an "info leak" has been patched in the last commit. We are interested in knowing exactly what has been changed, which we can do with the command `diff`:

```bash
git diff <new log> <old log>
```

We learn that the inital 'README.md' file used to contain the real, uncensored password to bandit29. We can copy said password from the output and connect to the next level.

## ADDITIONAL CONTEXT
Inside `.git/objects/pack` we can find the following objects:

* The `*.pack` file contains the actual Git objects (commits, trees, blobs, and tags) compressed together into a single binary file. Instead of storing every object as a separate file, Git packs them to save space.

* The `*.idx` (index) file is a lookup table that maps object hashes to their locations inside the `*.pack` file. This allows Git to quickly retrieve a specific commit or file without scanning the entire pack.

* The `*.rev` file is a reverse index that helps Git translate positions in the packfile back to object order for internal optimization.

## SUMMARY
We have learnt how use `log` and `diff` in Git to retrieve the password.
