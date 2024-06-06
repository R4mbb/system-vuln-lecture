@echo off
chcp 65001
icacls c:\windows\system32\config\SAM | findstr /V /I "administrator system success" > W-37.txt
fsutil file createnew test.txt 0
echo n | comp test.txt W-37.txt

IF NOT ERRORLEVEL 1 (
    echo 취약
    echo.
) ELSE (
    REM 양호
    type  W-37.txt | find /I ":" >nul
    
    IF NOT ERRORLEVEL 1 (
        echo 취약
    ) ELSE (
        echo 양호
    )
)
pause
