#!/bin/bash

cat << EOF
===== [U-12] /etc/services 파일 소유자 및 권한 설정  =====
EOF
echo

if test -f /etc/services
then
	echo "services 파일이 존재합니다" 2>&1
	IO=`ls -l /etc/services | awk '{print $3}'`
	IP=`ls -l /etc/services | awk '{print $1}'`

	if [ $IO = root ]
	then
		echo "==> [진단결과 : 안전] services 파일 소유자 : " $IO 2>&1
	else
		echo "==> [진단결과 : 취약] services 파일 소유자 : " $IO 2>&1
	fi

	if [ $IP = -rw-r--r-- ]
	then
		echo "==> [진단결과 : 안전] services 파일 권한   : " $IP 2>&1
	else
		echo "==> [진단결과 : 취약] services 파일 권한   : " $IP 2>&1
	fi

else
	echo "services 파일이 존재하지 않습니다" 2>&1
fi
echo 
