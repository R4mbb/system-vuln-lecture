#!/bin/bash

FILE1=nosetuid.txt
FILE3=tmp3.txt

cat << EOF
================================================
[ GOOD ] : There are no SetUID/SetGID bits.
[ WARN ] : SetUID/SetGID bits exists.
================================================
EOF

cat nosetuid.txt | while read FILE2

do
	if [ -e $FILE2 ] ; then
		ls -l $FILE2 | awk '{print $1}' | grep -i 's' > $FILE3

		if [ $? -eq 0 ] ; then
			echo "WARN!! : $FILE2 (`cat $FILE3`)"
		else
			echo "GOOD!! : $FILE2"
		fi
	else
		echo "File not found. : $FILE2"

	fi
done
