@REM Build the library XDev
@REM ======================

:MinGW64
@SET Lib=..\XDev64.a
@IF EXIST %Lib% DEL %Lib%
@CALL ..\Bin\solid64 %Lib% SYSTEM
@CALL ..\Bin\solid64 %Lib% Heap
@CALL ..\Bin\solid64 %Lib% Platform
@CALL ..\Bin\smart64 %Lib% Strings -noinit
::@CALL ..\Bin\smart64 %Lib% StringsW
@CALL ..\Bin\smart64 %Lib% CmdLine
::@CALL ..\Bin\smart64 %Lib% CmdLineW
::@CALL ..\Bin\smart64 %Lib% WinCmdLineW
@CALL ..\Bin\solid64 %Lib% Debug
@CALL ..\Bin\smart64--include %Lib% Math
@CALL ..\Bin\smart64 %Lib% Files
@CALL ..\Bin\solid64 %Lib% GrApp
@CALL ..\Bin\smart64 %Lib% Console
::@CALL ..\Bin\smart64 %Lib% ConsoleW

@COPY ..\C\GrConfigS.h GrConfig.h
 @CALL ..\Bin\smart64 %Lib% GrPixel
 @CALL ..\Bin\solid64 %Lib% GrTiles
 @CALL ..\Bin\smart64 %Lib% GrFonts
 @CALL ..\Bin\solid64 %Lib% GrConsole
@DEL GrConfig.h

@CALL ..\Bin\solid64 %Lib% Input
@CALL ..\Bin\smart64 %Lib% Timer
@CALL ..\Bin\solid64 %Lib% Sound
@CALL ..\Bin\smart64 %Lib% Delphi -noinit
