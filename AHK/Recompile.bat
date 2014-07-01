@echo off
@title compile AHK to Builds folder with x64 and x86


Echo "Compiling downloader..."
..\Compiler\Ahk2Exe.exe /in ..\AHK\DownloadAndUnzipMPRESS.ahk /out ..\Compiler\DownloadAndUnzipMPRESS.exe /bin "..\Compiler\AutoHotkeySC.bin" 
Echo "Compilled downloader [OK]"


Echo "Downloading Mpress if its not there yet"
..\Compiler\DownloadAndUnzipMPRESS.exe
Echo "Downloaded mpress.exe"


Echo "Compiling x64 version ..."
..\Compiler\Ahk2Exe.exe /in ..\AHK\SteamBulkKeyActivator.ahk /out ..\Builds\SteamBulkKeyActivator_x64.exe /bin "..\Compiler\Unicode 64-bit.bin" /icon ..\Recources\local\wizard.ico /mpress 1
Echo "Compiled x64 version [OK]"


Echo "Compiling x86 version ..."
..\Compiler\Ahk2Exe.exe /in ..\AHK\SteamBulkKeyActivator.ahk /out ..\Builds\SteamBulkKeyActivator_x86.exe /bin "..\Compiler\Unicode 32-bit.bin" /icon ..\Recources\local\wizard.ico /mpress 1
Echo "Compiled x86 version [OK]"