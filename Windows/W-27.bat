@echo off
chcp 65001
set RESULT=W-27.txt

echo [W-27] Anonymous FTP 금지  > %RESULT%
echo [점검 현황]    >> %RESULT%
echo .

reg query "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\MSFTPSVC\Parameters" /s | findstr /I "AllowAnonymous" >> %RESULT%
echo [점검 기준] >> %RESULT%
echo [양호] Anonymous FTP 금지되어 있음 >> %RESULT%
echo [취약] Anonymous FTP 금지되어 있지 않음  >> %RESULT%
echo .

echo [점검결과]    >> %RESULT%
echo %ERRORLEVEL%

IF ERRORLEVEL 1 (
    echo [양호] Anonymous FTP 금지설정 O >> %RESULT%
) ELSE (
    echo [취약] Anonymous FTP 금지설정 X >> %RESULT%
)

pause