#NoEnv
;#Warn
;#NoTrayIcon
#Persistent
#SingleInstance Force

;{;;;;;;, TOGGLE, ;;;;;;;;;
SetWorkingDir %A_ScriptDir%
cacheloc= %A_Temp%
ARCH= 64
		  
if (A_Is64bitOS	= 0)
	{
		ARCH= 32
	}
;;BLDTOOLS= https://raw.githubusercontent.com/romjacket/BuildTools/master/BuildTools-%ARCH%.7z
;;NOTEPADL= https://raw.githubusercontent.com/romjacket/Notepad_PlusPlus/master/Notepad_PlusPlus.7z
;;save= %cacheloc%\BuildTools-%ARCH%.7z
;;npsave= %cacheloc%\Notepad_PlusPlus.7z

optionONE= %1%
optionTWO= %2%
optionTHREE= %3%
optionFOUR= %4%

ifinstring,optionONE,-gituser
	{
		stringsplit,vvi,optionONE,=
		GITUSER= %vvi2%
		ifinstring,optionTWO,-gitpass
			{
				stringsplit,vvb,optionTWO,=
				GITPASS= %vvb2%
				ifinstring,optionTHREE,-gittoken
					{
						stringsplit,vvc,optionTHREE,=
						GITPAT= %vvc2%
					}
			}
	}

ifinstring,optionONE,-reset
	{
		FileDelete,%save%
		FileDelete,%npsave%
		Msgbox,3,Credentials,Keep git credentials and passwords?
		ifmsgbox,Cancel
			{
				goto, QUITOUT
			}
		cntrst= 1	
		GITROOT=
		SITEURL=
		BUILDIR=
		BUILDW=
		SKELD=
		AHKDIR=
		DEPL=
		NSIS=
		GITAPP=
		GITD=
		SITEDIR=
		SHDRPURL=
		GETIPADR=
		NLOB=
		REPOURL=
		UPDTURL=
		GITSRC=
		GITRLS=
		NPPR=
		ifmsgbox,No
			{
				GITPASS= 
				GITUSER=
				GITPAT=
				cntrst= 
			}
		filedelete,skopt.cfg
	}

Loop, %save%
	{
		if (A_LoopFileSizeMB < 30)
			{
				filedelete, %save%
			}
	}
ifnotexist, skopt.cfg
	{
		ifexist, %save%
			{
				MsgBox,3,BuildTools-%ARCH%,Would you like to keep the build-tools in your temp directory?`nIt will be redownloaded if needed.
				ifmsgbox, No
					{
						filedelete, %save%
					}
			}
	}
ProgramFilesX86 := A_ProgramFiles . (A_PtrSize=8 ? " (x86)" : "")
skeltmp= %A_ScriptDir% 
IfExist, %A_MyDocuments%\skeletonKey
	{
		skeltmp= %A_MyDocuments%\skeletonKey
	}
gitrttmp= %GITROOT%
IfExist, %A_MyDocuments%\Github
	{
		gitrttmp= %A_MyDocuments%\Github
	}
gittmp= %A_MyDocuments%
ifexist, %GITROOT%
	{
		gittmp= %GITROOT%
	}
ifexist,%GITROOT%\skeletonkey
	{
		gittmp= %GITROOT%\skeletonkey
	}
IfExist, %A_MyDocuments%\Github\skeletonKey
	{
		gittmp= %A_MyDocuments%\Github\skeletonKey
	}
ahktmp= %A_MyDocuments%	
comptmp= %A_MyDocuments%
IfExist, %A_ProgramFiles%\AutoHotkey\Compiler
	{
		ahktmp= %A_ProgramFiles%\AutoHotkey\Compiler
		comptmp= %A_ProgramFiles%\AutoHotkey\Compiler
	}
IfExist, %A_MyDocuments%\AutoHotkey\Compiler
	{
		ahktmp= %A_MyDocuments%\AutoHotkey\Compiler
		comptmp= %A_MyDocuments%\AutoHotkey\Compiler
	}
depltmp= 
IfExist, %A_MyDocuments%\Github\skeletonkey.deploy
	{
		depltmp= %A_MyDocuments%\Github\skeletonkey.deploy
	}
bldtmp= 
IfExist,%A_WorkingDir%\sets\skdeploy.set
	{
		bldtmp= %A_WorkingDir%
	}
gitapdtmp= %a_programfiles%\git\bin
ifnotexist, %gitapptmp%
	{
		gitapdtmp= %A_MyDocuments%
	}
nsitmp= %A_MyDocuments%\NSIS
nstmp= %A_MyDocuments%\NSIS\makensis.exe

npptmp= %A_MyDocuments%
ifexist, %A_ProgramFiles%\Notepad++
	{
		npptmp= %A_ProgramFiles%\Notepad++
	}
ifexist, %A_ProgramFilesx86%\Notepad++
	{
		npptmp= %A_ProgramFiles%\Notepad++
	}
iniread,REPOURLX,sets\arcorg.set,GLOBAL,HOSTINGURL
;;FileReadline,REPOURLX,sets\arcorg.set,2
if (REPOURLX <> "")
	{
		REPORULT= %REPOURLX%
	}
			
FormatTime, date, YYYY_MM_DD, yyyy-MM-dd
FormatTime, TimeString,,Time
rntp= hide
skhtnum=
oldvrnum= 
buildtnum= 
oldsznum= 
olsize= 
olsha= 
olrlsdt= 
vernum= 
INIT= 

if ("%1%" = "show")
	{
		rntp= max
	}

IfNotExist, skopt.cfg
	{
		INIT= 1
		if (cntrst = 1)
			{
				if (GITUSER <> "")
					{
						iniwrite,%GITUSER%,skopt.cfg,GLOBAL,git_username
					}
				if (GITPASS <> "")
					{
						iniwrite,%GITPASS%,skopt.cfg,GLOBAL,git_password
					}
				if (GITPAT <> "")
					{
						iniwrite,%GITPAT%,skopt.cfg,GLOBAL,git_token
					}
				goto, READSKOPT
			}
			
		gosub, SelDXB
	}
	
READSKOPT:	
Loop, Read, skopt.cfg
	{
		curvl1= 
		curvl2= 
		stringsplit, curvl, A_LoopReadLine,=
		if (curvl1 = "Git_Root")
				{
					if (curvl2 <> "")
						{
							GITROOT= %curvl2%
						}
				}
		if (curvl1 = "Build_Directory")
			{
				if (curvl2 <> "")
					{
						BUILDIR= %curvl2%
					}
			}
		if (curvl1 = "Working_file")
			{
				if (curvl2 <> "")
					{
						BUILDW= %curvl2%
					}
			}
		if (curvl1 = "Source_Directory")
			{
				if (curvl2 <> "")
					{
						SKELD= %curvl2%
					}
			}
		if (curvl1 = "Compiler_Directory")
			{
				if (curvl2 <> "")
					{
						AHKDIR= %curvl2%
					}
			}
		if (curvl1 = "Deployment_Directory")
			{
				if (curvl2 <> "")
					{
						DEPL= %curvl2%
					}
			}
		if (curvl1 = "NSIS")
				{
					if (curvl2 <> "")
						{
							NSIS= %curvl2%
						}
				}
		if (curvl1 = "Git_app")
				{
					if (curvl2 <> "")
						{
							GITAPP= %curvl2%
							splitpath,GITAPP,,GITAPPT
						}
				}
		if (curvl1 = "Project_Directory")
					{
						if (curvl2 <> "")
							{
								GITD= %curvl2%
							}
					}
		if (curvl1 = "Site_URL")
					{
						if (curvl2 <> "")
							{
								SITEURL= %curvl2%
							}
					}
		if (curvl1 = "Site_Directory")
					{
						if (curvl2 <> "")
							{
								SITEDIR= %curvl2%
							}
					}
		if (curvl1 = "shader_url")
				{
					if (curvl2 <> "")
						{
							SHDRPURL= %curvl2%
						}
				}
		if (curvl1 = "net_ip")
				{
					if (curvl2 <> "")
						{
							GETIPADR= %curvl2%
						}
				}
		if (curvl1 = "lobby_url")
				{
					if (curvl2 <> "")
						{
							NLOB= %curvl2%
						}
				}
		if (curvl1 = "repository_url")
				{
					if (curvl2 <> "")
						{
							REPOURL= %curvl2%
						}
				}
		if (curvl1 = "update_url")
				{
					if (curvl2 <> "")
						{
							UPDTURL= %curvl2%
						}
				}
		if (curvl1 = "update_file")
				{
					if (curvl2 <> "")
						{
							UPDTFILE= %curvl2%
						}
				}
		if (curvl1 = "git_url")
				{
					if (curvl2 <> "")
						{
							GITSRC= %curvl2%
						}
				}
		if (curvl1 = "git_username")
				{
					if (curvl2 <> "")
						{
							GITUSER= %curvl2%
						}
				}
		if (curvl1 = "git_password")
				{
					if (curvl2 <> "")
						{
							GITPASS= %curvl2%
						}
				}
		if (curvl1 = "git_token")
				{
					if (curvl2 <> "")
						{
							GITPAT= %curvl2%
						}
				}
		if (curvl1 = "git_app")
				{
					if (curvl2 <> "")
						{
							GITAPP= %curvl2%
						}
				}
		if (curvl1 = "git_rls")
				{
					if (curvl2 <> "")
						{
							GITRLS= %curvl2%
						}
				}
		if (curvl1 = "Notepad_PlusPlus")
				{
					if (curvl2 <> "")
						{
							NPPR= %curvl2%
						}
				}


	}	

if (GITUSER = "")
	{
		gosub, GetGUSR
	}
if (GITUSER = "")
	{
		msgbox,1,,Git User must be set.`nGITUSER set to ''romjacket'',5
	}
if (GITPASS = "")
	{
		gosub, GitGPass
	}
if (GITROOT = "")
	{
		gosub, GitRoot
	}
if (GITROOT = "")
	{
		msgbox,1,,Git Root Directory must be set.
		filedelete, skopt.cfg
		ExitApp
	}
ifnotexist, %GITROOT%
	{
		gosub, GitRoot
	}
if (GITAPP = "")
	{
		gosub, GetApp
	}
if (GITAPP = "")
	{
		msgbox,1,,Git.exe must be set.
		filedelete, skopt.cfg
		ExitApp
	}
if (GITSRC = "")
	{
		gosub, GitSRC
	}	
ifnotexist,%GITAPP%
	{
		gosub, GetApp
	}
if (GITRLS = "")
	{
		splitpath,gitapp,,gitrlstmp
		gosub, GetRls
	}
if (GITRLS = "")
	{
		msgbox,1,,github-release.exe must be set to deploy executables to github.
	}
if (BUILDIR = "")
	{
		gosub, GetBld
	}
if (BUILDIR = "")
	{
		msgbox,1,,Build Directory must be set.
		filedelete, skopt.cfg
		ExitApp
	}
ifnotexist,%BUILDIR%
	{
		gosub, GetBLD
	}
if (BUILDW = "")
	{
		gosub, GetWrk
	}
if (BUILDW = "")
	{
		msgbox,1,,Working development file must be set.
		filedelete, skopt.cfg
		ExitApp
	}
ifnotexist,%BUILDW%
	{
		gosub, GetWrk
	}
if (SKELD = "")
	{
		gosub, GetSrc
	}
if (SKELD = "")
	{
		msgbox,1,,Source Directory must be set.
		filedelete, skopt.cfg
		ExitApp
	}
ifnotexist,%SKELD%
	{
		gosub, GetSrc
	}
if (DEPL = "")
	{
		depltmp= %GITROOT%
		gosub, GetDepl
	}
if (DEPL = "")
	{
		msgbox,1,.deploy,Deployment Directory must be set.
		filedelete, skopt.cfg
		ExitApp
	}
ifnotexist, %DEPL%
	{
		gosub, GetDepl
	}
if (AHKDIR = "")
	{
		gosub, GetComp
	}
if (AHKDIR = "")
	{
		msgbox,1,,Compiler Directory must be set.
		filedelete, skopt.cfg
		ExitApp
	}
ifnotexist,%AHKDIR%
	{
		gosub, GetComp
	}
if (GITD = "")
	{
		gosub, GetGit
	}
if (GITD = "")	{
		msgbox,1,,Project Directory must be set.
		filedelete, skopt.cfg
		ExitApp
	}
ifnotexist,%GITD%
	{
		gosub, GetGit
	}
if (GITPAT = "")
	{
		gosub, GetGPAC
	}
if (GITPAT = "")
	{
		msgbox,1,,Git Personal Access Token must be set to deploy executables.,3
		GITPAT= XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
		FIE=
	}
if (NSIS = "")
	{
		gosub, SelNSIS
	}
if (NSIS = "")
	{
		msgbox,1,,makeNSIS.exe must be set.
		filedelete, skopt.cfg
		ExitApp
	}
ifnotexist,%NSIS%
	{
		gosub,SelNSIS
	}
if (SITEDIR = "")
	{
		SITEDIR= %gitroot%\%gituser%.github.io/skeletonkey
	}
if (SITEURL = "")
	{
		SITEURL= https://%gituser%.github.io/skeletonkey
	}
if (SHDRPURL = "")
	{
		gosub, GetShaderP
	}
if (REPOURL = "")
	{
		gosub, RepoURL
	}
if (GETIPADR = "")
	{
		gosub, GetIPAddr
	}
if (NLOB = "")
	{
		gosub, NewLobby
	}
if (UPDTURL = "")
	{
		gosub, UpdateURL
	}
if (UPDTFILE = "")
	{
		gosub, UpdateFile
	}
if (NPPR = "")
	{
		NPPR= Notepad++.exe
	}
oldsize=
oldsha= 
olrlsdt=
vernum=	

VERSIONGET:
sklnum= 
getversf= %gitroot%\%GITUSER%.github.io\skeletonkey\index.html

ifnotexist,%getversf%
	{
		FileDelete,ORIGHTML.html
		save= ORIGHTML.html
		if (progb = "")
			{
				Progress, 0,,,....Loading....
			}
		URLFILE= http://romjacket.github.io/skeletonkey/index.html
		DownloadFile(URLFILE, save, True, True)
		;;UrlDownloadToFile, http://romjacket.github.io/skeletonkey/index.html, ORIGHTML.html
		if (progb = "")
			{
				Progress, off
			}
		getversf= ORIGHTML.html
	}

Loop, Read, %getversf%
	{
		sklnum+=1
		getvern= 
		ifinstring,A_LoopReadLine,<h99>
			{
				stringgetpos,verstr,A_LoopReadLine,<h99>
				stringgetpos,endstr,A_LoopReadLine,</h99>
				strstr:= verstr + 6
				midstr:= (endstr - verstr - 5)
				stringmid,vernum,A_LoopReadLine,strstr,midstr
				if (midstr = 0)
					{
						vernum= 0.99.00.00
					}
				continue
			}
			ifinstring,A_LoopReadLine,<h88>
					{
						stringgetpos,verstr,A_LoopReadLine,<h88>
						FileReadLine,sklin,%gitroot%\%GITUSER%.github.io\skeletonkey\index.html,%sklnum%
						getvern:= verstr+6
						StringMid,oldsize,sklin,%getvern%,4
						continue
					}
			ifinstring,A_LoopReadLine,<h87>
					{
						stringgetpos,verstr,A_LoopReadLine,<h87>
						FileReadLine,sklin,%gitroot%\%GITUSER%.github.io\skeletonkey\index.html,%sklnum%
						getvern:= verstr+6
						StringMid,oldsize,sklin,%getvern%,4
						continue
					}
			ifinstring,A_LoopReadLine,<h77>
					{
						stringgetpos,verstr,A_LoopReadLine,<h77>
						FileReadLine,sklin,%gitroot%\%GITUSER%.github.io\skeletonkey\index.html,%sklnum%
						getvern:= verstr+6
						StringMid,oldsha,sklin,%getvern%,40
						continue
					}
			ifinstring,A_LoopReadLine,<h66>
					{
						stringgetpos,verstr,A_LoopReadLine,<h66>
						FileReadLine,sklin,%gitroot%\%GITUSER%.github.io\skeletonkey\index.html,%sklnum%
						getvern:= verstr+6
						StringMid,olrlsdt,sklin,%getvern%,18
						continue
					}	
			ifinstring,A_LoopReadLine,<h55>
					{
						stringgetpos,donat,A_LoopReadLine,<h55>
						FileReadLine,donit,%gitroot%\%GITUSER%.github.io\skeletonkey\index.html,%sklnum%
						getvern:= donat+6
						StringMid,donation,donit,%getvern%,5
						continue
					}	
}

if (vernum = "")
	{
		vernum= [DIVERSION]
	}
FileReadLine,initchk,skopt.cfg,21
if (initchk = "")
	{
		msgbox,,,incomplete config
		filedelete,skopt.cfg
		exitapp
	}	
	
FIE= 
if (GITRLS = "")
	{
		FIE= Hidden
	}
if (GITPAT = "")
	{
		FIE= Hidden
	}
if (GITPAT = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
	{
		FIE= Hidden
	}

;{;;;;;;;;;;;;;;;,,,,,,,,,, MENU,,,,,,,,,,;;;;;;;;;;;;;;;;;;;;;;;
Gui Add, Tab2, x2 y-1 w487 h171 vTABMENU Bottom, Setup|Deploy
Gui, Tab, 1
Gui, Tab, Setup
Gui, Add, Text,x164 y5, Location
Gui, Add, DropDownList, x8 y2 w100 vSRCDD gSrcDD, Project||Git.exe|github-release|Source|Compiler|Site|Deployment|Build|NSIS|NP++
Gui, Add, Button, x109 y2 w52 h21 vSELDIR gSelDir, Select
Gui, Add, Button, x109 y26 w52 h21 vRESGET gRESGET, Clone
Gui Add, DropDownList,x331 y2 w92 vResDD gResDD, All||Dev-Build|Portable-Build|Stable-Build|Deployer|Site-URL|Update-URL|Update-File|Shader-URL|Repo-URL|Internet-IP-URL|Git-User|Git-Password|Git-Token|Git-URL
Gui Add, Button, x425 y2 w52 h21 vResB gResB, Reset

Gui Add, Text,x4 y125, %ARCH%-bit
Gui Add, Picture, x4 y58 w155 h67, img\ins.png
Gui Add, Picture, x160 y58 w70 h60, img\cor.png
Gui Add, Picture, x241 y58 w70 h60, img\emu.png
Gui Add, Picture, x322 y58 w70 h60, img\net.png
Gui Add, Picture, x404 y58 w70 h60, img\opt.png

Gui, Tab, 2
Gui Tab, Deploy
Gui, Add, Edit, x8 y24 w469 h50 vPushNotes gPushNotes,%date% :%A_Space%
Gui, Add, Edit, x161 y151 w115 h21 vVernum gVerNum +0x2, %vernum%
Gui, Add, Button, x280 y154 w16 h16 vAddIncVer gAddIncVer,+
gui,font,bold
Gui, Add, Button, x408 y123 w75 h23 vCOMPILE gCOMPILE, DEPLOY
gui,font,normal
Gui, Add, Text, x8 y7, Git Push Description / changelog
Gui, Add, Button, x170 y7 w25 h15 vLogView gLogView,log
Gui, Add, CheckBox, x9 y75 h17 vGitPush gGitPush checked, Git Push
Gui, Add, CheckBox, x9 y94 h17 vServerPush gServerPush checked, Server Push
Gui, Add, CheckBox, x9 y112 h17 vSiteUpdate gSiteUpdate checked, Site Update
gui,font,bold
Gui, Add, Button, x408 y123 w75 h23 vCANCEL gCANCEL hidden, CANCEL
gui,font,normal
Gui, Add, Text, x308 y155, Version
Gui, Add, CheckBox, x204 y76 w114 h13 vINITINCL gINITINCL checked, Initialize-Include
Gui, Add, CheckBox, x204 y95 w154 h13 vREPODATS gREPODATS, Repository Databases
Gui, Add, CheckBox, x90 y95 w104 h13 vPortVer gPortVer checked %FIE%, Portable/Update
Gui, Add, CheckBox, x90 y76 w104 h13 vOvrStable gOvrStable %FIE% checked,Stable
Gui, Add, CheckBox, x90 y95 w154 h13 vDevlVer gDevlVer hidden, Development Version
Gui, Add, CheckBox, x90 y113 w154 h13 vDATBLD gDatBld, Database Recompile

Gui, Add, Progress, x12 y135 w388 h8 vprogb -Smooth, 0

Gui, Add, StatusBar, x0 y151 w488 h18, Compiler Status
Gui, Show, w488 h194,,_DEV_	
GuiControl, Choose, TABMENU, 2
Return

;};;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SelDXB:
Msgbox,3,Quick-Setup,This tool can automatically install and initialize a development environment in:`n%A_MyDocuments%`n`nProceed? 
ifmsgbox,No
	{
		goto, SelDir
	}
ifmsgbox,Cancel
	{
		goto, QUITOUT
	}
AUTOINSTALL= 1
GITAV= GIT_%ARCH%
GITRV= Git_Release_%ARCH%
BLDITEMS=%GITAV%|%GITRV%|Notepad_PlusPlus|RunMe_Plugin|ToolBucket_Plugin|TextFX_Plugin|AutoHotkey|NSIS
Loop,parse,BLDITEMS,|
	{
		stringreplace,dwnlsi,A_LoopField,_%ARCH%,,All
		iniread,nwurl,sets\BuildTools.set,BUILDENV,%A_LoopField%
		%dwnlsi%URL= %nwurl%
		splitpath,nwurl,nwurlf
		if (A_LoopField = GITAV)
			{
						gosub, GetGitz
			}
		if (A_LoopField = GITRV)
			{
						gosub, GetRls
			}
		if (A_LoopField = "AutoHotkey")
			{
						gosub, GetAHKZ
			}
		if (A_LoopField = "NSIS")
			{
						gosub, GetNSIS
			}
		if (A_LoopField = "Notepad_PlusPlus")
			{
						gosub, GetNPP
			}
		if (A_LoopField = "TextFX_Plugin")
			{
						gosub, GetTXP
			}
		if (A_LoopField = "ToolBucket_Plugin")
			{
						gosub, GetTBP
			}
		if (A_LoopField = "RunMe_Plugin")
			{
						gosub, GetRMP
			}
	}
	
	
SelDir:
gui,submit,nohide

if (INIT = 1)
	{
		if (GITUSER = "")
			{
				gosub, GetGUSR
			}
	}
if (SRCDD = "Git-User")
	{
		gosub, GetGUSR
		if (GITUSER = "")
			{
				GITUSER= %A_Username%
			}
	}
if (INIT = 1)
	{
		GITPASST= *******
		if (GITPASS = "")
			{
				gosub, GitGPass
			}
	}
if (INIT = 1)
	{
		if (GITPAT = "")
			{
				GITPAT= XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
			}
	}
if (GITPAT = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
	{
		msgbox,1,,Git Personal Access Token must be set to deploy executables.,5
		gosub, GetGPAC
	}

if (AUTOINSTALL >= 1)
	{
		iniwrite,%GITUSER%,skopt.cfg,GLOBAL,git_username
		iniwrite,%GITPASS%,skopt.cfg,GLOBAL,git_password
		iniwrite,%GITPAT%,skopt.cfg,GLOBAL,git_token
		;;Progress,10,Extracting Tools
		;;Runwait, bin\7za.exe x -y "%save%" -O"%A_MyDocuments%",,%rntp%
		;;Progress,100,Complete
		;;Sleep, 1000
		;;Progress,Off
		GITROOT= %A_MyDocuments%\GitHub
		iniwrite,%GITROOT%,skopt.cfg,GLOBAL,Git_Root		
		SITEURL= https://%gituser%.github.io/skeletonkey
		BUILDIR= %A_ScriptDir%
		iniwrite,%BUILDIR%,skopt.cfg,GLOBAL,Build_Directory
		BUILDW= %A_ScriptDir%\working.ahk
		iniwrite,%BUILDW%,skopt.cfg,GLOBAL,working_file
		SKELD= %A_ScriptDir%
		iniwrite,%SKELD%,skopt.cfg,GLOBAL,source_Directory
		AHKDIR= %A_MyDocuments%\AutoHotkey\Compiler
		iniwrite,%AHKDIR%,skopt.cfg,GLOBAL,Compiler_Directory
		DEPL= %GITROOT%\skeletonkey.deploy
		iniwrite,%DEPL%,skopt.cfg,GLOBAL,Deployment_Directory
		NSIS= %A_MyDocuments%\NSIS\makensis.exe
		iniwrite,%NSIS%,skopt.cfg,GLOBAL,NSIS
		GITAPP= %A_MyDocuments%\Git\bin\git.exe
		splitpath,GITAPP,,GITAPPD
		iniwrite,%GITAPP%,skopt.cfg,GLOBAL,git_app
		GITRLS= %GITAPPD%\github-release.exe
		iniwrite,%GITRLS%,skopt.cfg,GLOBAL,git_rls
		GITD= %GITROOT%\skeletonKey
		iniwrite,%GITD%,skopt.cfg,GLOBAL,Project_Directory
		SITEDIR= %GITROOT%\%GITUSER%.github.io
		iniwrite,%SITEDIR%,skopt.cfg,GLOBAL,site_directory
		SHDRPURL= http://raw.githubusercontent.com/libretro/shader-previews/master/
		iniwrite,%SHDRPURL%,skopt.cfg,GLOBAL,shader_url
		GETIPADR= http://www.netikus.net/show_ip.html
		iniwrite,%GETIPADR%,skopt.cfg,GLOBAL,net_ip
		NLOB= http://newlobby.libretro.com/list
		iniwrite,%NLOB%,skopt.cfg,GLOBAL,lobby_url
		REPOURL= https://github.com/%gituser%
		iniwrite,%REPOURL%,skopt.cfg,GLOBAL,repository_url
		UPDTURL= http://raw.githubusercontent.com/%gituser%/skeletonkey/master/version.txt
		iniwrite,%UPDTURL%,skopt.cfg,GLOBAL,update_url
		GITSRC= http://github.com/%GITUSER%/skeletonkey
		iniwrite,%GITSRC%,skopt.cfg,GLOBAL,git_url
		UPDTFILE=https://github.com/%GITUSER%/skeletonkey/releases/download/portable/skeletonKey-portable.zip
		iniwrite,%GITSRC%,skopt.cfg,GLOBAL,update_file
		
		ifnotexist, %GITROOT%
			{
				FileCreateDir, %GITROOT%
			}	
			
		ifnotexist, %DEPL%
			{
				FileCreateDir,%DEPL%
			}
		Progress,10,Cloning skeletonKey from github	
		ifnotexist, %GITD%
			{
				Runwait, "%gitapp%" clone %GITSRC%,%gitroot%,%rntp%
			}
		Progress,90,Cloning skeletonKey website
		ifnotexist, %SITEDIR%
			{
				Runwait, "%gitapp%" clone https://github.com/%gituser%/%gituser%.github.io,%GITROOT%,%rntp%
			}
		Progress,100,Complete
		Sleep,1000
		Progress, off
		if (AUTOINSTALL > 1)
			{
				Progress,1,Extracting Notepad++
				Runwait, bin\7za.exe x -y "%npsave%" -O"%A_MyDocuments%",,%rntp%
				Progress,100,Complete
				Sleep,1000
				Progress,off
				NPPR= %A_MyDocuments%\Notepad_PlusPlus\notepad++.exe
				iniwrite,%NPPR%,skopt.cfg,GLOBAL,Notepad_PlusPlus
			}
		INIT= 
		return
	}

if (INIT = 1)
	{
		SRCDD= Source
	}
if (SRCDD = "Source")
	{
		skeltmp= %A_ScriptDir%
		gosub, GetSrc
	}
if (INIT = 1)
	{
		SRCDD= Git.exe
	}
if (SRCDD = "Git.exe")
	{	
		gitapdtmp= %a_programfiles%\git\bin
		ifnotexist, %gitapptmp%
			{
				gitapdtmp= %A_MyDocuments%
			}
		gosub, GetAPP
	}
if (INIT = 1)
	{
		SRCDD= GitRoot
	}
if (SRCDD = "GitRoot")
	{
		gitrttmp= %A_MyDocuments%
		gosub, GitRoot
	}
if (INIT = 1)
	{
		SRCDD= Site
	}
if (SRCDD = "Site")
	{
		STLOCtmp= %GITROOT%
		gosub, GetSiteDir
	}
if (INIT = 1)
	{
		SRCDD= Compiler
	}
if (SRCDD = "Compiler")
	{
		ahktmp= %A_MyDocuments%
		comptmp= %A_MyDocuments%
		ifexist, %A_ProgramFiles%\AutoHotkey\Compiler
			{
				comptmp= %A_ProgramFiles%\AutoHotkey\Compiler
			}
		ifexist, %A_MyDocuments%\AutoHotkey\Compiler
			{
				comptmp= %A_MyDocuments%\AutoHotkey\Compiler
			}
		gosub, GetComp
	}
if (INIT = 1)
	{
		SRCDD= Project
	}
if (SRCDD = "Project")
	{
		gittmp= %A_MyDocuments%
		ifexist, %GITROOT%\skeletonKey
			{
				gittmp= %GITROOT%\skeletonKey
			}
		gosub, GetGit
	}
if (INIT = 1)
	{
		SRCDD= Notepad_PlusPlus
	}
if (SRCDD = "NP++")
	{
		npptmp= %A_MyDocuments%
		gosub, GetNPP
	}
if (INIT = 1)
	{
		SRCDD= Deployment
	}
if (SRCDD = "Deployment")
	{
		depltmp= %GITROOT%
		gosub, GetDepl
	}
if (INIT = 1)
	{
		SRCDD= Build
	}
if (SRCDD = "github-release")
	{
		splitpath,gitapp,,gitrlstmp
		gosub, GetRls
	}
if (INIT = 1)
	{
		SRCDD= NP++
	}
if (SRCDD = "Build")
	{
		gosub, GetBld
	}
if (INIT = 1)
	{
		SRCDD= NSIS
	}
if (SRCDD = "NSIS")
	{
		nsitmp= %A_MyDocuments%\NSIS
		nstmp= %A_MyDocuments%\NSIS\makensis.exe
		ifexist, %ProgramFilesX86%\NSIS\makensis.exe
			{
				nsitmp= %ProgramFilesX86%\NSIS
				nstmp= %ProgramFilesX86%\NSIS\makensis.exe
			}
		ifexist, %A_MyDocuments%\NSIS
			{
				nsimp= %A_MyDocuments%\NSIS
				nstmp= %A_MyDocuments%\NSIS\makensis.exe
			}
		ifnotexist, %nsitmp%
			{
				nsitmp= %A_MyDocuments%
			}
		gosub, SelNSIS
	}
INIT= 
return

GetWrk:
BUILDWT= %BUILDW%
bldtmpf= %BUILDIR%
FileSelectFile,BUILDWT,3,%bldtmpf%\working.ahk,Select The working development file,*.ahk
if (BUILDW <> "")
	{
		if (BUILDWT = "")
			{
				SB_SetText("Working development file is " BUILDW " ")
				if (bldtmpf <> "")
					{
						bldtmpf= 
						goto, GetWrk
					}
				return
			}
	}
if (BUILDWT = "")
	{
		return
	}
BUILDW= %BUILDWT%	
FileCopy, %BUILDIR%\Working.ahk,%BUILDIR%\Working.bak,1
FileCopy, %BUILDWT%,%BUILDIR%\Working.ahk,1
IniWrite, %BUILDW%,skopt.cfg,GLOBAL,Working_file
return

GitRoot:
GITROOTT= %GITROOT%
ifnotexist, %gitrttmp%
	{
		gitrttmp= 
	}
FileSelectFolder, GITROOTT,*%gitrttmp% ,1,Select The GitHub Root Directory (contains all projects)
gitrtexists= 
if (GITROOT <> "")
	{
		if (GITROOTT = "")
			{
				SB_SetText("Github dir is " GITROOT " ")
				if (gitrttmp <> "")
					{
						gitrttmp=
						goto, GitRoot
					}
				return
			}
	}
if ((GitROOTT = "") && (gitrttmp <> ""))
	{
		gitrttmp= 
		goto, GitROOT
	}
if (GITROOTT = "")
	{
		GITROOTT= %A_MyDocuments%
	}
ifnotinstring,GITROOTT,GitHub
	{
		Loop, %GITROOTT%\*,2
			{
				ifinstring,A_LoopFilename,GitHub
					{
						GITROOTT= %A_LoopFileFullPath%
						GITROOT:= GITROOTT
						iniwrite, %GITROOT%,skopt.cfg,GLOBAL,Git_Root
						SB_SetText("Github dir is " GITROOT " ")
						return
					}
			}
		Msgbox,3,Github Directory not found,A ''github'' directory was not found.`nWould you like to create it?
		ifmsgbox,Yes
			{
				filecreatedir, %GITROOTT%\GitHub
				GITROOTT= %GITROOTT%\GitHub
				GITROOT:= GITROOTT
				iniwrite, %GITROOT%,skopt.cfg,GLOBAL,Git_Root
				SB_SetText("Github dir is " GITROOT " ")
				return
			}
		ifmsgbox,No
			{
				filedelete,skopt.cfg
				ExitApp
			}
	}
if (GITROOTT = A_MyDocuments)
	{
		filecreatedir, %GITROOTT%\GitHub
		GITROOTT= %GITROOTT%\GitHub
		GITROOT:= GITROOTT
		iniwrite, %GITROOT%,skopt.cfg,GLOBAL,Git_Root
		SB_SetText("Github dir is " GITROOT " ")
		return
	}
ifinstring,GITROOTT,GitHub
	{
		GITROOT:= GITROOTT
		iniwrite, %GITROOT%,skopt.cfg,GLOBAL,Git_Root
		SB_SetText("Github dir is " GITROOT " ")
		return
	}
Msgbox,3,Github Root,Github Root Directory not found.`nRetry?
IfMsgBox, Yes
	{
		gosub, GitRoot
	}
filedelete, skopt.cfg
ExitApp

INITINCL:
INITINCL= 1
return

GetBld:
BUILDIT= %BUILDIR%
ifnotexist, %bldtmp%
	{
		bldtmp= 
	}
FileSelectFolder, BUILDIT,*%bldtmp% ,1,Select The Build Directory
bldtmp= 
bldexists= 
if (BUILDIR <> "")
	{
		if (BUILDIT = "")
			{
				SB_SetText("BUILD dir is " BUILDIR " ")
				return
			}
	}
Loop,%BUILDIT%\sets\skdeploy.set
	{
		bldexists= 1
	}
if (bldexists = 1)
	{
		BUILDIR:= BUILDIT
		iniwrite, %BUILDIR%,skopt.cfg,GLOBAL,Build_Directory
		FileRead, nsiv,%BUILDIR%\sets\skdeploy.set
		StringReplace, nsiv, nsiv,[SOURCE],%SKELD%,All
		StringReplace, nsiv, nsiv,[INSTYP],-installer,All
		StringReplace, nsiv, nsiv,[BUILD],%BUILDIR%,All
		StringReplace, nsiv, nsiv,[DBP],%DEPL%,All
		StringReplace, nsiv, nsiv,[CURV],%vernum%,All
		FileAppend, %nsiv%,%BUILDIR%\skdeploy.nsi
		return
	}
Msgbox,3,Build Dir,Build Directory not found`nRetry?
IfMsgBox, Yes
	{
		gosub, GetBld
	}
filedelete, skopt.cfg
ExitApp

GetShaderP:
gui,submit,NoHide
SHDRPURL= 
if (SHDRPURLT = "") 
	SHDRPURLT= http://raw.githubusercontent.com/libretro/shader-previews/master/
inputbox,SHDRPURL,Shader Preveiw URL,Enter the url of the shader preview master directory,,345,140,,,,,%SHDRPURLT%
if (SHDRPURL = "")
	{
		SHDRPRUL= %SHDRPURLT%
	}
iniwrite,%SHDRPURL%,skopt.cfg,GLOBAL,shader_url
return

GetIpAddr:
gui,submit,nohide
GETIPADR= 
if (GETIPADRT = "")
	GETIPADRT= http://www.netikus.net/show_ip.html
inputbox,GETIPADR,Internet-IP-Address,Enter the url of the file which contains your internet ip-address,,345,140,,,,,%GETIPADRT%
if (GETIPADR = "")
	{
		GETIPADR= %GETIPADRT%
	}
IniWrite,%GETIPADR%,skopt.cfg,GLOBAL,net_ip
return

UpdateURL:
gui,submit,nohide
UPDTURL= 
if (UPDTURLT = "")
	{
		UPDTURLT= http://raw.githubusercontent.com/%GITUSER%/skeletonkey/master/version.txt
	}
inputbox,UPDTURL,Version,Enter the url of the file which contains your update information,,345,140,,,,,%UPDTURLT%
if (UPDTURL = "")
	{
		UPDTURLT= http://raw.githubusercontent.com/romjacket/skeletonkey/master/version.txt
		UPDTURL= %UPDTURLT%
	}
IniWrite,%UPDTURL%,skopt.cfg,GLOBAL,update_url
return

UpdateFILE:
gui,submit,nohide
UPDTFILE= 
if (UPDTFILET = "")
	{
		UPDTFILET= https://github.com/%gituser%/skeletonKey/releases/download/portable/skeletonKey-portable.zip	
	}
inputbox,UPDTFILE,Version,Enter the url of the file which contains your update information,,345,140,,,,,%UPDTFILET%
if (UPDTFILE = "")
	{
		UPDTFILET= https://github.com/%gituser%/skeletonKey/releases/download/portable/skeletonKey-portable.zip
		UPDTFILE= %UPDTFILET%
	}
IniWrite,%UPDTFILE%,skopt.cfg,GLOBAL,update_file
return

GitGPass:
InputBox, GITPASST , Git-Password, Input your github password,HIDE , 180, 140, , , ,, %GITPASST%
if (GITPASST = "")
	{
		GITPASS= *******
		iniwrite,*******,skopt.cfg,GLOBAL,Git_password
		return
	}
SRCDD= 
GITPASS= %GITPASST%	
iniwrite, %GITPASS%,skopt.cfg,GLOBAL,Git_password
return

GitSRC:
gui,submit,nohide
GitSRC= 
if (GitSRCT = "")
	{
		GitSRCT= http://github.com/%GITUSER%/skeletonkey
	}

inputbox,GitSRC,Git Repo,Enter the url for the skeletonKey git repo,,345,140,,,,,%GitSRCT%
if (GitSRC = "")
	{
		GitSRCT= http://github.com/romjacket/skeletonkey
		GitSRC= %GitSRCT%
	}

IniWrite,%GitSRC%,skopt.cfg,GLOBAL,git_url
return

RepoUrl:
gui,submit,nohide
REPOURL= 
UPDTFILE= http://github.com/%GITUSER%/skeletonKey/releases/download/nodats
if (REPORURLT = "")
	{
		iniread,REPOURLT,sets\arcorg.set,GLOBAL,HOSTINGURL
		;;filereadline,REPOURLT,sets\arcorg.set,2
		UPDTFILE= %REPORULT%/skeletonKey/releases/download/nodats
	}
inputbox,REPOURL,Repository-URL,Enter the base-url of the file-repository,,345,140,,,,,%REPOURLT%
if (REPOURL = "")
	{
		REPOURL= %REPOURLT%
		UPDTFILE= %UPDTFILE%
	}
IniWrite,%REPOURL%,skopt.cfg,GLOBAL,repository_url
return

NewLobby:
gui,submit,nohide
NLOB= 
if (NLOBT = "")
	{
		NLOBT= http://newlobby.libretro.com/list
	}
inputbox,NLOB,retroarch lobby,Enter the url of the lobby list file,,275,140,,,,,%NLOBT%
if (NLOB = "")
	{
		NLOB= %NLOBT%
	}
IniWrite,%NLOB%,skopt.cfg,GLOBAL,lobby_url
return

GetUpdate:
UPDTURLT=,http://raw.githubusercontent.com/%GITUSER%/skeletonkey/master/version.txt
UPDTURL=
InputBox,UPDTURL,Update URL,If you wish to deploy updates from your own repository`nEnter the http address of the update file`nusually where ''version.txt'' can be found,0,,,,,,,%UPDTURLT%
		if (UPDTURL = "")
				{
					UPDTURL= http://raw.githubusercontent.com/romjacket/skeletonkey/master/version.txt
				}
return

GetSiteURL:
gui,submit,nohide
STURL=
STURLT= romjacket.github.io/skeletonkey

iniread,cca,sets\arcorg.set,GLOBAL,HOSTINGURL
;;filereadline,cca,sets\arcorg.set,2
ifnotinstring,cca,romjacket
	{
		STURLT= http://%gituser%.github.io/skeletonkey
	}
inputbox,STURL,Website-URL,Enter the website url,,345,140,,,,,%STURLT%
if (STURL = "")
	{
		STURL= romjacket.github.io/skeletonkey
	}	
IniWrite,%STURL%,skopt.cfg,GLOBAL,site_url
return

GetSiteDir:
gui,submit,nohide
STLOC=
STLOCT=
FileSelectFolder, STLOCT,*%STLOCtmp% ,1,Select The Git-WebSite Root Directory or cancel to pull the latest version from github.
STLOCexists= 
if (STLOC <> "")
	{
		if (STLOCT = "")
			{
				SB_SetText(" Website directory is " STLOC " ")
				if (STLOCtmp <> "")
					{
						STLOCtmp=
						goto, GetSiteDir
					}
				return
			}
	}
STLOCtmp= 
STLOC:= STLOCT
splitpath,STLOC,STLOCn
ifnotinstring,STLOCn,.github.io
	{
		if (stlocn <> "")
			{
				STLOC= %STLOC%\%gituser%.github.io
			}
	}
if ((STLOC = "") && (stloctmp = ""))
	{
		STLOC= %GITROOT%\%gituser%.github.io
	}
ifnotexist, %STLOC%\skeletonkey\
	{
		Runwait, %gitapp% clone http://github.com/%gituser%/%gituser%.github.io,%GITROOT%
		Loop, %GITROOT%\%gituser%.github.io\skeletonkey*.*
			{
				av+=1
			}
		if (av = "")
			{
				FileRemoveDir, %GITROOT%\%gituser%.github.io\skeletonkey,1
				Runwait, %gitapp% clone http://github.com/romjacket/romjacket.github.io,%GITROOT%
				RunWait, %comspec% cmd /c "%gitapp%" init,%gitroot%\%GITUSER%.github.io,hide
				RunWait,%comspec% cmd /c "bin\curl.exe" -u %gituser%:%gitpass% https://api.github.com/user/repos -d "{\"name\":\"%gituser%.github.io\"}",,hide
				FileMoveDir, %GITROOT%\romjacket.github.io\skeletonkey,%GITROOT%\%gituser%.github.io\skeletonkey,1
			}
	}
SITEDIR= %STLOC%	
iniwrite, %SITEDIR%,skopt.cfg,GLOBAL,Site_Directory
if (SITEDIR = "")
	{
		Msgbox,3,Website Directory,Website Environment not found`nRetry
		IfMsgBox, Yes
			{
				STLOCtmp= 
				goto, GetSiteDir
			}
		filedelete, skopt.cfg
		ExitApp
	}
return


GetDepl:
DEPL=
DEPLT=
ifnotexist, %depltmp%
	{
		depltmp= 
	}
FileSelectFolder, DEPLT,*%depltmp% ,1,Select The Deployment Directory
deplexists= 
if (DEPL <> "")
	{
		if (DEPLT= "")
			{
				SB_SetText(" Deploy dir is " DEPL " ")
				if (depltmp <> "")
					{
						depltmp=
						goto, GetDepl
					}
				return
			}
	}
depltmp= 
if (DEPLT = "")
	{
		Msgbox,3,Deployment Directory,Deployment Environment not found`nRetry
		IfMsgBox, Yes
			{
				goto, GetDepl
			}
		filedelete, skopt.cfg
		ExitApp
	}
DEPL:= DEPLT
if (DEPL = "")
	{
		DEPL= %GITROOT%\skeletonkey.deploy
	}
splitpath,DEPL,depln
if (DEPLN = "Project")
	{
		DEPL= %DEPL%\skeletonkey.deploy
	}
splitpath,DEPL,deplname
ifnotinstring,deplname,.deploy
	{
		Loop, %DEPL%\*,2
			{
				ifinstring,A_LoopFileName,.deploy
					{
						DEPL= %A_LoopFileFullPath%
					}
			}
	}
splitpath,DEPL,deplname
ifnotinstring,deplname,.deploy
	{
		DEPL= %DEPL%\skeletonkey.deploy
	}
ifnotexist, %DEPL%
	{
		fileCreateDir,%DEPL%
	}
iniwrite, %DEPL%,skopt.cfg,GLOBAL,Deployment_Directory
return

GetComp:
ifnotexist, %comptmp%
	{
		comptmp= 
	}
AHKDIT= %AHKDIR%
ifnotexist, %comptmp%
	{
		comptmp= 
	}
ifexist, %A_MyDocuments%\AutoHotkey\Compiler
	{
		comptmp= %A_MyDocuments%\AutoHotkey\Compiler
	}
ifexist, %a_programfiles%\AutoHotkey\Compiler
	{
		comptmp= %a_programfiles%\AutoHotkey\Compiler
	}
FileSelectFolder, AHKDIT,*%comptmp%,0,Select The AHK Compiler Directory or cancel to install it.
compexists= 
if (AHKDIR <> "")
	{
		if (AHKDIT = "")
			{
				SB_SetText(" AHK Compiler dir is " AHKDIR " ")
				if (comptmp <> "")
					{
						comptmp= 
						goto, GetComp
					}
				return
			}
	}
comptmp= 
if ((comptmp <> "") && (AHKDIT = ""))
	{
		comptmp= 
		goto, GetComp
	}
ahkkcd= 	
Loop,Files, %AHKDIT%\Ahk2Exe.exe,R
	{
		ahkkcd= %A_LoopFileFullPath%
		compexists= 1
	}
if (compexists = 1)
	{
		splitpath,ahkkcd,,AHKDIT
		AHKDIR:= AHKDIT
		iniwrite, %AHKDIR%,skopt.cfg,GLOBAL,Compiler_Directory
		return
	}
gosub, GetAHKZ

if (AHKDIR = "")
	{
		if (comptmp <> "")
			{
				comptmp= %A_MyDocuments%
			}
		ahktmp=
		gosub, GetComp
	}
if (AHKDIR = "")
	{
		filedelete, skopt.cfg
		ExitApp
	}
return

GetSrc:
SKELT= %SKELD%
ifnotexist, %skeltmp%
	{
		skeltmp= 
	}

FileSelectFolder, SKELT,*%skeltmp% ,1,Select The Source Directory
skelexists= 
if (SKELD <> "")
	{
		if (SKELT = "")
			{
				SB_SetText(" SOURCE dir is " SKELD " ")
				if (skeltmp <> "")
					{
						skeltmp=
						goto, GetSrc
					}
				return
			}
	}
if ((SKELT = "") && (skeltmp = ""))
	{
		SKELT= %A_MyDocuments%\skeletonKey
		skelexists= 1
	}
Loop, %SKELT%\working.ahk
	{
		skelexists= 1
	}
if (skelexists = 1)
	{
		SKELD:= SKELT
		iniwrite, %SKELD%,skopt.cfg,GLOBAL,Source_Directory
		return
	}
skeltmp= 
gosub, GetSrc
return

GetRls:
GITRLST=
iniread,GRLURL,sets\BuildTools.set,BUILDENV,Github_Release_%ARCH%
splitpath,GRLURL,grlfn
grlsv= %cacheloc%\%grlfn%
grltmp= %GITAPPD%
if (AUTOINSTALL >= 1)
	{
		GITRLST= 
		goto, GITRLST
	}
FileSelectFile,GITRLST,3,%grltmp%\github-release.exe,Select github-release,*.exe
GITRLST:
if (GITRLST = "")
	{
		ifnotexist,%grlsv%
			{
				grltmp= %GITAPPD%
				if (progb = "")
					{
						Progress, 0, , ,Downloading Github-release
					}	
				DownloadFile(GRLURL, grlsv, False, True)
				sleep, 1200
				if (progb = "")
					{
						Progress, off
					}
			}
		ifexist, %grlsv%
			{
				GRLK=
				GRLL=
				if (AUTOINSTALL >= 1)
					{
						GRLL= %GITAPPD%
						goto, GRLLSEL
					}
				FileselectFolder,GRLL,*%grltmp%,0,Location to extract Github-release.exe
				GRLLSEL:
				if (GRLL = "")
					{
						return
					}
				Runwait, bin\7za.exe x -y "%grlsv%" -O"%GRLL%",,%rntp%
				GITRLS= %GRLL%\github-release.exe
				iniwrite, %GITRLS%,skopt.cfg,GLOBAL,git_rls
				SB_SetText(" Github-release is " GITRLS "")
				return
			}
		grltmp= 
		Msgbox,3,Not Found,%grlsv% not found.`nRETRY?
		ifmsgbox,Yes
			{
				AUTOINSTALL= 
				gosub,GetRls
			}
		return
}
GITRLS= %GITRLST%
iniwrite, %GITRLS%,skopt.cfg,GLOBAL,git_rls
SB_SetText(" Notepad Plus Plus is " GITRLS "")
return

SelNSIS:
ifexist, %A_MyDocuments%\NSIS
	{
		nsisapdtmp= %A_MyDocuments%\NSIS
	}
NSIST= %NSIS%
NSISCONT:
ifnotexist, %nsisapdtmp%
	{
		nsisapdtmp= 
	}

FileSelectFile, NSIST,3,%nsisapdtmp%\makensis.exe,Select the makensis.exe or cancel to install it.,*.exe
nsisapptmp= 
if (NSIST = "")
	{
		MsgBox,1,NSIS,Download NSIS?
		ifMsgBox,OK
			{
				goto,SelNSIS
			}
		gosub, GetNSIS
	}
nsisappxst= 
if (NSIS <> "")
	{
		if (NSIST = "")
			{
				SB_SetText("NSIS is " NSIS " ")
				if (nsisapdtmp <> "")
					{
						nsisapdtmp= 
						goto, NSISCONT
					}
				return
			}
	}	
ifexist, %a_programfiles%\NSIS\makensis.exe
	{
		NSISXST= 1
	}
IF (NSISXST = 1)	
	{	
		NSIS= %a_programfiles%\NSIS\makensis.exe
	}
NSIS= %NSIST%
if (NSIST = "")
	{
		gosub, GetNSIS
		if (NSIS = "")
			{
				MsgBox,3,NSIS,NSIS not found, Retry?
				ifmsgbox, No
					{
						NSISAPP= nsis		
					}
				ifmsgbox, Yes
					{
						nsisapptmp= 
						goto, NSISCONT
					}
			}
			
	}
splitpath, nsisapp,,nsisappd
iniwrite, %NSIS%,skopt.cfg,GLOBAL,NSIS
return

GetAPP:
ifexist, %A_MyDocuments%\Git\bin
	{
		gitapdtmp= %A_MyDocuments%\Git\Bin
	}
GITAPPT= %GITAPP%
GITAPPCONT:
ifnotexist, %gitapdtmp%
	{
		gitapdtmp= 
	}

FileSelectFile, GITAPPT,3,%gitapdtmp%\git.exe,Select the git.exe or cancel to install it.,*.exe
gitapptmp= 
if (GITAPPT = "")
	{
		MsgBox,1,Git.exe,Download Git.exe?
		ifMsgBox,OK
			{
				gosub, GetGITZ
			}
		goto,GetAPP 
	}
gitappxst= 
if (GITAPP <> "")
	{
		if (GITAPPT = "")
			{
				SB_SetText("Git is " GITAPP " ")
				if (gitapdtmp <> "")
					{
						gitapdtmp= 
						goto, GITAPPCONT
					}
				return
			}
	}	
ifexist, %a_programfiles%\git\bin\git.exe
	{
		GITAPPXST= 1
	}
IF (GITAPPXST = 1)	
	{	
		GITAPP= %a_programfiles%\git\bin\git.exe
	}
GITAPP= %GITAPPT%
if (GITAPPT = "")
	{
		gosub, GetGITZ
		if (GITAPP = "")
			{
				MsgBox,3,Git exe,Git not found, Retry?
				ifmsgbox, No
					{
						GITAPP= git		
					}
				ifmsgbox, Yes
					{
						gitapptmp= 
						goto, GITAPPCONT
					}
			}
			
	}
splitpath, gitapp,,gitappd
iniwrite, %GITAPP%,skopt.cfg,GLOBAL,git_app
return

GetGPAC:
GITPATT= 
envGet, GITPATT, GITHUB_TOKEN
InputBox, GITPATT , Git-PAC, Input your git token, , 230, 140, , , ,,%GITPATT%
if (GITPAT <> "")
	{
		if (GITPATT = "")
			{
				envGet, GITPATT, GITHUB_TOKEN
				SB_SetText(" Git Access token is " GITPAT " ")
			}
	}
GITPAT= %GITPATT%	
iniwrite, %GITPAT%,skopt.cfg,GLOBAL,git_token
SB_SetText(" Git Access token is " GITPAT " ")
return


GetGPass:
InputBox, GITPASST , Git-Password, Input your github password,HIDE , 180, 140, , , ,, %GITPASST%
if (GITPASS <> "")
	{
		if (GITPASST = "")
			{
				GITPASST= *******
				SB_SetText(" Git Password is " ******* " ")
			}
	}
GITPASS= %GITPASST%	
iniwrite, %GITPASS%,skopt.cfg,GLOBAL,Git_password
return

GetGUSR:
GITUSERT= 
InputBox, GITUSERT , Git-Username, Input your git username, , 180, 140, , , ,, %a_username%
if (GITUSER <> "")
	{
		if (GITUSERT = "")
			{
				SB_SetText(" Git Username is " GITUSER " ")
				return
			}
	}
GITUSER= %GITUSERT%	
iniwrite, %GITUSER%,skopt.cfg,GLOBAL,Git_username
return

GetGit:
GITT= 
ifnotexist, %gittmp%
	{
		gittmp= 
	}
FileSelectFolder,GITT,*%gittmp%,1,Select The Git skeletonKey Project Directory or cancel to pull it to the git-root directory.
if (GITT = "")
	{
		MsgBox,1,Project,Pull the skeletonKey project from GitHub?
		ifMsgbox,OK
			{
				gosub,gitclone
			}
		goto, GetGit
	}
gitexists= 
if (GITD <> "")
	{
		if (GITT = "")
			{
				GITT= 
				SB_SetText(" GIT dir is " GITD " ")
				if (gittmp <> "")
					{
						gittmp= 
						goto, GetGit
					}
				return
			}
	}	
if (GITT = "")
	{
		MsgBox,1,Clone,Would you like to clone skeletonKey from github?
		ifmsgbox,OK
			{
				goto, gitclone
			}
		gittmp= 
		goto, GetGit
	}
gittmp= 
Loop, %GITT%\working.ahk
	{
		gitexists= 1
	}
if (gitexists = "")
		{
			Loop, %GITT%\*,2
				{
					if (A_LoopFileName = "skeletonkey")
						{
							Loop, %A_LoopFileFullPath%\working.ahk
									{
										gitexists= 1
										GITT= %A_LoopFileDir%
										gitexists= 1
										break
									}
						}
				}
		}
if (gitexists = 1)
	{
		GITD:= GITT
		iniwrite, %GITD%,skopt.cfg,GLOBAL,Project_Directory
		FileDelete, %BUILDIR%\gitcommit.bat
		FileAppend,for /f "delims=" `%`%a in ("%GITAPP%") do set gitapp=`%`%~a`n,%BUILDIR%\gitcommit.bat
		FileAppend,pushd "%GITD%"`n,%BUILDIR%\gitcommit.bat
		FileAppend,"`%gitapp`%" add .`n,%BUILDIR%\gitcommit.bat
		FileAppend,"`%gitapp`%" commit -m `%1`%.`n,%BUILDIR%\gitcommit.bat
		if (GITPASS <> "")
			{
				FileAppend,"`%gitapp`%" push --repo http://%gituser%:%GITPASS%@github.com/%gituser%/skeletonkey`n,%BUILDIR%\gitcommit.bat			
			}
		if (GITPASS = "")
			{
				FileAppend,"`%gitapp`%" push origin master`n,%BUILDIR%\gitcommit.bat			
			}
		return
	}
if (GITT = "")
	{
		goto, PULLSKEL
	}
if (GITD <> "")
	{
		return
	}
gitclone:
Msgbox,3,project not found,Git Source file not found`nWould you like to pull the latest version?
ifmsgbox, Yes
	{
		gosub, PULLSKEL
	}
IfMsgBox, No
	{
		if (GITD = "")
			{
				filedelete, skopt.cfg
				exitapp
			}
	}
gittmp= %GITROOT%
ifexist, %gittmp%\skeletonkey	
	{
		gittmp= %GITROOT%\skeletonkey		
	}
gosub, GetGit
return

RESGET:
guicontrolget,SRCDD,,SRCDD
if (SRCDD = "Project")
	{
		goto, Clone
	}
if (SRCDD = "Git.exe")
	{
		gitapdtmp= %A_MyDocuments%	
		goto, GetGITZ
	}
if (SRCDD = "github-release")
	{
		goto, GetRls
	}
if (SRCDD = "Site")
	{
		STLOCtmp= %GITROOT%
		ifexist, %GITROOT%\%gituser%.github.io
			{
				filemovedir,%GITROOT%\%gituser%.github.io\skeletonkey,%GITROOT%\%gituser%.skeletonkey.old,1
			}
		goto, GetSiteDir
	}

if (SRCDD = "NP++")
	{
		goto, GetNPP
	}

if (SRCDD = "Compiler")
	{
		goto, GetAHKZ
	}

if (SRCDD = "NSIS")
	{
		nsitmp= %A_MyDocuments%
		nstmp= %A_MyDocuments%\makensis.exe
		ifexist, %ProgramFilesX86%\NSIS
			{
				nstimp= %ProgramFilesX86%\NSIS
				nstmp= %ProgramFilesX86%\NSIS\makensis.exe
			}
		ifexist, %A_MyDocuments%\NSIS
			{
				nsitmp= %A_MyDocuments%\NSIS
				nstmp= %A_MyDocuments%\NSIS\makensis.exe
			}
		goto, SelNSIS
	}
return

PULLSKEL:
av= 
Runwait, "%gitapp%" clone http://github.com/%GITUSER%/skeletonKey,%GITROOT%
Loop, %GITROOT%\skeletonKey\*.*
			{
				av+=1
			}
		if (av = "")
			{
				FileSetAttrib, -h,.git
				FileRemoveDir,%GITROOT%\skeletonkey,1
				Runwait, "%gitapp%" clone http://github.com/romjacket/skeletonkey,%GITROOT%
				RunWait, %comspec% cmd /c "%gitapp%" init,%gitroot%\skeletonkey,hide
				RunWait,%comspec% cmd /c "bin\curl.exe" -u %gituser%:%gitpass% https://api.github.com/user/repos -d "{\"name\":\"skeletonkey\"}",,hide
			}
ifnotexist, %GITROOT%\%GITUSER%.github.io
	{
		av= 
		Runwait, "%gitapp%" clone http://github.com/%GITUSER%/%GITUSER%.github.io,%GITROOT%
		Loop, %GITROOT%\%GITUSER%.github.io\*.*
			{
				av+=1
			}
		if (av = "")
			{
				FileSetAttrib,-h,%GITUSER%.github.io\.git

				FileRemoveDir,%GITROOT%\%GITUSER%.github.io\skeletonkey,1

				Runwait, "%gitapp%" clone http://github.com/romjacket/romjacket.github.io,%GITROOT%
				FileMoveDir, %GITROOT%\romjacket.github.io\skeletonkey,%GITROOT%\%GITUSER%.github.io\skeletonkey,R
				FileCreateDir,%gitroot%\%gituser%.github.io\skeletonkey
				RunWait, %comspec% cmd /c "%gitapp%" init,%gitroot%\%GITUSER%.github.io,hide
				RunWait,%comspec% cmd /c "bin\curl.exe" -u %gituser%:%gitpass% https://api.github.com/user/repos -d "{\"name\":\"%gituser%.github.io\"}",,hide
				
			}
	}
GITD= %GITROOT%\skeletonKey
iniwrite, %GITD%,skopt.cfg,GLOBAL,Project_Directory
iniwrite, %SITEDIR%,skopt.cfg,GLOBAL,Site_Directory
return

Clone:
gui, submit, nohide
guicontrol,disable,RESGET
guicontrol,disable,SRCDD
guicontrol,disable,SELDIR
guicontrol,disable,RESDD
guicontrol,disable,RESB
SB_SetText("Cloning current skeletonkey project")
FileCreateDir, %DEPL%
Runwait, "%gitapp%" clone %GITSRC%,%gitroot%,min
Loop, %GITROOT%\skeletonKey\*.*
			{
				av+=1
			}
		if (av = "")
			{
				FileSetAttrib, -h,%GITUSER%.github.io\skeletonkey\.git
				FileRemoveDir,%GITROOT%\skeletonkey,1
				Runwait, "%gitapp%" clone http://github.com/romjacket/skeletonkey,%GITROOT%
				RunWait, %comspec% cmd /c "%gitapp%" init,%gitroot%\skeletonkey,hide
				RunWait,%comspec% cmd /c "bin\curl.exe" -u %gituser%:%gitpass% https://api.github.com/user/repos -d "{\"name\":\"skeletonkey\"}",,hide
			}
SB_SetText("Cloning current skeletonkey website")
Runwait, "%gitapp%" clone http://github.com/%GITUSER%/%GITUSER%.github.io,%gitroot%,min
Loop, %GITROOT%\*.*
	{
		av+=1
	}
if (av = "")
	{
		FileSetAttrib, -h,%GITUSER%.github.io\.git
	
		FileRemoveDir,%GITROOT%\%GITUSER%.github.io,1
	
		Runwait, "%gitapp%" clone http://github.com/romjacket/romjacket.github.io,%GITROOT%
		RunWait, %comspec% cmd /c "%gitapp%" init,%gitroot%\%GITUSER%.github.io,hide
		RunWait,%comspec% cmd /c "bin\curl.exe" -u %gituser%:%gitpass% https://api.github.com/user/repos -d "{\"name\":\"%gituser%.github.io\"}",,hide	
		FileCreateDir,%GITROOT%\%GITUSER%.github.io,1
		FileMoveDir, %GITROOT%\romjacket.github.io\skeletonkey,%GITROOT%\%GITUSER%.github.io\skeletonkey,R
	}
			
SB_SetText("Complete")

guicontrol,enable,SRCDD
guicontrol,enable,SELDIR
guicontrol,enable,RESGET
guicontrol,enable,RESDD
guicontrol,enable,RESB
return


GetNSIS:
iniread,nsisurl,sets\BuildTools.set,BUILDENV,NSIS
splitpath,nsisurl,nsisf
nsisv= %cacheloc%\%nsisf%
ifnotexist, %cacheloc%\%nsisf%
	{													
		if (progb = "")
			{
				Progress, 0, , ,Downloading NSIS Program
			}	
		DownloadFile(nsisurl, nsisv, False, True)
		sleep, 1200
		if (progb = "")
			{
				Progress, off
			}
	}
ifexist, %nsisv%
	{
		NSISD= 
		NSISDT= 
		NSIS= 
		if (AUTOINSTALL >= 1)
			{
				NSISDT= %A_MyDocuments%
				goto, NSISSL
			}
		FileSelectFolder, NSIST,*%gitapdtmp%,0,Location to extract the NSIS programs.
		NSISSL:
		if (NSISDT = "")
			{
				return
			}
		splitpath,nsisdt,nsisdfn,nsisdnew
		ifinstring,nsisdfn,nsis
			{
				NSISDT= %nsisdnew%
			}
		Runwait, bin\7za.exe x -y "%nsisv%" -O"%NSISDT%",,%rntp%
		Loop, %NSISDT%\nsis-*,2
			{
				NSISdf= %A_LoopFilename%
				break
			}
		filemovedir,%NSISDT%\%NSISdf%,%NSISDT%\NSIS,R
		NSISD= %NSISDT%\NSIS
		NSIS= %NSISD%\makensis.exe
		iniwrite, %NSIS%,skopt.cfg,GLOBAL,NSIS
		SB_SetText("makensis.exe is " NSIS " ")
		return
	}
gitapdtmp= 
Msgbox,3,not found,%nsisv% not found.`nRETRY?
ifmsgbox,yes
	{
		AUTOINSTALL= 
		gosub, getNSIS
	}
return


GetGITZ:
iniread,gitzurl,sets\BuildTools.set,BUILDENV,GIT_%ARCH%
splitpath,gitzurl,gitzf
gitzsv= %cacheloc%\%gitzf%
ifnotexist, %gitzsv%
	{													
		if (progb = "")
			{
				Progress, 0, , ,Downloading Git Program
			}	
		DownloadFile(gitzurl, gitzsv, False, True)
		sleep, 1200
		if (progb = "")
			{
				Progress, off
			}
	}
ifexist, %gitzsv%
	{
		GITAPP= 
		GITAPPT=
		if (AUTOINSTALL >= 1)
			{
				GITAPPT= %A_MyDocuments%
				goto, GITZSL
			}
		FileSelectFolder, GITAPPT,*%gitapdtmp%,0,Location to extract the Git programs.
		GITZSL:
		ifinstring,GITAPPT,git
			{
				splitpath,GITAPPT,,gitappdt
				GITAPPT= %gitappdt%
			}
		if (GITAPPT = "")
			{
				gitapdtmp= 
				return
			}
		GITAPPT.= "\Git"
		Runwait, bin\7za.exe x -y "%gitzsv%" -O"%GITAPPT%",,%rntp%
		GITAPP= %GITAPPT%\bin\Git.exe
		splitpath, gitapp,,gitappd
		iniwrite, %GITAPP%,skopt.cfg,GLOBAL,git_app
		return
	}
gitapdtmp= 
Msgbox,3,not found,%gitzsv% not found.`nRETRY?
ifmsgbox,yes
	{
		AUTOINSTALL= 
		gosub, getGitz
	}
return


GetNPP:
NPPRT=
iniread,NPPURL,sets\BuildTools.set,BUILDENV,Notepad_PlusPlus
splitpath,NPPURL,nppfn
nppsv= %cacheloc%\%nppfn%				   

if (AUTOINSTALL >= 1)
	{
		NPPRT= 
		goto, NPPRT
	}
FileSelectFile,NPPRT,3,%npptmp%,Select notepad++,*.exe
NPPRT:
if (NPPRT = "")
	{
		ifnotexist,%nppsv%
			{
				npptmp= %A_MyDocuments%				
				if (progb = "")
					{
						Progress, 0, , ,Downloading NotePad++
					}	
				DownloadFile(NPPURL, nppsv, False, True)
				sleep, 1200
				if (progb = "")
					{
						Progress, off
					}
			}
		ifexist, %nppsv%
			{
				NPPK=
				NPPL=
				if (AUTOINSTALL >= 1)
					{
						NPPL= %A_MyDocuments%
						goto, NPPLSEL
					}
				FileselectFolder,NPPL,*%npptmp%,0,Location to extract NotepadPlusPlus
				NPPLSEL:
				if (NPPL = "")
					{
						return
					}
				splitpath,NPPL,nppflt
				ifnotinstring,nppflt,notepad
				NPPL.= "\Notepad++"
				Runwait, bin\7za.exe x -y "%nppsv%" -O"%NPPL%",,%rntp%
				NPPR= %NPPL%\notepad++.exe
				SB_SetText(" Notepad Plus Plus is " NPPR "")
				return
			}
		npptmp= 
		Msgbox,3,Not Found,%nppsv% not found.`nRETRY?
		ifmsgbox,Yes
			{
				AUTOINSTALL= 
				gosub,GetNPP
			}
		return
}
NPPR= %NPPRT%
SB_SetText(" Notepad Plus Plus is " NPPR "")
GetRMP:
rmptmp= %NPPL%\plugins
iniread,RMPURL,sets\BuildTools.set,BUILDENV,RunMe_Plugin
splitpath,RMPURL,rmpfn
rmpsv= %cacheloc%\%rmpfn%
ifexist,%NPPL%\plugins\RunMe.dll
	{
		goto,GetTBP
	}
goto,RMPRT
GetRMPSL:
if (AUTOINSTALL >= 1)
	{
		RMPRT= %NPPL%\plugins
		goto, RMPRT
	}
FileSelectFile,RMPRT,3,%rmptmp%,Select RunMe.dll,*.dll
RMPRT:
if (RMPRT = "")
	{
		ifnotexist,%rmpsv%
			{
				rmptmp= %A_MyDocuments%				
				if (progb = "")
					{
						Progress, 0, , ,Downloading RunMe Plugin
					}	
				DownloadFile(RMPURL, rmpsv, False, True)
				sleep, 1200
				if (progb = "")
					{
						Progress, off
					}
			}
		ifexist, %rmpsv%
			{
				Runwait, bin\7za.exe x -y "%rmpsv%" -O"%NPPL%\plugins\RunMe" "32bit\RunMe.dll",,%rntp%
			}
		else {
			Msgbox,3,Not Found,%rmpsv% not found.`nRETRY?
					ifmsgbox,Yes
						{
							AUTOINSTALL= 
							gosub,GetRMPSL
						}
				}
	}
GetTBP:
tbptmp= %NPPL%\plugins
iniread,TBPURL,sets\BuildTools.set,BUILDENV,ToolBucket_Plugin
splitpath,TBPURL,tbpfn
tbpsv= %cacheloc%\%tbpfn%
ifexist,%NPPL%\plugins\NppToolBucket.dll
	{
		goto,GetTXP
	}
if (AUTOINSTALL >= 1)
	{
		TBPRT= %NPPL%\plugins
		goto, TBPRT
	}

goto, TBPRT

GetTBPSL:
FileSelectFile,TBPRT,3,%tbptmp%,Select NppToolBucket.dll,*.dll

TBPRT:
if (TBPRT = "")
	{
		ifnotexist,%tbpsv%
			{
				tbptmp= %A_MyDocuments%
				if (progb = "")
					{
						Progress, 0, , ,Downloading ToolBucket Plugin
					}	
				DownloadFile(TBPURL, tbpsv, False, True)
				sleep, 1200
				if (progb = "")
					{
						Progress, off
					}
			}
		ifexist, %tbpsv%
			{
				Runwait, bin\7za.exe x -y "%tbpsv%" -O"%NPPL%\plugins\ToolBucket",,%rntp%
			}
		else {	
				Msgbox,3,Not Found,%tbpsv% not found.`nRETRY?
				ifmsgbox,Yes
					{
						AUTOINSTALL= 
						gosub,GetTBPSL
					}
		}
	}
GetTXP:
txptmp= %NPPL%\plugins
iniread,TXPURL,sets\BuildTools.set,BUILDENV,TextFX_Plugin
splitpath,TXPURL,txpfn
tspsv= %cacheloc%\%txpfn%
ifexist,%NPPL%\plugins\NppTextFX.dll
	{
		return
	}
if (AUTOINSTALL >= 1)
	{
		TXPRT= %NPPL%\plugins
		goto, TXPRT
	}
	
goto, TXPRT

TXPRSL:
FileSelectFile,TXPRT,3,%txptmp%,Select NppTextFX.dll,*.dll
TXPRT:
if (TXPRT = "")
	{
		ifnotexist,%txpsv%
			{
				txptmp= %A_MyDocuments%
				if (progb = "")
					{
						Progress, 0, , ,Downloading TextFX Plugin
					}	
				DownloadFile(TXPURL, txpsv, False, True)
				sleep, 1200
				if (progb = "")
					{
						Progress, off
					}
			}
		ifexist, %txpsv%
			{
				Runwait, bin\7za.exe x -y "%txpsv%" -O"%NPPL%\plugins\TextFX",,%rntp%
			}
		else {
					Msgbox,3,Not Found,%txpsv% not found.`nRETRY?
					ifmsgbox,Yes
						{
							AUTOINSTALL= 
							gosub,TXPRSL
						}
		}	
	}	
return

GetAHKZ:
iniread,AHKURL,sets\BuildTools.set,BUILDENV,AutoHotkey
splitpath,AHKURL,ahksvf
ahksv= %cacheloc%\%ahksvf%
ifnotexist, %ahksv%
	{
		ahktmp= %A_MyDocuments%		
		if (progb = "")
			{
				Progress, 0, , ,Downloading AutoHotkey
			}	
		DownloadFile(AHKURL, ahksv, False, True)
		sleep, 1200
		if (progb = "")
			{
				Progress, off
			}
	}
ifexist, %ahksv%
	{
		AHKDIR= 
		AHKDIT= 		
		if (AUTOINSTALL >= 1)
			{
				AHKDIT= %A_MyDocuments%
				goto, AHKRT
			}
		FileSelectFolder, AHKDIT,*%ahktmp%,0,Location to extract the AutoHotkey Programs.
		AHKRT:
		if (AHKDIT = "")
			{
				return
			}
		splitpath,ahkdit,ahktstn
		ifnotinstring,ahktstn,autohotkey
			{
				AHKDIT.= "\Autohotkey"
			}
		Runwait, bin\7za.exe x -y "%ahksv%" -O"%AHKDIT%",,%rntp%
		AHKDIR= %AHKDIT%\Compiler
		iniwrite, %AHKDIR%,skopt.cfg,GLOBAL,Compiler_Directory
		SB_SetText("AutoHotkey Compiler Directory is " AHKDIR " ")
		ahktmp= 
		return
	}
ahktmp= 
Msgbox,3,Not Found,%ahksv% not found.`nRETRY?
ifmsgbox,Yes
	{
		AUTOINSTALL= 
		gosub,GetAHKZ
	}
return

SrcDD:
gui,submit,nohide
guicontrolget,SRCDD,,SRCDD
guicontrol,,RESGET,GET
if (SRCDD = "Compiler")
	{
		SB_SetText(" " AHKDIR " ")
	}
if (SRCDD = "Build")
	{
		SB_SetText(" " BUILDIR " ")
	}
if (SRCDD = "Deployment")
	{
		SB_SetText(" " DEPL " ")
	}
if (SRCDD = "Source")
	{
		SB_SetText(" " SKELD " ")
	}
if (SRCDD = "Project")
	{
		guicontrol,,RESGET,CLONE
		SB_SetText(" " GITD " ")
	}
if (SRCDD = "NSIS")
	{
		SB_SetText(" " NSIS " ")
	}
if (SRCDD = "github-release")
	{
		SB_SetText(" " GITRLS " ")
	}
if (SRCDD = "Site")
	{
		guicontrol,,RESGET,CLONE
		SB_SetText(" " SITEDIR " ")
	}
	
if (SRCDD = "NP++")
	{
		SB_SetText(" " NPPR " ")
	}
		
if (SRCDD = "Git.exe")
	{
		SB_SetText(" " GITAPP " ")
	}
	
return

ResDD:
gui,submit,nohide
guicontrolget,RESDD,,RESDD
if (RESDD = "Dev-Build")
	{			
		SB_SetText(" BUILDING ")
		if (DBOV = 1)
			SB_SetText(" Overriding ")
	}
if (RESDD = "Update-URL")
	{
		SB_SetText(" " UPDTURL " ")
	}
if (RESDD = "Update-File")
	{
		SB_SetText(" " UPDTFILE " ")
	}
if (RESDD = "Git-URL")
	{
		SB_SetText(" " GITSRC " ")
	}
if (RESDD = "Portable-Build")
	{
		SB_SetText(" BUILDING ")
		if (PBOV = 1)
			SB_SetText(" Overriding ")
	}
if (RESDD = "Stable-Build")
	{
		SB_SetText(" BUILDING ")
		if (SBOV = 1)
			SB_SetText(" Overriding ")
	}
if (RESDD = "NSIS")
	{
		SB_SetText(" " NSIST " ")
	}
if (RESDD = "Deployer")
	{
		SB_SetText(" Reset this tool to default options !Remember your password!")
	}
if (RESDD = "Shader-URL")
	{
		SB_SetText(" " SHDRPURL " ")
	}
if (RESDD = "Internet-IP-URL")
	{
		SB_SetText(" " GETIPADR " ")
	}
if (RESDD = "Git-Password")
	{
		SB_SetText(" ********* ")
	}
if (RESDD = "Site-URL")
	{
		SB_SetText(" " SITEURL " ")
	}
if (RESDD = "Git-User")
	{
		SB_SetText(" " GITUSER " ")
	}
if (RESDD = "Git-Token")
	{
		SB_SetText(" " GITPAT " ")
	}
if (RESDD = "Repo-URL")
	{
		REPORURLT= %GITUSER%.github.io
		SB_SetText(" " REPOURL " ")
	}
return

ResB:
gui,submit,nohide
if (RESDD = "Stable-Build")
	{
		StbBld= 
		SBOV= 
		FileSelectFile,StbBld,3,Installer.zip,Select Stable Build
		if (StbBld = "")
			{
				return
			}
		MsgBox,1,Confirm Overwrite,Are you sure you want to revert your Stable Build?
			IfMsgBox, OK
				{
					FileCopy, %StbBld%,%DEPL%,1
					SBOV= 1
				}
	}

if (RESDD = "Portable-Build")
	{
		PortBld= 
		PBOV= 
		FileSelectFile,PortBld,3,skeletonKey-portable.zip,Select Portable Build
		if (PortBld = "")
			{
				return
			}
		MsgBox,1,Confirm Overwrite,Are you sure you want to revert your portable Build?
			IfMsgBox, OK
				{
					FileCopy, %PortBld%,%DEPL%,1
					PBOV= 1
				}
	}

if (RESDD = "Dev-Build")
	{
		DevBld= 
		DBOV= 
		FileSelectFile,DevBld,3,skeletonKey-portable.zip,Select Portable Build
		if (DevBld = "")
			{
				return
			}
		MsgBox,1,Confirm Overwrite,Are you sure you want to revert your Development Build?
			IfMsgBox, OK
				{
					rvbldn= 
					buildrv= 
					Loop, %DEPL%\skeletonKey-%date%*.zip
						{
							rvbldn+=1
							buildrv= -%rvbldn%
						}
						if (rvbldn = 1)
							{
								buildrv= 
							}
					FileCopy, %DevBld%,%DEPL%\skeletonKey-%date%%buildrv%,1
					DBOV= 1
				}
	}

if (RESDD = "Deployer")
	{
		MsgBox,1,Confirm Tool Reset, Are You sure you want to reset the Deployment Tool?
		IfMsgBox, OK
			{
				FileDelete, %BUILDIR%\gitcommit.bat
				FileDelete, %BUILDIR%\skdeploy.nsi				
				FileDelete, %BUILDIR%\skopt.cfg
				;;FileDelete, %BUILDIR%\ltc.txt
				;;FileDelete, %BUILDIR%\insts.sha1
				ExitApp
			}
	}

if (RESDD = "NSIS")
	{
		MsgBox,1,Confirm Tool Reset, Are You sure you want to reset the NSIS makensis.exe?
		IfMsgBox, OK
			{
				NSIStmp= 
				NBOV= 
				FileSelectFile,NSIST,3,%NSISD%\makensis.exe,Select makensis.exe
				if (NSIST = "")
					{
						return
					}
				MsgBox,1,Confirm Overwrite,Are you sure you want to change the makensis.exe?
					IfMsgBox, OK
						{
							NSIS= %NSIST%
							NBOV= 1
						}
				ExitApp
			}
	}

if (RESDD = "github-release")
	{
		MsgBox,1,Confirm Tool Reset, Are You sure you want to reset the github-release.exe?
		IfMsgBox, OK
			{
				GITRLSTtmp= 
				GBOV= 
				FileSelectFile,GITRLST,3,%gitroot%\github-release.exe,Select github-release,*.exe.
				if (GITRLST = "")
					{
						return
					}
				MsgBox,1,Confirm Overwrite,Are you sure you want to change the github-release.exe?
					IfMsgBox, OK
						{
							GITRLS= %GITRLST%
							GBOV= 1
						}
				ExitApp
			}
	}
	
if (RESDD = "Site-URL")
	{
		Gosub, GetSiteURL
	}

if (RESDD = "Repo-URL")
	{
		iniread,REPOURL,sets\arcorg.set,GLOBAL,HOSTINGURL
		;;FileReadline,REPOURLT,arcorg.set,2
		Gosub, RepoURL
	}

if (RESDD = "Internet-IP-URL")
	{
		GETIPADRT= %GETIPADR%
		Gosub, GetIpAddr
	}

if (RESDD = "Shader-URL")
	{
		SHDRPURLT= %SHDRPURL%
		Gosub, GetShaderP
	}

if (RESDD = "Git-URL")
	{
		GITSRCT= %GITSRC%
		Gosub, GitSRC
	}
if (RESDD = "Update-URL")
	{
		UPDTURLT= %UPDTURL%
		Gosub, UpdateURL
	}
if (RESDD = "Update-File")
	{
		UPDTURLT= %UPDTFILE%
		Gosub, UpdateFile
	}
if (RESDD = "Git-Token")
	{
		GITPAT= XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
		Gosub, GetGPAC
	}
if (RESDD = "Git-User")
	{
		GITUSER= 
		Gosub, GetGUSR
	}
if (RESDD = "Git-Password")
	{
		GITPASS= 
		Gosub, GetGPass
	}
if (RESDD = "All")
	{
		Msgbox,3,Confirm Reset,Are you sure you wish to reset the SKey-Deploy tool?
			ifmsgbox,yes
				{
					filedelete,skopt.cfg
					exitapp
				}
		Gosub, GetGPass
	}
return


VerNum:
gui,submit,nohide
guicontrolget,vernum,,vernum
return

AddIncVer:
gui,submit,nohide
guicontrolget,vernum,,vernum
stringsplit,vernad,vernum,.
nven:= vernad4+1
if (vernad4 = 99)
	{
		nven= 00
		if (vernad3 = 99)
			{
				nven= x
			}
			else {
				vernad3+=1
			}
	}
	
vernum:= vernad1 . "." vernad2 . "." vernad3 . "." nven
guicontrol,,VerNum,%vernum%
return

PortVer:
gui,submit,nohide

return

OvrStable:
gui,submit,nohide

return

DevlVer:
gui,submit,nohide

return

REPODATS:
gui,submit,nohide

return

DatBld:
gui,submit,nohide

return

PushNotes:
gui,submit,nohide
guicontrolget, PushNotes,,PushNotes
ifinstring,pushnotes,$
	{
		stringgetpos,verstr,pushnotes,$
		stringgetpos,endstr,pushnotes,.00
		if (ErrorLevel <> "")
			{
				strstr:= verstr + 2
				midstr:= (endstr - verstr - 1)
				stringmid,donation,pushnotes,strstr,midstr
				SB_SetText(" $" donation " found")
			}
	}
return

ServerPush:
gui,submit,nohide

return

GitPush:
gui,submit,nohide
guicontrolget,GITPUSH,,GITPUSH
return

SiteUpdate:
gui,submit,nohide

return

CANCEL:
gui,submit,nohide
msgbox,1,Cancel,Are you sure you wish to cancel your deployment?,10
ifmsgbox,Cancel
	{
		return
	}
BCANC= 1
guicontrol,enable,PushNotes
guicontrol,enable,VerNum
guicontrol,enable,GitPush
guicontrol,enable,ServerPush
guicontrol,enable,SiteUpdate
guicontrol,enable,PortVer
guicontrol,enable,INITINCL
guicontrol,enable,DevlVer
guicontrol,enable,RESDD
guicontrol,enable,ResB
guicontrol,enable,SrcDD
guicontrol,enable,SelDir
guicontrol,hide,CANCEL
guicontrol,show,COMPILE
guicontrol,,progb,0
SB_SetText(" Operation Cancelled ")
return

BUILDING:
BUILT= 1
ifexist, %DEPL%\skeletonD.zip
	{
		FileDelete, %DEPL%\skeletonD.zip
	}
ifexist, %DEPL%\skeletonK.zip
	{
		FileDelete, %DEPL%\skeletonK.zip
	}
ifexist, %DEPL%\skeletonkey-installer.exe
	{
		FileDelete, %DEPL%\skeletonkey-installer.exe
	}
;;FileDelete, %DEPL%\skeletonkey-Full.exe
ifexist, %BUILDIR%\skdeploy.nsi
	{
		FileDelete, %BUILDIR%\skdeploy.nsi
	}

FileRead, nsiv,%BUILDIR%\sets\skdeploy.set
StringReplace, nsiv, nsiv,[INSTYP],-installer,All
StringReplace, nsiv, nsiv,[SOURCE],%SKELD%,All
StringReplace, nsiv, nsiv,[BUILD],%BUILDIR%,All
StringReplace, nsiv, nsiv,[DBP],%DEPL%,All
StringReplace, nsiv, nsiv,[CURV],%vernum%,All
FileAppend, %nsiv%, %BUILDIR%\skdeploy.nsi
RunWait, %comspec% cmd /c echo.###################  DEPLOYMENT LOG FOR %date%  ####################### >>"%DEPL%\deploy.log", ,%rntp%
RunWait, %comspec% cmd /c " "%NSIS%" "%BUILDIR%\skdeploy.nsi" >>"%DEPL%\deploy.log"", ,%rntp%
RunWait, %comspec% cmd /c echo.########################################## >>"%DEPL%\deploy.log", ,%rntp%
FileDelete,skdeploy.nsi
CrCFLN= %DEPL%\skeletonkey-installer.exe
gosub, SHA1GET
nchash:= ApndSHA
;;RunWait, %comspec% cmd /c " "%BUILDIR%\fciv.exe" -sha1 "%DEPL%\skeletonkey-installer.exe" > "%BUILDIR%\fcivINST.txt" ", %BUILDIR%,%rntp%
;;FileReadLine, nchash, %BUILDIR%\fcivINST.txt,4
;;RunWait, %comspec% cmd /c " "%NSIS%" "%BUILDIR%\skdeploy.nsi" >"%DEPL%\deploy.log"", ,%rntp%
BLDERROR= 
ifnotexist, %DEPL%\skeletonKey-installer.exe
	{
		BLDERROR= 1	
	}
BLDCHKSZ= 0
ifexist, %DEPL%\skeletonKey-installer.exe
	{
		FileGetSize, BLDCHKSZ,%DEPL%\skeletonKey-installer.exe,M
		if BLDCHKSZ < 2
			{
				BLDERROR= 1
			}
	}
if (BLDERROR = 1)
	{
		MsgBox,,,HALT.,INSTALLER FAILED.,CHECK YO SCRIPT MAN!
	}

FileDelete, %SKELD%\site\version.txt
FileAppend, %date% %timestring%=%nchash%=%vernum%,%SKELD%\site\version.txt


buildnum= 
buildtnum= 1
Loop, %DEPL%\skeletonkey-%date%*.zip
	{
		buildnum+=1
	}

if (buildnum <> "")
	{
		buildnum= -%buildnum%
	}	

RunWait, %comspec% cmd /c echo.##################  CREATE INSTALLER ######################## >>"%DEPL%\deploy.log", ,%rntp%
RunWait, %comspec% cmd /c " "%BUILDIR%\bin\7za.exe" a "%DEPL%\skeletonK.zip" "%DEPL%\skeletonKey-installer.exe" >>"%DEPL%\deploy.log"", %BUILDIR%,%rntp%
RunWait, %comspec% cmd /c echo.########################################## >>"%DEPL%\deploy.log", ,%rntp%
if (DevlVer = 1)
	{
		if (DBOV <> 1)
			{
				FileMove,%DEPL%\skeletonK.zip, %DEPL%\skeletonKey.zip,1	
				FileMove,%DEPL%\skeletonK.zip, %DEPL%\Installer.zip,1	
			}
	}
if (OvrStable = 1)
	{
				if (SBOV <> 1)
					{
						FileCopy,%DEPL%\skeletonK.zip, %DEPL%\skeletonkey-%date%%buildnum%.zip,1
						ifExist, %DEPL%\Installer.zip
							{
								FileMove,%DEPL%\Installer.zip, %DEPL%\Installer.zip.bak,1
							}
						FileMove,%DEPL%\skeletonK.zip, %DEPL%\Installer.zip,1
					}
	}
return

LogView:
ifexist,%DEPL%\deploy.log
	{
		Run,Notepad "%DEPL%\deploy.log"
		return
	}
SB_SetText("Log Not Found")
return

COMPILE:
filedelete,%DEPL%\deploy.log
BCANC= 
gui,submit,nohide
compiling= 1
guicontrol,disable,RESDD
guicontrol,disable,OvrStable
guicontrol,disable,ResB
guicontrol,disable,SrcDD
guicontrol,disable,SelDir
guicontrol,hide,COMPILE
guicontrol,show,CANCEL
guicontrol,disable,PushNotes
guicontrol,disable,VerNum
guicontrol,disable,GitPush
guicontrol,disable,ServerPush
guicontrol,disable,SiteUpdate
guicontrol,disable,DatBld
guicontrol,disable,REPODATS
guicontrol,disable,PortVer
guicontrol,disable,INITINCL
guicontrol,disable,DevlVer
guicontrolget,REPODATS,,REPODATS
guicontrolget,DATBLD,,DATBLD
guicontrolget,GITPUSH,,GITPUSH
guicontrolget,SERVERPUSH,,SERVERPUSH
guicontrolget,SITEUPDATE,,SITEUPDATE
guicontrolget,INITINCL,,INITINCL
guicontrolget,PORTVER,,PORTVER


readme= 
FileMove,%SKELD%\ReadMe.md, %SKELD%\ReadMe.bak,1
FileRead,readme,%SKELD%\sets\ReadMe.set
StringReplace,readme,readme,[CURV],%vernum%
StringReplace,readme,readme,[VERSION],%date% %timestring%
FileAppend,%readme%,%SKELD%\ReadMe.md
FileCopy,%SKELD%\ReadMe.md,site,1
arcorgv= 
FileMove,%SKELD%\sets\themes.set, %SKELD%\themes.bak,1
FileMove,%SKELD%\sets\arcorg.set, %SKELD%\arcorg.bak,1
FIleRead,skthemes,%SKELD%\sets\Themes.put
FIleRead,arcorgv,%SKELD%\sets\arcorg.put
StringReplace,skthemes,skthemes,[HOSTINGURL],%REPOURL%,All
StringReplace,arcorgv,arcorgv,[UPDATEFILE],%UPDTFILE%,All
StringReplace,arcorgv,arcorgv,[HOSTINGURL],%REPOURL%,All
StringReplace,arcorgv,arcorgv,[LOBBY],%NLOB%,All
StringReplace,arcorgv,arcorgv,[SHADERHOST],%SHDRPURL%,All
StringReplace,arcorgv,arcorgv,[SOURCEHOST],%UPDTURL%,All
StringReplace,arcorgv,arcorgv,[REPOSRC],https://github.com/%gituser%/skeletonKey/releases/download,All
StringReplace,arcorgv,arcorgv,[IPLK],%GETIPADR%,All
StringReplace,arcorgv,arcorgv,[CURV],%vernum%,All
FileAppend,%skthemes%,%SKELD%\sets\themes.set
FileAppend,%arcorgv%,%SKELD%\sets\arcorg.set
FileDelete, %SKELD%\skeletonKey.exe
FileDelete,%SKELD%\skeletonkey.tmp
FileMove,%SKELD%\skeletonkey.ahk,%SKELD%\skel.bak,1
FileCopy, %SKELD%\working.ahk, %SKELD%\skeletonkey.tmp,1
sktmp= 
sktmc= 
sktmv= 
FileRead, sktmp,%SKELD%\skeletonkey.tmp
StringReplace,sktmc,sktmp,[VERSION],%date% %TimeString%,All
StringReplace,sktmv,sktmc,[CURV],%vernum%,All
stringreplace,sktmv,sktmv,/*  ;;[DEBUGOV],,All
stringreplace,sktmv,sktmv,*/  ;;[DEBUGOV],,All
FileAppend,%sktmv%,%SKELD%\skeletonkey.ahk
FileDelete,%SKELD%\skeletonkey.tmp

if (BCANC = 1)
	{
		SB_SetText(" Cancelling Compile ")
		guicontrol,,progb,0
		;Sleep, 500
		compiling= 
		return
	}
	
SB_SetText(" Compiling ")
if (OvrStable = 1)
	{
		ifexist, %DEPL%\skeletonkey.exe
			{
				FileMove, %DEPL%\skeletonkey.exe, %DEPL%\skeletonkey.exe.bak,1
			}
		ifexist, %SKELD%\SKey-Deploy.exe
			{
				FileMove, %SKELD%\SKey-Deploy.exe, %SKELD%\SKey-Deploy.exe.bak,1
			}
	}
	
if (INITINCL = 1)
	{
			exprt= 
			;;exprt.= "FileCreateDir, gam\Archive\MAME - Systems" . "`n"
			;;exprt.= "FileCreateDir, gam\THE-EYE" . "`n"
			exprt.= "FileCreateDir, gam" . "`n"
			exprt.= "FileCreateDir, img" . "`n"
			exprt.= "FileCreateDir, site" . "`n"
			exprt.= "FileCreateDir, sets" . "`n"
			exprt.= "FileCreateDir, bin" . "`n"
			exprt.= "FileCreateDir, src" . "`n"
			exprt.= "IfNotExist, rj" . "`n" . "{" . "`n" . "FileCreateDir, rj" . "`n" . "FILEINS= 1" . "`n" . "}" . "`n"
			exprt.= "If (INITIAL = 1)" . "`n" . "{" . "`n" . "FILEINS= 1" . "`n" . "}" . "`n"
			exprt.= "If (FILEINS = 1)" . "`n" . "{" . "`n" 
			RunWait, %comspec% cmd /c echo.###################  COMPILE DEPLOYER  ####################### >>"%DEPL%\deploy.log", ,%rntp%
			runwait, %comspec% cmd /c " "%AHKDIR%\Ahk2Exe.exe" /in "%SKELD%\src\Skey-Deploy.ahk" /out "%SKELD%\Skey-Deploy.exe" /icon "%SKELD%\img\Sharp - X1.ico" /bin "%AHKDIR%\Unicode 32-bit.bin" >>"%DEPL%\deploy.log"", %SKELD%,%rntp%
			RunWait, %comspec% cmd /c echo.########################################## >>"%DEPL%\deploy.log", ,%rntp%
			Loop, Files, %SKELD%\rj\emuCfgs\*,DR
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					fcdxp.= "FileCreateDir," . ain . "`n"
				}	
			Loop, Files, %SKELD%\rj\joyCfgs\*,DR
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					fcdxp.= "FileCreateDir," . ain . "`n"
				}	
			Loop, Files, %SKELD%\rj\KODI\*,DR
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					fcdxp.= "FileCreateDir," . ain . "`n"
				}	
			exprt.= fcdxp . "`n" . "}" . "`n"
			exprt.= "FileCreateDir, rj\ES" . "`n"
			exprt.= "FileCreateDir, rj\PG" . "`n"
			exprt.= "FileCreateDir, rj\RF" . "`n"
			Loop, files, %SKELD%\site\*.txt
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\site\*.md
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\site\*.ico
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\site\*.svg
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\site\*.png
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\site\*.html
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\site\*.ttf
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files,%SKELD%\sets\*.set
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\sets\*.put
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\*.exe
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\bin\*.exe
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\img\*.png
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\img\*.ico
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\rj\KODI\*.set,R
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\src\*.ahk,R
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			/*	
			Loop, files, %SKELD%\gam\Archive\MAME - Systems\*.gam,R
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\gam\Archive\*.gam,R
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\gam\THE-EYE\*.gam,R
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			*/	
			Loop, files, %SKELD%\rj\emucfgs\*.*,R
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					if (A_LoopFileExt = "ret")
						{
							exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
						}
					if (A_LoopFileExt = "set")
						{
							exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
						}
					if (A_LoopFileExt = "get")
						{
							exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
						}
				}
			Loop, files, %SKELD%\rj\joyCfgs\*.*,R
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					if (A_LoopFileExt = "amgp")
						{
							exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
						}
					if (A_LoopFileExt = "xpadderprofile")
						{
							exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
						}
				}				
			exprt.= "FileInstall, bin\7zsd32.sfx,bin\7zsd32.sfx" . "`n"	
			exprt.= "FileInstall, bin\7zsd64.sfx,bin\7zsd64.sfx" . "`n"	
			;;exprt.= "FileInstall, bin\Portable.bat,bin\Portable.bat,1" . "`n"	
			exprt.= "FileInstall, site\index.html,site\index.html,1" . "`n"	
			exprt.= "FileInstall, site\version.txt,site\version.txt,1" . "`n"	
			exprt.= "FileInstall, working.ahk,working.ahk,1" . "`n"	
			exprt.= "FileInstall, src\init.ahk,src\init.ahk,1" . "`n"	
			exprt.= "FileInstall, src\PortableUtil.ahk,src\PortableUtil.ahk,1" . "`n"	
			exprt.= "FileInstall, src\Update.ahk,src\Update.ahk,1" . "`n"	
			exprt.= "FileInstall, skeletonKey.ahk,skeletonkey.ahk,1" . "`n"	
			exprt.= "FileInstall, src\SKey-Deploy.ahk,src\SKey-Deploy.ahk,1" . "`n"	
			exprt.= "FileInstall, src\emuexe.ahk,src\emuexe.ahk,1" . "`n"	
			exprt.= "FileInstall, src\BSL.ahk,src\BSL.ahk,1" . "`n"	
			exprt.= "FileInstall, src\LV_InCellEdit.ahk,src\LV_InCellEdit.ahk,1" . "`n"	
			exprt.= "FileInstall, src\tf.ahk,src\tf.ahk,1" . "`n"	
			exprt.= "FileInstall, src\lbex.ahk,src\lbex.ahk,1" . "`n"	
			exprt.= "FileInstall, src\LVA.ahk,src\LVA.ahk,1" . "`n"	
			exprt.= "FileInstall, src\HtmlDlg.ahk,src\HtmlDlg.ahk,1" . "`n"	
			exprt.= "FileInstall, src\AHKSock.ahk,src\AHKSock.ahk,1" . "`n"
			exprt.= "FileInstall, Readme.md,Readme.md,1" . "`n"
			FileDelete,%SKELD%\sets\ExeRec.set
			FileAppend,%exprt%,%SKELD%\sets\ExeRec.set
	}

