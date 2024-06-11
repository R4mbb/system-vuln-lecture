@echo off
cls
chcp 65001

title Windows System Vuln Check Shell

echo ------------------------------------------------------------------------------- 
echo          Windows System Vuln Check Shell
echo -------------------------------------------------------------------------------


REM -------------------------------------------------------------------------------
REM Enter the case name and datetime
REM -------------------------------------------------------------------------------

:ENTER_CASE

set /p _CASE=# Please enter the case name : || GOTO:ENTER_CASE
 
set DATE="date /t"
set TIME="time /t"
set HNAME="hostname"

FOR /F "tokens=1" %%a IN (' %DATE% ') DO SET DATE=%%a
FOR /F "tokens=2" %%a IN (' %TIME% ') DO SET TIME=%%a
FOR /F "tokens=1" %%a IN (' %HNAME% ') DO SET HNAME=%%a


REM -------------------------------------------------------------------------------
REM Enter the examiner name
REM -------------------------------------------------------------------------------
 
:ENTER_EXAMINER

set /p _EXAMINER=# Please enter the examiner's name : || GOTO:ENTER_EXAMINER
echo.

echo -------------------------------------------------------------------------------  > %HNAME%.%DATE%.txt
echo          Examiner Information       >> %HNAME%.%DATE%.txt
echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt

echo ■ Username: %username%        >> %HNAME%.%DATE%.txt
echo ■ Computername: %computername%       >> %HNAME%.%DATE%.txt
echo ■ Case name: %_CASE%        >> %HNAME%.%DATE%.txt
echo ■ Examiner name: %_EXAMINER%       >> %HNAME%.%DATE%.txt
echo ■ Stat Time : %DATE%.%TIME%       >> %HNAME%.%DATE%.txt 
echo ■ Log file : %HNAME%.%DATE%.txt       >> %HNAME%.%DATE%.txt
 
            
 
REM -------------------------------------------------------------------------------
REM Check the windows version
REM -------------------------------------------------------------------------------
 
for /f "tokens=2 delims=[]" %%i in ('ver') do set VERSION=%%i
for /f "tokens=2-3 delims=. " %%i in ("%VERSION%") do set VERSION=%%i.%%j

if "%VERSION%" == "5.00" if "%VERSION%" == "5.0" echo Windows 2000 is not supported! 
if "%VERSION%" == "5.1" (
        echo ■ OS: Windows XP        >> %HNAME%.%DATE%.txt 
        GOTO:CPU_TYPE
)

if "%VERSION%" == "5.2" (
        echo ■ OS: Windows Server 2003       >> %HNAME%.%DATE%.txt
        GOTO:CPU_TYPE
)

if "%VERSION%" == "6.0" (
        echo ■ OS: Windows Vista or Windows Server 2008     >> %HNAME%.%DATE%.txt
        GOTO:CPU_TYPE
)

if "%VERSION%" == "6.1" (
        echo ■ OS: Windows 7 or Windows Server 2008 R2     >> %HNAME%.%DATE%.txt
        GOTO:CPU_TYPE
)

if "%VERSION%" == "6.2" (
        echo ■ OS: Windows 8        >> %HNAME%.%DATE%.txt
        GOTO:CPU_TYPE
)

if "%VERSION%" == "6.3" (
        echo ■ OS: Windows 8.1        >> %HNAME%.%DATE%.txt
        GOTO:CPU_TYPE
)

if "%VERSION%" == "10.0" (
        echo ■ OS: Windows 10        >> %HNAME%.%DATE%.txt
        GOTO:CPU_TYPE
)


REM -------------------------------------------------------------------------------
REM Check the CPU Architecture
REM -------------------------------------------------------------------------------
 
:CPU_TYPE

if /i "%PROCESSOR_ARCHITECTURE:~-2%"=="86" (
echo ■ CPU: 32 bit        >> %HNAME%.%DATE%.txt 
)

if /i "%PROCESSOR_ARCHITECTURE:~-2%"=="64" (
echo ■ CPU: 64 bit        >> %HNAME%.%DATE%.txt
)
echo.           >> %HNAME%.%DATE%.txt 


echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt
echo          User Information        >> %HNAME%.%DATE%.txt 
echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt

net user          >> %HNAME%.%DATE%.txt
echo.           >> %HNAME%.%DATE%.txt 

echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt
echo          Network Information       >> %HNAME%.%DATE%.txt 
echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt

netsh interface ip show address | findstr "IP 주소:" | findstr /v "127.0.0.1"  >> %HNAME%.%DATE%.txt
echo.           >> %HNAME%.%DATE%.txt

echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt
echo          Basic System Information       >> %HNAME%.%DATE%.txt
echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt

systeminfo          >> %HNAME%.%DATE%.txt 
echo.           >> %HNAME%.%DATE%.txt




REM -------------------------------------------------------------------------------
REM W-01 Administrator 계정 이름 변경 또는 보안성 강화
REM -------------------------------------------------------------------------------

echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt
echo          W-01 Administrator 계정 이름 변경 또는 보안성 강화    >> %HNAME%.%DATE%.txt
echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt

echo [점검 현황]          >> %HNAME%.%DATE%.txt
echo ## administrator 계정 정보 조회 ##        >> %HNAME%.%DATE%.txt
net user | findstr /V "account ---- command"       >> %HNAME%.%DATE%.txt
net user | findstr /V "account ---- command" | findstr /I "administrator"  >> %HNAME%.%DATE%.txt
echo.           >> %HNAME%.%DATE%.txt

echo [점검 기준]          >> %HNAME%.%DATE%.txt
echo [양호] 윈도우의 기본 관리자 계정명 administrator 존재하지 않음    >> %HNAME%.%DATE%.txt
echo [취약] 윈도우의 기본 관리자 계정명 administrator 존재함     >> %HNAME%.%DATE%.txt
echo.           >> %HNAME%.%DATE%.txt
echo [점검결과]          >> %HNAME%.%DATE%.txt


If %errorlevel% == 0   echo 취약  : administrator 계정 존재    >> %HNAME%.%DATE%.txt
If Not %errorlevel% == 0  echo 양호  : administrator 계정 존재하지 않음   >> %HNAME%.%DATE%.txt
echo.           >> %HNAME%.%DATE%.txt


REM -------------------------------------------------------------------------------
REM W-02 Guest 기본 계정 활성화 여부 점검
REM -------------------------------------------------------------------------------

echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt
echo          W-02 Guest 기본 계정 활성화 여부 점검    >> %HNAME%.%DATE%.txt
echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt

echo [점검 현황]    >> %HNAME%.%DATE%.txt
echo ##### Guest 계정 정보 조회 #####  >> %HNAME%.%DATE%.txt
net user guest | find /I "account active"  >> %HNAME%.%DATE%.txt
net user guest | find /I "account active" | findstr  "Yes"
echo.           >> %HNAME%.%DATE%.txt

echo [점검 기준] >> %HNAME%.%DATE%.txt
echo [양호] echo 윈도우의 기본 Guest 계정명 비활성화 상태임 >> %HNAME%.%DATE%.txt
echo [취약] echo 윈도우의 기본 Guest 계정명 활성화 상태임  >> %HNAME%.%DATE%.txt
echo.           >> %HNAME%.%DATE%.txt

echo [점검결과]    >> %HNAME%.%DATE%.txt
If %errorlevel% == 0  echo 취약 : Guest 기본 계정 활성화 O >> %HNAME%.%DATE%.txt
If Not %errorlevel% == 0  echo 양호 : Guest 기본 계정 활성화 X >> %HNAME%.%DATE%.txt
echo.           >> %HNAME%.%DATE%.txt


REM -------------------------------------------------------------------------------
REM W-03 계정 잠금 임계값 설정
REM -------------------------------------------------------------------------------

echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt
echo          W-03 계정 잠금 임계값 설정    >> %HNAME%.%DATE%.txt
echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt

