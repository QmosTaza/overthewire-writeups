import pexpect

HOST = "bandit.labs.overthewire.org"
PORT = 2220
USER = "bandit32"
PASSWORD = ""

with open("bandit_passwords", "r") as f:
    for line in f:
        if line.startswith("32:"):
            PASSWORD = line.split("32:")[1].strip()

child = pexpect.spawn(
    f"ssh -tt {USER}@{HOST} -p {PORT}",
    encoding="utf-8"
)

child.expect("password:")
child.sendline(PASSWORD)

child.expect([">"])
child.sendline("$0")

child.delaybeforesend = 0.5
child.sendline("cat /etc/bandit_pass/bandit33")

child.expect([r"[A-Za-z0-9]{32}"])

print(child.after)