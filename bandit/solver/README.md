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

- `solver.sh`: Main orchestrator for all levels  
- `solver_*.py`: Interactive solver used for some levels.  
- `bandit_passwords`: Generated cache of discovered passwords  
- `sshkey_lvl*.private`: Generated SSH keys used in some levels  

Note:  
`bandit_passwords` and `sshkey_lvl*.private` are generated at runtime and ignored by git.



## Usage

Run the helper script with the level you wish to connect to, and it will output the password required to access that level.

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