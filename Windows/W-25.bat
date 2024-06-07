@echo off
chcp 65001
set RESULT=W-25.txt

echo [W-25] FTP 서비스 구동 점검  > %RESULT%
echo [점검 현황]    >> %RESULT%
echo .

net start | find "Microsoft FTP Service" >> %RESULT%
echo [점검 기준] >> %RESULT%
echo [양호] FTP 서비스 구동되어 있음 >> %RESULT%
echo [취약] FTP 서비스 구동되어 있지 않음  >> %RESULT%
echo .

echo [점검결과]    >> %RESULT%
echo %ERRORLEVEL%

IF ERRORLEVEL 1 (
    echo [양호] FTP 서비스 구동 X >> %RESULT%
) ELSE (
    echo [취약] FTP 서비스 구동 O >> %RESULT%
)

pause