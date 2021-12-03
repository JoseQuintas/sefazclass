echo #define HMGRPATH %HmgPath%\RESOURCES > _hmg_resconfig.h
COPY /b %HMGPATH%\resources\hmg32.rc+"%~n1.rc"+%HMGPATH%\resources\filler _temp.rc >NUL
WINDRES -i _temp.rc -o _temp.o >windres.log 2>&1

rem -ldflag="-pthread  -static-libgcc  -static-libstdc++  -static -lpthread"  --> for gcc.exe link pthread library in static mode
rem -trace --> for show execute command line

HBMK2 -ldflag="-pthread  -static-libgcc  -static-libstdc++  -static -lpthread" -mt -o"%~n1" %HMGPATH%\hmg32.hbc %gtdrivers% %debug% -q %1 %2 %3 %4 %5 %6 %7 %8 >hbmk.log 2>&1

rem ******************************************************************************
rem CLEANUP
rem ******************************************************************************

:CLEANUP
if exist windres.log del windres.log
if exist hbmk.log del hbmk.log
if exist _hmg_resconfig.h del _hmg_resconfig.h
if exist _temp.rc del _temp.rc
if exist _temp.o del _temp.o

