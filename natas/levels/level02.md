# NATAS Level 2 -> 3


## GOAL
To search through the files in a website to retrieve the password.


## CONTEXT
Web servers often expose static resources such as images, stylesheets, and downloadable files through publicly accessible directories. If directory listing is enabled, visiting the URL of a folder instead of a specific file will display all files stored inside it. This is convenient for development and debugging, but it can become a security risk if sensitive files are placed in those directories.


## STEPS
http://natas2.natas.labs.overthewire.org

After entering the username and password, we will find that in and of itself doesn't contain anything. We can check ourselves:

Press `Ctrl + Shift + C` to open Inspect Element
or  
Press `Ctrl + U` to view the source code

We do find, however a single pixel under `src/files/pixel.png`. We can see that pixel for ourselves by adding it to the URL:

http://natas2.natas.labs.overthewire.org/files/pixel.png

The pixel itself is not important. However, the fact that we can see it by adding it to the URL suggests that we may be able to see the contents of `src/files` from it too, assuming directory listing is enabled. Let's try:

http://natas2.natas.labs.overthewire.org/files

It would seem like there is a `users.txt` file that we can check out:

http://natas2.natas.labs.overthewire.org/files/users.txt

There, you should be able to find the password easily.

## SUMMARY
We have used file navigation to retrieve the password.