echo [점검 현황]    >> %HNAME%.%DATE%.txt
echo ## 전체 계정 정보 조회 ##  >> %HNAME%.%DATE%.txt
net user | findstr /V "account ---- command"  >> %HNAME%.%DATE%.txt
echo.           >> %HNAME%.%DATE%.txt

echo [점검 기준] >> %HNAME%.%DATE%.txt
echo [양호] 불필요한 계정이 존재하지 않음 >> %HNAME%.%DATE%.txt
echo [취약] 불필요한 계정이 존재함 >> %HNAME%.%DATE%.txt
echo.           >> %HNAME%.%DATE%.txt

echo [점검결과]    >> %HNAME%.%DATE%.txt
echo [인터뷰] 운영자/담당자와의 인터뷰를 통해 불필요한 계정 확인 >> %HNAME%.%DATE%.txt
echo.           >> %HNAME%.%DATE%.txt


REM -------------------------------------------------------------------------------
REM W-04 계정 잠금 임계값 설정
REM -------------------------------------------------------------------------------

echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt
echo          W-04 계정 잠금 임계값 설정    >> %HNAME%.%DATE%.txt
echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt

echo [점검 현황]    >> %HNAME%.%DATE%.txt
set TEMP=test.txt
echo ## 계정 잠금 임계값 조회 ##  >> %HNAME%.%DATE%.txt
net accounts | findstr /i /C:"Lockout threshold"    >> %TEMP%
net accounts | findstr /i /C:"Lockout threshold"    >> %HNAME%.%DATE%.txt
echo.           >> %HNAME%.%DATE%.txt

echo [점검 기준] >> %HNAME%.%DATE%.txt
echo [양호] 계정 잠금 임계값이 5 이하의 값으로 설정되어 있는 경우  >> %HNAME%.%DATE%.txt
echo [취약] 계정 잠금 임계값이 6 이상의 값으로 설정되어 있는 경우  >> %HNAME%.%DATE%.txt
echo.           >> %HNAME%.%DATE%.txt

for /f "tokens=1-3" %%a IN (%TEMP%) do set Threshold=%%c
echo [점검결과]    >> %HNAME%.%DATE%.txt
if %TEMP% LEQ 5   echo 양호 : administrator 계정 임계값 설정 O  >> %HNAME%.%DATE%.txt
if not %TEMP% LEQ 5  echo 취약 : administrator 계정 임계값 설정 X  >> %HNAME%.%DATE%.txt
echo.           >> %HNAME%.%DATE%.txt
del %TEMP%


REM -------------------------------------------------------------------------------
REM W-09 불필요한 서비스 제거
REM -------------------------------------------------------------------------------

echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt
echo          W-09 불필요한 서비스 제거    >> %HNAME%.%DATE%.txt
echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt

echo [점검 현황]    >> %HNAME%.%DATE%.txt
echo ## 불필요한 서비스 조회 ##  >> %HNAME%.%DATE%.txt
net start | findstr /I "Alerter ClipBook Messenger"  > nul
if NOT ERRORLEVEL 1 (
        net start | findstr /I "Alerter ClipBook Messenger"  >> %HNAME%.%DATE%.txt
) ELSE (
        echo Service not found.  >> %HNAME%.%DATE%.txt
)
echo.           >> %HNAME%.%DATE%.txt

echo [점검 기준] >> %HNAME%.%DATE%.txt
echo [양호] 일반적으로 불필요한 서비스(위 목록 참조)가 중지되어 있는 경우 >> %HNAME%.%DATE%.txt
echo [취약] 일반적으로 불필요한 서비스(위 목록 참조)가 구동 중인 경우  >> %HNAME%.%DATE%.txt
echo.           >> %HNAME%.%DATE%.txt

echo [점검결과]    >> %HNAME%.%DATE%.txt
net start | findstr /I "Alerter ClipBook Messenger" > nul
if ERRORLEVEL 1 (
        echo 양호 : 불필요한 Alerter, ClipBook, Messenger Services가 존재하지 않음. >> %HNAME%.%DATE%.txt
) ELSE (
        echo 취약 : 불필요한 서비스가 발견되었습니다. 관리자와 상의하세요. >> %HNAME%.%DATE%.txt
)
echo.           >> %HNAME%.%DATE%.txt


