# NATAS Level 4 -> 5


## GOAL
To access a website from another URL to retrieve the password.


## CONTEXT
### 1
The `Console` tab in Web browser Developer Tools provides access to JavaScript logs, warnings, errors, and interactive commands executed by the page. 

It is commonly used by developers to debug client-side behavior, but it can also reveal useful information during web security challenges: hidden variables, failed requests, scripts that manipulate page content dynamically... Since JavaScript often interacts directly with the browser and server, inspecting the console can help identify how a webpage behaves internally.

### 2
The `Network` tab allows you to inspect every HTTP request and response exchanged between the browser and the server while loading a webpage. This includes HTML documents, images, scripts, API calls, cookies, and request headers. 

By selecting an individual request, you can examine its full details, including the URL, response body, authentication information, and custom HTTP headers. It can be especially useful in web challenges because it exposes how the browser communicates with the server and which parameters or headers influence the application's behavior.

### 3
A `GET` request is the standard HTTP method used by browsers to retrieve resources from a server, such as webpages, images, or files. Alongside the requested URL, the browser also sends HTTP headers containing metadata about the request.



## STEPS
http://natas4.natas.labs.overthewire.org

After entering the username and password, we find the following text:

```
Access disallowed. You are visiting from "http://natas4.natas.labs.overthewire.org/index.php" while authorized users should come only from "http://natas5.natas.labs.overthewire.org/"
```

As you can probably tell from the 'CONTEXT' section, we are meant to search through the Developer Tools to find a way of changing the procedence of our visit.

We can check the HTTP requests and responses received under the tabs `Console` and `Network`.

Both tabs show an HTTP request that has received an error response (404 Not Found). The header for the HTTP response does not give us much information. However, the request we have made contains a `Referer` header which shows the URL "http://natas4.natas.labs.overthewire.org/index.php".

This header indicates the page from which the request originated. Some websites use this value to restrict access or validate navigation flow, although it is not considered secure because the client can modify it manually.

Resending a request with this header changed may require that you install a browser extention. For this reason, we are going to solve this level directly from our terminal using `curl`. To change the 'referer' header we can simply add the option `--referer` to our command:

```bash
curl -u natas4:<password> --referer "http://natas5.natas.labs.overthewire.org/" http://natas4.natas.labs.overthewire.org
```

After running this command, you should be able to read the password easily.

## SUMMARY
We have changed an HTTP request header to retrieve the password.
