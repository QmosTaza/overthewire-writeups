#!/bin/bash

#VARIABLES
MAX_LEVEL=4
PASSWORD="bandit0"
if [ "$1" -gt "$MAX_LEVEL" ]; then
  SOLVE_UNTIL=$MAX_LEVEL
else
  SOLVE_UNTIL=$1
fi

#SOLVERS FOR EACH LEVEL
solve_level_0() {
        cat readme | tr ' ' '\n' | grep '^[a-zA-Z0-9]\{32\}$'
}

solve_level_1() {
	cat ~/-
}

solve_level_2() {
	FILE_PATH=$(ls)
	cat ~/"$FILE_PATH"
}

solve_level_3() {
	cd inhere
	FILE_PATH=$(ls -a | tail -n 1)
	cat $FILE_PATH
}

#MAIN FUNCTION
for ((i=0; i<SOLVE_UNTIL; i++)); do
	NEXT=$((i+1))
	CMD="solve_level_$i"

	echo "Level $i -> $NEXT"

	PASSWORD=$(sshpass -p "$PASSWORD" ssh -p 2220 bandit$i@bandit.labs.overthewire.org "
		$(declare -f $CMD)
		$CMD	
	")

	echo "Password for level $NEXT: $PASSWORD"
done
