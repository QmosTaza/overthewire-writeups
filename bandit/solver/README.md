# Bandit Solver

Automated solver for the OverTheWire Bandit wargame (up to level 27).

It combines Bash scripting with Python (pexpect) for interactive challenges.



## Requirements

- Python 3.8+
- pip
- Linux / WSL / macOS
- SSH access to bandit.labs.overthewire.org

Install dependencies:

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```


## Project Structure

- `solver.sh` → main orchestrator for all levels  
- `solver_25.py`, `solver_26.py` → interactive solvers (pexpect-based)  
- `bandit_passwords` → generated cache of discovered passwords  
- `sshkey_lvl*.private` → generated SSH keys used in some levels  

Note:  
`bandit_passwords` and `sshkey_lvl*.private` are generated at runtime and ignored by git.



## Usage

A helper script is included to streamline progression for each game:

```bash
./solver.sh <level>
```

Example:

```bash
./solver.sh 5
```

This will output the password required to access level 5. 


## Disclaimer

This project is for educational purposes only. This solver is meant to facilitate the retrieval of passwords for levels that the person using it has already completed, in case those passwords have changed over time or have been lost.