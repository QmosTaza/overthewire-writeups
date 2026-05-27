# NATAS Level 3 -> 4


## GOAL
To search through the files in a website to retrieve the password.


## CONTEXT
The `robots.txt` file is a standard configuration file placed at the root of a website to give instructions to web crawlers and search engines like Google about which parts of the site should and shouldn't be indexed. It is typically accessible through a URL such as `http://example.com/robots.txt`. 


## STEPS
http://natas3.natas.labs.overthewire.org

After entering the username and password, and viewing the source code, we find a comment saying that 'not even Google' will find information leaks. This is meant to be a clue about the file that we should be looking for: `robots.txt`.

This file is intended for cooperative behavior rather than security, meaning it does not actually protect files or directories from being accessed directly. Because of this, developers sometimes accidentally expose sensitive paths inside `robots.txt`, making it a common place to check during web security challenges. Therefore, it is worth checking out:

http://natas3.natas.labs.overthewire.org/robots.txt

We read the following text in said file:

```
User-agent: *
Disallow: /s3cr3t/
```

The first line of text tells us that these rules should apply to all web crawlers and bots. The second line tells said crawlers not to access or index the directory `/s3cr3t/`. However, these instructions are only advisory and they do not provide any real access control or security. Therefore, we can access this directory ourselves:

http://natas3.natas.labs.overthewire.org/s3cr3t/

It would seem like there is a `users.txt` file that we can check out:

http://natas3.natas.labs.overthewire.org/s3cr3t/users.txt

There, you should be able to find the password easily.

## SUMMARY
We have used file navigation and knowledge on the `robots.txt` file to retrieve the password.
