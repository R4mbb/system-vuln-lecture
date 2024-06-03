@echo off
chcp 65001

set RESULT=W-04.txt

echo ===============================
echo 계정 잠금 임계값 설정 확인 스크립트
echo ===============================
echo ■ 기준
echo 양호 : 계정 잠금 임계값이 5 이하의 값으로 설정되어 있는 경우
echo 취약 : 계정 잠금 임계값이 6 이상의 값으로 설정되어 있는 경우
echo.

echo ■ 확인
net accounts | findstr /i /C:"Lockout threshold"
echo.

echo ■ 결과
net accounts | findstr /I /C:"Lockout threshold" > 04.txt

for /f "tokens=1-3" %%a IN (%RESULT%) do set Threshold=%%c

echo [점검결과]    >> %RESULT%
if %Threshold% LEQ 5   echo 양호
if not %Threshold% LEQ 5  echo 취약

pause
