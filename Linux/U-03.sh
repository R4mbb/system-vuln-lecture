#!/bin/bash

cat << EOF
===== [U-03] Password faillock check  =====
EOF

TI=`grep deny= /etc/pam.d/common-auth | awk '{print $6}' | awk -F = '{print $2}'`

if [ "`grep deny= /etc/pam.d/common-auth`" ]
then
	echo "    ==> [진단결과 : 안전] "$TI"번 로그인 실패시 계정이 잠김 설정이 되어 있습니다."
else
	echo "    ==> [진단결과 : 취약] 계정 잠금 정책이 설정되어 있지 않습니다."
	echo "    ==> [방안] 로그인 5회 이상 실패시 계정 잠금을 설정해야 합니다."
fi
