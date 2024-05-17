#!/bin/bash

cat << EOF
===== [U-10] /etc/(x)inetd.conf 파일 소유자 및 권한 설정  =====
EOF
echo

if test -f /etc/inetd.conf
then
	echo "inetd.conf 파일이 존재합니다" 2>&1
	IO=`ls -l /etc/inetd.conf | awk '{print $3}'`
	IP=`ls -l /etc/inetd.conf | awk '{print $1}'`

	if [ $IO = root ]
	then
		echo "==> [진단결과 : 안전] inetd.conf 파일 소유자 : " $IO 2>&1
	else
		echo "==> [진단결과 : 취약] inetd.conf 파일 소유자 : " $IO 2>&1
	fi

	if [ $IP = -rw------- ]
	then
		echo "==> [진단결과 : 안전] inetd.conf 파일 권한   : " $IP 2>&1
	else
		echo "==> [진단결과 : 취약] inetd.conf 파일 권한   : " $IP 2>&1
	fi

else
	echo "inetd.conf 파일이 존재하지 않습니다" 2>&1
fi
echo 

if test -f /etc/xinetd.conf
then
	echo "xinetd.conf 파일이 존재합니다" 2>&1
	XO=`ls -l /etc/xinetd.conf | awk '{print $3}'`
	XP=`ls -l /etc/xinetd.conf | awk '{print $1}'`

	if [ $XO = root ]
	then
		echo "==> [진단결과 : 안전] xinetd.conf 파일 소유자 : " $XO 2>&1
	else
		echo "==> [진단결과 : 취약] xinetd.conf 파일 소유자 : " $XO 2>&1
	fi

	if [ $XP = -rw------- ]
	then
		echo "==> [진단결과 : 안전] xinetd.conf 파일 권한   : " $XP 2>&1
	else
		echo "==> [진단결과 : 취약] xinetd.conf 파일 권한   : " $XP 2>&1
	fi

else
	echo "xinetd.conf 파일이 존재하지 않습니다" 2>&1
	echo 
fi
echo 

if [ -d "/etc/xinetd.d" ]
then
	echo "/etc/xinetd.d/ 폴더가 존재합니다" 2>&1
	FP=`ls -l /etc/xinetd.d/ | awk '{print $1, $9}' | sed -n '1!p' | grep -v "^-rw-r--r--"`
	FO=`ls -l /etc/xinetd.d/ | awk '{print $3, $9}' | sed -n '1!p' | grep -v "^root"`

	if [ "$FP" ]
	then
		echo "==> [진단결과 : 취약] 권한이 잘못 설정된 파일 있습니다. " 2>&1
		echo "        > " $ FP
	else
		echo "==> [진단결과 : 안전] 해당 폴더에 서비스 파일이 존재하지 않거나, 모든 파일이 올바른 권한으로 설정되어 있습니다." 2>&1
	fi

	if [ "$FO" ]
	then
		echo "==> [진단결과 : 취약] 소유자 잘못 설정된 파일 있습니다. " 2>&1
		echo "        > " $ FO
	else
		echo "==> [진단결과 : 안전] 해당 폴더에 서비스 파일이 존재하지 않거나, 모든 파일이 올바른 소유자로 설정되어 있습니다." 2>&1
	fi

else
	echo "/etc/xinetd.d 폴더가 존재하지 않습니다" 2>&1
fi

echo
echo 2>&1