REM -------------------------------------------------------------------------------
REM W-24 NetBIOS 바인딩 서비스 구동 점검
REM -------------------------------------------------------------------------------

echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt
echo          W-24 NetBIOS 바인딩 서비스 구동 점검    >> %HNAME%.%DATE%.txt
echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt

echo [점검 현황]    >> %HNAME%.%DATE%.txt
echo ##### NetBIOS 바인딩 서비스 구동 점검 #####  >> %HNAME%.%DATE%.txt
REG QUERY HKLM\SYSTEM\ControlSet001\Services\NetBT\Parameters\Interfaces /s >> %HNAME%.%DATE%.txt
type %HNAME%.%DATE%.txt | findstr "NetbiosOptions" | findstr /L "0x2" > nul
echo.           >> %HNAME%.%DATE%.txt

echo [점검 기준] >> %HNAME%.%DATE%.txt
echo [양호] NetbiosOptions 값이 2로 설정되어 있음 >> %HNAME%.%DATE%.txt
echo [취약] NetbiosOptions 값이 2 이외의 값으로 설정되어 있음  >> %HNAME%.%DATE%.txt
echo.           >> %HNAME%.%DATE%.txt

echo [점검결과]    >> %HNAME%.%DATE%.txt
If NOT ERRORLEVEL 1 (
        echo 양호 : NetBIOS 바인딩 >> %HNAME%.%DATE%.txt
) ELSE (
        echo 취약 : NetBIOS 바인딩 >> %HNAME%.%DATE%.txt
)
echo.           >> %HNAME%.%DATE%.txt


REM -------------------------------------------------------------------------------
REM W-25  FTP 서비스 구동 점검
REM -------------------------------------------------------------------------------

echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt
echo          W-25  FTP 서비스 구동 점검    >> %HNAME%.%DATE%.txt
echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt

echo [점검 현황]    >> %HNAME%.%DATE%.txt
echo ##### FTP 서비스 구동 점검 #####  >> %HNAME%.%DATE%.txt
net start | find "Microsoft FTP Service" >nul
IF ERRORLEVEL 1 (
        echo FTP service Not found.  >>  %HNAME%.%DATE%.txt
) ELSE (
        net start | find "Microsoft FTP Service" >> %HNAME%.%DATE%.txt
)
echo.           >> %HNAME%.%DATE%.txt

echo [점검 기준] >> %HNAME%.%DATE%.txt
echo [양호] FTP 서비스 구동되어 있음 >> %HNAME%.%DATE%.txt
echo [취약] FTP 서비스 구동되어 있지 않음  >> %HNAME%.%DATE%.txt
echo.           >> %HNAME%.%DATE%.txt

echo [점검결과]    >> %HNAME%.%DATE%.txt
IF ERRORLEVEL 1 (
    echo 양호 : FTP 서비스 구동 X >> %HNAME%.%DATE%.txt
) ELSE (
    echo 취약 : FTP 서비스 구동 O >> %HNAME%.%DATE%.txt
)
echo.           >> %HNAME%.%DATE%.txt


REM -------------------------------------------------------------------------------
REM W-27  Anonymous FTP 금지
REM -------------------------------------------------------------------------------

echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt
echo          W-27  Anonymous FTP 금지    >> %HNAME%.%DATE%.txt
echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt

echo [점검 현황]    >> %HNAME%.%DATE%.txt
echo ##### Anonymous FTP 금지 점검 #####  >> %HNAME%.%DATE%.txt
reg query "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\MSFTPSVC\Parameters" /s 2>nul
if ERRORLEVEL 1 (
        echo FTP Server not found.  >> %HNAME%.%DATE%.txt
) ELSE (
        reg query "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\MSFTPSVC\Parameters" /s | findstr /I "AllowAnonymous"  >> %HNAME%.%DATE%.txt
)
echo.           >> %HNAME%.%DATE%.txt

