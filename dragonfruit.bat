:load
@echo off & setlocal enabledelayedexpansion
mode con:cols=60 lines=40
if not exist %appdata%\Mellow\Dragonfruit mkdir %appdata%\Mellow\Dragonfruit
echo %cd%> %appdata%\Mellow\Dragonfruit\temp.txt

:var
set version=1.0.0
set data=%appdata%\Mellow\Dragonfruit
set cache=%data%\cache.txt
set scripts=%data%\scripts
set settings=%data%\settings.txt
set /p main= < %data%\temp.txt
set adb=%main%\adb
set files=%main%\files
set backups=%files%\backups
if not exist %files% mkdir %files%
if not exist %backups% mkdir %backups%
if not exist %scripts% mkdir %scripts%
if not exist %cache% echo version=%version% > %cache%
if not exist %settings% (
	echo theme=8b > %settings%
	echo wireless_adb=000.000.0.0:5555 >> %settings%
	echo show_errors=true >> %settings%
)
for /f "tokens=2 delims==" %%a in ('find "version" ^<%cache%') do set prev=%%a
for /f "tokens=2 delims==" %%b in ('find "theme" ^<%settings%') do set theme=%%b
for /f "tokens=2 delims==" %%c in ('find "wireless_adb" ^<%settings%') do set adbw=%%c
for /f "tokens=2 delims==" %%d in ('find "show_errors" ^<%settings%') do set errors=%%d
if not %prev% == %version% (
	msg * "A different version of Dragonfruit has been detected.  Settings have been reset and unnecessary files were removed."
	del %cache%
	del %settings%
	goto var
)	
if %errors% == true (if not %errorlevel% == 0 goto err)

:ini
title Dragonfruit v%version%
color %theme%
cd %adb%

:main
cls
echo ____________________________________________________________
echo.
echo                          Main Menu
echo.
echo ____________________________________________________________
echo.
echo [BASIC]
echo.
echo 1. Reboot
echo 2. Manage Files
echo 3. Manage Apps
echo.
echo [ADVANCED]
echo.
echo 4. Flash Zip / Img
echo 5. Backup System (WIP)
echo 6. ADB Shell
echo 7. User Scripts (WIP)
echo.
echo [OTHER]
echo.
echo 8. Wireless ADB
echo 9. Options
echo *. Quit
echo.
set /p main=Option #: 
if %main% == 1 goto reboot
if %main% == 2 goto manageFiles
if %main% == 3 goto manageApps
if %main% == 4 goto flash
if %main% == 5 goto backup
if %main% == 6 goto shell
if %main% == 7 goto scripts
if %main% == 8 goto wireless
if %main% == 9 goto options
if %main% == * goto quit
goto main

:reboot
cls
echo ____________________________________________________________
echo.
echo                           Reboot
echo.
echo ____________________________________________________________
echo.
echo 1. System
echo 2. Recovery
echo 3. Bootloader
echo.
set /p reboot=Option #: 
cd %adb%
if %reboot% == 0 goto main
if %reboot% == 1 (
	adb reboot
	goto var
)
if %reboot% == 2 (
	adb reboot recovery
	goto var
)
if %reboot% == 3 (
	adb reboot bootloader
	goto var
)
goto reboot

:manageFiles
cls
echo ____________________________________________________________
echo.
echo                       Manage Files
echo.
echo ____________________________________________________________
echo.
echo 1. Push
echo 2. Pull
echo.
set /p manageFiles=Option #: 
if %manageFiles% == 0 goto main
if %manageFiles% == 1 goto push
if %manageFiles% == 2 goto pull
goto manageFiles

:push
cls
echo ____________________________________________________________
echo.
echo                 Push files to your device
echo.
echo Local: %files%
echo Remote: /sdcard/
echo.
echo ____________________________________________________________
echo.
echo Which file would you like to push? (Include Extension)
echo example.zip
echo.
set /p push=File: 
cd %adb%
if %push% == 0 goto main
adb push %files%\%push% /sdcard/%push%
goto var

:pull
cls
echo ____________________________________________________________
echo.
echo                 Pull files from your device
echo.
echo Local: %files%
echo Remote: /sdcard/
echo.
echo ____________________________________________________________
echo.
echo Which file would you like to pull? (Include Extension)
echo example.zip
echo.
set /p pull=File: 
cd %adb%
if %pull% == 0 goto main
adb pull /sdcard/%pull% %files%\%pull%
goto var

