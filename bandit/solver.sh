#!/bin/bash

#VARIABLES
MAX_LEVEL=16
PASSWORD="bandit0"

if ! [[ "$1" =~ ^[0-9]+$ ]]; then
	echo "Error: argument must be a number"
	exit 1
fi
if [ "$1" -lt 1 ]; then
	echo "Error: level must be >= 1"
	exit 1
fi
if [ "$1" -gt "$MAX_LEVEL" ]; then
  SOLVE_UNTIL=$MAX_LEVEL
else
  SOLVE_UNTIL=$1
fi
RESUME=$((SOLVE_UNTIL-1))

PASSWORD_FILE=".bandit_passwords"

touch "$PASSWORD_FILE"
grep -qxF "bandit/.bandit_passwords" ../.gitignore 2>/dev/null || echo "bandit/.bandit_passwords" >> ../.gitignore
grep -qxF "0:bandit0" "$PASSWORD_FILE" 2>/dev/null || echo "0:bandit0" >> "$PASSWORD_FILE"


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

solve_level_8() {
	sort data.txt | uniq -u
}

solve_level_9() {
	strings data.txt | grep "^===" | tr -d '= ' | tail -n 1
}

solve_level_10(){
	base64 -d data.txt | tr ' ' '\n' | tail -n 1
}

solve_level_11(){
	cat data.txt | tr '[a-zA-Z]' '[n-za-mN-ZA-M]' | tr ' ' '\n' | tail -n 1
}

solve_level_12(){
	TEMP_DIR=$(mktemp -d)
	cd "$TEMP_DIR"
	cp ~/data.txt ./hex.txt
	xxd -r hex.txt > data.txt
	rm hex.txt
	FILE_NAME="data.txt"

	while true; do
		FILE_OUTPUT=$(file * | tr ' ' '\n' | head -n 2 | grep -v "$FILE_NAME")
		
		if [[ "$FILE_OUTPUT" == *gzip* ]]; then
			mv "$FILE_NAME" "$FILE_NAME.gz"
			gzip -d "$FILE_NAME.gz"
		elif [[ "$FILE_OUTPUT" == *bzip2* ]]; then
			bzip2 -d "$FILE_NAME"
			FILE_NAME="$FILE_NAME.out"
		elif [[ "$FILE_OUTPUT" == *POSIX* ]]; then
			tar -xf "$FILE_NAME"
			rm "$FILE_NAME"
			FILE_NAME=$(find . -maxdepth 1 -type f | head -n 1)
			FILE_NAME="${FILE_NAME#./}"
		else
			break
		fi
	done
	cat "$FILE_NAME" | tr ' ' '\n' | tail -n 1
}

solve_level_13(){
	LVL13_PASSWORD=$(get_password 13)
	LVL13_SSHKEY="./sshkey_lvl13.private"
	
	sshpass -p "$LVL13_PASSWORD" \
	scp -P 2220 \
		-o StrictHostKeyChecking=no \
		-o LogLevel=ERROR \
		bandit13@bandit.labs.overthewire.org:~/sshkey.private \
		"$LVL13_SSHKEY"

	grep -qxF "bandit/sshkey_lvl13.private" ../.gitignore 2>/dev/null || echo "bandit/sshkey_lvl13.private" >> ../.gitignore
	
	chmod 600 "$LVL13_SSHKEY"

	ssh -i "$LVL13_SSHKEY" \
		-o StrictHostKeyChecking=no -o LogLevel=ERROR \
		-p 2220 bandit14@bandit.labs.overthewire.org \
		"cat /etc/bandit_pass/bandit14"
}

solve_level_14(){
	LVL14_PASSWORD=$(get_password 14)
	RESPONSE=$(sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no -o LogLevel=ERROR -p 2220 \
			bandit$i@bandit.labs.overthewire.org "
			echo "$LVL14_PASSWORD" | nc localhost 30000
			" 2>/dev/null)
	echo "$RESPONSE" | tail -n 1
}

solve_level_15(){
	LVL15_PASSWORD=$(get_password 15)
	RESPONSE=$(sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no -o LogLevel=ERROR -p 2220 \
			bandit$i@bandit.labs.overthewire.org "
			printf '%s\n' '$LVL15_PASSWORD' | openssl s_client -quiet -connect localhost:30001 -servername localhost 2>/dev/null
			")
	echo "$RESPONSE" | tr ' ' '\n' | tail -n 1
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

	if [[ "$i" -eq 13 || "$i" -eq 14 || "$i" -eq 15 ]]; then
		PASSWORD=$($CMD)
	else
		PASSWORD=$(sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no -o LogLevel=ERROR -p 2220 \
			bandit$i@bandit.labs.overthewire.org "
			$(declare -f $CMD)
			$CMD
			" 2>/dev/null)
	fi

	save_password "$NEXT" "$PASSWORD"
	echo "Password for level $NEXT: $PASSWORD"
done
