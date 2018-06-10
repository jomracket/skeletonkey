CHCP 1252
MODE CON: COLS=15 LINES=1
TITLE LAUNCHER

for /f "delims=" %%a in ("%~1") do (
set FETYPE=%%~a
set RUNROM=1
)
for /f "delims=" %%a in ("%~2") do set JYTYP=%%~a
for /f "delims=" %%a in ("%~3") do set JYZ=%%~a
for /f "delims=" %%a in ("%~4") do set DMT=%%~a
for /f "delims=" %%a in ("%~5") do set CFG=%%~a
for /f "delims=" %%a in ("%~6") do set CCMDA=%%~a
for /f "delims=" %%a in ("%~7") do set CCMDB=%%~a
for /f "delims=" %%a in ("%~8") do set CCMDY=%%~a
for /f "delims=" %%a in ("%~9") do set CCMDZ=%%~a
for %%a in ("") do set FRLOC=%%~a
set PLYRN1=
set PLYRN2=

if "%FETYPE%" NEQ "" call :REDEF
if "%JYTP%"=="." set JYTP=1
if "%JYTP%"=="" set JYTP=1
if "%FETYPE%"=="" set FETYPE=
if "%FETYPE%"=="." set FETYPE=
SET JYX=REM 
if "%JYZ%" NEQ "" set JYX=%JYX% && if "%JYTYP%" NEQ "." set JYX=
SET DMX=REM 
if "%DMT%"=="1" set DMX=
SET XFG=REM 
if "%CFG%"=="" set XFG=
if "%CFG%"=="." set XFG=REM 
SET RLOC=REM 
if "%FRLOC%"=="" set RLOC=

for %%a in ("cmd /c start """) do set XPSTRT=%%~a
for %%a in ("start /w """) do set LAUNCH=%%~a
for %%a in ("start """) do set LSTART=%%~a
for /f "tokens=2 delims=[" %%a in ('ver') do if "%%~a"=="" set WINE=1
if "%WINE%"=="1" for %%a in ("start /w") do set LAUNCH=%%~a
if "%WINE%"=="1" set XPSTRT=

set XPALT=REM 
if "%JYTP%"=="1" set XPALT=

pushd "%~dp0"

for %%A in ("C:\Emulators\Mame") do SET EMUL=%%~A&if not exist "%%~A" echo.NO EMULATOR>RJerror.log&EXIT /b
for %%A in ("C:\Emulators\Mame\Mame64.exe") do SET EMUZ=%%~nA&if not exist "%%~A" echo.NO EMULATOR EXE>RJerror.log&EXIT /b
for %%A in ("%~dpn0") do SET GAMNAM=%%~A
for %%A in ("%EMUL:~0,2%") do SET EMUDIR=%%~A
for %%A in ("%CD%") do SET GAMDIR=%%~A
%CCMDA%
%XPALT%%JYX%for %%A in ("C:\Emulators\Antimicro\antimicro.exe") do (
%XPALT%%JYX%SET ANTIMIC=%%~A
%XPALT%%JYX%SET AMDIR=%%~dpA
%XPALT%%JYX%)
%XPALT%%JYX%for %%A in ("%ANTIMIC%") do if not exist "%%~A" echo.NO ANTIMICRO>RJerror.log& set XPALT=REM  
%JYX%for %%A in ("C:\Emulators\Xpadder\XPadder.exe") do (
%JYX%SET XPADDER=%%~A
%JYX%XPDIR=%%~dpA
%JYX%)
%JYX%for %%A in ("%XPADDER%") do if not exist "%%~A" echo.NO XPADDER>RJerror.log& set JYX=REM  
%DMX%for %%A in ("[DAMVAR]") do SET DAMVAR=%%~A
%DMX%for %%A in ("%DAMVAR%") do if not exist "%%~A" echo.NO DAEMONTOOLS>>RJerror.log& set DMX=REM  
If "%PLYRN1%"=="" SET PLYRN1=Player1
If "%PLYRN2%"=="" SET PLYRN2=Player2

%XPALT%FOR /F "tokens=2 delims= " %%A IN ('TASKLIST /FI "imagename eq antimicro.exe" /v^| find /i "antimicro"') DO if "%%~A" NEQ "" goto :CPY
goto :CPY

[INIVARS]
EMUL="C:\Emulators\Mame"
EMUZ="Mame64.exe"
GAMNAM="[GAMNAM]"
ANTIMIC="C:\Emulators\Antimicro\antimicro.exe"
XPADDER="C:\Emulators\Xpadder\XPadder.exe"
DAMVAR="[DAMVAR]"
PLYRN1=""
PLYRN2=""
[INIVAREND]

