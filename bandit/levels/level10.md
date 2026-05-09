# BANDIT Level 10 -> 11


## GOAL
To find the password which is stored in a file that contains base64 encoded data.


## CONTEXT
Base64 encoding is a way of converting binary data into plain ASCII text so it can be safely transmitted or stored in systems that only handle text. It works by mapping binary data into a set of 64 readable characters (A-Z, a-z, 0-9, +, and /), often adding = padding at the end to complete the encoding. It does not encrypt data or make it secure, it simply encodes it for compatibility. It is commonly used in email systems, APIs, and embedding files like images in text-based formats such as HTML or JSON.


## STEPS
Under the 'Commands you may need to solve this level', we are already told about a `base64` command. We can check the manual to find that this command encodes and decodes (`-d`) base64. 

```bash
cat data.txt
```

While `file data.txt` does not mention the type of encoding (since base64 uses plain ASCII text), by reading its contents it is clear that it is encoded. We can easily solve this level by decoding the base64:

```bash
base64 -d data.txt
```

You may want to try to output only the password by using the methods shown in previous levels.


## SUMMARY
We have used `base64` to decode an encripted file and retrieve the password from said file.