if (OvrStable = 1)
	{
		Process, exist, Skey-Deploy.exe
		if (ERRORLEVEL = 1)
			{
				SB_SetText("You should not compile this tool with the compiled skey-deploy.exe executable")
			}
		RunWait, %comspec% cmd /c echo.##################  COMPILE DEPLOYER  ######################## >>"%DEPL%\deploy.log", ,%rntp%	
		runwait, %comspec% cmd /c " "%AHKDIR%\Ahk2Exe.exe" /in "%SKELD%\src\Skey-Deploy.ahk" /out "%SKELD%\Skey-Deploy.exe" /icon "%SKELD%\img\Sharp - X1.ico" /bin "%AHKDIR%\Unicode 32-bit.bin" >>"%DEPL%\deploy.log"", %SKELD%,%rntp%	
		RunWait, %comspec% cmd /c echo.##################  COMPILE SKELETONKEY  ######################## >>"%DEPL%\deploy.log", ,%rntp%	
		runwait, %comspec% cmd /c " "%AHKDIR%\Ahk2Exe.exe" /in "%SKELD%\skeletonkey.ahk" /out "%DEPL%\skeletonkey.exe" /icon "%SKELD%\site\key.ico" /bin "%AHKDIR%\Unicode 32-bit.bin" >>"%DEPL%\deploy.log"", %SKELD%,%rntp%
		RunWait, %comspec% cmd /c echo.########################################## >>"%DEPL%\deploy.log", ,%rntp%	
		FileDelete,%SKELD%\skeletonkey.ahk
		FileCopy, %DEPL%\skeletonkey.exe,%SKELD%,1
	}

