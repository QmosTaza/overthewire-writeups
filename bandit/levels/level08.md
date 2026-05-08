# BANDIT Level 8 -> 9


## GOAL
To find the password which is stored in the only non-repeating line in a given file.


## CONTEXT
Pipes (|) are used to send the output of one command directly as the input of another command, allowing commands to work together in a chain. This makes it easy to process, filter, and transform data efficiently from the command line. For example, `cat file.txt | grep error` sends the contents of 'file.txt' into `grep`, which then searches for lines containing the word “error”.


## STEPS
Under the 'Commands you may need to solve this level', the command `uniq` is mentioned. We can check the manual to find that this command reports/omits repeated lines. 

```bash
uniq -u data.txt
```

Please note that `uniq -u` only works if the repeated lines are right next to each other, which is why it is usually used together with `sort`, which outputs a sorted reading of a text file:

```bash
sort data.txt | uniq -u
```


## SUMMARY
We have used `sort` and `uniq` to retrieve the password from a given file.
