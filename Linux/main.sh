#!/bin/bash
clear


echo -n "# Please enter the case name : "
read case_name
echo -n "# Please enter the examiner's name : "
read ex_name
echo ""

DATE=$(date +"%Y-%m-%d")
Time=$(date +"%H:%M")
USERNAME=$(whoami)
HNAME=$(hostname)
OS=$(uname -a | awk '{print $1}')
ARCH=$(uname -m)

cat << EOF > ${HNAME}.${DATE}.txt
------------------------------------------------------------------------------- 
        Examiner Information       
------------------------------------------------------------------------------- 

■ Username: ${USERNAME}        
■ Computername: ${HNAME}       
■ Case name: ${case_name}        
■ Examiner name: ${ex_name}
■ Stat Time : ${DATE}.${Time}        
■ Log file : ${HNAME}.${DATE}.txt       
■ OS: ${OS}
■ CPU: ${ARCH}      


EOF


USERLIST=$(cat /etc/passwd | grep -E '1+[[:digit:]]{3}' | awk '{split($1,tmp,":"); print tmp[1]}')
cat << EOF >> ${HNAME}.${DATE}.txt
------------------------------------------------------------------------------- 
        User Information         
------------------------------------------------------------------------------- 

■ User List
${USERLIST}


EOF


TMP1=$'\n' IP=("`ifconfig | grep 'inet ' | awk '{print $2}'`")
cat << EOF >> ${HNAME}.${DATE}.txt
------------------------------------------------------------------------------- 
        Network Information        
------------------------------------------------------------------------------- 

EOF
for i in ${IP[@]}; do
    echo "■ IP Address:                   ${i}" >> ${HNAME}.${DATE}.txt
done
unset IP
cat << EOF >> ${HNAME}.${DATE}.txt


EOF


# -------------------------------------------------------------------------------
# U-01 Remote Login Permission for the root User
# -------------------------------------------------------------------------------

cat << EOF >> ${HNAME}.${DATE}.txt
-------------------------------------------------------------------------------
        U-01 Remote Login Permission for the root User   
-------------------------------------------------------------------------------

[**root 계정 원격접속 제한 설정**]
EOF
echo"" >> ${HNAME}.${DATE}.txt

if [ -z "`grep pts /etc/securetty 2>/dev/null`" ]
then
    echo "[양호] securetty safe" >> ${HNAME}.${DATE}.txt
else
    echo "[취약] securetty unsafe" >> ${HNAME}.${DATE}.txt
fi

VALUE=`(cat /etc/ssh/sshd_config | grep 'PermitRootLogin' | awk {'print $2'}) 2>/dev/null`
if [ "$VALUE" = "yes" ] ; then
    echo "[취약] PermitRootLogin unsafe" >> ${HNAME}.${DATE}.txt
else
    echo "[양호] PermitRootLogin safe" >> ${HNAME}.${DATE}.txt
fi
cat << EOF >> ${HNAME}.${DATE}.txt


EOF


# -------------------------------------------------------------------------------
# U-02 Password Expiration and Complexity check
# -------------------------------------------------------------------------------

cat << EOF >> ${HNAME}.${DATE}.txt
-------------------------------------------------------------------------------
        U-02 Password Expiration and Complexity check   
-------------------------------------------------------------------------------

[**패스워드 복잡성 설정**]
EOF
echo "Hashing           : `cat /etc/login.defs | grep ENCRYPT_METHOD | awk '{print $1 " " $2}' | sed '/#/d'`" >> ${HNAME}.${DATE}.txt
echo "PASS_MAX_DAYS     : `cat /etc/login.defs | grep PASS_MAX_DAYS | awk '{print $2}' | sed '1d'` days" >> ${HNAME}.${DATE}.txt
echo "PASS_MIN_DAYS     : `cat /etc/login.defs | grep PASS_MIN_DAYS | awk '{print $2}' | sed '1d'` days" >> ${HNAME}.${DATE}.txt
echo "PASS_MIN_LEN      : `cat /etc/login.defs | grep PASS_MIN_LEN | awk '{print $2}' | sed '1d'` chars" >> ${HNAME}.${DATE}.txt
echo "PASS_WARN_AGE     : `cat /etc/login.defs | grep PASS_WARN_AGE | awk '{print $2}' | sed '1d'` days" >> ${HNAME}.${DATE}.txt
cat << EOF >> ${HNAME}.${DATE}.txt