guicontrol,,progb,15
FileDelete,%SKELD%\*.lpl
FileDelete,%SKELD%\*.tmp
/*
;;FileDelete,%SKELD%\version.txt
FileDelete,ltc.txt
;;FileAppend, "%SKELD%\skeletonkey.ahk"`n,ltc.txt
FileAppend, "%SKELD%\working.ahk"`n,ltc.txt
FileAppend, "%SKELD%\src\Update.ahk"`n,ltc.txt
FileAppend, "%SKELD%\site\version.txt"`n,ltc.txt
FileAppend, "%SKELD%\src\SKey-Deploy.ahk"`n,ltc.txt
FileAppend, "%SKELD%\src\BSL.ahk"`n,ltc.txt
FileAppend, "%SKELD%\src\AHKsock.ahk"`n,ltc.txt
FileAppend, "%SKELD%\src\lbex.ahk"`n,ltc.txt
FileAppend, "%SKELD%\src\init.ahk"`n,ltc.txt
FileAppend, "%SKELD%\src\PortableUtil.ahk"`n,ltc.txt
FileAppend, "%SKELD%\src\LVA.ahk"`n,ltc.txt
FileAppend, "%SKELD%\src\HtmlDlg.ahk"`n,ltc.txt
FileAppend, "%SKELD%\src\emuexe.ahk"`n,ltc.txt
FileAppend, "%SKELD%\src\tf.ahk"`n,ltc.txt
FileAppend, "%SKELD%\src\LV_InCellEdit.ahk"`n,ltc.txt
Loop, %SKELD%\*
		{
			if (A_LoopFileExt = "cfg")
				{
					continue
				}
			if (A_LoopFileExt = "7z")
				{
					continue
				}
			if (A_LoopFileExt = "zip")
				{
					continue
				}
			if (A_LoopFileExt = "ini")
				{
					continue
				}
			if (A_LoopFileExt = "ahk")
				{
					continue
				}
			if (A_LoopFileExt = "bak")
				{
					continue
				}
			FileAppend, "%A_LoopFileFullPath%"`n,ltc.txt
		}
FileAppend,:%SKELD%\img\*.ico`n,ltc.txt
FileAppend,:%SKELD%\rj\ES\*.set`n,ltc.txt
FileAppend,:%SKELD%\rj\PG\*.set`n,ltc.txt
FileAppend,:%SKELD%\rj\RF\*.set`n,ltc.txt
FileAppend,:%SKELD%\img`n,ltc.txt
FileAppend,:%SKELD%\rj\joycfgs`n,ltc.txt
FileAppend,:%SKELD%\rj\KODI\*.set`n,ltc.txt
FileAppend,:%SKELD%\rj\KODI\AEL\*.set`n,ltc.txt
FileAppend,:%SKELD%\rj\emucfgs`n,ltc.txt
FileAppend,:%SKELD%\rj\scrapeart`n,ltc.txt

Loop, %SKELD%\rj\scrapeart\*.7z
	{
		FileAppend,"%A_LoopFileFullPath%"`n,ltc.txt
	}

Loop, %SKELD%\rj\emucfgs\*,2
	{
		FileAppend,:"%A_LoopFileFullPath%"`n,ltc.txt
		Loop, %A_LoopFileFullPath%\*
			{
				FileAppend,"%A_LoopFIleFullPath%"`n,ltc.txt
			}
	}

Loop, %SKELD%\rj\joycfgs\*,2
	{										
		FileAppend,:"%A_LoopFileFullPath%"`n,ltc.txt
		Loop, %A_LoopFileFullPath%\*
			{
				FileAppend,"%A_LoopFIleFullPath%"`n,ltc.txt
			}
	}
*/
guicontrol,,progb,20

