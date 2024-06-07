REM W-24 NetBIOS 바인딩 서비스 구동 점검
@echo off
chcp 65001
set RESULT=W-24.txt
echo [W-24] NetBIOS 바인딩 서비스 구동 점검  > %RESULT%
echo [점검 현황]    >> %RESULT%
echo.
echo ##### NetBIOS 바인딩 서비스 구동 점검 #####  >> %RESULT%
REG QUERY HKLM\SYSTEM\ControlSet001\Services\NetBT\Parameters\Interfaces /s >> %RESULT%
type %RESULT% | findstr "NetbiosOptions" | findstr /L "0x2" > nul
echo.
echo [점검 기준] >> %RESULT%
echo [양호] NetbiosOptions 값이 2로 설정되어 있음 >> %RESULT%
echo [취약] NetbiosOptions 값이 2 이외의 값으로 설정되어 있음  >> %RESULT%
echo.
echo [점검결과]    >> %RESULT%
echo %ERRORLEVEL%
If NOT ERRORLEVEL 1 (
echo NetBIOS 바인딩 양호 >> %RESULT%
) ELSE (
echo NetBIOS 바인딩 취약 >> %RESULT%
)
echo %RESULT% 문서를 확인하세요.
pause
