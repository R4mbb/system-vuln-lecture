#!/bin/bash

cat << EOF

========== [U-19] Check Finger service Enable ===========

EOF

IFS=$'\n' arr=("`cat /etc/services | grep finger | awk '{print $1}'`")

if [ -f /etc/services ]; then
  for i in ${arr[@]}; do
    if [ $i = "finger" ]; then
      echo "BAD!! Finger service enabled."
      exit 0
    fi
  done
fi

if [ -f /etc/xinetd.d/finger ]; then
  echo "BAD!! Finger service enabled."
  exit 0
else
  echo "GOOD!! Finger service disabled."
fi

unset arr
