@echo OFF
TITLE Building LIBTEST2...
SETLOCAL
SET temp=%~dp0
SET stemp=%temp%&SET pos=0

:loop
SET /a pos+=1
echo %stemp%|FINDSTR /b /c:"SAMPLES" >NUL
IF ERRORLEVEL 1 (
SET stemp=%stemp:~1%
IF DEFINED stemp GOTO loop
SET pos=0
)

setlocal enableDelayedExpansion
SET "temp1=%temp%"
SET /a pos=pos-2
SET HMGPATH=!temp1:~0,%pos%!
SET PATH=%HMGPATH%\harbour\bin;%HMGPATH%\mingw\bin;%PATH%

hbmk2 libtest2.hbp -i%hmgpath%\include