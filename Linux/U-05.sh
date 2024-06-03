#!/bin/sh

cat << EOF
===== [U-05] Root directory permission check  =====
EOF

ROOTPERM="drwx------"
CHECKPERM=`ls -l /../ | awk '{print $1" "$8" "$9}' | grep root | awk '{print $1}'`    # 여기 퍼미션을 확인하는 코드를 완성하세요

echo "Recommand root directory permission : "${ROOTPERM}
echo "Checked   root directory permission : "${CHECKPERM}
echo ""

if [ ${CHECKPERM} = ${ROOTPERM} ]; then    # 여기 비교하는 구문을 완성하세요
        echo "ROOT directory permission OK!"
else
        echo "ROOT directory permission BAD!!"
fi

unset ROOTPERM 
unset CHECKPERM
