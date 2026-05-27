# NATAS Level 6 -> 7


## GOAL
To "log into" a website to retrieve the password.


## CONTEXT
Many webpages use URL parameters to pass information from the browser to the server dynamically. These parameters appear after a `?` in the URL and follow the format `key=value`. This section of the URL is called the query string. 

Parameters allow web applications to load different content, perform searches, filter results, or customize behavior without changing the actual page path. Multiple parameters can also be combined using `&`.


## STEPS
http://natas7.natas.labs.overthewire.org/

After entering the username and password, we find to pages we can access: Home and About. There is not much of value in either of these pages, except the URLs we are visiting look something like this:

```
http://natas7.natas.labs.overthewire.org/index.php?page=<home or about>
```

Additionally, if we check the source code for the index page, we will find a hint that mentions how the password for webuser natas8 is in `/etc/natas_webpass/natas8`. 

Because applications often rely heavily on parameters such as `page`, modifying them manually is a common technique in web security challenges to explore hidden functionality or access unintended resources. Thus, we should try modifying page to see if we can access the file path that we were told about in the source code:

http://natas7.natas.labs.overthewire.org/index.php?page=/etc/natas_webpass/natas8

The password for the next level is shown directly in front of us.

## SUMMARY
We have modified a URL parameter to retrieve the password.
