@echo off
set codePath=..\..\code
set assembler=c:\masm32\bin\ml.exe
set linker=c:\masm32\bin\Link.exe
set wdcodecheck=..\wdcodecheck\bin\Release\wdcodecheck.exe
set patcher=..\patcher\Release\patcher.exe

if exist wd.obj del wd.obj
if exist wd.exe del wd.exe

%wdcodecheck% %codePath%\wd.asm
if errorlevel 1 goto errasm

%assembler% /c /coff /D_DEDIC %codePath%\wd.asm
if errorlevel 1 goto errasm

%linker% /SUBSYSTEM:CONSOLE /OPT:NOREF /BASE:0x400000 wd.obj
if errorlevel 1 goto errlink
goto patch

:errlink
echo _
echo Link error
goto TheEnd

:errasm
echo _
echo Assembly Error
goto TheEnd

:patch
%patcher% nfk075d.exe wd.exe
move nfk075d.upd.exe nfk076d.upd.exe

:TheEnd

pause
