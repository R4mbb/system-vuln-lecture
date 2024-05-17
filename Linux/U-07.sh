#!/bin/bash
SP=`stat -c %a /etc/passwd`
SO=`stat -c %U /etc/passwd`
SG=`stat -c %G /etc/passwd`

echo "Permission :" $SP
echo "File owner : " $SO
echo "File group : " $SG

if [ $SP -le 644 ]; then
	echo "File permission OK!"
else
	echo "File permission BAD"
fi

if [ $SO = "root" ]; then
	echo "File owner OK!"
else
	echo "File owner BAD"
fi

if [ $SG = "root" ]; then
	echo "File group OK!"
else
	echo "File group BAD"
fi