echo [점검 기준] >> %HNAME%.%DATE%.txt
echo [양호] Anonymous FTP 금지되어 있음 >> %HNAME%.%DATE%.txt
echo [취약] Anonymous FTP 금지되어 있지 않음  >> %HNAME%.%DATE%.txt
echo.           >> %HNAME%.%DATE%.txt

echo [점검결과]    >> %HNAME%.%DATE%.txt
IF ERRORLEVEL 1 (
    echo 양호 : Anonymous FTP 금지설정 O >> %HNAME%.%DATE%.txt
) ELSE (
    echo 취약 : Anonymous FTP 금지설정 X >> %HNAME%.%DATE%.txt
)
echo.           >> %HNAME%.%DATE%.txt


REM -------------------------------------------------------------------------------
REM W-37   SAM 파일 접근 통제 설정
REM -------------------------------------------------------------------------------

echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt
echo          W-37   SAM 파일 접근 통제 설정    >> %HNAME%.%DATE%.txt
echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt

echo [점검 현황]    >> %HNAME%.%DATE%.txt
echo ##### SAM 파일 접근 통제 점검 #####  >> %HNAME%.%DATE%.txt
icacls c:\windows\system32\config\SAM | findstr /V /I "administrator system success" > test1.txt
fsutil file createnew test2.txt 0  1>nul
echo N | comp test2.txt test1.txt  1>nul
echo.           >> %HNAME%.%DATE%.txt

echo [점검 기준] >> %HNAME%.%DATE%.txt
echo [양호] SAM 파일 접근 통제 설정되어 있음 >> %HNAME%.%DATE%.txt
echo [취약] SAM 파일 접근 통제 설정되어 있지 않음  >> %HNAME%.%DATE%.txt
echo.           >> %HNAME%.%DATE%.txt

echo [점검결과]    >> %HNAME%.%DATE%.txt
IF NOT ERRORLEVEL 1 (
    echo 취약 : SAM 파일 접근 통제 설정 O   >> %HNAME%.%DATE%.txt
) ELSE (
    type  %HNAME%.%DATE%.txt | find /I ":" > nul
    
    IF NOT ERRORLEVEL 1 (
        echo 취약 : SAM 파일 접근 통제 설정 O   >> %HNAME%.%DATE%.txt
    ) ELSE (
        echo 양호 : SAM 파일 접근 통제 설정 X   >> %HNAME%.%DATE%.txt
    )
)
del test1.txt
del test2.txt
echo.           >> %HNAME%.%DATE%.txt


REM -------------------------------------------------------------------------------
REM W-67   원격터미널 접속 타임아웃 설정
REM -------------------------------------------------------------------------------

echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt
echo          W-67   원격터미널 접속 타임아웃 설정    >> %HNAME%.%DATE%.txt
echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt

echo [점검 현황]    >> %HNAME%.%DATE%.txt
echo ##### SAM 파일 접근 통제 점검 #####  >> %HNAME%.%DATE%.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" | findstr /I "MaxIdleTime" | findstr /V /I "fInherit" >> %HNAME%.%DATE%.txt
type %HNAME%.%DATE%.txt | findstr /L "0x2" > nul
echo.           >> %HNAME%.%DATE%.txt

echo [점검 기준] >> %HNAME%.%DATE%.txt
echo [양호] 원격터미널 접속 타임아웃 설정되어 있음 >> %HNAME%.%DATE%.txt
echo [취약] 원격터미널 접속 타임아웃 설정되어 있지 않음  >> %HNAME%.%DATE%.txt
echo.           >> %HNAME%.%DATE%.txt

echo [점검결과]    >> %HNAME%.%DATE%.txt
If NOT ERRORLEVEL 1 (
echo 양호 : 원격터미널 접속 타임아웃 설정됨. >> %HNAME%.%DATE%.txt
) ELSE (
echo 취약 : 원격터미널 접속 타임아웃 설정 안됨. >> %HNAME%.%DATE%.txt
)
echo.           >> %HNAME%.%DATE%.txt


echo .
echo Open the %HNAME%.%DATE%.txt file with NOTEPAD Application
pause
