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
		BUILDIR=
		SKELD=
		AHKDIR=
		DEPL=
		NSIS=
		GITAPP=
		GITD=
		SITEDIR=
		GETIPADR=
		REPOURL=
		UPDTURL=
		GITSRC=
		GITRLS=
		SCITL=
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
ifexist, %A_ProgramFiles%\AutoHotkey\SciTE\SciTE.exe
	{
		npptmp= %A_ProgramFiles%\AutoHotkey\SciTE\SciTE.exe
	}
ifexist, %A_ProgramFilesx86%\AutoHotkey\SciTE\SciTE.exe
	{
		npptmp= %A_ProgramFiles%\AutoHotkey\SciTE\SciTE.exe
	}
iniread,REPOURLX,sets\arcorg.set,GLOBAL,HOSTINGURL
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
	}

READSKOPT:	
Loop, Read, skopt.cfg
	{
		curvl1= 
		curvl2= 
		stringsplit, curvl, A_LoopReadLine,=
		if (curvl1 = "git_username")
				{
					_GITUSER= 
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							GITUSER= %curvl2%
							_GITUSER= %curvl2%
							CONTPARAM1= 1
						}
				}
		if (curvl1 = "git_password")
				{	
					_GITPASS=
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							GITPASS= %curvl2%
							_GITPASS= %curvl2%
							CONTPARAM2= 1
						}
				}
		if (curvl1 = "git_token")
				{
					_GITPAT= 
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							GITPAT= %curvl2%
							_GITPAT= %curvl2%
							CONTPARAM3= 1
						}
				}
		if (curvl1 = "git_app")
				{
					_GITAPP= git.exe
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							GITAPP= %curvl2%
							_GITAPP= %curvl2%
							CONTPARAM4= 1
						}
				}		
		if (curvl1 = "git_rls")
				{
					_GITRLS= github-release.exe
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							GITRLS= %curvl2%
							_GITRLS= %curvl2%
							CONTPARAM5= 1
						}
				}
		if (curvl1 = "NSIS")
				{
					_NSIS= makensis.exe
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							NSIS= %curvl2%
							_NSIS= %curvl2%
							CONTPARAM6= 1
						}
				}
		if (curvl1 = "Compiler_Directory")
			{
				_AHKDIR= Ahk2Exe.exe
				if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
					{
						AHKDIR= %curvl2%
						_AHKDIR= %curvl2%
						CONTPARAM7= 1
					}
			}
		if (curvl1 = "Git_Root")
				{
					_GITROOT= Github-Projects-Directory
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							GITROOT= %curvl2%
							_GITROOT= %curvl2%
							CONTPARAM8= 1
						}
				}
		if (curvl1 = "Source_Directory")
			{
				_SKELD= Source-Directory
				if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
					{
						SKELD= %curvl2%
						_SKELD= %curvl2%
						CONTPARAM9= 1
					}
			}
		if (curvl1 = "Project_Directory")
					{
						_GITD= Github-Skeletonkey-Directory
						if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
							{
								GITD= %curvl2%
								_GITD= %curvl2%
								CONTPARAM10= 1
							}
					}
		if (curvl1 = "Site_Directory")
					{
						_SITEDIR= Github-Site-Directory
						if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
							{
								SITEDIR= %curvl2%
								_SITEDIR= %curvl2%
								CONTPARAM11= 1
							}
					}
		if (curvl1 = "Deployment_Directory")
			{
				_DEPL= Deployment-Directory
				if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
					{
						DEPL= %curvl2%
						_DEPL= %curvl2%
						CONTPARAM12= 1
					}
			}
		if (curvl1 = "update_url")
				{
					_UPDTURL= http://raw.githubusercontent.com/romjacket/skeletonkey/master/version.txt
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							UPDTURL= %curvl2%
							_UPDTURL= %curvl2%
							CONTPARAM13= 1
						}
				}
		if (curvl1 = "update_file")
				{
					_UPDTFILE= https://github.com/romjacket/skeletonKey/releases/download/portable/skeletonKey-portable.zip
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							UPDTFILE= %curvl2%
							_UPDTFILE= %curvl2%
							CONTPARAM14= 1
						}
				}
		if (curvl1 = "net_ip")
				{
					_GETIPADR= http://www.netikus.net/show_ip.html
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							GETIPADR= %curvl2%
							_GETIPADR= %curvl2%
							CONTPARAM15= 1
						}
				}
		if (curvl1 = "repository_url")
				{
					_REPOURL= http://github.com/romjacket
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							REPOURL= %curvl2%
							_REPOURL= %curvl2%
							CONTPARAM16= 1
						}
				}
		if (curvl1 = "Build_Directory")
			{
				_BUILDIR= Build-Directory
				if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
					{
						BUILDIR= %curvl2%
						_BUILDIR= %curvl2%
						CONTPARAM17= 1
					}
			}
		if (curvl1 = "git_url")
				{
					_GITSRC= http://github.com/romjacket/skeletonkey
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							GITSRC= %curvl2%
							_GITSRC= %curvl2%
							CONTPARAM18= 1
						}
				}
		if (curvl1 = "SciTE4AutoHotkey")
				{
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							SCITL= %curvl2%
						}
				}
	}
initchk= 

