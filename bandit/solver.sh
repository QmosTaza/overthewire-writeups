#!/bin/bash

#VARIABLES
MAX_LEVEL=8
PASSWORD="bandit0"

if [ "$1" -gt "$MAX_LEVEL" ]; then
  SOLVE_UNTIL=$MAX_LEVEL
else
  SOLVE_UNTIL=$1
fi
RESUME=$((SOLVE_UNTIL-1))

PASSWORD_FILE=".bandit_passwords"

touch "$PASSWORD_FILE"
grep -qxF "bandit/.bandit_passwords" ../.gitignore 2>/dev/null || echo "bandit/.bandit_passwords" >> ../.gitignore


#HELPER FUNCTIONS
get_password() {
	grep "^$1:" "$PASSWORD_FILE" 2>/dev/null | cut -d ':' -f2
}

save_password() {
	grep -v "^$1:" "$PASSWORD_FILE" > "$PASSWORD_FILE.tmp"
	echo "$1:$2" >> "$PASSWORD_FILE.tmp"
	mv "$PASSWORD_FILE.tmp" "$PASSWORD_FILE"
}

remove_password() {
	grep -v "^$1:" "$PASSWORD_FILE" > "$PASSWORD_FILE.tmp"
	mv "$PASSWORD_FILE.tmp" "$PASSWORD_FILE"
}

test_password() {
	sshpass -p "$2" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 -p 2220 \
		bandit"$1"@bandit.labs.overthewire.org "echo ok" 2>/dev/null | grep -q ok
}


#SOLVERS FOR EACH LEVEL
solve_level_0() {
	cat readme | tr ' ' '\n' | grep '^[a-zA-Z0-9]\{32\}$'
}

solve_level_1() {
	cat ./-
}

solve_level_2() {
	FILE_PATH=$(ls)
	cat ./"$FILE_PATH"
}

solve_level_3() {
	cd inhere
	FILE_PATH=$(ls -a | tail -n 1)
	cat "$FILE_PATH"
}

solve_level_4() {
	cd inhere
	FILE_PATH=$(file ./-file* | grep ASCII | tr ':' '\n' | head -n 1)
	cat "$FILE_PATH"
}

solve_level_5() {
	FILE_PATH=$(file "$(find -size 1033c -not -executable)" | grep ASCII | tr ':' '\n' | head -n 1)
	cat "$FILE_PATH" | head -n 1
}

solve_level_6() {
	FILE_PATH=$(find / -size 33c -user bandit7 -group bandit6 2>/dev/null)
	cat "$FILE_PATH"
}

solve_level_7() {
	grep "millionth" data.txt | awk '{print $2}'
}


#CACHE FUNCTION
for ((i=$((SOLVE_UNTIL-1)); i > 0; i--)); do
	echo "Testing caché for level $i"
	CACHED_PASS=$(get_password "$i")
	if [ -n "$CACHED_PASS" ] && test_password "$i" "$CACHED_PASS"; then
		PASSWORD="$CACHED_PASS"
		echo "Found valid password for level $i"
		break
	else
		remove_password "$i"
		RESUME=$((RESUME-1))
	fi
done


#MAIN FUNCTION
for ((i=$RESUME; i<SOLVE_UNTIL; i++)); do

	NEXT=$((i+1))
	CMD="solve_level_$i"

	echo "Level $i -> $NEXT"

	PASSWORD=$(sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no -o LogLevel=ERROR -p 2220 \
		bandit$i@bandit.labs.overthewire.org "
		$(declare -f $CMD)
		$CMD
		" 2>/dev/null)
	
	save_password "$NEXT" "$PASSWORD"
	echo "Password for level $NEXT: $PASSWORD"
done
