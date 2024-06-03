REM W-01 administrator 계정 점검
@echo off
chcp 65001

set RESULT=W-01.txt

echo [W-01] Administrator 계정 확인  >> %RESULT%
echo [점검 현황]    >> %RESULT%
echo.


echo ## administrator 계정 정보 조회 ##  >> %RESULT%
net user | findstr /V "account ---- command"  >> %RESULT%
net user | findstr /V "account ---- command" | findstr /I "administrator"
echo.


echo [점검 기준] >> %RESULT%
echo [양호] echo 윈도우의 기본 관리자 계정명 administrator 존재하지 않음 >> %RESULT%
echo [취약] echo 윈도위의 기본 관리자 계정명 administrator 존재함  >> %RESULT%
echo.


echo [점검결과]    >> %RESULT%
If %errorlevel% == 0  echo 취약 >> %RESULT%
If Not %errorlevel% == 0  echo 양호 >> %RESULT%

pause
