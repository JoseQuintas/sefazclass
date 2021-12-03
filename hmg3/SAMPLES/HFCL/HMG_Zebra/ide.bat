@ECHO OFF
SET Temp1=%~dp0
SET Temp2=%Temp1%
SET Pos=0

:Loop
SET /a Pos+=1
ECHO %Temp2%|FINDSTR /b /c:"SAMPLES" >NUL
IF ERRORLEVEL 1 (
SET Temp2=%Temp2:~1%
IF DEFINED Temp2 GOTO Loop
SET Pos=0
)

SETLOCAL EnableDelayedExpansion
SET "Temp3=%Temp1%"
SET /a Pos=Pos-2
SET Temp1=!Temp3:~0,%Pos%!

IF "%1"=="" for %%x in (*.hbp) do (%Temp1%\Ide\Ide.exe %%x)
IF NOT "%1"=="" %Temp1%\Ide\Ide.exe %1