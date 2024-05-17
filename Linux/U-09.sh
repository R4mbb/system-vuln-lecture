#!/bin/bash

cat << EOF
===== [U-09] /etc/hosts 파일 소유자 및 권한 설정  =====
EOF
echo

HO=`ls -l /etc/hosts | awk '{print $3}'`
HP=`ls -l /etc/hosts | awk '{print $1}'`

if [ $HO = root ]
then
	echo "    ==> [소유자 진단결과 : 안전] hosts 파일 소유자 : " $HO 2>&1
else
	echo "    ==> [소유자 진단결과 : 취약] hosts 파일 소유자 : " $HO 2>&1
	echo "    ==> [강화방안] hosts 파일의 소유자를 root로 변경하세요."
fi

if [ $HP = -rw------- ]
then
	echo "    ==> [권  한 진단결과 : 안전] hosts 파일 권한   : " $HP 2>&1
else
	echo "    ==> [권  한 진단결과 : 취약] hosts 파일 권한   : " $HP 2>&1
	echo "    ==> [강화방안] hosts 파일의 권한을 600으로 변경하세요." 2>&1
fi

echo