EOF


# -------------------------------------------------------------------------------
# U-03 Password faillock check
# -------------------------------------------------------------------------------

cat << EOF >> ${HNAME}.${DATE}.txt
-------------------------------------------------------------------------------
        U-03 Password faillock check   
-------------------------------------------------------------------------------

[**계정 잠금 임계값 설정**]
EOF
TI=`grep deny= /etc/pam.d/common-auth | awk '{print $6}' | awk -F = '{print $2}'`

echo"" >> ${HNAME}.${DATE}.txt
if [ "`grep deny= /etc/pam.d/common-auth`" ]
then
	echo "[양호] "$TI"번 로그인 실패시 계정이 잠김 설정이 되어 있습니다." >> ${HNAME}.${DATE}.txt
else
	echo "[취약] 계정 잠금 정책이 설정되어 있지 않습니다." >> ${HNAME}.${DATE}.txt
	echo "[방안] 로그인 5회 이상 실패시 계정 잠금을 설정해야 합니다." >> ${HNAME}.${DATE}.txt
fi
cat << EOF >> ${HNAME}.${DATE}.txt


EOF


# -------------------------------------------------------------------------------
# U-04 Password File secure
# -------------------------------------------------------------------------------

cat << EOF >> ${HNAME}.${DATE}.txt
-------------------------------------------------------------------------------
        U-04 Password File secure   
-------------------------------------------------------------------------------

[**패스워드 파일 보호 설정**]
EOF
SHADOW=0
PASSWD=0
RESULT_FILE="check_passwd.txt"

if [ -f "/etc/shadow" ]; then 
	SHADOW=1
	echo "shadow file exist " >> $RESULT_FILE 2>&1
	echo "`ls -al /etc/shadow`" >> $RESULT_FILE 2>&1
fi

if [ -f "/etc/passwd" ]; then 
	echo "passwd file exist " >> $RESULT_FILE 2>&1
	echo "`ls -al /etc/passwd`" >> $RESULT_FILE 2>&1
	echo "`cat /etc/passwd`" >> $RESULT_FILE 2>&1
	pass_chk=`cat /etc/passwd | awk -F":" '{ print $2 }' | grep -v 'x'`

	if [ "$pass_chk" = "" ]; then
		PASSWD=1 
	fi
fi

echo"" >> ${HNAME}.${DATE}.txt
if [ $SHADOW -eq 1 -a $PASSWD -eq 1 ]; then
	echo "[양호] Password file check : OK" >> ${HNAME}.${DATE}.txt
else
	echo "[취약] Password file check : BAD" >> ${HNAME}.${DATE}.txt
fi

unset SHADOW 
unset PASSWD
rm -rf $RESULT_FILE
cat << EOF >> ${HNAME}.${DATE}.txt


EOF


# -------------------------------------------------------------------------------
# U-05 root Home, Path Derectory Permissions Settings
# -------------------------------------------------------------------------------

cat << EOF >> ${HNAME}.${DATE}.txt
-------------------------------------------------------------------------------
        U-05 root Home, Path Derectory Permissions Settings   
-------------------------------------------------------------------------------

[**root홈, 패스 디렉터리 권한 및 패스 설정**]
EOF
ROOTPERM="drwx------"
CHECKPERM=`ls -l /../ | awk '{print $1" "$8" "$9}' | grep root | awk '{print $1}'`    # 여기 퍼미션을 확인하는 코드를 완성하세요

echo "[점검기준] Recommand root directory permission : "${ROOTPERM} >> ${HNAME}.${DATE}.txt
echo "[점검결과] Checked   root directory permission : "${CHECKPERM} >> ${HNAME}.${DATE}.txt
echo "" >> ${HNAME}.${DATE}.txt

if [ ${CHECKPERM} = ${ROOTPERM} ]; then    # 여기 비교하는 구문을 완성하세요
        echo "[양호] ROOT directory permission OK!" >> ${HNAME}.${DATE}.txt
