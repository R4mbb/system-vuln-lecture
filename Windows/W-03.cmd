REM W-03 administrator 계정 점검
@echo off
chcp 65001

set RESULT=W-03.txt

echo [W-03] 불필요한 계정 제거  >> %RESULT%
echo [점검 현황]    >> %RESULT%
echo.


echo ## 전체 계정 정보 조회 ##  >> %RESULT%
net user | findstr /V "account ---- command"  >> %RESULT%
echo.


echo [점검 기준] >> %RESULT%
echo [양호] 불필요한 계정이 존재하지 않음 >> %RESULT%
echo [취약] 불필요한 계정이 존재함 >> %RESULT%
echo.

echo [점검결과]    >> %RESULT%
echo [인터뷰] 운영자/담당자와의 인터뷰를 통해 불필요한 계정 확인 >> %RESULT%

pause
