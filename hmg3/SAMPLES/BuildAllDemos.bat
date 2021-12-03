@ECHO OFF
SET HMGPATH=%~dp0
TITLE Build All Demos at %HMGPATH%
cls
echo.
echo. ***********************************************
echo. *               Build All Demos               *
echo. ***********************************************
echo.
echo.
echo.                    N - No
echo.                    
echo.                    Y - Yes
echo.                    
echo.                    C - Cancel
echo.
echo. 
CHOICE /C:NYC /N /M:"Build HMG SAMPLES and running executable file ?"
IF ERRORLEVEL 3 GOTO End
IF ERRORLEVEL 2 SET NoRun=
IF ERRORLEVEL 1 SET NoRun=.T.

FOR /R %HMGPATH% %%G in (.) DO (
Pushd %%G
Echo %%G
IF EXIST %%G\Build.bat Call %%G\Build.bat
IF EXIST %%G\Compile.bat Call %%G\Compile.bat
Popd )
:End