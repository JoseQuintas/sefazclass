@echo OFF

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
set "temp1=%temp%"
set /a pos=pos-2

set temp=!temp1:~0,%pos%!

if "%1"=="" Goto WithOutPar
	Set MainFile=%1
	Goto Continue
	:WithOutPar
	for /R %~dp0%~1 %%f in (*.hbp) do (Set MainFile="%%~nf")
	Goto Continue
	:Continue


call %temp%\build.bat %MainFile%

