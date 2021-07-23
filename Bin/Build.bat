@ECHO OFF
SET DJGPP=d:\Archive\Projects\XDev\WinDevD\Bin\DJGPP\djgpp.env
SET PATH=d:\Archive\Projects\XDev\WinDevD\Bin\DJGPP\bin

::..\Lib\Mod\crt1.c
gcc.exe ..\Lib\Mod\SYSTEM.c %1.c -o ..\%1.exe @..\Bin\djgpp.opt
@IF errorlevel 1 PAUSE

CD ..
::CLS
%1.exe
PAUSE
