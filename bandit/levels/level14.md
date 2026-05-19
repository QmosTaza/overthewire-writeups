# BANDIT Level 14 -> 15


## GOAL
To find the next password by submitting the current password to a given port on localhost.


## CONTEXT
An IP address is a numerical identifier assigned to a device on a network, allowing computers to locate and communicate with one another. Public IP addresses are used on the internet, while private IP addresses are commonly used within local networks. Every network connection involves a source and destination IP address, which tell data packets where they are coming from and where they should be delivered.

Additionally, `localhost` is a special hostname that always refers to the current machine, typically mapped to the IP address `127.0.0.1` in IPv4 (and `::1` in IPv6). Connecting to `localhost` means communicating with a service running on your own computer rather than on a remote host. This is useful for testing applications and for secure communication between programs on the same system.

Ports are numbered communication endpoints that allow multiple services to share a single IP address. For example, web servers commonly use port 80 for HTTP and port 443 for HTTPS, while SSH typically uses port 22. When you connect to a server, both the IP address and the port number are needed to identify the exact service you want to reach.



## STEPS
The solution to this level is much simpler than it would initially seem. It requires you to read through the manual for the command `telnet`, and learn that it works by following the template `telnet HOST PORT`. 

Telnet is a network protocol used to open a remote text-based connection to another machine over TCP. When you use it, you essentially connect to a specific IP address and port and get a raw terminal session where you can send and receive plain text data.

In our case, the *HOST* we wish to connect to is `localhost` and the *PORT* is `30000`:

```bash
telnet localhost 30000
```

Then, we simply need to paste the password onto the terminal, press `Enter`, then escape the connection by typing the given 'escape character' `^]`:

```bash
<password>
^]
```

We will receive a response that contains the password.


## EXTRA STEPS
We can solve this level by using a completely different command: `nc`.
The steps are basically the same, where we simply paste the password after the nc command:

```bash
nc localhost 30000
**pasword goes here**
#Ctrl + C to end the connection
```

We could do it in one line by using the `echo` command, which prints text you give it as an argument to standard output:

```bash
echo <password> | nc localhost 30000
```

Note that this does not work with `telnet`.

If you wanted to retrieve the password on its own, you could use environmental variables. These variables can be used to save the output of a given command and allow you to operate on it more easily. They are specially useful for scripting in bash:

```bash
RESPONSE=$(echo <password> | nc localhost 30000) 
#Do not add spaces between the '=' character
echo "$RESPONSE" #To echo the response in question
```

## ADDITIONAL CONTEXT

### 1
In practice, telnet was historically used for remote administration of systems, similar to SSH. The problem is that it does not encrypt traffic, which makes it insecure on modern networks. Because of this, it's mostly deprecated for remote login and replaced by secure alternatives like SSH. 

However, it is still useful today for simple testing tasks, such as checking whether a service is listening on a port (for example, verifying if a web server or mail server is reachable on a specific endpoint).

### 2
Netcat (invoked as `netcat` or `nc`) is a simple but powerful command-line tool used to read from and write to network connections using TCP or UDP. It acts like a "network pipe", allowing you to connect to a specific IP address and port, send data, and receive responses directly in the terminal. Because of this, it's commonly used for debugging network services, testing whether ports are open, and interacting with simple server-based challenges, similarly to telnet.

In practice, nc is often preferred over tools like telnet for scripting because it is more flexible and easier to automate. You can pipe input into it, capture output, and integrate it into Bash scripts, making it very useful in environments like CTFs or wargames such as this one, where you need to send a password to a service and read back a response.

## SUMMARY
We have used `telnet` or `nc` to send and receive messages from a port in localhost, which let us listen to the password.
