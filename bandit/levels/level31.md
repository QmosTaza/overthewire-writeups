# BANDIT Level 31 -> 32


## GOAL
To retrieve the next password by pushing a file to a Git repository.


## CONTEXT
The `.gitignore` file tells Git which files and directories should be excluded from version control. It is commonly used to prevent temporary files, build artifacts, logs, credentials, and other machine-specific data from being accidentally committed to a repository. 

Each line contains a pattern that Git matches against file paths, allowing developers to ignore filenames and entire directories if they wish to. This helps keep repositories clean, reduces unnecessary clutter in commit history, and prevents sensitive information such as passwords or private keys from being tracked.


## STEPS
We already know how to obtain the repository:

```bash
git clone ssh://bandit31-git@bandit.labs.overthewire.org:2220/home/bandit31-git/repo
```

For this last Git related level, the README file actually gives us useful information:

```
This time your task is to push a file to the remote repository.

Details:
    File name: key.txt
    Content: 'May I come in?'
    Branch: master
```

Additionally, if we list all the files in the `repo` directory (`ls -la`), we may notice that there is a new `.gitignore` file which contains the text: `*.txt`.

It is pretty self explanatory that we must create a file with the characteristics mentioned in the README file. We can do so with just one `echo`:

```bash
echo "May I come in?" > key.txt
```

Before sending the file to the remote repository, we must tell Git to track the new changes and save them locally. `git add <path>` stages all modified files, marking them to be included in the next snapshot. `git commit -m "<message>"` creates a new commit in the local repository with a descriptive message. Finally, `git push` uploads those committed changes to the remote repository.

However, if we try to add, commit and push the file as it is...

```bash
git add .
git commit -m "Please give me the password ty xoxo"
git push
```

...we will find that there is "nothing to commit". This is because all files ending in `.txt` are included in the contents of the `.gitignore`. To fix this, we must change the contents of the `.gitignore` file:

```bash
echo "" > .gitignore

git add .
git commit -m "Please give me the password ty xoxo"
git push

```

This time, our commit should work. While it will be rejected by the remote repository, we will be given the password in the error message.


## SUMMARY
We have learnt how use `add`, `commit` and `push` to retrieve the password.
