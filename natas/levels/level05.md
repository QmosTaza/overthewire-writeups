# NATAS Level 5 -> 6


## GOAL
To "log into" a website to retrieve the password.


## CONTEXT
Cookies are small pieces of data stored by the browser and associated with a specific website. In HTTP, they are commonly used to maintain sessions, remember user preferences, track activity, or store authentication information between HTTP requests. This is because HTTP itself is stateless, meaning each request is treated as completely independent from the previous one.


## STEPS
http://natas5.natas.labs.overthewire.org

After entering the username and password, we find the following text:

```
Access disallowed. You are not logged in
```

We are once again meant to search through the Developer Tools to find a way of changing the procedence of our visit.

We can check the HTTP requests and responses received under the tabs `Console` and `Network`, like we did in the previous level.

Both tabs show an HTTP request that has received an error response (404 Not Found). The header for the HTTP request contains a `Cookie` header which shows a variable 'loggedin=0'.

This header contains all the relevant information from previous connections to a site, which is automatically sent back to the server whenever the browser makes a request to the same site in a short amount of time. 

Because cookies can directly influence how a web application behaves, they are frequently inspected and modified during web security challenges to bypass restrictions or impersonate different states or users.

Note how, conventionally, computers use `0` to represent `false` and `1` to represent `true` because digital systems are built on binary logic, where electrical states are naturally represented using two distinct values. In programming and logic operations, 0 has become associated with the absence of a condition, while any nonzero value (usually 1) represents the presence of a condition or a successful result.

With this information, we can once again use the `curl` command to connect to the site while sending a cookie (with the option `--cookies`) stating that the variable `loggedin` equals `1` instead of `0`:

```bash
curl -u natas5:<password> --cookie loggedin=1 http://natas5.natas.labs.overthewire.org

```

After running this command, you should be able to read the password easily.

## SUMMARY
We have changed an HTTP request header to retrieve the password.
