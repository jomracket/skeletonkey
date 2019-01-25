#NoEnv
#SingleInstance Force
rjsyst= %1%
rjemut= %2%
process, exist, %3%
if (ERRORLEVEL = 0)
	{
		exitapp
	}
splitpath,A_ScriptDir,,,,,drvp
Gui, Add, GroupBox, x4 y0 w265 h162 +Center, SETUP
Gui, Add, Text, x14 y18 w44 h16, Systems
Gui, Add, Text, x13 y89 w46 h18, Emulators
Gui, Add, Edit, x13 y42 w247 h42 vintrmsys +readonly, %rjsyst%
Gui, Add, Edit, x14 y110 w247 h42 vintrmemu +readonly, %rjemut%
Gui, Add, Button, x60 y19 w62 h17 gSETJKR, BROWSE
Gui, Add, Button, x61 y89 w62 h17 gSETEMUD, BROWSE
Gui, Add, CheckBox, x139 y18 w112 h17 vRNMDIR checked, Rename Directories
Gui Add, Button, x190 y163 w80 h23 vCONTINUE gCONTINUE disabled, CONTINUE
Gui, Show, w274 h188, Window
ifexist,%rjsyst%\
	{
		ifexist,%rjemut%\
			{
				RJSYSTEMS= %rjsyst%
				RJEMUF= %rjemut%
				IniWrite, "%RJEMUF%",Settings.ini,GLOBAL,emulators_directory
				IniWrite, "%RJSYSTEMS%",Settings.ini,GLOBAL,systems_directory
				guicontrol,enable,CONTINUE			
			}
	}
iniread,RJSYSTEMS,Settings.ini,GLOBAL,systems_directory
iniread,RJEMUD,Settings.ini,GLOBAL,emulators_directory
if ((RJSYSTEMS <> "") && (RJEMUD <> "") && (RJSYSTEMS <> "ERROR") && (RJEMUD <> "ERROR"))
	{
		guicontrol,enable,CONTINUE
	}
return

SETJKD:
RJSYSTSL= %1%
SETJKR:
RJSYSTEMF=
FileSelectFolder, RJSYSTEMF,%RJSYSTSL%,3,Select the Root folder for all systems %vvtmp%
RJSYSTEMFX= %RJSYSTEMF%
if (RJSYSTEMF = "")
	{
		IF (SYSRETRY = "1")
			{
				MsgBox,1,--=REQUIRED=--,You must select a location for your systems to continue.
			}
		if (SYSRETRY = "")
			{
				SYSRETRY= 1
				RJSYSTSL= 
				vvtmp= 
				goto, SETJKR
			}
	}

