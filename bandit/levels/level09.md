# BANDIT Level 9 -> 10


## GOAL
To find the password which is stored in one of the few human-readable strings, preceded by several '=' characters.


## CONTEXT
Human-readable strings and characters are text formats designed to be easily understood by people, such as plain text files or ASCII/UTF-8 encoded text. However, computers also use non-human-readable data like binary files, compressed formats, or encrypted content because they are more efficient, secure, or better suited for storing complex information.


## STEPS
Under the 'Commands you may need to solve this level', the command `strings` is mentioned. We can check the manual to find that this command prints the sequences of printable characters in files.

```bash
strings data.txt
```

However, when we use it on its own, there are too many strings to check, which is why we use `grep`to filter through the ones that begin with '===' by adding '^' to the searched pattern (thought it's still easily solvable without adding '^'):

```bash
strings data.txt | grep "^==="
```


## EXTRA STEPS
If we wish to separate the password from the rest of the text, we can easily do so with the commands we have learnt along the game:

```bash
strings data.txt | grep "^===" | tr -d '= ' | tail -n 1
```

It is recommandable to try different ways of solving this problem for practice.


## SUMMARY
We have used `strings` and `grep` to retrieve the password from a given file.