else
        echo "[취약] ROOT directory permission BAD!!" >> ${HNAME}.${DATE}.txt
fi

unset ROOTPERM 
unset CHECKPERM
cat << EOF >> ${HNAME}.${DATE}.txt


EOF


# -------------------------------------------------------------------------------
# U-06 File and Directory Owners Check
# -------------------------------------------------------------------------------

cat << EOF >> ${HNAME}.${DATE}.txt
-------------------------------------------------------------------------------
        U-06 File and Directory Owners Check   
-------------------------------------------------------------------------------

[**파일 및 디렉터리 소유자 설정**]
EOF
CHECKOWN=`find / -nouser -nogroup 2>/dev/null`

for i in ${CHECKOWN[@]}
do
	echo $i >> ${HNAME}.${DATE}.txt
done

echo"" >> ${HNAME}.${DATE}.txt
if [ "${CHECKOWN}" = "" ]; then
        echo "[양호] Owner Settings GOOD!!" >> ${HNAME}.${DATE}.txt
else
        echo "[취약] Owner Settings BAD!!" >> ${HNAME}.${DATE}.txt
fi

unset CHECKPERM
cat << EOF >> ${HNAME}.${DATE}.txt


EOF


# -------------------------------------------------------------------------------
# U-07 /etc/passwd file Owner and Permissions Settings
# -------------------------------------------------------------------------------

cat << EOF >> ${HNAME}.${DATE}.txt
-------------------------------------------------------------------------------
        U-07 /etc/passwd file Owner and Permissions Settings   
-------------------------------------------------------------------------------

[**/etc/passwd 파일 소유자 및 권한 설정**]
EOF
SP=`stat -c %a /etc/passwd`
SO=`stat -c %U /etc/passwd`
SG=`stat -c %G /etc/passwd`

echo "Permission :" $SP >> ${HNAME}.${DATE}.txt
echo "File owner : " $SO >> ${HNAME}.${DATE}.txt
echo "File group : " $SG >> ${HNAME}.${DATE}.txt

echo"" >> ${HNAME}.${DATE}.txt
if [ $SP -le 644 ]; then
	echo "[양호] File permission OK!" >> ${HNAME}.${DATE}.txt
else
	echo "[취약] File permission BAD" >> ${HNAME}.${DATE}.txt
fi

if [ $SO = "root" ]; then
	echo "[양호] File owner OK!" >> ${HNAME}.${DATE}.txt
else
	echo "[취약] File owner BAD" >> ${HNAME}.${DATE}.txt
fi

if [ $SG = "root" ]; then
	echo "[양호] File group OK!" >> ${HNAME}.${DATE}.txt
else
	echo "[취약] File group BAD" >> ${HNAME}.${DATE}.txt
fi
cat << EOF >> ${HNAME}.${DATE}.txt


EOF


# -------------------------------------------------------------------------------
# U-08 /etc/shadow file Owner and Permissions Settings
# -------------------------------------------------------------------------------

cat << EOF >> ${HNAME}.${DATE}.txt
-------------------------------------------------------------------------------
        U-08 /etc/shadow file Owner and Permissions Settings   
-------------------------------------------------------------------------------

[**/etc/shadow 파일 소유자 및 권한 설정**]
EOF
SP=`stat -c %a /etc/shadow`
SO=`stat -c %U /etc/shadow`
SG=`stat -c %G /etc/shadow`

echo "Permission :" $SP >> ${HNAME}.${DATE}.txt
echo "File owner : " $SO >> ${HNAME}.${DATE}.txt
echo "File group : " $SG >> ${HNAME}.${DATE}.txt

echo"" >> ${HNAME}.${DATE}.txt
if [ $SP -eq 400 ]; then
	echo "[양호] File permission OK!" >> ${HNAME}.${DATE}.txt
else
	echo "[취약] File permission BAD" >> ${HNAME}.${DATE}.txt
fi

if [ $SO = "root" ]; then
	echo "[양호] File owner OK!" >> ${HNAME}.${DATE}.txt
else
	echo "[취약] File owner BAD" >> ${HNAME}.${DATE}.txt
fi

if [ $SG = "shadow" ]; then
	echo "[양호]File group OK!" >> ${HNAME}.${DATE}.txt