stringright,efi,RJSYSTEMF,2	
stringLeft,efix,RJSYSTEMF,2
if (efi = ":\")
	{
		RJSYSDRV= %RJSYSTEMF%
		RJSYSTEMF= %efix%
		RJSYSTEMFX= %RJSYSTEMF%Console
	}
splitpath,RJSYSTEMFX,pthnm
if (pthnm = A_Username)
	{
		Msgbox,3,User Directory Root?,Systems Directory set to`n " %RJSYSTEMF%\Console "`n      Is this okay?
		ifmsgbox,yes
			{
				RJSYSTEMF=%RJSYSTEMF%\Console
				ifnotexist, %RJSYSTEMF%\Console
					{
						FileCreateDir,%RJSYSTEMF%\Console
						if (ERRORLEVEL <> 0)
							{
								Msgbox,5,Directory Creation Failed,Directory %RJSYSTEMF% could not be created.
								ifmsgbox, Retry
									{
										RJSYSTSL= 
										goto, SETJKR
									}
								FileDelete,Settings.ini
								Run, %comspec% cmd /c taskkill /f /im skeletonKey.exe,,hide
								ExitApp	
							}
					}
			}
		ifmsgbox,no
			{
				avhl= SJMPOT
				if (alii = 1)
					{
						avhl= SETJKD	
					}
				alii= 	
				goto, %avhl%
			}
		ifmsgbox,cancel
			{
				goto, SETJKD
			}
	
	}
if (efi = ":\")
	{
		SFEvb= Create a
		RJSYSTEMFR= %RJSYSTEMF%
		ifexist, %RJSYSTEMF%\Console
			{
				SFEvb= Use the
				RJSYSTEMFR= %RJSYSTEMF%\Console
			}
		Msgbox,8196,Confirm,%SFEvb% Console directory?,4
		RJSYSTEMF= %RJSYSTEMFR%
		ifmsgbox,no
			{
				RJSYSTEMF= %RJSYSDRV%
			}
		ifmsgbox,cancel
			{
				RJSYSTSL= 
				goto, SETJKR
			}
			
	}
	
Msgbox,8196,Confirm,You have selected ''%RJSYSTEMF%''`nAre you sure you would like to use this directory?,14
ifmsgbox,no
	{
		goto, SETJKD
	}
ifmsgbox,cancel
	{
		goto, SETJKD
	}
AUTOFUZ= 0
JUNCTOPT= 1
RJSYSTEMS= %RJSYSTEMF%
nfemu= 1
stringreplace,RJSYSTEMS,RJSYSTEMS,\\,\,All
IniWrite, "%RJSYSTEMS%",Settings.ini,GLOBAL,systems_directory
ifnotexist, %RJSYSTEMF%
	{
		filecreatedir,%RJSYSTEMF%
			if (ERRORLEVEL <> 0)
				{
					Msgbox,5,Directory Creation Failed,Directory %RJSYSTEMF% could not be created.
					ifmsgbox, Retry
						{
							RJSYSTSL= 
							goto, SETJKR
						}
					FileDelete,Settings.ini
					Run, %comspec% cmd /c taskkill /f /im skeletonKey.exe,,hide
					ExitApp	
				}
	}
splitpath,RJSYSTEMF,RJHHS
if (RJHHS <> "Console")
	{
		SFEvb= Create a
		ifexist, %RJSYSTEMF%\Console
			{
				SFEvb= Use the
			}
		Msgbox,8196,Confirm,%SFEvb% Console directory?,14
		ifmsgbox,yes
			{
				RJSYSTEMF= %RJSYSTEMF%\Console
				ifnotexist,%RJSYSTEMF%
					{
						filecreatedir,%RJSYSTEMF%
						if (ERRORLEVEL <> 0)
							{
								Msgbox,5,Directory Creation Failed,Directory %RJSYSTEMF% could not be created.
								ifmsgbox, Retry
									{
										RJSYSTSL= 
										goto, SETJKR
									}
								FileDelete,Settings.ini
								Run, %comspec% cmd /c taskkill /f /im skeletonKey.exe,,hide
								ExitApp	
							}
					}
			}
		ifmsgbox,cancel
			{
				goto, SETJKD
			}
	}
guicontrol,,intrmsys,%RJSYSTEMS%
iniread,RJSYSTEMS,Settings.ini,GLOBAL,systems_directory
iniread,RJEMUD,Settings.ini,GLOBAL,emulators_directory
if ((RJSYSTEMS <> "") && (RJEMUD <> "") && (RJSYSTEMS <> "ERROR") && (RJEMUD <> "ERROR"))
	{
		guicontrol,enable,CONTINUE
	}

return

SETEMUD:
ifexist, %A_ScriptDir%\apps
	{
		EMUTSL= %A_ScriptDir%\apps
	}
ifexist, %drvp%\Emulators
	{
		EMUTSL= %drvp%\Emulators
	}
vvtmp= (cancel to select any location)
RJEMUF=

SETEMUR:
FileSelectFolder, RJEMUF,%EMUTSL%,3,Select the Root folder for all emulators %vvtmp%
if (RJEMUF = "")
	{
		if (EMUTRST = 1)
			{
				MsgBox,1,--=REQUIRED=--,You must select a directory for emulators.			
			}
		if (EMUTRST = "")
			{
				emutrst= 1
				EMUTSL= 
				vvtmp= 
				goto, SETEMUR
			}
	}

stringright,efi,RJEMUF,2	
if (efi = ":\")
	{
		SFEvb= Create an
		ifexist,%RJEMUF%\Emulators
			{
				SFEvb= Use the
			}
		RJSDRV= %RJEMUF%
		RJEMUF= %RJEMUF%Emulators
		Msgbox,8196,Confirm,Confirm %SFEvb% Emulator directory?,4
		ifmsgbox,no
			{
				RJEMUF= %RJSDRV%
			}
		ifmsgbox,cancel
			{
				EMUTSL= 
				goto, SETEMUR
			}
	}	
ifnotexist,%RJEMUF%	
	{
		filecreatedir,%RJEMUF%
		if (ERRORLEVEL <> 0)
			{
				Msgbox,5,Directory Creation Failed, Directory %RJEMUF% could not be created.
				ifmsgbox, Retry
					{
						EMUTSL= 
						goto, SETEMUR
					}
				FileDelete,Settings.ini
				Run, %comspec% cmd /c taskkill /f /im skeletonKey.exe,,hide
				ExitApp
			}
	}
splitpath,RJEMUF,RJHHS
if (RJHHS <> "Emulators")
	{
		SFEvb= Create an
		ifexist, %RJEMUF%\Emulators
			{
				SFEvb= Use the
			}
		Msgbox,8196,Confirm,%SFEvb% Emulator directory?,4
		ifmsgbox,yes
			{
				RJEMUF= %RJEMUF%\Emulators
				ifnotexist,%RJEMUF%
					{
						filecreatedir,%RJEMUF%
						if (ERRORLEVEL <> 0)
							{
								Msgbox,5,Directory Creation Failed, Directory %RJEMUF% could not be created.
								ifmsgbox, Retry
									{
										EMUTSL= 
										goto, SETEMUR
									}
								FileDelete,Settings.ini
								Run, %comspec% cmd /c taskkill /f /im skeletonKey.exe,,hide
								ExitApp
							}
					}
			}
		ifmsgbox,cancel
			{
				EMUTSL= 
				goto, SETEMUR
			}
	}
splitpath,RJEMUF,usremum
if (usremum = A_Username)
	{
		Msgbox,8196,Confirm,Create an Emulators directory?,4
		ifmsgbox,Yes
			{
				RJEMUF= %RJEMUF%\Emulators
			}
		ifmsgbox,cancel
			{
				EMUTSL= 
				goto, SETEMUR
			}
		Msgbox,3,User Directory Root?,Emulators Directory set to`n " %RJEMUF% "`n      Is this okay?
		ifmsgbox,yes
			{
				ifnotexist, %RJEMUF%
					{
						FileCreateDir,%RJEMUF%
						if (ERRORLEVEL <> 0)
							{
								Msgbox,5,Directory Creation Failed, Directory %RJEMUF% could not be created.
								goto, SETEMUR
							}
					}
			}
		ifmsgbox,no
			{
				anii= SETEMUD
				if (nfemu = 1)
					{
						anii= CNFUR
					}
				nfemu= 	
				goto, %anii%
			}
		ifmsgbox,cancel
			{
				EMUTSL= 
				goto, SETEMUR
			}
	}
IniWrite, "%RJEMUF%",Settings.ini,GLOBAL,emulators_directory
guicontrol,,intrmemu,%RJEMUF%
iniread,RJSYSTEMS,Settings.ini,GLOBAL,systems_directory
iniread,RJEMUD,Settings.ini,GLOBAL,emulators_directory
if ((RJSYSTEMS <> "") && (RJEMUD <> "") && (RJSYSTEMS <> "ERROR") && (RJEMUD <> "ERROR"))
	{
		guicontrol,enable,CONTINUE
	}

return


CONTINUE:
IniWrite, "1",Settings.ini,GLOBAL,wizard_complete
IniWrite, "%RJEMUF%",Settings.ini,GLOBAL,emulators_directory
IniWrite, "%RJSYSTEMS%",Settings.ini,GLOBAL,systems_directory
exitapp