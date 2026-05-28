# NATAS Level 8 -> 9


## GOAL
To "log into" a website to retrieve the password.


## CONTEXT
PHP is a server-side programming language designed primarily for building dynamic web applications. Unlike client-side languages such as JavaScript, PHP code is executed on the server before the page is sent to the browser, meaning the user only receives the generated HTML output, not the underlying logic. 

It is widely used for handling forms, managing sessions, interacting with databases, and generating content based on user input.


## STEPS
http://natas8.natas.labs.overthewire.org/

After entering the username and password, we find an input box similar to level 6's. When we open the source code, we see the following:

```php
<?

$encodedSecret = "3d3d516343746d4d6d6c315669563362";

function encodeSecret($secret) {
    return bin2hex(strrev(base64_encode($secret)));
}

if(array_key_exists("submit", $_POST)) {
    if(encodeSecret($_POST['secret']) == $encodedSecret) {
    print "Access granted. The password for natas9 is <censored>";
    } else {
    print "Wrong secret";
    }
}
?>
```

From what we can tell from this source code, we are meant to input a secret that, when used as an argument for the `encodeSecret` function, returns the `$encodedSecret` variable. Therefore, we need to do the opposite of what `encodeSecret` does on the given variable to retrieve the secret we are supposed to input.

Note how the `encodeSecret` function encodes a given secret in base64, then reverses the result and converts it from binary to hexadecimal.

We can retrieve the password by writing a `decodeSecret` function in PHP. You may use a PHP online compiler and run the followin code:

```php
<?
$encodedSecret = "3d3d516343746d4d6d6c315669563362";

function decodeSecret($secret) {
	return base64_decode(strrev(hex2bin($secret)));
}

echo decodeSecret($encodedSecret)
?>
```

This should return the decoded secret, which you can input into the submission box to obtain the password to the next level.

## SUMMARY
We have decoded an encoded secret using PHP to retrieve the password.