else
	echo "[취약] File group BAD" >> ${HNAME}.${DATE}.txt
fi
cat << EOF >> ${HNAME}.${DATE}.txt


EOF


# -------------------------------------------------------------------------------
# U-09 /etc/hosts file Owner and Permissions Settings
# -------------------------------------------------------------------------------

cat << EOF >> ${HNAME}.${DATE}.txt
-------------------------------------------------------------------------------
        U-09 /etc/hosts file Owner and Permissions Settings   
-------------------------------------------------------------------------------

[**/etc/hosts 파일 소유자 및 권한 설정**]
EOF
HO=`ls -l /etc/hosts | awk '{print $3}'`
HP=`ls -l /etc/hosts | awk '{print $1}'`

echo"" >> ${HNAME}.${DATE}.txt
if [ $HO = root ]
then
	echo "[안전] hosts 파일 소유자 : " $HO  >> ${HNAME}.${DATE}.txt
else
	echo "[취약] hosts 파일 소유자 : " $HO  >> ${HNAME}.${DATE}.txt
	echo "[강화방안] hosts 파일의 소유자를 root로 변경하세요." >> ${HNAME}.${DATE}.txt
    echo"" >> ${HNAME}.${DATE}.txt
fi

if [ $HP = -rw------- ]
then
	echo "[안전] hosts 파일 권한   : " $HP  >> ${HNAME}.${DATE}.txt
else
	echo "[취약] hosts 파일 권한   : " $HP  >> ${HNAME}.${DATE}.txt
	echo "[강화방안] hosts 파일의 권한을 600으로 변경하세요."  >> ${HNAME}.${DATE}.txt
fi
cat << EOF >> ${HNAME}.${DATE}.txt


EOF


# -------------------------------------------------------------------------------
# U-10 /etc/(x)inetd.conf file Owner and Permissions Settings
# -------------------------------------------------------------------------------

cat << EOF >> ${HNAME}.${DATE}.txt
-------------------------------------------------------------------------------
        U-10 /etc/(x)inetd.conf file Owner and Permissions Settings   
-------------------------------------------------------------------------------

[**/etc/(x)inetd.conf 파일 소유자 및 권한 설정**]
EOF
echo"" >> ${HNAME}.${DATE}.txt
if test -f /etc/inetd.conf
then
	IO=`ls -l /etc/inetd.conf | awk '{print $3}'`
	IP=`ls -l /etc/inetd.conf | awk '{print $1}'`

	if [ $IO = root ]
	then
		echo "[안전] inetd.conf 파일 소유자 : " $IO  >> ${HNAME}.${DATE}.txt
	else
		echo "[취약] inetd.conf 파일 소유자 : " $IO  >> ${HNAME}.${DATE}.txt
	fi

	if [ $IP = -rw------- ]
	then
		echo "[안전] inetd.conf 파일 권한   : " $IP  >> ${HNAME}.${DATE}.txt
	else
		echo "[취약] inetd.conf 파일 권한   : " $IP  >> ${HNAME}.${DATE}.txt
	fi

else
	echo "[----] inetd.conf 파일이 존재하지 않습니다"  >> ${HNAME}.${DATE}.txt
fi

echo"" >> ${HNAME}.${DATE}.txt
if test -f /etc/xinetd.conf
then
	XO=`ls -l /etc/xinetd.conf | awk '{print $3}'`
	XP=`ls -l /etc/xinetd.conf | awk '{print $1}'`

	if [ $XO = root ]
	then
		echo "[안전] xinetd.conf 파일 소유자 : " $XO  >> ${HNAME}.${DATE}.txt
	else
		echo "[취약] xinetd.conf 파일 소유자 : " $XO  >> ${HNAME}.${DATE}.txt
	fi

	if [ $XP = -rw------- ]
	then
		echo "[안전] xinetd.conf 파일 권한   : " $XP  >> ${HNAME}.${DATE}.txt
	else
		echo "[취약] xinetd.conf 파일 권한   : " $XP  >> ${HNAME}.${DATE}.txt
	fi

else
	echo "[----] xinetd.conf 파일이 존재하지 않습니다"  >> ${HNAME}.${DATE}.txt
fi

