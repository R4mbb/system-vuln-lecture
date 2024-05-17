#!/bin/bash
SP=`stat -c %a /etc/shadow`
SO=`stat -c %U /etc/shadow`
SG=`stat -c %G /etc/shadow`

echo "Permission :" $SP
echo "File owner : " $SO
echo "File group : " $SG

if [ $SP -eq 400 ]; then
	echo "File permission OK!"
else
	echo "File permission BAD"
fi

if [ $SO = "root" ]; then
	echo "File owner OK!"
else
	echo "File owner BAD"
fi

if [ $SG = "shadow" ]; then
	echo "File group OK!"
else
	echo "File group BAD"
fi
