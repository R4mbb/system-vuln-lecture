#!/bin/sh

cat << EOF
===== [U-06] File and Directory Owners Check =====
EOF

CHECKOWN=`find / -nouser -nogroup 2>/dev/null`

for i in ${CHECKOWN[@]}
do
	echo $i
done

if [ "${CHECKOWN}" = "" ]; then
        echo "Owner Settings GOOD!!"
else
        echo "Owner Settings BAD!!"
fi

unset CHECKPERM
