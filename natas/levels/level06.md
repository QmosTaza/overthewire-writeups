# NATAS Level 6 -> 7


## GOAL
To "log into" a website to retrieve the password.


## CONTEXT
In HTTP, the `POST` method is used to send data from the client to the server, commonly through forms, login pages, search bars, or file uploads. Unlike `GET` requests, where parameters are appended directly to the URL, `POST` requests place submitted data inside the body of the HTTP request. This makes them better suited for transmitting larger amounts of data or sensitive values that should not appear directly in the address bar.


## STEPS
http://natas6.natas.labs.overthewire.org/

After entering the username and password, we find an input box that asks us to "Input secret". Under it, we can find a button to submit our input and, to the bottom right, a "View sourcecode" button. When we click it, we find a piece of code such as the following:

```
<?
include "includes/secret.inc";

    if(array_key_exists("submit", $_POST)) {
        if($secret == $_POST['secret']) {
        print "Access granted. The password for natas7 is <censored>";
        } else {
            print "Wrong secret";
        }
    }
?>
```

You will not be able to see this if you view the source code directly (Ctrl + U). The code has been given to us this way as to not reveal the password for natas, but still give us information on how to retrieve it. 

By reading the code, we can tell that we are meant to "POST" a `secret` variable with the value stored in `includes/secret.inc`. This file is easily accessible to us:

http://natas6.natas.labs.overthewire.org/includes/secret.inc

From this file, we can read the value that we are meant to input to the submition box. If we do so, the password for the next level will be shown to us in the main page.

## SUMMARY
We have sent a specific input to the server to retrieve the password.
