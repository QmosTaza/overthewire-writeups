# NATAS Level 0 -> 1


## GOAL
To open a website located at a given HTTP URL, enter the username and password, and open "Inspect Element" mode to retrieve a password.


## CONTEXT
### 1
In HTTP, communication between a browser and a web server happens through requests and responses. When you visit a website, your browser sends an HTTP request to the server asking for a resource (such as an HTML page, image, or script), and the server replies with the corresponding content. This model is stateless, meaning each request is independent, but additional mechanisms like cookies and authentication headers can be used to maintain sessions or identify users across requests.

### 2
When using the shortcut `Ctrl + Shift + C` in a browser, you open the developer tools “Inspect Element” mode, which allows you to examine and modify the structure of a webpage in real time. 

This gives access to the page's HTML, CSS, JavaScript, network requests, cookies, and sometimes hidden elements or comments that are not directly visible in the rendered page. In the context of web challenges like Natas, this is especially useful because sensitive information is often embedded in the page source or exposed through client-side scripts rather than shown directly in the interface.


## STEPS

To open the website we need to complete this level, we can open any web browser of our choice and type the following URL on the search bar:

http://natas0.natas.labs.overthewire.org

We will be asked to enter the username and password for this level, in this case "natas0" for both.

From here, we are not given too much information other than the password being "on this page". As you can probably imagine from reading the 'CONTEXT' section, you will have to open "Inspect Element" mode to retrieve the password.

Press `Ctrl + Shift + C`
or  
Right-click the page and select **View source code** or **Inspect Element**

When you open "Inspect Element", you will be first greeted with the "Inspection" tab, which shows the HTML document as the browser interprets it. This lets you view and modify the structure of the page in real time (note that only you can see what you modify).

Inside this view, the \<head> section contains metadata about the page, such as the title, linked stylesheets, scripts, etc. Sometimes, you may find hidden comments or configuration values that are not directly visible on the page. 

The \<body> section contains the actual content rendered to the user: text, images, forms, and interactive elements. Since the DOM is fully exposed here (we will learn what that is later), anything loaded into the page, whether visible or hidden by CSS, can often be discovered or inspected. This makes this tool especially useful for analyzing how a webpage is built and where it might expose unintended information.

In our case, we can open the \<div>s in the \<body> section to find a very convenient comment that contains the password for the next level. If you chose to select **View source code** directly, you can see it without any issues.


## EXTRA STEPS

This level is essentially about understanding how a web server delivers content and how to retrieve said content. What you may not know, is that we can also retrieve content from the terminal using HTTP requests.

The command-line tool `curl` sends HTTP requests and prints the server's response directly into the terminal. In HTTP, this corresponds to making a simple `GET` request to the page and receiving the raw HTML content back. 

Since this level uses HTTP Basic Authentication, we must also provide the username and password using the `-u` flag.

```bash
curl -u natas0:natas0 http://natas0.natas.labs.overthewire.org
```

The password for the next level is hidden directly in that output.


## ADDITIONAL CONTEXT
For the remainder of this Natas series, you may want to learn how to use certain shortcuts that will make your life easier:

### Browsing Shortcuts
* `Ctrl + T`: open new tab
* `Ctrl + W`: close current tab
* `Ctrl + Shift + T`: reopen last closed tab
* `Ctrl + (Shift) + Tab`: switch to next (or previous) tab
* `Ctrl + L`: focus address bar
* `Alt + Left / Right`: back / forward

### Developer and Inspection Tools
* `Ctrl + Shift + I`: open Developer Tools
* `Ctrl + Shift + C`: open Inspect Element
* `Ctrl + Shift + J`: open console
* `F12`: toggle Developer Tools

### Page Analysis
* `Ctrl + U`: view page source
* `Ctrl + F`: search within page
* `Ctrl + Shift + R`: hard refresh (ignoring cache)


## SUMMARY
We have used HTTP and `curl` to view the source code and retrieve the password.

