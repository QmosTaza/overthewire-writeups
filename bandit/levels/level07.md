# BANDIT Level 7 -> 8


## GOAL
To find the password which is stored in a given file next to a particular word.


## CONTEXT
The `grep` command is used to search for specific text patterns inside files or command output. In real life, it is commonly used by developers and system administrators to quickly find errors in logs, search configuration files, filter command results, or locate keywords in large amounts of text. Its speed and flexibility make it one of the most useful tools for navigating and analyzing data in Linux systems.


## STEPS
With everything that we have learnt until now, the solution to this level is a straightforward use of the command `grep` on 'data.txt'

```bash
grep "millionth" data.txt
```

We can show the password by itself by printing the second term ($2) from the output we just received with the `awk` command:

```bash
grep "millionth" data.txt | awk '{print $2}'
```


## SUMMARY
We have used `grep` to retrieve the password from a given file.