if (DATBLD = 1)
	{		
		SB_SetText(" Recompiling Databases ")
		FileDelete, %DEPL%\DATFILES.7z
		Loop, %GITD%\rj\scrapeArt\*.7z
			{
				RunWait, %comspec% cmd /c echo.##################  CREATE METADATA  ######################## >>"%DEPL%\deploy.log", ,%rntp%	
				runwait, %comspec% cmd /c " "%BUILDIR%\bin\7za.exe" a -t7z "DATFILES.7z" "%A_LoopFileFullPath%" >>"%DEPL%\deploy.log"",%DEPL%,%rntp%
				RunWait, %comspec% cmd /c echo.########################################## >>"%DEPL%\deploy.log", ,%rntp%	
			}
	}
if (REPODATS = 1)
	{
		SB_SetText(" Compiling Repository Databases ")
		repolsts= 
		Loop, %BUILDIR%\gam\*,2
			{
				repolsts+=1
				repoln%A_Index%= %A_LoopFileName%
				RunWait, %comspec% cmd /c echo.##################  CREATE GAMFILES  ######################## >>"%DEPL%\deploy.log", ,%rntp%
				runwait, %comspec% cmd /c " "%BUILDIR%\bin\7za.exe" a -t7z "%A_LoopFileName%.7z" "%A_LoopFileFullPath%" >>"%DEPL%\deploy.log"",%DEPL%,%rntp%
				RunWait, %comspec% cmd /c echo.########################################## >>"%DEPL%\deploy.log", ,%rntp%
			}	

	}

