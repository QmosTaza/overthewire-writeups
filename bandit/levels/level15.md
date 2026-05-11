# BANDIT Level 15 -> 16


## GOAL
To find the next password by submitting the current password to a given port on localhost using SSL/TLS encryption.


## CONTEXT
SSL/TLS encryption refers to cryptographic protocols used to secure communication over a network, most commonly the internet. SSL/TLS ensures that data exchanged between a client (like a browser or SSH client) and a server is encrypted, preventing eavesdropping, tampering, and impersonation. Although SSL is the older version and largely deprecated, it is often still used as a name, while TLS is the modern, secure standard.

TLS works by first establishing a secure handshake between client and server, where they agree on encryption methods and exchange cryptographic keys. After this handshake, all transmitted data is encrypted using symmetric encryption, which is fast and efficient. This is what makes HTTPS websites secure and is also used in many other secure services like email, APIs, and secure file transfers.


## STEPS
To solve this level, we can take a look at the 'Helpful Reading Material' section, specifically at the OpenSSL Cookbook, since `openssl` is the command we will need to connect with SSL/TLS encryption.

We learn that we can use this command with the client tool of OpenSSL (`s_client`) and the options `-crlf`, `-connect` and `servername` to connect to a secure server in a way similar to `nc` and `telnet`. We simply need to supply a hostname and a port in the following manner: `openssl s_client -crlf -connect HOST:PORT -servername HOST`.

Note that we supply the host twice, once to establish the TCP connection (which requires both host and port), and another time to specify the server name sent at the TLS level. The switch `-crlf` makes sure that you do not disconnect after the first HTTP request line. 

In our case we will simply have to connect with `openssl` and send the previous password:

```bash
openssl s_client -crlf -connect localhost:30001 -servername localhost

# You will receive a lot of diagnostic output here once you press Enter

**pasword goes here** # + Enter
```

After this, you will receive a message with the password.


## SUMMARY
We have used `openssl` and its client tool to send and receive messages from a port in localhost using SSL/TLS encryption, which let us listen to the password.
