# BANDIT Level 30 -> 31


## GOAL
To retrieve the next password by cloning a Git repository and looking through its tags.


## CONTEXT
In Git, tags are named references that point to specific commits, typically used to mark important milestones such as releases or stable versions. 

Unlike branches, which move forward as new commits are added, tags remain fixed and always refer to the same commit. This makes them useful for easily revisiting known states of a project, comparing versions, and distributing software releases with clear and permanent identifiers.


## STEPS
We already know how to obtain the repository:

```bash
git clone ssh://bandit30-git@bandit.labs.overthewire.org:2220/home/bandit30-git/repo
```

This time, the README file looks properly useless. When we look into the logs, we only find one commit:

```bash
git log
```

If we look into `.git` folder, we see that it looks quite similar to the previous levels. However, if we once again read every file we can (without looking into the subfolders)...

```bash
cat *
```

...we will find that `packed-refs` has been changed yet again. This time, it mentions a different tag called "secret". We can confirm this information by running:

```bash
git tag
```

Using the `log` command won't work . However, we can `show` the commit to which it points like this:

```bash
git show secret
```

Just like that, the commit's name clooks really similar to our usual passwords. If we use it to connect to the next level, it should work.


## ADDITIONAL CONTEXT
In Git, `show` is a command used to display information about a specific Git object, such as a commit or tag. When used on a tag, it resolves the tag to the commit it points to and prints details like the commit message, author, date, and the changes introduced. It can also be used to view the contents of a file at a particular commit using the syntax `tag:path`, making it a quick way to inspect snapshots of a repository without checking them out.


## SUMMARY
We have learnt how use `tag` and `show` to retrieve the password.