FileGetSize,dbsize,%DEPL%\DATFILES.7z,K
DATSZ:= dbsize / 1000
	
if (PortVer = 1)
	{		
		SB_SetText(" Building portable ")
		COMPLIST= 
		if (PBOV <> 1)
			{
				FileDelete, %DEPL%\skeletonKey-portable.zip
				RunWait, %comspec% cmd /c echo.##################  CREATE PORTABLE ZIP  ######################## >>"%DEPL%\deploy.log", ,%rntp%	
				runwait, %comspec% cmd /c " "%BUILDIR%\bin\7za.exe" a "%DEPL%\skeletonKey-portable.zip" "%DEPL%\skeletonkey.exe" >>"%DEPL%\deploy.log"", %SKELD%,%rntp%
				RunWait, %comspec% cmd /c echo.########################################## >>"%DEPL%\deploy.log", ,%rntp%	
				sleep, 1000
			}
	}

guicontrol,,progb,35
if (BCANC = 1)
	{
		SB_SetText(" Cancelling Development Build ")
		guicontrol,,progb,0
		gosub, canclbld
		compiling= 
		return
	}
	
if (DevlVer = 1)
	{
		SB_SetText(" Building Devel ")
		gosub, BUILDING
		guicontrol,,progb,55
}

if (BCANC = 1)
	{
		SB_SetText(" Cancelling Git Push ")
		guicontrol,,progb,0
		gosub, canclbld
		compiling= 
		return
	}

