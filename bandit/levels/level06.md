# BANDIT Level 6 -> 7


## GOAL
To find a file that is 33 bytes in size and owned by a certain user and group somewhere on the server.


## CONTEXT
In Linux, every file and directory is associated with an owner user and an owner group, which help control access and permissions. The user usually represents the creator or primary owner of the file, while the group allows multiple users to share access. Linux uses these ownership settings together with read, write, and execute permissions to manage security and control who can interact with files and directories.


## STEPS
We are told the characteristics of the file we are looking for. By re-reading the manual for the command `find`, we learn that we can also filter by user and group. The required solution is quite straightforward from here. Since we are asked to search through the entire server, we will have to search from `/`. We can do this by using the command `cd ..` twice (going back to the parent directory twice), or by having the find command be followed by the requested file path, in our case `/`.

```bash
find / -size 33c -user bandit7 -group bandit6
```

By searching through the entire server, we receive multiple "Permission denied" errors. To filter these errors and receive only our desired filepath, you might think to `grep -v` this pattern, excluding it from the output. However, this will not work, as these messages are sent to stderr, not stdout, and grep only filters stdout by default. We can simply redirect stderr (2) to the path `/dev/null`, which works as a bin of sorts.

```bash
find / -size 33c -user bandit7 -group bandit6 2>/dev/null
```

This way, we can easily obtain the password:

```bash
cat /var/lib/dpkg/info/bandit7.password
```


## SUMMARY
We have used `find` to retrieve the password from a series of given characteristics by searching through the server and filtering through error messages.
