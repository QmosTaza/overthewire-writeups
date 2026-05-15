# BANDIT Level 20 -> 21


## GOAL
To find the next password by running a file with setuid.


## CONTEXT
In a basic client-server connection, one program (the server) listens on a specific port and waits for incoming connections, while another program (the client) connects to that port to exchange data. The server acts like a receptionist waiting at a numbered door, and the client chooses the correct door number (the port) to reach the desired service. Once the connection is established, both sides can send and receive information until one of them closes the connection.


## STEPS
We are given a file that connects on localhost to a specified port, where it must read the password to the current level in order to send the next level's.

```bash
./suconnect 12345
```

However, if we try connecting it to a random level, it will not work. This is because it can only connect to an open port, therefore we must open one. To do so, we can use the command `nc` together with `-l`, an option that lets the connection prevail (so the terminal works as a server or listener to that port):

```bash
nc -l -p 12345
```

Nevertheless, if we just do this, we are stuck connected to the port and we cannot execute the './suconnect' file. We now have two options:

* Work on two different terminal screens at the same time (see 'ADDITIONAL CONTEXT' for information on how to do it)

* Echo the password to the `nc` command and have it run in the background

If you choose the second option, you must use the special character `&` with the command you wish to push to the background. In our case, it will look like this:

```bash
echo **pasword goes here** | nc -l -p 12345 &
LISTENER_PID=$!
./"$FILE_PATH" 12345
kill "$LISTENER_PID" 2>/dev/null
```

LISTENER_PID stores the process ID (PID) of the background listener started with '&' and the special variable '$!' contains the PID of the most recently launched background process. 'Killing it' means terminating the background process once it is no longer needed. Do not worry to much about this, it is just a way of making sure we clean after ourselves.

This way, you will receive the password. It is recommended that you try the first option on your own.


## ADDITIONAL CONTEXT
Commands like `tmux` allow you to split one terminal into multiple panes so you can work on several tasks at the same time. 

After starting `tmux`, press `Ctrl+b %` to create a vertical split or `Ctrl+b "` to create a horizontal split. You can move between panes using `Ctrl+b` followed by the arrow keys. This is especially useful when you need one pane running a server or listener (such as `nc -l`) and another pane connecting to it or monitoring its output.


## SUMMARY
We have created a simple listener and we have connected to it to retrieve the password.