if (GitPush = 1)
	{
		ifinstring,pushnotes,$
			{
				stringgetpos,verstr,pushnotes,$
				stringgetpos,endstr,pushnotes,.00
				if (ErrorLevel <> "")
					{
						strstr:= verstr + 2
						midstr:= (endstr - verstr - 1)
						stringmid,donation,pushnotes,strstr,midstr
						SB_SetText(" $" donation " found")
					}
			}
		If (PushNotes = "")
			{
				PushNotes= %date% %TimeString%
				Loop, Read, %getversf%
					{
						sklnum+=1
						getvern= 
						ifinstring,A_LoopReadLine,$
							{
								stringgetpos,verstr,A_LoopReadLine,$
								stringgetpos,endstr,A_LoopReadLine,.00
								if (ErrorLevel <> "")
									{			
										strstr:= verstr + 2
										midstr:= (endstr - verstr - 1)
										stringmid,donation,A_LoopReadLine,strstr,midstr
										if (midstr = [PAYPAL])
											{
												donation= 00.00
											}
										if (donation = "[PAYPAL].00")
											{
												donation= 00.00
											}
										SB_SetText(" $" donation " found")
										break
											
									}
							}
								continue
					}
			}
		if (donation = "")
			{
				donation= 00.00				
			}			
		FileDelete, %SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\gam"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\bin"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\rj\scrapeArt"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\rj\ES"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\rj\PG"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\rj\RF"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\rj\emuCfgs"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\rj\KODI\ADVL"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\rj\KODI\AEL"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\rj\KODI\IAGL"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\rj\KODI\RCB"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\img"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\site"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\src"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\sets"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /s /q "%GITD%\rj\netArt\*"`n,%SKELD%\!gitupdate.cmd
		FileAppend, rd /s/q "%GITD%\rj\netArt"`n,%SKELD%\!gitupdate.cmd
		FileAppend, rd /s/q "%GITD%\rj\sysCfgs"`n,%SKELD%\!gitupdate.cmd
		;;FileAppend, robocopy "gam" "%GITD%\gam" /s /e /w:1 /r:1`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\*.tdb"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\*.tmp"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\*.ini"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\ES\*.zip"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\PG\*.zip"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\RF\*.zip"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\ES\*.cfg"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\PG\*.cfg"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\RF\*.cfg"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\ES\*.txt"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\PG\*.txt"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\RF\*.txt"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\ES\*.ini"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\PG\*.ini"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\RF\*.ini"`n,%SKELD%\!gitupdate.cmd
		FileAppend, robocopy "rj" "%GITD%\rj" /s /e /w:1 /r:1 /xf "*.ini" "*.tdb" "*.tmp" "*.jak" /xd "syscfgs"`n,%SKELD%\!gitupdate.cmd
		FileAppend, robocopy "img" "%GITD%\img" /s /e /w:1 /r:1`n,%SKELD%\!gitupdate.cmd
		FileAppend, robocopy "rj\emucfgs" "%GITD%\rj\emuCfgs" /s /e /w:1 /r:1`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "rj\scrapeArt\*.7z" "%GITD%\rj\scrapeArt"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "*.exe" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "bin\*.exe" "%GITD%\bin"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "sets\*.set" "%GITD%\sets"`n,%SKELD%\!gitupdate.cmd
		;;FileAppend, copy /y "bin\Portable.bat" "%GITD%\bin"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "site\index.html" "%GITD%\site"`n,%SKELD%\!gitupdate.cmd
		;;FileAppend, copy /y "version.html" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "src\LV_InCellEdit.ahk" "%GITD%\src"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "src\emuexe.ahk" "%GITD%\src"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "src\init.ahk" "%GITD%\src"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "src\Portable.ahk" "%GITD%\src"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "src\BSL.ahk" "%GITD%\src"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "src\lbex.ahk" "%GITD%\src"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "src\LVA.ahk" "%GITD%\src"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "src\HtmlDlg.ahk" "%GITD%\src"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "src\tf.ahk" "%GITD%\src"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "src\AHKsock.ahk" "%GITD%\src"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "src\SKey-Deploy.ahk" "%GITD%\src"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "working.ahk" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		;;FileAppend, copy /y "skeletonkey.ahk" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "rj\KODI\RCB\*.set" "%GITD%\rj\KODI\RCB"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "rj\KODI\AEL\*.set" "%GITD%\rj\KODI\AEL"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "rj\KODI\IAGL\*.set" "%GITD%\rj\KODI\IAGL"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "rj\KODI\AEL\*.set" "%GITD%\rj\KODI\AEL"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "img\*.ico" "%GITD%\img"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "img\*.png" "%GITD%\img"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "ReadMe.md" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "site\ReadMe.md" "%GITD%\site"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "site\version.txt" "%GITD%\site"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\skeletonKey.exe"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "sets\Themes.put" "%GITD%\sets"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "sets\arcorg.put" "%GITD%\sets"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "bin\7zsd32.sfx" "%GITD%\bin"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "bin\7zsd64.sfx" "%GITD%\bin"`n,%SKELD%\!gitupdate.cmd

		FileSetAttrib, +h, %SKELD%\!gitupdate.cmd
		SB_SetText(" Adding changes to git ")
		RunWait, %comspec% cmd /c echo.###################  GIT UPDATE  ####################### >>"%DEPL%\deploy.log", ,%rntp%	
		RunWait, %comspec% cmd /c " "%SKELD%\!gitupdate.cmd" >>"%DEPL%\deploy.log"",%SKELD%,%rntp%
		RunWait, %comspec% cmd /c echo.########################################## >>"%DEPL%\deploy.log", ,%rntp%	
		FileDelete, %SKELD%\!gitupdate.cmd
		SB_SetText(" committing changes to git ")
		FileDelete, %BUILDIR%\gitcommit.bat
			{
				FileAppend,for /f "delims=" `%`%a in ("%GITAPP%") do set gitapp=`%`%~a`n,%BUILDIR%\gitcommit.bat
				FileAppend,pushd "%GITD%"`n,%BUILDIR%\gitcommit.bat
				FileAppend,"`%gitapp`%" add .`n,%BUILDIR%\gitcommit.bat
				FileAppend,"`%gitapp`%" commit -m `%1`%`n,%BUILDIR%\gitcommit.bat
				if (GITPASS <> "")
					{
						FileAppend,"`%gitapp`%" push -f --repo http://%GITUSER%:%GITPASS%@github.com/%gituser%/skeletonKey`n,%BUILDIR%\gitcommit.bat
					}
				if (GITPASS = "")
					{
						FileAppend,"`%gitapp`%" push -f origin master`n,%BUILDIR%\gitcommit.bat
					}
			}
			
		FileAppend, "%PushNotes%`n",%DEPL%\changelog.txt
		RunWait, %comspec% cmd /c echo.###################  GIT UPDATE  ####################### >>"%DEPL%\deploy.log", ,%rntp%
		RunWait, %comspec% cmd /c " "%SKELD%\!gitupdate.cmd" >>"%DEPL%\deploy.log"",%SKELD%,%rntp%
		RunWait, %comspec% cmd /c echo.########################################## >>"%DEPL%\deploy.log", ,%rntp%
		SB_SetText(" Source changes committed.  Files Copied to git.  Committing...")
		StringReplace,PushNotes,PushNotes,",,All
		;"
		RunWait, %comspec% cmd /c echo.####################  GIT COMMIT  ###################### >>"%DEPL%\deploy.log", ,%rntp%
		RunWait, %comspec% cmd /c " "%BUILDIR%\gitcommit.bat" "%PushNotes%" >>"%DEPL%\deploy.log"",%GITD%,%rntp%
		RunWait, %comspec% cmd /c echo.########################################## >>"%DEPL%\deploy.log", ,%rntp%
		FileDelete, %BUILDIR%\gitcommit.bat
		SB_SetText(" source changes pushed to master ")
		guicontrol,,progb,65
	}

if (BCANC = 1)
	{
		SB_SetText(" Cancelling Stable Overwrite ")
		guicontrol,,progb,0
		gosub, canclbld
		compiling= 
		return
	}

if (OvrStable = 1)
	{
		SB_SetText(" overwriting stable ")
		if (BUILT <> 1)
			{
				gosub, BUILDING
			}
	}				
guicontrol,,progb,70

if (BCANC = 1)
	{
		SB_SetText(" Cancelling Server Upload ")
		guicontrol,,progb,0
		gosub, canclbld
		compiling= 
		return
	}

if (ServerPush = 1)
	{
		FileDelete, %DEPL%\gpush.cmd
		FileAppend, set GITHUB_USER=%GITUSER%`n,%DEPL%\gpush.cmd
		FileAppend, set GITHUB_TOKEN=%GITPAT%`n,%DEPL%\gpush.cmd
		FileAppend, pushd "%DEPL%"`n,%DEPL%\gpush.cmd
		
		SB_SetText(" Uploading to server ")
		
		if (PortVer = 1)
			{
				if (ServerPush = 1)
					{	
						FileAppend, "%GITRLS%" delete -r skeletonkey -t portable`n,%DEPL%\gpush.cmd
						FileAppend, "%GITRLS%" release -r skeletonkey -t portable`n,%DEPL%\gpush.cmd
						FileAppend, "%GITRLS%" upload -R -r skeletonkey -t portable -l portable -n skeletonKey-portable.zip -f "%DEPL%\skeletonKey-portable.zip"`n,%DEPL%\gpush.cmd
					}
			}
		if (DATBLD = 1)
			{
				if (ServerPush = 1)
					{					
						FileAppend, "%GITRLS%" delete -r skeletonkey -t DATFILES`n,%DEPL%\gpush.cmd
						FileAppend, "%GITRLS%" release -r skeletonkey -t DATFILES`n,%DEPL%\gpush.cmd
						FileAppend, "%GITRLS%" upload -R -r skeletonkey -t DATFILES -l "DATFILES" -n DATFILES.7z -f "%DEPL%\DATFILES.7z"`n,%DEPL%\gpush.cmd
					}
			}
		if (REPODATS = 1)
			{
				if (ServerPush = 1)
					{
						Loop,%repolsts%
							{
								rpofn:= % repoln%A_Index%
								stringupper,rpoln,rpofn
								FileAppend, "%GITRLS%" delete -r skeletonkey -t %rpoln%`n,%DEPL%\gpush.cmd
								FileAppend, "%GITRLS%" release -r skeletonkey -t %rpoln%`n,%DEPL%\gpush.cmd
								FileAppend, "%GITRLS%" upload -R -r skeletonkey -t %rpoln% -l "%rpoln%" -n %rpofn%.7z -f "%DEPL%\%rpofn%.7z"`n,%DEPL%\gpush.cmd
							}
					}
			}
		if (OvrStable = 1)
			{
				if (ServerPush = 1)
					{
						FileAppend, "%GITRLS%" delete -r skeletonkey -t Installer`n,%DEPL%\gpush.cmd
						FileAppend, "%GITRLS%" release -r skeletonkey -t Installer`n,%DEPL%\gpush.cmd
						FileAppend, "%GITRLS%" upload -R -r skeletonkey -t Installer -l Installer -n Installer.zip -f "%DEPL%\Installer.zip"`n,%DEPL%\gpush.cmd
					}
			}

			/*
		if (DevlVer = 1)
			{
				if (ServerPush = 1)
					{
						FileAppend, "%GITRLS%" delete -r skeletonkey -t FullVersion`n,%DEPL%\gpush.cmd
						FileAppend, "%GITRLS%" release -r skeletonkey -t FullVersion`n,%DEPL%\gpush.cmd
						FileAppend, "%GITRLS%" upload -R -r skeletonkey -t FullVersion -l "Full Version" -n FullVersion.zip -f "%DEPL%\skeletonkey-Full-%date%%buildnum%.zip"`n,%DEPL%\gpush.cmd
					}
			}
			*/
		if (SiteUpdate <> 1)
			{

			}
		guicontrol,,progb,80
		if (GitPush = 1)
			{
				RunWait, %comspec% cmd /c echo.###################  GIT DEPLOYMENT PUSH  ####################### >>"%DEPL%\deploy.log", ,%rntp%
				RunWait, %comspec% cmd /c " "gpush.cmd" >>"%DEPL%\deploy.log"",%DEPL%,%rntp%
				RunWait, %comspec% cmd /c echo.########################################## >>"%DEPL%\deploy.log", ,%rntp%
			}
	}
	
