# U-04 패스워드 파일 보호 관련 취약점 점검 스크립트
# 이 스크립트는 U-07, U-08과 같이 연계하여 체크해야 합니다

#!/bin/bash
SHADOW=0
PASSWD=0
RESULT_FILE="check_passwd.txt"

if [ -f "/etc/shadow" ]; then 
	SHADOW=1
	echo "shadow file exist " >> $RESULT_FILE 2>&1
	echo "`ls -al /etc/shadow`" >> $RESULT_FILE 2>&1
fi

if [ -f "/etc/passwd" ]; then 
	echo "passwd file exist " >> $RESULT_FILE 2>&1
	echo "`ls -al /etc/passwd`" >> $RESULT_FILE 2>&1
	echo "`cat /etc/passwd`" >> $RESULT_FILE 2>&1
	pass_chk=`cat /etc/passwd | awk -F":" '{ print $2 }' | grep -v 'x'`  # -v : non-matching lines

	if [ "$pass_chk" = "" ]; then
		PASSWD=1 
	fi
fi

if [ $SHADOW -eq 1 -a $PASSWD -eq 1 ]; then
	echo "Password file check : OK" >> $RESULT_FILE 2>&1
else
	echo "Password file check : BAD" >> $RESULT_FILE 2>&1
fi

unset SHADOW 
unset PASSWD
