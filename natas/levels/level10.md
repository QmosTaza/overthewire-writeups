# NATAS Level 10 -> 11


## GOAL
To escape from an insecure search bar to retrieve the password.


## CONTEXT
When working with regex, certain characters have special meanings and are used to describe flexible search patterns instead of literal text. Some of the most common ones are:

* `.` → matches any single character
* `*` → matches the previous pattern zero or more times
* `+` → matches the previous pattern one or more times
* `?` → makes the previous pattern optional
* `^` → matches the beginning of a line
* `$` → matches the end of a line
* `[abc]` → matches any character inside the brackets
* `[^abc]` → matches any character except those inside the brackets

These symbols allow regular expressions to perform more powerful searches and pattern matching.


## STEPS
http://natas10.natas.labs.overthewire.org/

After entering the username and password, we find a search bar similar to last level's, only this time some special characters are disallowed. When we open the source code, we see the following:

```
Output:
<pre>
<?
$key = "";

if(array_key_exists("needle", $_REQUEST)) {
    $key = $_REQUEST["needle"];
}

if($key != "") {
    if(preg_match('/[;|&]/',$key)) {
        print "Input contains an illegal character!";
    } else {
        passthru("grep -i $key dictionary.txt");
    }
}
?>
</pre>
```

Therefore, the special characters `;`, `|` and `&` are not allowed, so if we try the same trick as last level it will not work. However, we can circunvent this problem by utilising the `grep` command directly, then commenting the dictionary file like we did previously.

The `-i` flag in `grep` must be followed by a character, so we can simply use the special character `.`. Reading the password file directly should work as long as we have read permissions:

``` bash
. /etc/natas_webpass/natas11 #
```

The password should appear on screen.

## SUMMARY
We have injected a command to a poorly implemented search bar to gain access to the server and retrieve the next password.