if (BCANC = 1)
	{
		SB_SetText(" Cancelling Site Update ")
		guicontrol,,progb,0
		gosub, canclbld
		compiling= 
		return
	}

if (SiteUpdate = 1)
	{
		SB_SetText(" Updating the website ")
		RDATE= %date% %timestring%
		if (DBOV = 1)
			{
				RDATE= reverted
			}
		if (PBOV = 1)
			{
				RDATE= reverted
			}
		if (SBOV = 1)
			{
				RDATE= reverted
			}
		if (ServerPush = 0)
			{
				buildnum= 
				sha1:= olsha 
				RDATE:= olrlsdt
				dvms:= olsize
				olnan1= 
				olnan2= 
				olnan3= 
				olnan4= 
				olnan5= 
				stringsplit, olnan,olrlsb,-
				date= %olnan2%-%olnan3%-%olnan4% 
				if (olnan5 <> "")
					{
						buildnum= -%olnan5%
					}
			}

		if (ServerPush = 1)
			{
				FileMove, %DEPL%\site\index.html, %DEPL%\index.bak,1
				FileRead,skelhtml,%BUILDIR%\site\index.html
				StringReplace,skelhtml,skelhtml,[CURV],%vernum%,All
				FileDelete,%BUILDIR%\insts.sha1

				if (OvrStable = 1)
					{
						ifExist, %DEPL%\skeletonkey-installer.exe
							{
								CrCFLN= %DEPL%\skeletonkey-installer.exe
								gosub, SHA1GET
								if (SBOV = 1)
									{
										ApndSHA= reverted
									}
								if (DBOV = 1)
									{
										ApndSHA= reverted
									}
							}
							/*
						ifExist, %DEPL%\skeletonkey-Full.exe
							{
								Runwait, %comspec% cmd /c " "%BUILDIR%\fciv.exe" -sha1 "%DEPL%\skeletonkey-Full.exe" >"%BUILDIR%\instsFull.sha1" ", %BUILDIR%,%rntp%
								if (SBOV = 1)
									{
										shb1= reverted
									}
								if (DBOV = 1)
									{
										shb1= reverted
									}
							}
							*/
							
						ifExist, %DEPL%\skeletonkey-%date%%buildnum%.zip
							{
								FileGetSize,dvlsize,%DEPL%\skeletonkey-%date%%buildnum%.zip, K
								dvps:= dvlsize / 1000
								StringLeft,dvms,dvps,4
								if (DBOV = 1)
									{
										dvms= reverted
									}
								if (SBOV = 1)
									{
										dvms= reverted
									}
							}
					}
			}			
			/*
		ifExist, %DEPL%\skeletonkey-Full-%date%%buildnum%.zip
			{
				FileGetSize,dvgsize,%DEPL%\skeletonkey-Full-%date%%buildnum%.zip, K
				dvpg:= dvgsize / 1000
				StringLeft,dvmg,dvpg,4
				if (DBOV = 1)
					{
						dvmg= reverted
					}
				if (SBOV = 1)
					{
						dvmg= reverted
					}
			}
			*/
		;;FileReadLine,shap,%BUILDIR%\insts.sha1,4
		;;stringsplit,sha,shap,%A_Space%
		;;FileReadLine,shag,%BUILDIR%\instsFull.sha1,4
		;;stringsplit,shb,shag,%A_Space%		
		
		guicontrol,,progb,90
		StringReplace,skelhtml,skelhtml,[RSHA1],%ApndSHA%,All
		;;StringReplace,skelhtml,skelhtml,[RSHA2],%shb1%,All
		StringReplace,skelhtml,skelhtml,[WEBURL],http://%GITUSER%.github.io/skeletonkey,All
		StringReplace,skelhtml,skelhtml,[PAYPAL],%donation%
		StringReplace,skelhtml,skelhtml,[GITSRC],%GITSRC%,All
		;;StringReplace,skelhtml,skelhtml,[REVISION],http://github.com/%gituser%/skeletonkey-%date%%buildnum%,All
		StringReplace,skelhtml,skelhtml,[REVISION],http://github.com/%gituser%/skeletonKey/releases/download/Installer/Installer.zip,All
		StringReplace,skelhtml,skelhtml,[PORTABLE],https://github.com/%gituser%/skeletonKey/releases/download/portable/skeletonKey-portable.zip,All
		
		StringReplace,skelhtml,skelhtml,[DATFILES],https://github.com/%gituser%/skeletonKey/releases/download/DATFILES/DATFILES.7z,All
		;;StringReplace,skelhtml,skelhtml,[DATFILES],https://github.com/%gituser%/DATFILES/raw/master/DATFILES.7z,All
		
		
;;		StringReplace,skelhtml,skelhtml,[FULLRELEASE],https://github.com/%gituser%/skeletonKey/releases/download/FullVersion/FullVersion.zip,All
		StringReplace,skelhtml,skelhtml,[RDATE],%RDATE%,All
		StringReplace,skelhtml,skelhtml,[RSIZE],%dvms%,All
		StringReplace,skelhtml,skelhtml,[RSIZE2],%dvmg%,All
		StringReplace,skelhtml,skelhtml,[DBSIZE],%DATSZ%,All
		
		FileDelete,%gitroot%\%gituser%.github.io\skeletonkey\index.html
		ifnotexist, %gitroot%\%gituser%.github.io\skeletonkey
			{
				FileCreateDir,%gitroot%\%gituser%.github.io\skeletonkey
				RunWait, %comspec% cmd /c "%gitapp%" init,%gitroot%\%GITUSER%.github.io,hide
				RunWait,%comspec% cmd /c "bin\curl.exe" -u %gituser%:%gitpass% https://api.github.com/user/repos -d "{\"name\":\"%gituser%.github.io\"}",,hide
			}
		FileAppend,%skelhtml%,%gitroot%\%gituser%.github.io\skeletonkey\index.html
	}
