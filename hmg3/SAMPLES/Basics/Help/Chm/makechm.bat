@ECHO OFF
SETLOCAL
SET Temp1=%~dp0
SET Temp3=%Temp1%&SET Pos=0

:Loop
SET /a Pos+=1
ECHO %Temp3%|FINDSTR /b /c:"SAMPLES" >NUL
IF ERRORLEVEL 1 (
SET Temp3=%Temp3:~1%
IF DEFINED Temp3 GOTO Loop
SET Pos=0
)

SETLOCAL EnableDelayedExpansion
SET "Temp2=%Temp1%"
SET /a Pos=Pos-2
SET Temp1=!Temp2:~0,%Pos%!

IF "%1"=="" GOTO WithOutParam
SET MainFile="%1"
GOTO WithParam

:WithOutParam
FOR %%x IN (*.hhp) DO ( ECHO Building %%x
IF "%NoRun%"=="" CALL %Temp1%\makechm.bat %%~nx /c 
IF NOT "%NoRun%"=="" CALL %Temp1%\makechm.bat %%~nx /c /cx )
GOTO End

:WithParam
IF "%NoRun%"=="" CALL %Temp1%\makechm.bat %MainFile% /c 
IF NOT "%NoRun%"=="" CALL %Temp1%\makechm.bat %MainFile% /c /cx 

:End
