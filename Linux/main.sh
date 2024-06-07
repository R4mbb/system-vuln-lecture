#!/bin/bash
clear


echo -n "# Please enter the case name : "
read case_name
echo -n "# Please enter the examiner's name : "
read ex_name
echo ""

DATE=$(date +"%Y-%m")
TIME=$(date +"%H:%M")
USERNAME=$(whoami)
HNAME=$(hostname)
OS=$(uname -a | awk '{print $1}')
ARCH=$(uname -m)

cat << EOF > ${HNAME}.${TIME}.txt
------------------------------------------------------------------------------- 
         Examiner Information       
------------------------------------------------------------------------------- 

■ Username: ${USERNAME}        
■ Computername: ${HNAME}       
■ Case name: ${case_name}        
■ Examiner name: ${ex_name}
■ Stat Time : ${DATE}.${TIME}        
■ Log file : ${HNAME}.${TIME}.txt       
■ OS: ${OS}
■ CPU: ${ARCH}      


EOF

USERLIST=$(cat /etc/passwd | grep -E '1+[[:digit:]]{3}' | awk '{split($1,tmp,":"); print tmp[1]}')

cat << EOF >> ${HNAME}.${TIME}.txt
------------------------------------------------------------------------------- 
         User Information         
------------------------------------------------------------------------------- 

■ User List
${USERLIST}


EOF

IP=

cat << EOF >> ${HNAME}.${TIME}.txt
------------------------------------------------------------------------------- 
         Network Information        
------------------------------------------------------------------------------- 
    IP Address:                           192.168.145.1
    IP Address:                           192.168.222.1
    IP Address:                           192.168.11.238
    IP Address:                           172.23.160.1


EOF



# -------------------------------------------------------------------------------
# U-01 Remote Login Permission for the root User
# -------------------------------------------------------------------------------

cat << EOF
-------------------------------------------------------------------------------
         U-01 Remote Login Permission for the root User   
-------------------------------------------------------------------------------
EOF


