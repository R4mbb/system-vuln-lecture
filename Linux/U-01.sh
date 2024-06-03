#!/bin/bash

cat << EOF
===== [U-01] Remote Login Permission for the root User  =====
EOF

if [ -z "`grep pts /etc/securetty`" ]
then
echo "securetty safe"
else
echo "securetty unsafe"
fi


grep pts /etc/securetty > /dev/null 2>&1
if [ $? -eq 0 ] ; then
echo "securetty unsafe"
else
echo "securetty safe"
fi


VALUE=$(cat /etc/ssh/sshd_config | grep 'PermitRootLogin' | awk {'print $2'} | sed '/the/d')

if [ $VALUE == "yes" ] ; then
echo "PermitRootLogin unsafe"
else
echo "PermitRootLogin safe"
fi
echo""
