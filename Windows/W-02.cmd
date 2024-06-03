REM W-02 Guest 기본 계정 활성화 여부 점검
@echo off
chcp 65001

set RESULT=W-02.txt

echo [W-02] Guest 계정 비활성화 확인  > %RESULT%
echo [점검 현황]    >> %RESULT%
echo.
echo ##### Guest 계정 정보 조회 #####  >> %RESULT%
net user guest | find /I "account active"  >> %RESULT%
net user guest | find /I "account active" | findstr  "Yes"
echo.
echo [점검 기준] >> %RESULT%
echo [양호] echo 윈도우의 기본 Guest 계정명 비활성화 상태임 >> %RESULT%
echo [취약] echo 윈도우의 기본 Guest 계정명 활성화 상태임  >> %RESULT%
echo.
echo [점검결과]    >> %RESULT%
If %errorlevel% == 0  echo 취약 >> %RESULT%
If Not %errorlevel% == 0  echo 양호 >> %RESULT%

pause
