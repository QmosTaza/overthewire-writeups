# Natas Solver

Automated solver for the OverTheWire Natas wargame.

It uses Python to interact with web pages over HTTP, extract hidden information, and automatically progress through levels.



## Requirements

- Python 3.8+
- pip
- Internet access to natas.labs.overthewire.org
- Basic support for HTTP Basic Authentication

Install dependencies:

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```


## Project Structure

- `solver.py`: Main orchestrator for all levels
- `natas_passwords`: Generated cache of discovered passwords

Note:  
`natas_passwords` is generated at runtime and ignored by git.



## Usage

Run the solver up to a specific level.

```bash
python ./solver.py <level>
```

Example:

```bash
python ./solver.py 5
```

This will output the password required to access level 5. 


## Disclaimer

This project is for educational purposes only. This solver is meant to facilitate the retrieval of passwords for levels that the person using it has already completed, in case those passwords have changed over time or have been lost.