echo"" >> ${HNAME}.${DATE}.txt
if [ -d "/etc/xinetd.d" ]
then
	FP=`ls -l /etc/xinetd.d/ | awk '{print $1, $9}' | sed -n '1!p' | grep -v "^-rw-r--r--"`
	FO=`ls -l /etc/xinetd.d/ | awk '{print $3, $9}' | sed -n '1!p' | grep -v "^root"`

	if [ "$FP" ]
	then
		echo "[취약] 권한이 잘못 설정된 파일 있습니다. "  >> ${HNAME}.${DATE}.txt
		echo "        > " $ FP
	else
		echo "[안전] /etc/xinetd.d/ 내 서비스 파일이 존재하지 않거나,
        모든 파일이 올바른 권한으로 설정되어 있습니다."  >> ${HNAME}.${DATE}.txt
	fi

	if [ "$FO" ]
	then
		echo "[취약] 소유자 잘못 설정된 파일 있습니다. "  >> ${HNAME}.${DATE}.txt
		echo "        > " $ FO
	else
		echo "[안전] /etc/xinetd.d/ 내 서비스 파일이 존재하지 않거나,
        모든 파일이 올바른 소유자로 설정되어 있습니다."  >> ${HNAME}.${DATE}.txt
	fi

else
	echo "[----] /etc/xinetd.d/ 폴더가 존재하지 않습니다"  >> ${HNAME}.${DATE}.txt
fi
cat << EOF >> ${HNAME}.${DATE}.txt


EOF


# -------------------------------------------------------------------------------
# U-11 /etc/syslog.conf file Owner and Permissions Settings
# -------------------------------------------------------------------------------

cat << EOF >> ${HNAME}.${DATE}.txt
-------------------------------------------------------------------------------
        U-11 /etc/syslog.conf file Owner and Permissions Settings   
-------------------------------------------------------------------------------

[**/etc/syslog.conf 파일 소유자 및 권한 설정**]

EOF
if test -f /etc/syslog.conf
then
	IO=`ls -l /etc/syslog.conf | awk '{print $3}'`
	IP=`ls -l /etc/syslog.conf | awk '{print $1}'`

	if [ $IO = root ]
	then
		echo "[안전] syslog.conf 파일 소유자 : " $IO  >> ${HNAME}.${DATE}.txt
	else
		echo "[취약] syslog.conf 파일 소유자 : " $IO  >> ${HNAME}.${DATE}.txt
	fi

	if [ $IP = -rw-r----- ]
	then
		echo "[안전] syslog.conf 파일 권한   : " $IP  >> ${HNAME}.${DATE}.txt
	else
		echo "[취약] syslog.conf 파일 권한   : " $IP  >> ${HNAME}.${DATE}.txt
	fi

else
	echo "[----] syslog.conf 파일이 존재하지 않습니다"  >> ${HNAME}.${DATE}.txt
fi
cat << EOF >> ${HNAME}.${DATE}.txt


EOF


# -------------------------------------------------------------------------------
# U-12 /etc/services file Owner and Permissions Settings
# -------------------------------------------------------------------------------

cat << EOF >> ${HNAME}.${DATE}.txt
-------------------------------------------------------------------------------
        U-12 /etc/services file Owner and Permissions Settings   
-------------------------------------------------------------------------------

[**/etc/services 파일 소유자 및 권한 설정**]

EOF
if test -f /etc/services
then
	IO=`ls -l /etc/services | awk '{print $3}'`
	IP=`ls -l /etc/services | awk '{print $1}'`

	if [ $IO = root ]
	then
		echo "[안전] services 파일 소유자 : " $IO  >> ${HNAME}.${DATE}.txt
	else
		echo "[취약] services 파일 소유자 : " $IO  >> ${HNAME}.${DATE}.txt
	fi

	if [ $IP = -rw-r--r-- ]
	then
		echo "[안전] services 파일 권한   : " $IP  >> ${HNAME}.${DATE}.txt
	else
		echo "[취약] services 파일 권한   : " $IP  >> ${HNAME}.${DATE}.txt
	fi

else
	echo "[----] services 파일이 존재하지 않습니다"  >> ${HNAME}.${DATE}.txt
fi
cat << EOF >> ${HNAME}.${DATE}.txt


