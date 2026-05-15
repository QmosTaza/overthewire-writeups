# BANDIT Level 16 -> 17


## GOAL
To find the next password by submitting the current password to a a port in a given range with certain characteristics.


## CONTEXT
Nmap is a network scanning tool used to discover hosts, services, and open ports on a machine or network. Its main purpose is to "map" how a system is exposed from a networking perspective, showing which ports are open and what services are running behind them. 

It is widely used in system administration and cybersecurity for network inventory, security auditing, and vulnerability assessment. Nmap can also perform more advanced tasks such as service version detection, operating system fingerprinting, and script-based scanning to gather detailed information about targets. In environments like CTFs or wargames, it is especially useful for finding hidden or non-obvious services that may be running on unusual ports or using particular protocols.


## STEPS
After reading the 'CONTEXT' section, you can probably imagine that we will be using the command `nmap` to scan the ports mentioned for this level.

By skimming through the manual, we can easily figure out that to scan specific ports, we simply need to add the option `-p` to the command. With a simple scan on our host server, we should be able to find which ports are open:

```bash
nmap -p 31000-32000 localhost
```

With this list of open ports, we could use trial and error and connect to each port with the command we saw in the previous level. Since there is a small number of ports, we can reasonably do this. However, it seems more interesting in the long run to try to automate this process instead of doing it all by hand.

To automate it, we will first save the list of ports, retrieving only the port numbers with the methods we have been seeing in this writeup.

```bash
nmap localhost -p 31000-32000 | tr '/tcp' '\n'| grep -E '^[0-9]{5}$'
```

Or for a cleaner alternative:

```bash
nmap localhost -p 31000-32000 | awk '/open/ {print $1}' | cut -d/ -f1

# '/open/' in 'awk' is equivalent to "greping" by open in this case

# 'cut' separates an input into fields (f1, f2, ...) based on a delimiter ('/' in our case) specified after '-d'. 

# Note that this delimiter must be a single character
```

Once we have a clean list that contains only the ports, we will save it in an environmental variable for our convenience:

```bash
PORTS=$(nmap localhost -p 31000-32000 | awk '/open/ {print $1}' | cut -d/ -f1)
```

We can operate on this variable in Bash the same way we could do it in other languages. Therefore, we can loop over the contents of "PORTS" with a *for* loop. The basic loop format we will be using is:

```bash
for item in list; do
    commands
done
```

We wish to run the command `openssl` on the ports that we have gathered, like we did the previous level:

```bash
for p in "$PORTS"; do 
    openssl s_client -connect localhost:"$p" -servername localhost
done
```

However, we don't *just* want to connect to each port, we want to send them the previous password. Piping `echo`onto the connection may give you some problems, so it is best to use the command `printf`:

```bash
for p in "$PORTS"; do 
    printf '%s\n' **password goes here** | 
    openssl s_client -connect localhost:"$p" -servername localhost
done
```

To clean up the output, we can add the `-quiet` option to the `openssl` command and redirect the stderr to '/dev/null' like we did in previous levels. 

The correct port should respond with an SSH private key, with which you can connect to the next level. Running `./solver.sh 17` should both provide you with the password to level 17 *AND* create a file that contains the private key for said level.


## ADDITIONAL CONTEXT
Environment variables in Bash are named values stored in the shell environment that programs and scripts can access to control their behavior. They are typically written in uppercase (like PATH, HOME, or PASSWORD) and are set using `VAR=value` or exported with `export VAR=value` so that child processes can inherit them. You can access them with the `$` prefix, for example `$HOME`. Custom scripts often rely on environment variables to store values without hardcoding them directly into the program, making scripts more flexible and reusable.


## SUMMARY
We have used `nmap` to scan open ports and Bash scripting to operate on an environmental variable and automate a process that would have otherwise taken us much longer.
