@echo off
chcp 65001
set RESULT=W-67.txt

echo [W-67] 원격터미널 접속 타임아웃 설정  > %RESULT%
echo [점검 현황]    >> %RESULT%
echo .

reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" | findstr /I "MaxIdleTime" | findstr /V /I "fInherit" >> %RESULT%
type %RESULT% | findstr /L "0x2" > nul

echo .
echo [점검 기준] >> %RESULT%
echo [양호] 원격터미널 접속 타임아웃 설정되어 있음 >> %RESULT%
echo [취약] 원격터미널 접속 타임아웃 설정되어 있지 않음  >> %RESULT%
echo .
echo [점검결과]    >> %RESULT%
echo %ERRORLEVEL%

If NOT ERRORLEVEL 1 (
echo 원격터미널 접속 타임아웃 양호 >> %RESULT%
) ELSE (
echo 원격터미널 접속 타임아웃 취약 >> %RESULT%
)
echo %RESULT% 문서를 확인하세요.

pause