uptoserv=

if (SiteUpdate = 1)
	{
		uptoserv= 1
	}

if (ServerPush = 1)
	{
		uptoserv= 1
	}

if (uptoserv = 1)
	{
		SB_SetText(" Uploading to server ")
		FileDelete, %BUILDIR%\sitecommit.bat
		FileAppend,pushd "%gitroot%\%GITUSER%.github.io"`n,%BUILDIR%\sitecommit.bat
		FileAppend,copy /y "%BUILDIR%\site\Global-Launch-Menu.png" "%gitroot%\%GITUSER%.github.io\skeletonkey"`n,%BUILDIR%\sitecommit.bat
		FileAppend,copy /y "%BUILDIR%\site\key.ico" "%gitroot%\%GITUSER%.github.io\skeletonkey"`n,%BUILDIR%\sitecommit.bat
		FileAppend,copy /y "%BUILDIR%\site\key.png" "%gitroot%\%GITUSER%.github.io\skeletonkey"`n,%BUILDIR%\sitecommit.bat
		FileAppend,copy /y "%BUILDIR%\site\paradigm.png" "%gitroot%\%GITUSER%.github.io\skeletonkey"`n,%BUILDIR%\sitecommit.bat
		FileAppend,copy /y "%BUILDIR%\site\tip.png" "%gitroot%\%GITUSER%.github.io\skeletonkey"`n,%BUILDIR%\sitecommit.bat
		FileAppend,copy /y "%BUILDIR%\site\*.ttf" "%gitroot%\%GITUSER%.github.io\skeletonkey"`n,%BUILDIR%\sitecommit.bat
		FileAppend,copy /y "%BUILDIR%\site\*.svg" "%gitroot%\%GITUSER%.github.io\skeletonkey"`n,%BUILDIR%\sitecommit.bat
		FileAppend,copy /y "%BUILDIR%\site\ReadMe.md" "%gitroot%\%GITUSER%.github.io\skeletonkey"`n,%BUILDIR%\sitecommit.bat
		FileAppend,copy /y "%BUILDIR%\site\version.txt" "%gitroot%\%GITUSER%.github.io\skeletonkey"`n,%BUILDIR%\sitecommit.bat
		FileAppend,for /f "delims=" `%`%a in ("%GITAPP%") do set gitapp=`%`%~a`n,%BUILDIR%\sitecommit.bat
		FileAppend,"`%gitapp`%" add skeletonkey`n,%BUILDIR%\sitecommit.bat
		FileAppend,"`%gitapp`%" commit -m siteupdate`n,%BUILDIR%\sitecommit.bat
		if (GITPASS <> "")
			{
				FileAppend,"`%gitapp`%" push -f --repo http://%GITUSER%:%GITPASS%@github.com/%GITUSER%/%GITUSER%.github.io`n,%BUILDIR%\sitecommit.bat
			}
		if (GITPASS = "")
			{
				FileAppend,"`%gitapp`%" push`n,%BUILDIR%\sitecommit.bat
			}
		RunWait, %comspec% cmd /c echo.##################  SITE COMMIT  ######################## >>"%DEPL%\deploy.log", ,%rntp%
		RunWait, %comspec% cmd /c " "%BUILDIR%\sitecommit.bat" "site-commit" >>"%DEPL%\deploy.log"",%BUILDIR%,%rntp%
		RunWait, %comspec% cmd /c echo.########################################## >>"%DEPL%\deploy.log", ,%rntp%
		FileDelete,%BUILDIR%\sitecommit.bat
	}

guicontrol,,progb,100
SB_SetText(" Complete ")
gosub, canclbld
guicontrol,,progb,0

guicontrol,enable,OvrStable
guicontrol,enable,RESDD
guicontrol,enable,ResB
guicontrol,enable,SrcDD
guicontrol,enable,SelDir
guicontrol,enable,PushNotes
guicontrol,enable,VerNum
guicontrol,enable,GitPush
guicontrol,enable,ServerPush
guicontrol,enable,SiteUpdate
guicontrol,enable,DatBld
guicontrol,enable,REPODATS
guicontrol,enable,PortVer
guicontrol,enable,INITINCL
guicontrol,enable,DevlVer
guicontrol,hide,CANCEL
guicontrol,show,COMPILE
guicontrol,,progb,0
compiling= 
return

canclbld:
filemove,%SKELD%\skeletonKey.exe, %SKELD%\skeletonKey.del,1
return

esc::
#IfWinActive _DEV_
FDME:= 8452
quitnum+=1
if (quitnum = 3)
	{
		FDME:= 8196
	}
if (quitnum > 3)
	{
		goto, QUITOUT
	}
sleep,250
if (compiling = 1)
	{
		goto, CANCEL
	}
msgbox,% FDME,Exiting, Would you like to close the publisher?
ifmsgbox, yes
	{
		gosub, QUITOUT
	}
ifmsgbox, no
	{
		DWNCNCL= 
		return
	}
return



SHA1GET:
ApndSHA= % FileSHA1( CrCFLN )
FileSHA1(sFile="", cSz=4) {
 cSz := (cSz<0||cSz>8) ? 2**22 : 2**(18+cSz), VarSetCapacity( Buffer,cSz,0 ) ; 09-Oct-2012
 hFil := DllCall( "CreateFile", Str,sFile,UInt,0x80000000, Int,3,Int,0,Int,3,Int,0,Int,0 )
 IfLess,hFil,1, Return,hFil
 hMod := DllCall( "LoadLibrary", Str,"advapi32.dll" )
 DllCall( "GetFileSizeEx", UInt,hFil, UInt,&Buffer ),    fSz := NumGet( Buffer,0,"Int64" )
 VarSetCapacity( SHA_CTX,136,0 ),  DllCall( "advapi32\A_SHAInit", UInt,&SHA_CTX )
 Loop % ( fSz//cSz + !!Mod( fSz,cSz ) )
   DllCall( "ReadFile", UInt,hFil, UInt,&Buffer, UInt,cSz, UIntP,bytesRead, UInt,0 )
 , DllCall( "advapi32\A_SHAUpdate", UInt,&SHA_CTX, UInt,&Buffer, UInt,bytesRead )
 DllCall( "advapi32\A_SHAFinal", UInt,&SHA_CTX, UInt,&SHA_CTX + 116 )
 DllCall( "CloseHandle", UInt,hFil )
 Loop % StrLen( Hex:="123456789ABCDEF0" ) + 4
  N := NumGet( SHA_CTX,115+A_Index,"Char"), SHA1 .= SubStr(Hex,N>>4,1) SubStr(Hex,N&15,1)
Return SHA1, DllCall( "FreeLibrary", UInt,hMod )
}
StringLower,ApndSHA,ApndSHA
return

QUITOUT:
WinGet, PEFV,PID,_DEV_
Process, close, %PEFV%
GuiEscape:
GuiClose:
ExitApp

getBldTlz:
if (progb = "")
	{
		Progress, 0, , ,Downloading BuildTools
	}	
URLFILE= %BLDTOOLS%
DownloadFile(URLFILE, save, False, True)
sleep, 1200
if (progb = "")
	{
		Progress, off
	}
return

DownloadFile(UrlToFile, _SaveFileAs, Overwrite := True, UseProgressBar := True) {
		FinalSize= 
	
      If (!Overwrite && FileExist(_SaveFileAs))
		  {
			FileSelectFile, _SaveFileAs,S, %_SaveFileAs%
			if !_SaveFileAs 
			  return
		  }

      If (UseProgressBar) {
          
            SaveFileAs := _SaveFileAs
          
            try WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
			catch {
			}
          
            try WebRequest.Open("HEAD", UrlToFile)
            catch {
			}
			try WebRequest.Send()
			catch {
			}
          
			try FinalSize := WebRequest.GetResponseHeader("Content-Length") 
			catch {
				FinalSize := 1
			}
			SetTimer, DownloadFileFunction_UpdateProgressBar, 100
		
 
      }
    
      UrlDownloadToFile, %UrlToFile%, %_SaveFileAs%
    
      If (UseProgressBar) {
          Progress, Off
          SetTimer, DownloadFileFunction_UpdateProgressBar, Off
      }
      return

      DownloadFileFunction_UpdateProgressBar:
    
      try CurrentSize := FileOpen(_SaveFileAs, "r").Length 
	  catch {
			}
			
      try CurrentSizeTick := A_TickCount
    catch {
			}
			
      try Speed := Round((CurrentSize/1024-LastSize/1024)/((CurrentSizeTick-LastSizeTick)/1000)) . " Kb/s"
	  catch {
			}
    
      LastSizeTick := CurrentSizeTick
      try LastSize := FileOpen(_SaveFileAs, "r").Length
    catch {
			}
	
      try PercentDone := Round(CurrentSize/FinalSize*100)
    catch {
			}
			
	 if (PercentDone > 100)
		{
			PercentDone= 
		}
	 SB_SetText(" " Speed " " updtmsg " at " . PercentDone . `% " " CurrentSize " bytes completed")
	if (progb = "")
		{
			Progress, %PercentDone%,,,
		}
	Guicontrol, ,progb, %PercentDone%
      return
  }
Guicontrol, ,progb, 0
if (progb = "")
	{
		Progress, off
	}
return


;};;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
