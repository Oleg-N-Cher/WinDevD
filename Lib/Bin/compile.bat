@SET PATH=..\..\Bin\MinGW\bin
@SET gcc=gcc.exe

@SET Mod=%1
@IF "%Mod%"=="Platform.Windows" SET Mod=Platform
@IF EXIST ..\C\%1.c GOTO clib

:olib
%gcc% -c %Mod%.c -I ".." -I ..\C
@IF errorlevel 1 GOTO noinit
@GOTO exit

:noinit
@COPY /Y %Mod%.c %Mod%.c__
..\..\..\Bin\smartlib %Mod%.c -noinit -nocut
%gcc% -c %Mod%.c -I ".." -I ..\C
@MOVE /Y %Mod%.c__ %Mod%.c
@GOTO exit

:clib
@IF EXIST %Mod%.h DEL %Mod%.h
@IF EXIST %Mod%.c DEL %Mod%.c
%gcc% -c ..\C\%Mod%.c -I ".." -I ..\C

:exit
@IF errorlevel 1 PAUSE
pause