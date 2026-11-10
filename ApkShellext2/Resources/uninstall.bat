@ECHO OFF
ECHO #######################################################
ECHO ##            APK Shell Extension  2                 ##
ECHO ##                                                   ##
ECHO ##           http://apkshellext.com      s            ##
ECHO #######################################################

REM === check and get the UAC for administrator privilege ===
REM === code from https://sites.google.com/site/eneerge/scripts/batchgotadmin
REM === 
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

REM Unregister with the 64-bit regasm (matches install.bat).
set REGASM="%windir%\Microsoft.NET\Framework64\v4.0.30319\regasm.exe"
if not exist %REGASM% set REGASM="%windir%\Microsoft.NET\Framework\v4.0.30319\regasm.exe"
%REGASM% /unregister "%~dp0\apkshellext2.dll"

ECHO Restarting Explorer to refresh icons...
TASKKILL /F /IM explorer.exe >nul 2>&1
START "" %WINDIR%\explorer.exe

ECHO.
REM ECHO The apkshellext.dll may can't be deleted before explorer restart.

ECHO.
ECHO /-------------------------------------------------------------------\
ECHO  apkshellext is an open-source project,
ECHO  Please visit http://apkshellext.com for more information
ECHO \-------------------------------------------------------------------/

PAUSE
@ECHO ON