:manageApps
cls
echo ____________________________________________________________
echo.
echo                        Manage Apps
echo.
echo ____________________________________________________________
echo.
echo 1. Install
echo 2. Uninstall
echo.
set /p manageApps=Option #: 
if %manageApps% == 0 goto main
if %manageApps% == 1 goto install
if %manageApps% == 2 goto uninstall
goto manageApps

:install
cls
echo ____________________________________________________________
echo.
echo                 Install app on device
echo.
echo Local: %files%
echo.
echo ____________________________________________________________
echo.
echo Which app would you like to install? (Include Extension)
echo example.apk
echo.
set /p install=App: 
cd %adb%
if %install% == 0 goto main
adb install %files%\%install%
goto var

:uninstall
cls
echo ____________________________________________________________
echo.
echo                 Uninstall app from device
echo.
echo Local: %files%
echo.
echo ____________________________________________________________
echo.
echo Which app would you like to uninstall? (Include Extension)
echo example.apk
echo.
set /p uninstall=App: 
cd %adb%
if %uninstall% == 0 goto main
adb uninstall %files%\%uninstall%
goto var

:flash
cls
echo ____________________________________________________________
echo.
echo                        Flash Files
echo.
echo ____________________________________________________________
echo.
echo 1. Zip (ROM)
echo 2. Img (Recovery)
echo.
set /p flash=Option #: 
if %flash% == 0 goto main
if %flash% == 1 goto zip
if %flash% == 2 goto img
goto flash

:zip
cls
echo ____________________________________________________________
echo.
echo                         Flash ROM   
echo.
echo Local: %files%
echo.
echo ____________________________________________________________
echo.
echo Which ROM would you like to flash? (Include Extension)
echo example.zip
echo.
set /p zip=ROM: 
cd %adb%
if %zip% == 0 goto main
fastboot -w update %files%\%zip%
goto var

:img
cls
echo ____________________________________________________________
echo.
echo                      Flash Recovery
echo.
echo Local: %files%
echo.
echo ____________________________________________________________
echo.
echo Which recovery would you like to flash? (Include Extension)
echo example.img
echo.
set /p img=Recovery Image: 
cd %adb%
if %img% == 0 goto main
fastboot flash recovery %files%\%img%
goto var

:backup
msg * "This feature is unfinished and still a WIP."
cls
echo ____________________________________________________________
echo.
echo                          Backup
echo.
echo ____________________________________________________________
echo.
echo 1. System
echo.
set /p backup=Option #: 
cd %adb%
if %backup% == 0 goto main
if %backup% == 1 (
	adb backup -all
)
pause
goto var

:shell
msg * Coming soon - this will allow remote access to your android device.
goto var

:scripts
msg * "This feature is unfinished and still a WIP."
cls
cd %scripts%
echo ____________________________________________________________
echo.
echo                       User Scripts  
echo.
echo ____________________________________________________________
echo.
echo 1. View Scripts
echo.
set /p scripts=Option #: 
if %scripts% == 0 goto main
if %scripts% == 1 dir /b *.txt
pause
goto var

:wireless
cls
echo ____________________________________________________________
echo.
echo               Perform ADB commands over WiFi
echo.
echo  Must be enabled on a supported ROM under developer tools.
echo.
echo ____________________________________________________________
echo.
echo Please enter your device number found under developer tools
echo or type '1' to use previous number: %adbw%
echo.
set /p wireless=Device #: 
cd %adb%
if %wireless% == 0 goto main
if %wireless% == 1 (
	adb connect %adbw%
	goto var
)
echo theme=%theme% > %settings%
echo wireless_adb=%wireless% >> %settings%
echo show_errors=%errors% >> %settings%
adb connect %wireless%
goto var

:options
cls
echo ____________________________________________________________
echo.
echo                       	   Options
echo.
echo ____________________________________________________________
echo.
echo 1. Force update
echo 2. Open settings
echo 3. Reset settings
echo.
set /p options=Option #: 
if %options% == 0 goto main
if %options% == 1 start https://github.com/sociallymellow/dragonfruit/archive/master.zip
if %options% == 2 start %settings%
if %options% == 3 (
	del %settings%
	goto load
)
goto options

:err
echo.
echo ########################## error ###########################
echo.
verify >nul
pause
goto var

:quit
cd %adb%
adb kill-server
exit
