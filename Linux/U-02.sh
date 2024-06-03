#!/bin/bash

cat << EOF
===== [U-02] Password Expiration and Complexity check  =====
EOF

echo "Hashing           : `cat /etc/login.defs | grep ENCRYPT_METHOD | awk '{print $1 " " $2}' | sed '/#/d'`"
echo "PASS_MAX_DAYS     : `cat /etc/login.defs | grep PASS_MAX_DAYS | awk '{print $2}' | sed '1d'` days"
echo "PASS_MIN_DAYS     : `cat /etc/login.defs | grep PASS_MIN_DAYS | awk '{print $2}' | sed '1d'` days"
echo "PASS_MIN_LEN      : `cat /etc/login.defs | grep PASS_MIN_LEN | awk '{print $2}' | sed '1d'` chars"
echo "PASS_WARN_AGE     : `cat /etc/login.defs | grep PASS_WARN_AGE | awk '{print $2}' | sed '1d'` days"