;{;;;;;;;;;;;;;;;;;;;  INITIALIZATION MENU ;;;;;;;;;;;;;;;;;;;;;;;;;;
Loop,18
	{
		vinit= % CONTPARAM%A_Index%
		if (vinit = "")
			{
				initchk= 1
				break
			}
	}
if (initchk = 1)
	{
		Gui,Font,Bold
		Gui Add, GroupBox, x11 y1 w370 h406, Deployment Tool Setup
		Gui,Font,normal
		Gui Add, Text, x20 y20 w29 h14 , login:
		Gui Add, Text, x287 y25 w88 h14 , (github username)
		Gui Add, Edit, x51 y18 w234 h21 vILogin gILogin, %_GITUSER%
		Gui Add, Text, x18 y45 w29 h14 , pass:
		Gui Add, Edit, x51 y41 w171 h21 vIPass gIPass password, %_GITPASS%
		Gui Add, Text, x18 y68 w29 h14 , token:
		Gui Add, Edit, x51 y64 w295 h21 vIToken gIToken, %_GITPAT%
		Gui Add, Link, x351 y66 w10 h19, <a href="https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line#creating-a-token">?</a>

		Gui Add, Button, x16 y88 w13 h17 vDwnGit gDwnGit, V
		Gui Add, Text, x32 y90 w323 h14 vTxtGit, %_GITAPP%
		Gui Add, Button, x355 y87 w20 h19 vSelGit gSelGit, F
		Gui Add, Text, x14 y106 w363 h2 +0x10

		Gui Add, Button, x16 y109 w13 h17 vDwnRls gDwnRls, V
		Gui Add, Text, x32 y112 w324 h14 vTxtRls, %_GITRLS%
		Gui Add, Button, x355 y108 w20 h19 vSelRls gSelRls, F
		Gui Add, Text, x16 y128 w363 h2 +0x10

		Gui Add, Button, x16 y130 w13 h17 vDwnNSIS gDwnNSIS, V
		Gui Add, Text, x32 y134 w323 h14 vTxtNSIS, %_NSIS%
		Gui Add, Button, x355 y130 w20 h19 vSelNSIS gSelNSIS, F
		Gui Add, Text, x16 y150 w363 h2 +0x10

		Gui Add, Button, x16 y152 w13 h17 vDwnAHK gDwnAHK, V
		Gui Add, Text, x32 y155 w323 h14 vTxtAHK, %AHKDIR%\Ahk2Exe.exe
		Gui Add, Button, x355 y152 w20 h19 vSelAHK gSelAHK, F
		Gui Add, Text, x16 y170 w363 h2 +0x10

		Gui Add, Text, x23 y197 w322 h14  vTxtBLD, %_BUILDIR%
		Gui Add, Button, x353 y193 w23 h23 vSelBLD gSelBLD, ...
		Gui Add, Text, x16 y191 w363 h2 +0x10

		Gui Add, Text, x23 y175 w322 h14 vTxtGPD, %_GITROOT%
		Gui Add, Button, x353 y170 w23 h23 vSelGPD gSelGPD, ...
		Gui Add, Text, x16 y216 w363 h2 +0x10

		Gui Add, Button, x16 y218 w13 h17 vDwnPULL gPULLSKEL, C
		Gui Add, Text, x37 y221 w307 h14 vTxtGSD, %_GITD%
		Gui Add, Button, x353 y216 w23 h23 vSelGSD gSelGSD, ...
		Gui Add, Text, x16 y239 w363 h2 +0x10

		Gui Add, Button, x16 y241 w13 h17 vDwnIO gPULLIO, C
		Gui Add, Text, x37 y243 w307 h14 vTxtGWD, %_SITEDIR%
		Gui Add, Button, x353 y239 w23 h23 vSelGWD gSelGWD, ...
		Gui Add, Text, x16 y262 w363 h2 +0x10

		Gui Add, Text, x23 y267 w322 h14 vTxtDPL, %_DEPL%
		Gui Add, Button, x353 y262 w23 h23 vSelDPL gSelDPL, ...
		Gui Add, Text, x16 y284 w363 h2 +0x10

		Gui Add, Text, x23 y290 w322 h14 vTxtSRC, %_SKELD%
		Gui Add, Button, x353 y285 w23 h23 vSelSRC gSelSRC, ...

		Gui Add, Edit, x30 y310 w326 h21 vUVER gUVER, %_UPDTURL%
		Gui Add, Edit, x30 y333 w326 h21 vUFLU gUFLU, %_UPDTFILE%
		Gui Add, Edit, x30 y357 w326 h21 vIURL gIURL, %_GETIPADR%
		Gui Add, Edit, x30 y380 w326 h21 vIREPO gIREPO, %_REPOURL%
		Gui Add, Button, x10 y409 w51 h19 vIReset gIReset, reset_all
		Gui Add, Button, x331 y409 w51 h19 vSelDXB gSelDXB, detect
		Gui Add, Button, x159 y411 w80 h23 vICONTINUE gICONTINUE, CONTINUE
		Gui Add, StatusBar,, Status Bar
		Gui Show, w391 h462, _DEPLSETUP_
		return	
	}
;};;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INITCOMPLETE:
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
initchk= 	
FileReadLine,initchk,skopt.cfg,19
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
Gui, Add, DropDownList, x8 y2 w100 vSRCDD gSrcDD, Project||Git.exe|github-release|Source|Compiler|Site|Deployment|Build|NSIS|SciTE4AutoHotkey
Gui, Add, Button, x109 y2 w52 h21 vSELDIR gSelDir, Select
Gui, Add, Button, x109 y26 w52 h21 vRESGET gRESGET, Clone
Gui Add, DropDownList,x331 y2 w92 vResDD gResDD, All||Dev-Build|Portable-Build|Stable-Build|Deployer|Update-URL|Update-File|Repo-URL|Internet-IP-URL|Git-User|Git-Password|Git-Token|Git-URL
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
		return
	}
ifmsgbox,Cancel
	{
		return
	}
GITAV= GIT_%ARCH%
GITRV= Git_Release_%ARCH%
BLDITEMS=%GITAV%|%GITRV%|SciTE4AutoHotkey|AutoHotkey|NSIS
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
		if (A_LoopField = "SciTE4AutoHotkey")
			{
				gosub, DwnSCI
			}
	}
return	
	
SelDir:
gui,submit,nohide
if (SRCDD = "Git-User")
	{
		gosub, GetGUSR
		if (GITUSER = "")
			{
				GITUSER= %A_Username%
			}
	}
