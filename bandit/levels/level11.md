# BANDIT Level 11 -> 12


## GOAL
To find the password which is stored in a file where all lowercase (a-z) and uppercase (A-Z) letters have been rotated by a number of positions.


## CONTEXT
Caesar's cipher is one of the simplest encryption techniques, where each letter in a message is shifted a fixed number of places down or up the alphabet. For example, with a shift of 3, “A” becomes “D”, “B” becomes “E”, and so on, wrapping around at the end of the alphabet. It was used in ancient times by Julius Caesar for basic military communication, but it is very easy to break today because there are only 25 possible shifts, making it vulnerable to brute-force guessing. ROT13 is a variant of this cipher.


## STEPS
To solve this level, we simply need to use a command that we have already seen in these writeups: the `tr`command. This command translates a character or set of characters into a different character/set. Since we are told that the number of positions roteted is 13, we will need to change each "A" for "N", "B" for "O", and so on. We can do this by using regex patterns:

```bash
cat data.txt | tr '[a-zA-Z]' '[n-za-mN-ZA-M]'
```

In this example, we convert each letter from 'a-z' and 'A-Z' (remember upper and lower case are different ASCII characters) to its respective counterpart in the range 'n-za-m'. Note that we cannot just make a range 'n-m', since the letter "m" appears before "n". 

Once again, it is recommendable to find ways to isolate the password from the rest of the text.


## SUMMARY
We have used `tr` to decode a ciphertext and retrieve the password.
