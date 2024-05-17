#!/bin/bash

cat << EOF

========== [U-20] Check anonymous ftp settings ===========
===============================================

EOF

if [ -f /etc/proftpd/proftpd.conf ]; then
	if [ "`cat /etc/proftpd/proftpd.conf | grep anonymous_enable | awk -F= '{print $2}'`" = NO ]
	then
		echo "GOOD!!. Anonymous FTP logins are not allowed."
	else
		echo "BAD!! Anonymous FTP logins are allowed."
	fi
else
	echo "There is no FTP service."
fi
