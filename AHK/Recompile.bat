@echo off
@title compile AHK to Builds folder with x64 and x86
..\Compiler\Ahk2Exe.exe /in ..\AHK\SteamBulkKeyActivator.ahk /out ..\Builds\SteamBulkKeyActivator_x64.exe /bin "..\Compiler\Unicode 64-bit.bin" /icon ..\Recources\local\wizard.ico
..\Compiler\Ahk2Exe.exe /in ..\AHK\SteamBulkKeyActivator.ahk /out ..\Builds\SteamBulkKeyActivator_x86.exe /bin "..\Compiler\Unicode 32-bit.bin" /icon ..\Recources\local\wizard.ico