:CPY
%XFG%copy /Y "mame.ini" "%EMUL%\mame.ini"
%XFG%copy /y "default.cfg" "%EMUL%\ctrlr"
%JYX%%XPSTRT% "%XPADDER%" /m "%GAMDIR%\%PLYRN1%.xpadderprofile" "%GAMDIR%\%PLYRN2%.xpadderprofile"


%XPALT%%JYX%pushd "%AMDIR%"
%XPALT%%JYX%"%ANTIMIC%" -l>"%AMDIR%lst.ini"
%XPALT%%JYX%for /f "tokens=1,2 delims=: " %%a in ('type "%AMDIR%lst.ini"') do if "%%~a"=="Index" set JNUM=%%~b&&if "%%~b" GEQ "2" for /f "tokens=1,2,3* delims= " %%i in ("--profile-controller 2 --profile %GAMDIR%\%PLYRN2%.amgp") do (
%XPALT%%JYX%set AMCP2=%%~i %%~j %%~k
%XPALT%%JYX%set AMCV=%%~l
%XPALT%%JYX%)
%XPALT%%JYX%if "%AMCV%" NEQ "" for %%a in ("%AMCV%") do set AMCV=%%a
%XPALT%%JYX%%XPSTRT% "%ANTIMIC%" --hidden --profile-controller 1 --profile "%GAMDIR%\%PLYRN1%.amgp" %AMCP2% %AMCV%
%XPALT%%JYX%popd

for /f "delims=" %%a in ('dir /B /A-D "*.dsk" "*.dmk" "*.d77" "*.d88" "*.1dd" "*.dfi" "*.hfe" "*.imd" "*.ipf" "*.mfi" "*.mfm" "*.td0" "*.cqm" "*.cqi" "*.mx1" "*.bin" "*.rom" "*.wav" "*.tap" "*.cas.zip"') do (
set ROMF=%%~a
set ROM=%%~na
set ROMX=%%~xa
set ROMFN=%%~nxa
if "%RUNROM%" NEQ "" call :REPROM
CALL :RUN
)
exit /b

[RUNVARS]
CMDLINE=""
CMDXTN="[CMDLINEGET]"
RUNOPTS=" canonv30f -cart1 | canonv30f -cass | canonv30f -flop1 "
RUNARGS=" -rp "[ROMPATH]""
ROMF="[ROMF]"
ROM="[ROM]"
ROMX="[ROMX]"
ROMFN="[ROMFN]"

[INIVARSEND]

:REDEF
exit /b

:REPROM
for %%a in ("%FETYPE%") do (
set ROMF=%%~nxa
set ROM=%%~na
set GAMDIRP=%%~dpa
)
for /f "delims=" %%a in ("%GAMDIRP:~0,-1%") do set GAMDIR=%%~a
exit /b

:RUN
%CCMDB%
%RLOC%pushd "%EMUL%"
%DMX%"%DAMVAR%" -mount dt, 0, "[ROMINLP]"
%LAUNCH% "%EMUL%\%EMUZ%.exe" canonv30f -cart1 | canonv30f -cass | canonv30f -flop1 "%GAMDIR%\%ROMF%" -rp "%GAMDIR%"
%CCMDY%
%RLOC%popd
%XFG%copy /Y "%EMUL%\mame.ini" "%GAMDIR%"
%XFG%copy /y "%EMUL%\ctrlr\default.cfg" "%GAMDIR%"
%JYX%%XPSTRT% "%XPADDER%" /m "%FETYPE%.xpadderprofile" nolayout2

%XPALT%%JYX%pushd "%AMDIR%"
%XPALT%%JYX%for /f "tokens=1,2 delims=: " %%a in ('type "%AMDIR%lst.ini"') do if "%%~a"=="Index" set JNUM=%%~b&&if "%%~b" GEQ "2" for /f "tokens=1,2,3* delims= " %%i in ("--profile-controller 2 --profile %AMDIR%nolayout2.amgp") do (
%XPALT%%JYX%set AMCP2=%%~i %%~j %%~k
%XPALT%%JYX%set AMCV=%%~l
%XPALT%%JYX%)
%XPALT%%JYX%if "%AMCV%" NEQ "" for %%a in ("%AMCV%") do set AMCV=%%a
%XPALT%%JYX%%XPSTRT% "%ANTIMIC%" --hidden --profile-controller 1 --profile "%FETYPE%.amgp" %AMCP2% %AMCV%
%XPALT%%JYX%popd
%CCMDZ%
%DMX%cmd /c "%DAMVAR%" -unmount dt, 0
if "%WINE%"=="" goto :END
taskkill /f /im cmd.exe
:END
FOR /F "tokens=2 delims= " %%A IN ('TASKLIST /FI "imagename eq cmd.exe" /v^| find /i "LAUNCHER"') DO TASKKILL /F /PID %%A