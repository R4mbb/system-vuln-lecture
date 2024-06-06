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
::
  set DATE="date /t"
::
   set TIME="time /t"
::
    set HNAME="hostname"
::
     FOR /F "tokens=1" %%a IN (' %DATE% ') DO SET DATE=%%a
::
      FOR /F "tokens=2" %%a IN (' %TIME% ') DO SET TIME=%%a
::
       FOR /F "tokens=1" %%a IN (' %HNAME% ') DO SET HNAME=%%a
::
        
::
        -------------------------------------------------------------------------------
::
        Enter the examiner name
::
        -------------------------------------------------------------------------------
::
        :ENTER_EXAMINER
::
         set /p _EXAMINER=# Please enter the examiner's name : || GOTO:ENTER_EXAMINER
::
          echo.
::
           
::
           echo -------------------------------------------------------------------------------  > %HNAME%.%DATE%.txt
::
           echo          Examiner Information       >> %HNAME%.%DATE%.txt
::
           echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt
::
           echo ■ Username: %username%        >> %HNAME%.%DATE%.txt
::
           echo ■ Computername: %computername%       >> %HNAME%.%DATE%.txt
::
           echo ■ Case name: %_CASE%        >> %HNAME%.%DATE%.txt
::
           echo ■ Examiner name: %_EXAMINER%       >> %HNAME%.%DATE%.txt
::
           echo ■ Stat Time : %DATE%.%TIME%       >> %HNAME%.%DATE%.txt 
::
           echo ■ Log file : %HNAME%.%DATE%.txt       >> %HNAME%.%DATE%.txt
::
            
::
            -------------------------------------------------------------------------------
::
            Check the windows version
::
            -------------------------------------------------------------------------------
::
            for /f "tokens=2 delims=[]" %%i in ('ver') do set VERSION=%%i
::
            for /f "tokens=2-3 delims=. " %%i in ("%VERSION%") do set VERSION=%%i.%%j
::
            if "%VERSION%" == "5.00" if "%VERSION%" == "5.0" echo Windows 2000 is not supported! 
::
            if "%VERSION%" == "5.1" (
::
             echo ■ OS: Windows XP        >> %HNAME%.%DATE%.txt 
::
              GOTO:CPU_TYPE
::
              )
::
              if "%VERSION%" == "5.2" (
::
               echo ■ OS: Windows Server 2003       >> %HNAME%.%DATE%.txt
::
                GOTO:CPU_TYPE
::
                )
::
                if "%VERSION%" == "6.0" (
::
                 echo ■ OS: Windows Vista or Windows Server 2008     >> %HNAME%.%DATE%.txt
::
                  GOTO:CPU_TYPE
::
                  )
::
                  if "%VERSION%" == "6.1" (
::
                   echo ■ OS: Windows 7 or Windows Server 2008 R2     >> %HNAME%.%DATE%.txt
::
                    GOTO:CPU_TYPE
::
                    )
::
                    if "%VERSION%" == "6.2" (
::
                     echo ■ OS: Windows 8        >> %HNAME%.%DATE%.txt
::
                      GOTO:CPU_TYPE
::
                      )
::
                      if "%VERSION%" == "6.3" (
::
                       echo ■ OS: Windows 8.1        >> %HNAME%.%DATE%.txt
::
                        GOTO:CPU_TYPE
::
                        )
::
                        if "%VERSION%" == "10.0" (
::
                         echo ■ OS: Windows 10        >> %HNAME%.%DATE%.txt
::
                          GOTO:CPU_TYPE
::
                          )
::
                           
::
                           -------------------------------------------------------------------------------
::
                           Check the CPU Architecture
::
                           -------------------------------------------------------------------------------
::
                           :CPU_TYPE
::
                           if /i "%PROCESSOR_ARCHITECTURE:~-2%"=="86" (
::
                            echo ■ CPU: 32 bit        >> %HNAME%.%DATE%.txt 
::
                            )
::
                            if /i "%PROCESSOR_ARCHITECTURE:~-2%"=="64" (
::
                             echo ■ CPU: 64 bit        >> %HNAME%.%DATE%.txt
::
                             )
::
                             echo.           >> %HNAME%.%DATE%.txt 
::
                              
::
                              echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt
::
                              echo          User Information        >> %HNAME%.%DATE%.txt 
::
                              echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt
::
                              net user          >> %HNAME%.%DATE%.txt
::
                              echo.           >> %HNAME%.%DATE%.txt 
::
                               
::
                               echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt
::
                               echo          Network Information       >> %HNAME%.%DATE%.txt 
::
                               echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt
::
                               netsh interface ip show address | findstr "IP 주소:" | findstr /v "127.0.0.1"  >> %HNAME%.%DATE%.txt
::
                               echo.           >> %HNAME%.%DATE%.txt
::
                                
::
                                echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt
::
                                echo          Basic System Information       >> %HNAME%.%DATE%.txt
::
                                echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt
::
                                systeminfo          >> %HNAME%.%DATE%.txt 
::
                                echo.           >> %HNAME%.%DATE%.txt
::
                                 
::
                                 -------------------------------------------------------------------------------
::
                                 W-01 Administrator 계정 이름 변경 또는 보안성 강화
::
                                 -------------------------------------------------------------------------------
::
                                 echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt
::
                                 echo          W-01 Administrator 계정 이름 변경 또는 보안성 강화    >> %HNAME%.%DATE%.txt
::
                                 echo ------------------------------------------------------------------------------- >> %HNAME%.%DATE%.txt
::
                                 echo [점검 현황]          >> %HNAME%.%DATE%.txt
::
                                 echo.
::
                                 echo ## administrator 계정 정보 조회 ##        >> %HNAME%.%DATE%.txt
::
                                 net user | findstr /V "account ---- command"       >> %HNAME%.%DATE%.txt
::
                                 net user | findstr /V "account ---- command" | findstr /I "administrator"  >> %HNAME%.%DATE%.txt
::
                                 echo.           >> %HNAME%.%DATE%.txt
::
                                 echo [점검 기준]          >> %HNAME%.%DATE%.txt
::
                                 echo [양호] 윈도우의 기본 관리자 계정명 administrator 존재하지 않음    >> %HNAME%.%DATE%.txt
::
                                 echo [취약] 윈도우의 기본 관리자 계정명 administrator 존재함     >> %HNAME%.%DATE%.txt
::
                                 echo.           >> %HNAME%.%DATE%.txt
::
                                 echo [점검결과]          >> %HNAME%.%DATE%.txt
::
                                 If %errorlevel% == 0   echo 취약  : administrator 계정 존재    >> %HNAME%.%DATE%.txt
::
                                 If Not %errorlevel% == 0  echo 양호  : administrator 계정 존재하지 않음   >> %HNAME%.%DATE%.txt
::
                                 echo.
::
                                  
::
                                  echo Open the %HNAME%.%DATE%.txt file with NOTEPAD Application
::
                                  pause