if (GITPAT = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
	{
		msgbox,1,,Git Personal Access Token must be set to deploy executables.,5
		gosub, GetGPAC
	}
if (SRCDD = "Source")
	{
		skeltmp= %A_ScriptDir%
		gosub, GetSrc
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
if (SRCDD = "GitRoot")
	{
		gitrttmp= %A_MyDocuments%
		gosub, GitRoot
	}
if (SRCDD = "Site")
	{
		STLOCtmp= %GITROOT%
		gosub, GetSiteDir
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
if (SRCDD = "Project")
	{
		gittmp= %A_MyDocuments%
		ifexist, %GITROOT%\skeletonKey
			{
				gittmp= %GITROOT%\skeletonKey
			}
		gosub, GetGit
	}
if (SRCDD = "SciTE4AutoHotkey")
	{
		scitmp= %A_MyDocuments%
		gosub, GetSCI
	}
if (SRCDD = "Deployment")
	{
		depltmp= %GITROOT%
		gosub, GetDepl
	}
if (SRCDD = "github-release")
	{
		splitpath,gitapp,,gitrlstmp
		gosub, GetRls
	}
if (SRCDD = "Build")
	{
		gosub, GetBld
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

SelGPD:
gui,submit,nohide
GitRoot:
CONTPARAM8= 
gitrttmp= %A_MyDocuments%\GitHub
FileSelectFolder, GITROOTT,*%gitrttmp% ,1,Select The GitHub Root Directory (contains all projects)
if (GITROOTT = "")
	{
		inidelete,skopt.cfg,GLOBAL,Git_Root
		guicontrol,,txtGPD, Github-Projects-Directory
		CONTPARAM8=
		return
	}
GITROOT:= GITROOTT
splitpath,GITROOTT,GITROOTTFN
ifnotinstring,GITROOTTFN,GitHub
	{
		Loop, %GITROOTT%\*,2
			{
				ifinstring,A_LoopFilename,GitHub
					{
						GITROOTT= %A_LoopFileFullPath%
						GITROOT:= GITROOTT
						iniwrite, %GITROOT%,skopt.cfg,GLOBAL,Git_Root
						SB_SetText("Github dir is " GITROOT " ")
						CONTPARAM8= 1
						guicontrol,,txtGPD,%GITROOT%
						return
					}
			}
		Msgbox,3,Github Directory not found,A ''github'' directory was not found.`nWould you like to create it?
		ifmsgbox,Yes
			{
				filecreatedir, %GITROOTT%\GitHub
				if (ERRORLEVEL = 0)
					{
						GITROOTT= %GITROOTT%\GitHub
						GITROOT:= GITROOTT
					}
			}
		iniwrite, %GITROOT%,skopt.cfg,GLOBAL,Git_Root
		SB_SetText("Github dir is " GITROOT " ")
		CONTPARAM8= 1
		guicontrol,,txtGPD,%GITROOT%
		return			
	}
CONTPARAM8= 1
guicontrol,,txtGPD,%GITROOT%
iniwrite, %GITROOT%,skopt.cfg,GLOBAL,Git_Root
SB_SetText("Github dir is " GITROOT " ")
return

INITINCL:
INITINCL= 1
return

IReset:
gui,submit,nohide
guicontrol,,txtGIT,	git.exe
guicontrol,,ilogin,	
guicontrol,,ipass,	
guicontrol,,itoken,	
guicontrol,,txtrls,	github-release.exe
guicontrol,,txtnsis, makensis.exe
guicontrol,,txtahk,	Ahk2Exe.exe
guicontrol,,txtgpd,	Github-Projects-Directory
guicontrol,,txtgsd,	Github-Skeletonkey-Directory
guicontrol,,txtgwd,	Github-Site-Directory
guicontrol,,txtsrc,	Source-Directory
guicontrol,,txtbld,	Build-Directory
guicontrol,,txtdpl,	Deployment-Directory
guicontrol,,uver, http://raw.githubusercontent.com/romjacket/skeletonkey/master/version.txt
guicontrol,,iurl,http://www.netikus.net/show_ip.html
guicontrol,,uflu, https://github.com/romjacket/skeletonKey/releases/download/portable/skeletonKey-portable.zip
guicontrol,,irepo, https://github.com/romjacket
Loop,16
	{
		CONTPARAM%A_Index%= 
	}
CONTPARAM13= 1
CONTPARAM14= 1
CONTPARAM15= 1
CONTPARAM16= 1
filedelete,skopt.cfg
return
	

ICONTINUE:
nocont= 
stv= 
if (CONTPARAM13 = "")
	{
		guicontrolget,UVER,,UVER
		iniwrite,%UVER%,skopt.cfg,GLOBAL,update_url
		CONTPARAM13= 1
	}
if (CONTPARAM14 = "")
	{
		guicontrolget,UFLU,,UFLU
		CONTPARAM14= 1
		iniwrite,%UFLU%,skopt.cfg,GLOBAL,update_file
	}
if (CONTPARAM15 = "")
	{
		guicontrolget,IURL,,IURL
		iniwrite,%IURL%,skopt.cfg,GLOBAL,net_ip
		CONTPARAM15= 1
	}
if (CONTPARAM16 = "")
	{
		guicontrolget,IREPO,,IREPO
		IniWrite,%IREPO%,skopt.cfg,GLOBAL,repository_url
		CONTPARAM16= 1
	}
Loop,18
	{
		stv= % CONTPARAM%A_Index%
		if (stv = "")
			{
				nocont= 1
			}
	}
if (nocont = 1)
	{
		if (CONTPARAM1 = "")
			{
				SB_SetText("github user not defined")
				return
			}
		if (CONTPARAM2 = "")
			{
				SB_SetText("password not defined")
				return
			}
		if (CONTPARAM3 = "")
			{
				SB_SetText("token not defined")
				return
			}
		if (CONTPARAM4 = "")
			{
				SB_SetText("git.exe not defined")
				return
			}
		if (CONTPARAM5 = "")
			{
				SB_SetText("github-release.exe not defined")
				return
			}
		if (CONTPARAM6 = "")
			{
				SB_SetText("makensis.exe not defined")
				return
			}
		if (CONTPARAM7 = "")
			{
				SB_SetText("Ahk2exe.exe not defined")
				return
			}
		if (CONTPARAM8 = "")
			{
				SB_SetText("github projects directory not defined")
				return
			}
		if (CONTPARAM9 = "")
			{
				SB_SetText("source directory not defined")
				return
			}
		if (CONTPARAM10 = "")
			{
				SB_SetText("github skeletonkey project not defined")
				return
			}
		if (CONTPARAM11 = "")
			{
				SB_SetText("website directory not defined")
				return
			}
		if (CONTPARAM12 = "")
			{
				SB_SetText("deployment directory not defined")
				return
			}
		if (CONTPARAM17 = "")
			{
				SB_SetText("Build Directory not defined")
				return
			}
		if (CONTPARAM18 = "")
			{
				SB_SetText("github skeletonkey project not defined")
				return
			}
	}
Gui,Destroy
goto, INITCOMPLETE

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


IURL:
gui,submit,nohide
guicontrolget,IURL,,IURL
SB_SetText("Enter the url of the file which contains your internet ip-address")
if (IRUL = "")
	{
		IURL= http://www.netikus.net/show_ip.html
	}
CONTPARAM15= 1
guicontrol,,IURL,%IURL%
iniwrite,%IURL%,skopt.cfg,GLOBAL,net_ip
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

UFLU:
gui,submit,nohide
guicontrolget,UFLU,,UFLU
if (UFLU = "")
	{
		UFLU= https://github.com/%gituser%/skeletonKey/releases/download/portable/skeletonKey-portable.zip
	}
if ((GITROOT = "")or(GITUSER = "")or(GITPASS = "")or(GITPAT = ""))
		{
			UFLU= https://github.com/romjacket/skeletonKey/releases/download/portable/skeletonKey-portable.zip			
		}
guicontrol,,UFLU,%UFLU%
CONTPARAM14= 1
iniwrite,%UFLU%,skopt.cfg,GLOBAL,update_file
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

IREPO:
gui,submit,nohide
guicontrolget,IREPO,,IREPO
iniread,IREPO,sets\arcorg.set,GLOBAL,HOSTINGURL
if (IREPO = "")
	{
		IREPO= https://github.com/%gituser%
	}
if (GITUSER = "")
	{
		IREPO= https://github.com/romjacket
	}
guicontrol,,IREPO,%IREPO%
CONTPARAM16= 1
IniWrite,%IREPO%,skopt.cfg,GLOBAL,repository_url
return

RepoUrl:
gui,submit,nohide
REPOURL= 
UPDTFILE= http://github.com/%GITUSER%/skeletonKey/releases/download/nodats
if (REPORURLT = "")
	{
		iniread,REPOURLT,sets\arcorg.set,GLOBAL,HOSTINGURL
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


GetUpdate:
UPDTURLT=,http://raw.githubusercontent.com/%GITUSER%/skeletonkey/master/version.txt
UPDTURL=
InputBox,UPDTURL,Update URL,If you wish to deploy updates from your own repository`nEnter the http address of the update file`nusually where ''version.txt'' can be found,0,,,,,,,%UPDTURLT%
		if (UPDTURL = "")
				{
					UPDTURL= http://raw.githubusercontent.com/romjacket/skeletonkey/master/version.txt
				}
return

UVER:
gui,submit,nohide
guicontrolget,UVER,,UVER
if (UVER = "")
	{
		UVER= http://raw.githubusercontent.com/%GITUSER%/skeletonkey/master/version.txt
	}
if ((GITROOT = "")or(GITUSER = "")or(GITPASS = "")or(GITPAT = ""))
	{
		UVER= http://raw.githubusercontent.com/romjacket/skeletonkey/master/version.txt
	}
guicontrol,,UVER,%UVER%
CONTPARAM13= 1
iniwrite,%UVER%,skopt.cfg,GLOBAL,update_url
return

SelGWD:
GetSiteDir:
gui,submit,nohide
SB_SetText("Usually ..\ " gitroot "\" gituser ".github.io")
CONTPARAM11= 
if (GITROOT = "")
	{
		SB_SetText("GitHub Projects Directory not defined.")
		guicontrol,,txtGWD,Github-Site-Directory (..\GitHub\%gituser%.github.io)
		return
	}
STLOC=
STLOCT=
STLOCtmp= %GITROOT%
FileSelectFolder, STLOCT,%STLOCtmp%,1,Select The WebSite Root Directory.
if (STLOCT = "")
	{
		guicontrol,,txtGWD,Github-Site-Directory
		CONTPARAM11= 
		inidelete,skopt.cfg,GLOBAL,Site_Directory
		return
	}
STLOCtmp= 
STLOC:= STLOCT
splitpath,STLOC,STLOCn
webdx= 
ifnotinstring,STLOCn,.github.io
	{
		ifexist,%STLOC%\%gituser%.github.io\
			{
				STLOC= %STLOC%\%gituser%.github.io
				webdx= 1
			}
	}
gitspx= %gituser%.github.io	
Loop,%STLOC%\*,2
	{
		if (A_LoopField = "skeletonkey")
			{
				webdx= 1
			}
		if (A_LoopField = gitspx)
			{
				STLOC= %GITROOT%\%gitspx%
				webdx= 1
			}
	}
if (webdx = "")
	{
		gosub, PULLIO
	}
ifnotexist, %STLOC%\skeletonkey\
	{
		guicontrol,,txtGWD,
		CONTPARAM11= 
		inidelete,skopt.cfg,GLOBAL,Site_Directory
		return
	}
SITEDIR= %STLOC%	
iniwrite, %SITEDIR%,skopt.cfg,GLOBAL,Site_Directory
SITEDIR= %GITROOT%\%gituser%.github.io
CONTPARAM11= 1
RunWait, %comspec% cmd /c "%gitapp%" init,%gitroot%\%GITUSER%.github.io,hide
RunWait,%comspec% cmd /c "bin\curl.exe" -k -u %gituser%:%gitpass% https://api.github.com/user/repos -d "{\"name\":\"%gituser%.github.io\"}",,hide
guicontrol,,txtGWD,%SITEDIR%
CONTPARAM11= 1
return


SelDPL:
gui,submit,nohide
SB_SetText("The directory in which binaries are compiled token.")
GetDepl:
CONTPARAM12= 
DEPL=
depltmp= %GITROOT%\skeletonkey.deploy
ifnotexist, %depltmp%
	{
		depltmp= 
	}
FileSelectFolder, DEPLT,*%depltmp% ,1,Select The Deployment Directory
if (DEPLT = "")
	{
		guicontrol,,txtDPL,
		CONTPARAM12=
		inidelete,skopt.cfg,GLOBAL,Deployment_Directory
		return
	}
Loop, %DEPLT%\*,2
	{
		ifinstring,A_LoopFileName,skeletonkey.deploy
			{
				DEPLT= %A_LoopFileFullPath%
				DEPL= %DEPLT%
				iniwrite,%DEPL%,skopt.cfg,GLOBAL,Deployment_Directory
				CONTPARAM12= 1
				guicontrol,,txtDPL,%DEPL%
				return
			}
	}
DEPL= %DEPLT%
splitpath,DEPLT,depln
if (DEPLN <> "skeletonkey.deploy")
	{
		DEPL= %DEPLT%\skeletonkey.deploy
	}
filecreatedir,%DEPL%
ifnotexist,%DEPL%\
	{
		inidelete,skopt.cfg,GLOBAL,Deployment_Directory
		guicontrol,,txtDPL,Deployment-Directory
		CONTPARAM12= 
		return
	}
iniwrite,%DEPL%,skopt.cfg,GLOBAL,Deployment_Directory
CONTPARAM12= 1
guicontrol,,txtDPL,%DEPL%
return

SelAHK:
gui,submit,nohide
GetComp:
CONTPARAM7= 
ifexist, %A_MyDocuments%\AutoHotkey\Compiler\
	{
		comptmp= %A_MyDocuments%\AutoHotkey\Compiler
	}
ifexist, %a_programfiles%\AutoHotkey\Compiler\
	{
		comptmp= %a_programfiles%\AutoHotkey\Compiler
	}
FileSelectFile, AHKDIT,3,%comptmp%\Ahk2Exe.exe,Select AHK2Exe,*.exe
if (AHKDIT = "")
	{
		guicontrol,,txtAHK,
		CONTPARAM7= 
		inidelete,skopt.cfg,GLOBAL,Compiler_Directory
		return
	}
splitpath,AHKDIT,,AHKDIR
CONTPARAM7= 1
iniwrite, %AHKDIR%,skopt.cfg,GLOBAL,Compiler_Directory
guicontrol,,txtAHK,%AHKDIR%\Ahk2Exe.exe
return

SelBld:
gui,submit,nohide
CONTPARAM17= 
FileSelectFolder, BUILDT,*%A_ScriptDir% ,1,Select The BUILD Directory
if (BUILDT = "")
	{
		CONTPARAM17= 
		guicontrol,,txtBld,Build-Directory
		inidelete,skopt.cfg,GLOBAL,BUILD_Directory
		return
	}
splitpath,BUILDT,BUILDTFN
BUILDIR:= BUILDT
CONTPARAM17= 1
guicontrol,,txtBLD,%BUILDIR%
iniwrite, %BUILDIR%,skopt.cfg,GLOBAL,BUILD_Directory
if (SKELD = GITD)
	{
		SB_SetText(It is recommended to keep your BUILD and github directories separate)
	}
return

SelSRC:
gui,submit,nohide
SB_SetText("Usually the current directory")
CONTPARAM9= 
GetSrc:
FileSelectFolder, SKELT,*%A_ScriptDir% ,1,Select The Source Directory
if (SKELT = "")
	{
		CONTPARAM9= 
		guicontrol,,txtBLD
		inidelete,skopt.cfg,GLOBAL,Source_Directory
		return
	}
splitpath,SKELT,SKELTFN
if (SKELTFN = "skeletonkey")
	{
		skelexists= 1
	}
Loop, %SKELT%\working.ahk
	{
		skelexists= 1
	}
if (skelexists = 1)
	{
		SKELD:= SKELT
		CONTPARAM9= 1
		guicontrol,,txtSRC,%SKELD%
		iniwrite, %SKELD%,skopt.cfg,GLOBAL,Source_Directory
		if (SKELD = GITD)
			{
				SB_SetText(It is recommended to keep your source and github directories separate)
			}
		if (BUILDIR = "")
			{
				BUILDIR= %SKELD%
				guicontrol,,txtBLD,%SKELD%
				CONTPARAM17= 1
			}
		return
	}	
Msgbox,3,Not-Found,Skeletonkey was not found.`nRetry?
ifmsgbox,Yes
	{
		goto,SelSRC
	}
CONTPARAM9= 
guicontrol,,txtSRC
inidelete,skopt.cfg,GLOBAL,Source_Directory
CONTPARAM9= 
return

DwnRls:
gui,submit,nohide
CONTPARAM5= 
iniread,GRLURL,sets\BuildTools.set,BUILDENV,Github_Release_%ARCH%
splitpath,GRLURL,grlfn
grlsv= %cacheloc%\%grlfn%
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
		ifnotexist,%grlsv%
			{
				Msgbox,3,Not Found,%grlsv% not found.`nRETRY?
				ifmsgbox,Yes
					{
						goto,DwnRls
					}
			}
		return
	}
ifnotexist, %grlsv%
	{
		inidelete,skopt.cfg,GLOBAL,git_rls
		CONTPARAM5= 
		return
	}
GRLK=
GRLL=
grltmp= %GITAPPD%
FileselectFolder,GRLL,*%grltmp%,0,Location to extract Github-release.exe
GRLLSEL:
if (GRLL = "")
	{
		inidelete,skopt.cfg,GLOBAL,git_rls
		CONTPARAM5= 
		guicontrol,,TxtGit,
		return
	}
Runwait, "bin\7za.exe" x -y "%grlsv%" -O"%GRLL%",,%rntp%
GITRLS= %GRLL%\github-release.exe
iniwrite, %GITRLS%,skopt.cfg,GLOBAL,git_rls
CONTPARAM5= 1
SB_SetText(" Github-release is " GITRLS "")
return


SelRls:
gui,submit,nohide
CONTPARAM5= 
GetRls:
GITRLST=
grltmp= %GITAPPD%
FileSelectFile,GITRLST,3,%grltmp%\github-release.exe,Select github-release,*.exe
GITRLST:
if (GITRLST = "")
	{
		grltmp= 
		guicontrol,,TxtGit,
		CONTPARAM5= 
		return
	}
GITRLS= %GITRLST%
iniwrite, %GITRLS%,skopt.cfg,GLOBAL,git_rls
CONTPARAM5= 1
SB_SetText(" Github Release is " GITRLS "")
return


SelNSIS:
gui,submit,nohide
CONTPARAM6= 
ifexist, %A_MyDocuments%\NSIS
	{
		nsisapdtmp= %A_MyDocuments%\NSIS
	}
ifexist, %A_programfiles%\NSIS
	{
		nsisapdtmp= %A_programfiles%\NSIS
	}
ifnotexist, %nsisapdtmp%
	{
		nsisapdtmp= 
	}
FileSelectFile, NSIST,3,%nsisapdtmp%\makensis.exe,Select the makensis.exe,*.exe
nsisapptmp= 
if (NSIST = "")
	{
		CONTPARAM6= 
		guicontrol,,txtNSIS,
		inidelete,skopt.cfg,GLOBAL,NSIS
		return
	}
NSIS= %NSIST%
splitpath, NSIS,,nsisappd
iniwrite, %NSIS%,skopt.cfg,GLOBAL,NSIS
guicontrol,,txtNSIS,%NSIS%
CONTPARAM6= 1
return


SelGit:
gui,submit,nohide
GetAPP:
CONTPARAM4= 
ifexist, %a_programfiles%\git\bin\git.exe
	{
		gitapdtmp= %a_programfiles%\git\bin\git.exe
	}
ifexist, %A_MyDocuments%\Git\bin
	{
		gitapdtmp= %A_MyDocuments%\Git\Bin
	}
FileSelectFile, GITAPPT,3,%gitapdtmp%\git.exe,Select the git.exe,*.exe
gitapptmp= 
if (GITAPPT = "")
	{
		inidelete,skopt.cfg,GLOBAL,git_app
		return
	}
GITAPP= %GITAPPT%
CONTPARAM4= 1
splitpath, gitapp,,gitappd
iniwrite, %GITAPP%,skopt.cfg,GLOBAL,git_app
guicontrol,,txtGIT,%GITAPP%
return


IToken:
gui,submit,nohide
guicontrolget,GITPAT,,IToken
CONTPARAM3= 
if (GITPAT <> "")
	{
		CONTPARAM3= 1
		iniwrite, %GITPAT%,skopt.cfg,GLOBAL,git_token
		return
	}
inidelete,skopt.cfg,GLOBAL,git_token
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


IPass:
gui,submit,nohide
guicontrolget,GITPASS,,IPass
CONTPARAM2= 
if (GITPASS <> "")
	{
		CONTPARAM2= 1
		iniwrite, %GITPASS%,skopt.cfg,GLOBAL,Git_password
		return
	}
inidelete,skopt.cfg,GLOBAL,Git_password
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

ILogin:
gui,submit,nohide
guicontrolget,GITUSER,,ILogin
CONTPARAM1= 
if (GITUSER = "")
	{
		SB_SetText("You must enter a username to continue")
		inidelete,skopt.cfg,GLOBAL,Git_username
		return
	}
CONTPARAM1= 1
iniwrite, %GITUSER%,skopt.cfg,GLOBAL,Git_username	
guicontrol,,uVer,http://raw.githubusercontent.com/%gituser%/skeletonkey/master/version.txt
CONTPARAM13= 1
iniwrite,%uVer%,skopt.cfg,GLOBAL,update_url
guicontrol,,uFLU,https://github.com/%gituser%/skeletonKey/releases/download/portable/skeletonKey-portable.zip
CONTPARAM14= 1
iniwrite,%uFLU%,skopt.cfg,GLOBAL,update_file
guicontrol,,iRepo,https://github.com/%gituser%
CONTPARAM16= 1
iniwrite,%irepo%,skopt.cfg,GLOBAL,repository_url
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


SelGSD:
gui,submit,nohide
CONTPARAM10= 
CONTPARAM18= 
gittmp= %gitroot%\skeletonkey
if (GITUSER = "")
	{
		SB_SetText("username is not defined")
		return
	}
if (GITPASS = "")
	{
		SB_SetText("password is not defined")
		return
	}
if (BUILDIR = "")
	{
		SB_SetText("Build-directory is not defined")
		return
	}
if (GITAPP = "")
	{
		SB_SetText("Git.exe is not defined")
		return
	}
if (GITROOT = "")
	{
		SB_SetText("Github-projects-directory is not defined")
		return
	}
GetGit:
GITT= 
ifnotexist, %gittmp%
	{
		gittmp= 
	}
FileSelectFolder,GITT,*%gittmp%,1,Select The Git skeletonKey Project Directory.
if (GITT = "")
	{
		return
	}
Loop, %GITT%\*,2
	{
		if (A_LoopFileName = "skeletonKey")
			{
				GITT= %A_LoopFileFullPath%
				break
			}
	}	
splitpath,gitt,gittn
if (gittn <> "skeletonKey")
	{
		SB_SetText("Github SkeletonKey directory not found")
		CONTPARAM10= 
		CONTPARAM18= 
		return
	}
if ((GITT = BUILDIR)or(GITT = SKELD))
	{
		SB_SetText("Github SkeletonKey project directory should not be your source or build directories")
	}
GITD:= GITT
GITSRC= http://github.com/%gituser%/skeletonkey
iniwrite, %GITD%,skopt.cfg,GLOBAL,Project_Directory
IniWrite,%GitSRC%,skopt.cfg,GLOBAL,git_url
CONTPARAM10= 1
CONTPARAM18= 1
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
guicontrol,,txtGSD,%GITD%	
return

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
if (SRCDD = "SciTE4AutoHotkey")
	{
		goto, DwnSCI
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
gui,submit,nohide
av= 
if (gitapp = "")
	{
		SB_SetText("git.exe is not located")
		return
	}
if (SKELD = "")
	{
		SB_SetText("Source Directory is not defined")
		return
	}
if (gituser = "")
	{
		SB_SetText("username is not defined")
		return
	}
if (gitpass = "")
	{
		SB_SetText("password is not defined")
		return
	}
if (gitroot = "")
	{
		SB_SetText("github project directory is not defined")
		return
	}
SB_SetText("Cloning skeletonkey")
Runwait, "%gitapp%" clone http://github.com/%GITUSER%/skeletonKey,%GITROOT%
Loop, %GITROOT%\skeletonKey\*.*
	{
		av+=1
		break
	}
if (av = "")
	{
		CONTPARAM10= 
		CONTPARAM18= 
		FileSetAttrib, -h,.git
		FileRemoveDir,%GITROOT%\skeletonkey,1
		Msgbox,3,SetUp Github Project,Would you like to clone romjacket's skeletonkey?
		ifmsgbox,yes
			{
				Runwait, "%gitapp%" clone http://github.com/romjacket/skeletonkey,%GITROOT%					
			}
		ifmsgbox,no
			{
				Msgbox,3,SetUp Github Project,Would you like to copy the build directory to your github projects?
				ifmsgbox,Yes
					{
						FileCopyDir,%SKELD%,%GITROOT%\skeletonkey,1
					}
				ifmsgbox,No
					{
						guicontrol,,txtGSD,Github-Skeletonkey-Directory
						inidelete,skopt.cfg,GLOBAL,git_src
						inidelete,skopt.cfg,GLOBAL,Project_Directory
						return
					}
			}
	}
ifexist,%GITROOT%\skeletonkey\
	{
		GitSRC= http://github.com/%gituser%/skeletonkey
		GITD= %GITROOT%\skeletonkey
		CONTPARAM10= 1
		CONTPARAM18= 1
		RunWait, %comspec% cmd /c "%gitapp%" init,%gitroot%\skeletonkey,hide
		RunWait,%comspec% cmd /c "bin\curl.exe" -k -u %gituser%:%gitpass% https://api.github.com/user/repos -d "{\"name\":\"skeletonkey\"}",,hide					
		guicontrol,,txtGSD,%GITD%
		IniWrite,%GitSRC%,skopt.cfg,GLOBAL,git_url
		iniwrite, %GITD%,skopt.cfg,GLOBAL,Project_Directory
	}
return	

PULLIO:
av= 
if (gitapp = "")
	{
		SB_SetText("git.exe is not located")
		return
	}
if (SKELD = "")
	{
		SB_SetText("Source Directory is not defined")
		return
	}
if (gituser = "")
	{
		SB_SetText("username is not defined")
		return
	}
if (gitpass = "")
	{
		SB_SetText("password is not defined")
		return
	}
if (gitroot = "")
	{
		SB_SetText("github project directory is not defined")
		return
	}

SB_SetText("Cloning website")	
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
				Msgbox,3,SetUp Github Project,Would you like to clone romjacket's site?
				ifmsgbox,yes
					{
						Runwait, "%gitapp%" clone http://github.com/romjacket/romjacket.github.io,%GITROOT%
						FileCopyDir, %GITROOT%\romjacket.github.io\skeletonkey,%GITROOT%\%GITUSER%.github.io\skeletonkey,1
					}
				ifmsgbox,no
					{
						Msgbox,3,SetUp Github Site,Would you like to copy the source site to your github projects?
						ifmsgbox,Yes
							{
								FileCopyDir,%SKELD%\skeletonkey,%GITROOT%\%gituser%.github.io\skeleotnkey,1
							}
						ifmsgbox,No
							{
								CONTPARAM11= 
								guicontrol,,txtGWD,Github-Site-Directory
								inidelete,skopt.cfg,GLOBAL,site_directory
								return
							}
					}
			}
	}
ifexist,%GITROOT%\%gituser%.github.io\skeletonkey
	{
		SITEDIR= %GITROOT%\%gituser%.github.io
		CONTPARAM11= 1
		RunWait, %comspec% cmd /c "%gitapp%" init,%gitroot%\%GITUSER%.github.io,hide
		RunWait,%comspec% cmd /c "bin\curl.exe" -k -u %gituser%:%gitpass% https://api.github.com/user/repos -d "{\"name\":\"%gituser%.github.io\"}",,hide
		guicontrol,,txtGWD,%SITEDIR%
		iniwrite, %SITEDIR%,skopt.cfg,GLOBAL,Site_Directory
	}	
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

DwnNSIS:
gui,submit,nohide
CONTPARAM6= 
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
ifnotexist, %nsisv%
	{
		gitapdtmp= 
		Msgbox,3,not found,%nsisv% not found.`nRETRY?
		ifmsgbox,yes
			{
				goto, getNSIS
			}
		inidelete,skopt.cfg,GLOBAL,NSIS
		guicontrol,,txtNSIS,makensis.exe
		CONTPARAM6= 
		return
	}
NSISD= 
NSISDT= 
NSIS= 
NSISDT= %A_MyDocuments%
FileSelectFolder, NSIST,*%gitapdtmp%,0,Location to extract the NSIS programs.
if (NSIST = "")
	{
		inidelete,skopt.cfg,GLOBAL,NSIS
		guicontrol,,txtNSIS,
		CONTPARAM6= 
		return
	}
splitpath,NSIST,nsisdfn,nsisdnew
Runwait, "bin\7za.exe" x -y "%nsisv%" -O"%NSISDT%",,%rntp%
NSIS= %NSIST%\makensis.exe
iniwrite, %NSIS%,skopt.cfg,GLOBAL,NSIS
SB_SetText("makensis.exe is " NSIS " ")
guicontrol,,txtNSIS,%NSIS%
CONTPARAM6= 1
return


getSCI:
gui,submit,nohide
SCIRT=
FileSelectFile,SCIRT,3,%scitmp%,Select SciTE,*.exe
if (SCIRT = "")
	{
		return
	}
SCITL= %SCIRT%
iniwrite,%SCITL%,skopt.cfg,GLOBAL,SciTE4AutoHotkey
SB_SetText(" SciTE4AutoHotkey " SCITL "")
return

DwnSCI:
iniread,SCIURL,sets\BuildTools.set,BUILDENV,SciTE4AutoHotkey
splitpath,SCIURL,scifn
scisv= %cacheloc%\%scifn%
ifnotexist,%scisv%
	{
		scitmp= %A_MyDocuments%				
		if (progb = "")
			{
				Progress, 0, , ,Downloading SciTE
			}	
		DownloadFile(SCIURL, scisv, False, True)
		sleep, 1200
		if (progb = "")
			{
				Progress, off
			}
	}
ifnotexist, %scisv%
	{
		scitmp= 
		Msgbox,3,Not Found,%scisv% not found.`nRETRY?
		ifmsgbox,Yes
			{
				gosub,DwnSCI
			}
		return
	}
SCIK=
SCIL=
FileselectFolder,SCITL,*%scitmp%,0,Location to extract SciTE4AutoHotkey
SCILSEL:
if (SCITL = "")
	{
		return
	}
splitpath,SCIL,sciflt
ifnotinstring,sciflt,scite
SCIL.= "\SciTE"
Runwait, bin\7za.exe x -y "%scisv%" -O"%SCIL%",,%rntp%
SCITL= %SCIL%\SciTE.exe
iniwrite,%SCIR%,skopt.cfg,GLOBAL,SciTE4AutoHotKey
SB_SetText(" SciTE4AutoHotkey is " SCITL "")
return


DwnGit:
gui,submit,nohide
GetGITZ:
CONTPARAM4= 
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
		CONTPARAM4= 1
		iniwrite, %GITAPP%,skopt.cfg,GLOBAL,git_app
		return
	}
gitapdtmp= 
Msgbox,3,not found,%gitzsv% not found.`nRETRY?
ifmsgbox,yes
	{
		gosub, getGitz
	}
return


DwnAHK:
gui,submit,nohide
GetAHKZ:
CONTPARAM7= 
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
ifnotexist, %ahksv%
	{
		ahktmp= 
		Msgbox,3,Not Found,%ahksv% not found.`nRETRY?
		ifmsgbox,Yes
			{
				goto,GetAHKZ
			}
		inidelete,skopt.cfg,GLOBAL,Compiler_Directory
		CONTPARARM7= 
		guicontrol,,txtAHK,
		return
	}
AHKDIR= 
ahktmp= %A_MyDocuments%
FileSelectFolder, AHKDIT,*%ahktmp%,0,Location to extract the AutoHotkey Programs.
if (AHKDIT = "")
	{
		inidelete,skopt.cfg,GLOBAL,Compiler_Directory
		CONTPARARM7= 
		guicontrol,,txtAHK,Ahk2Exe.exe
		return
	}
splitpath,ahkdit,ahktstn
Runwait, "bin\7za.exe" x -y "%ahksv%" -O"%AHKDIT%",,%rntp%
AHKDIR= %AHKDIT%\Compiler
iniwrite, %AHKDIR%,skopt.cfg,GLOBAL,Compiler_Directory
CONTPARAM7= 1
SB_SetText("AutoHotkey Compiler Directory is " AHKDIR " ")
guicontrol,,txtAHK,%AHKDIR%\Ahk2Exe.exe
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
	
if (SRCDD = "SciTE4AutoHotkey")
	{
		SB_SetText(" " SCITE " ")
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
if (RESDD = "Internet-IP-URL")
	{
		SB_SetText(" " GETIPADR " ")
	}
if (RESDD = "Git-Password")
	{
		SB_SetText(" ********* ")
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
if (RESDD = "Repo-URL")
	{
		iniread,REPOURL,sets\arcorg.set,GLOBAL,HOSTINGURL
		Gosub, RepoURL
	}
if (RESDD = "Internet-IP-URL")
	{
		GETIPADRT= %GETIPADR%
		Gosub, GetIpAddr
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
		FileAppend, copy /y "site\index.html" "%GITD%\site"`n,%SKELD%\!gitupdate.cmd
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
		guicontrol,,progb,90
		StringReplace,skelhtml,skelhtml,[RSHA1],%ApndSHA%,All
		StringReplace,skelhtml,skelhtml,[WEBURL],http://%GITUSER%.github.io/skeletonkey,All
		StringReplace,skelhtml,skelhtml,[PAYPAL],%donation%
		StringReplace,skelhtml,skelhtml,[GITSRC],%GITSRC%,All
		StringReplace,skelhtml,skelhtml,[REVISION],http://github.com/%gituser%/skeletonKey/releases/download/Installer/Installer.zip,All
		StringReplace,skelhtml,skelhtml,[PORTABLE],https://github.com/%gituser%/skeletonKey/releases/download/portable/skeletonKey-portable.zip,All
		
		StringReplace,skelhtml,skelhtml,[GITUSER],%gituser%,All
		StringReplace,skelhtml,skelhtml,[RELEASEPG],https://github.com/%gituser%/skeletonKey/releases,All
		StringReplace,skelhtml,skelhtml,[DATFILES],https://github.com/%gituser%/skeletonKey/releases/download/DATFILES/DATFILES.7z,All
		
		StringReplace,skelhtml,skelhtml,[RDATE],%RDATE%,All
		StringReplace,skelhtml,skelhtml,[RSIZE],%dvms%,All
		StringReplace,skelhtml,skelhtml,[RSIZE2],%dvmg%,All
		StringReplace,skelhtml,skelhtml,[DBSIZE],%DATSZ%,All
		
		FileDelete,%gitroot%\%gituser%.github.io\skeletonkey\index.html
		ifnotexist, %gitroot%\%gituser%.github.io\skeletonkey
			{
				FileCreateDir,%gitroot%\%gituser%.github.io\skeletonkey
				RunWait, %comspec% cmd /c "%gitapp%" init,%gitroot%\%GITUSER%.github.io,hide
				RunWait,%comspec% cmd /c "bin\curl.exe" -k -u %gituser%:%gitpass% https://api.github.com/user/repos -d "{\"name\":\"%gituser%.github.io\"}",,hide
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
#IfWinActive _DEPLSETUP_
	{
		exitapp
	}
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
WinGet, DSFV,PID,_DEPLSETUP_
Process, close, %DSFV%
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
