# BANDIT Level 12 -> 13


## GOAL
To find the password which is stored in a hexdump of a file that has been repeatedly compressed.


## CONTEXT
A hexdump is a representation of a file's raw contents where each byte is displayed as a two-digit hexadecimal value. This format allows you to inspect exactly how data is stored, including non-printable characters that do not appear in normal text editors. Hexdumps are especially useful when analyzing binary files, debugging data formats, or examining encoded and compressed content.

Tape Archive (`tar`) is a tool used to combine multiple files and directories into a single archive file, usually with a '.tar' extension. By itself, tar does not compress data. It simply packages files together so they can be stored or transferred more conveniently. Archives are often compressed afterward using tools such as `gzip` or `bzip2`.

The command `xxd` is a utility that generates a hexdump of a file and can also reverse a hexdump back into its original binary form. `gzip` and `bzip2` are lossless compression tools that reduce file size by encoding repeated patterns more efficiently. The former is faster and more commonly used, while the latter usually achieves better compression at the cost of slower performance.


## STEPS
In the introduction to this level, we are told that it may be useful to create a directory under '/tmp' and work under said directory. We are given a command that creates it for us, so let's use it:

```bash
mktemp -d
cd # **insert the created directory's file path here**
cp ~/data.txt ./hex.txt
```

Now we have a copy of the original data file under our directory.

We are told that this data file is a hexdump, so we should search for a command that works on hexdumps. By reading the manual for the given commands under "Commands you may need to solve this level", we find `xxd`, which works exactly as we need if we use the 'revert' option:

```bash
xxd -r hex.txt
```

However, this command simply outputs the reverted information, it does not generate any files or change the given file. For this reason, we will have to redirect the output to a new file:

```bash
xxd -r hex.txt > data.txt
```

We obtain a new file with compressed data. To learn which type of file we have retrieved, we can use our already familiar `file` command:

```bash
file *
```

We learn that this new file contains gzip compressed data. With `gzip --help`, we learn that we can decompress it with the option `-d`. However, if we do so, we will receive an error, since `gzip` expects a '.gz' file. We can rename our current file to "data2.gz":

```bash
mv data.txt data.gz 
#Note that cp would also do the job, but this way we can reduce clutter
gzip -d data.gz
file *
```

This time, the file contains bzip2 compressed data. We repeat the previous steps to find how to decompress this file:

```bash
#Bzip2 does not require the file to end in 'bz2' :)
bzip -d data
file *
```

The output file once again contains gzip compressed data. We repeat the previous steps:

```bash
mv data.out data.gz
gzip -d data.gz
file *
```

On this occasion, we are told that the resulting file is a POSIX tar archive. One look at `tar --help` and we learn that we can use the following command to remove the package:

```bash
tar -xf data
file *
```

We repeat the previous steps until we obtain an ASCII text file, which should contain the password:

```bash
# These are the file names and file types I was given, please note that the may have changed:

tar -xf data5.bin
file *
bzip -d data6.bin
file *
tar -xf data6.bin.out
file *
mv data8.bin data8.gz
gzip -d data8.gz
file * 
cat data8
```

## SUMMARY
We have used `xxd`, `gzip`, `bzip2`, `tar` and `mv` to restore a file that contains the password and retrieve said password.
