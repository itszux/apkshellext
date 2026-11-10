@ECHO OFF
ECHO #######################################################
ECHO ##            APK Shell Extension  2                 ##
ECHO ##                                                   ##
ECHO ##           http://www.apkshellext.com              ##
ECHO #######################################################

REM === check and get the UAC for administrator privilege ===
REM === code from https://sites.google.com/site/eneerge/scripts/batchgotadmin
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
	if '%1' EQU '1' (
		echo Cannot elevate administrator privilege
		echo Please try again with "Run as Administrator"
		echo Installation failed.
		pause
		exit /B
	) else (
		echo Requesting administrative privileges...
		goto UACPrompt
	)
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "1", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B
	
:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

REM Register with the 64-bit regasm on 64-bit Windows (Explorer is 64-bit).
REM The old script clobbered ERRORLEVEL with the `set` commands, so it always
REM used the 32-bit regasm and 64-bit Explorer never saw the handler.
set REGASM="%windir%\Microsoft.NET\Framework64\v4.0.30319\regasm.exe"
if not exist %REGASM% set REGASM="%windir%\Microsoft.NET\Framework\v4.0.30319\regasm.exe"
%REGASM% /codebase "%~dp0\apkshellext2.dll"

ECHO Restarting Explorer to refresh icons...
TASKKILL /F /IM explorer.exe >nul 2>&1
START "" %WINDIR%\explorer.exe

ECHO Done!
ECHO.
ECHO /-------------------------------------------------------------------\
ECHO  apkshellext is an open-source project,
ECHO  Please visit http://www.apkshellext.com for more information
ECHO \-------------------------------------------------------------------/

PAUSE
@ECHO ON
