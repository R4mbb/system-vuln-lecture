#!/bin/bash

cat << EOF

========== [U-22] Check the crontab service ===========

EOF


if [ -f /etc/crontab ] && [ -f /usr/bin/crontab ]; then
  if [ "`ls -ld /etc/crontab | awk '{print $1}'`" = "-rwxr-x---" ]; then
    echo "[*] /etc/crontab 파일 권한이 양호합니다!!"
  else
    echo "[*] /etc/crontab 파일 권한이 취약합니다!!"
  fi
  if [ "`ls -ld /usr/bin/crontab | awk '{print $1}'`" = "-rwxr-x---" ]; then
    echo "[*] /usr/bin/crontab 파일 권한이 양호합니다."
  else
    echo "[*] /usr/bin/crontab 파일 권한이 취약합니다."
  fi
fi

declare -i count=0
TMP1=$'\n' cron=("`ls -ld /etc/cron.*/* | awk '{print $1" "$3}'`")
for i in ${cron[@]}; do
  if [ $i[1] != "-rw-r-----" ] && [ $i[2] != "root" ]; then
    #echo "/etc/cron.* 내 파일 중 권한이 취약한 파일이 있습니다!!"
    count+=1
  fi
done

echo "[*] /etc/cron.* 내 파일 중 권한이 취약한 파일 ${count}개 있습니다!!"

unset cron
