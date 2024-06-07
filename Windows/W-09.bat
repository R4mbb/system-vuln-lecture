@echo off
chcp 65001
set RESULT=W-09.txt
echo [W-09] 불필요한 서비스 제거  > %RESULT%
echo [점검 현황]    >> %RESULT%
echo.
echo [점검 기준] >> %RESULT%
echo 양호 : 일반적으로 불필요한 서비스(위 목록 참조)가 중지되어 있는 경우 >> %RESULT%
echo 취약 : 일반적으로 불필요한 서비스(위 목록 참조)가 구동 중인 경우  >> %RESULT%
echo.
echo [점검결과]    >> %RESULT%
net start | findstr /I "Alerter ClipBook Messenger" >> %RESULT%
echo.
REM
REM 아래 errorlevel 부분은 어떻게 설정해야 할까요?
REM 
IF NOT ERRORLEVEL 1 (
echo 불필요한 Alerter, ClipBook, Messenger Services가 존재하지 않음. >> %RESULT%
) ELSE (
echo 불필요한 서비스가 발견되었습니다. 관리자와 상의하세요. >> %RESULT%
)
pause
