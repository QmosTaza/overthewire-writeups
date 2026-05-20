import os
import re
import requests

PASSWORD_FILE = "natas_passwords"
MAX_LEVEL = 1


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
def request(level, password, path=""):
    url = f"http://natas{level}.natas.labs.overthewire.org{path}"
    return requests.get(url, auth=(f"natas{level}", password))


def extract_password(text):
    match = re.search(r"[A-Za-z0-9]{32}", text)
    return match.group(0) if match else None



# LEVEL SOLVERS
def solve_level_0(pw):
    r = request(0, pw, "/")
    return extract_password(r.text)

SOLVERS = {
    0: solve_level_0,
}


# CACHE VALIDATION
def test_password(level, pw):
    try:
        r = request(level, pw)
        return r.status_code == 200
    except:
        return False


# ----------------------------
# MAIN LOOP (equivalent to your Bash orchestrator)
# ----------------------------

def main(target_level=1):
    password = "natas0"

    # resume from cache
    for i in range(target_level - 1, 0, -1):
        print(f"Testing cache for level {i}")
        cached = get_password(i)
        if cached and test_password(i, cached):
            password = cached
            print(f"Found valid password for level {i}")
            break
        else:
            remove_password(i)

    # main solve loop
    for i in range(target_level):
        next_level = i + 1
        print(f"Level {i} -> {next_level}")

        solver = SOLVERS.get(i)

        if not solver:
            r = request(i, password)
            password = extract_password(r.text)
        else:
            password = solver(password)

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