EOF


# -------------------------------------------------------------------------------
# U-13  SUID, SGID, Setting files Check
# -------------------------------------------------------------------------------

cat << EOF >> ${HNAME}.${DATE}.txt
-------------------------------------------------------------------------------
        U-13  SUID, SGID, Setting files Check   
-------------------------------------------------------------------------------

[**SUID, SGID, 설정 파일점검**]

EOF
FILE=( # 점검할 파일 내용들
'/sbin/dump'
'/sbin/restore'
'/usr/bin/newgrp'
'/sbin/unix_chkpwd'
'/usr/bin/lpq-cups'
'/usr/bin/lpr'
'/usr/bin/lpc'
'/usr/bin/lpr-cups'
'/usr/sbin/lpc-cups'
'/usr/bin/lpq'
'/usr/bin/lprm-cups'
'/usr/bin/lprm'
'/usr/bin/at'
'/usr/bin/mount'
'/usr/bin/traceroute'
)
cat << EOF >> ${HNAME}.${DATE}.txt
================================================
[ 양호 ] : There are no SetUID/SetGID bits.
[ 취약 ] : SetUID/SetGID bits exists.
================================================

EOF
for i in ${FILE[@]}; do
    if [ -e ${i} ]; then
        TMP=$(ls -l ${i} | awk '{print $1}' | grep -i 's')
        if [ $? -eq 0 ]; then
            echo "[취약] : ${i}" >> ${HNAME}.${DATE}.txt
        else
            echo "[양호] : ${i}" >> ${HNAME}.${DATE}.txt
        fi
    else
        echo "[----] File not found : ${i}" >> ${HNAME}.${DATE}.txt
    fi
done
cat << EOF >> ${HNAME}.${DATE}.txt


EOF


# -------------------------------------------------------------------------------
# U-19  Check Finger service Enable
# -------------------------------------------------------------------------------

cat << EOF >> ${HNAME}.${DATE}.txt
-------------------------------------------------------------------------------
        U-19  Check Finger service Enable   
-------------------------------------------------------------------------------

[**Finger 서비스 활성화 점검**]

EOF
IFS=$'\n' arr=("`cat /etc/services | grep finger | awk '{print $1}'`")

if [ -f /etc/services ]; then
    for i in ${arr[@]}; do
        if [ $i = "finger" ]; then
            echo "[취약] [/etc/services] Finger service enabled." >> ${HNAME}.${DATE}.txt
        fi
    done
fi

if [ -f /etc/xinetd.d/finger ]; then
    echo "[취약] [/etc/xinetd.d/finger] Finger service enabled." >> ${HNAME}.${DATE}.txt
else
    echo "[양호] [/etc/xinetd.d/finger] Finger service disabled." >> ${HNAME}.${DATE}.txt
fi

unset arr
cat << EOF >> ${HNAME}.${DATE}.txt


EOF


# -------------------------------------------------------------------------------
# U-20  Check anonymous ftp settings
# -------------------------------------------------------------------------------

cat << EOF >> ${HNAME}.${DATE}.txt
-------------------------------------------------------------------------------
        U-20  Check anonymous ftp settings   
-------------------------------------------------------------------------------

[**Anonymous FTP 서비스 활성화 점검**]

EOF
if [ -f /etc/proftpd/proftpd.conf ]; then
	if [ "`cat /etc/proftpd/proftpd.conf | grep anonymous_enable | awk -F= '{print $2}'`" = NO ]
	then
		echo "[양호] Anonymous FTP logins are not allowed." >> ${HNAME}.${DATE}.txt
	else
		echo "[취약] Anonymous FTP logins are allowed." >> ${HNAME}.${DATE}.txt
	fi
else
	echo "[----] There is no FTP service." >> ${HNAME}.${DATE}.txt
fi
cat << EOF >> ${HNAME}.${DATE}.txt


EOF


# -------------------------------------------------------------------------------
# U-22  Check the crontab service
# -------------------------------------------------------------------------------

cat << EOF >> ${HNAME}.${DATE}.txt
-------------------------------------------------------------------------------
        U-22  Check the crontab service   
-------------------------------------------------------------------------------

[**crontab 서비스 점검**]

EOF