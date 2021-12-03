@echo off

rem ===========================================================================
rem
rem MakeChm.bat
rem
rem Kevin Carmody - 2014.10.22
rem
rem ===========================================================================

rem If no parameters, display command syntax.
if "%1"==""   goto SYNTAX
if "%1"=="?"  goto SYNTAX
if "%1"=="/?" goto SYNTAX
goto PARPARSE

:SYNTAX
  rem Display batch file syntax message
  echo.
  echo ModifyChm.bat
  echo Compiles and decompiles CHM help file.
  echo.
  echo Compile option must be run on HHP file and requires Microsoft Help Workshop,
  echo free download at http://www.microsoft.com/en-us/download/details.aspx?id=21138
  echo.
  echo Syntax:
  echo ModifyChm (source) [?] [/D] [/C] [/G] [/DL (loc)] [/CX]
  echo           [/GD] [/GN (title)] [/GI (init)] [/GW (width)] 
  echo           [/GL (left)] [/GT (top)] [/GR (right)] [/GB (bottom)] [/P]
  echo.
  echo   (source)    For decompile, CHM file name without extension
  echo               For compile, HHP file name without extension
  echo               For generate, HHP file name without extension
  echo   /D          Decompile CHM into HHP, HHC, HHK, HTML, and associated files,
  echo                 requires (source).CHM
  echo   /C          Compile HHP and files it specifies into CHM file,
  echo                 requires (source).HHP
  echo   /G          Generate (source).HHP file from decompiled files,
  echo                 requires decompiled files
  echo   /DL         For /D, use alternate location for decompiled files
  echo   (loc)       Alternate decompile location, default current directory
  echo   /CX         For /C, suppress display of CHM file after it has been compiled
  pause
  echo   /GD         For /G, delete (source).chm and (source).hhp if present
  echo   /GN         For /G, use alternate title to display in CHM
  echo   (title)     Alternate CHM title, default (source)
  echo   /GI         For /G, use alternate initial file to display in CHM
  echo   (init)      Alternate CHM initial file, including extension, default (source).htm
  echo   /GW         For /G, use alternate initial width of navigation pane
  echo   (width)     Alternate initial width of navigation pane, default 250
  echo   /GL         For /G, use alternate left position of window
  echo   (left)      Alternate initial left position of window in pixels, default 10
  echo   /GT         For /G, use alternate top position of window
  echo   (top)       Alternate initial top position of window in pixels, default 10
  echo   /GR         For /G, use alternate right position of window
  echo   (right)     Alternate initial right position of window in pixels, default 700
  echo   /GB         For /G, use alternate bottom position of window
  echo   (bottom)    Alternate initial bottom position of window in pixels, default 500
  echo   /P          Pause at end
  echo.
  echo You must specify /D, /C, or /G.  Spacing between parameters must be as shown.
  echo.
  pause
  echo You may set the following environment variables.
  echo Locations in these variables must not have a trailing backslash.
  echo.
  echo   LOC_HH      Location of HH.EXE, default C:\Windows
  echo   LOC_HHC     Location of HHC.EXE, default C:\Program Files\HTML Help Workshop
  echo.
  set MV_PAUSE=Y
  goto END

:SYNTERR
  echo Type ModifyChm.bat ? for syntax.
  set MV_PAUSE=Y
  goto END

:PARPARSE
  rem Initialize local variables.
  set MV_SRC=%1
  set MV_MODE=
  set MV_DLOC=.
  set MV_DLOCD=current directory
  set MV_CDISP=Y
  set MV_GDEL=N
  set MV_GTITLE=%MV_SRC%
  set MV_GINIT=%MV_SRC%.htm
  set MV_GWIDTH=250
  set MV_GLEFT=10
  set MV_GTOP=10
  set MV_GRIGHT=700
  set MV_GBOTTOM=500
  set MV_HHC=
  set MV_HHK=
  set MV_PAUSE=N
  rem Set default paths to Windows, Help Workshop folders
  if not defined LOC_HH  set LOC_HH=C:\Windows
  if not defined LOC_HHC set LOC_HHC=C:\Program Files\HTML Help Workshop
:PARMORE
  rem Start of parameter parse loop, test for end of parameters
  shift
  if   "%1"=="" goto OPCHECK
  rem Test for individual parameters: branch down when found, then loop back
  if    %1==?   goto SYNTAX
  if    %1==/?  goto SYNTAX
  if /i %1==/d  goto DECSET
  if /i %1==/c  goto COMPSET
  if /i %1==/g  goto GENSET
  if /i %1==/dl goto DLOCSET
  if /i %1==/cx goto CDISPSET
  if /i %1==/gd goto GDELSET
  if /i %1==/gn goto GTITLESET
  if /i %1==/gi goto GINITSET
  if /i %1==/gw goto GWIDTHSET
  if /i %1==/gl goto GLEFTSET
  if /i %1==/gt goto GTOPSET
  if /i %1==/gr goto GRIGHTSET
  if /i %1==/gb goto GBOTTOMSET
  if /i %1==/p  goto PAUSESET
  echo Unknown ModifyChm.bat option %1
  goto SYNTERR
:DECSET
  set MV_MODE=D
  goto PARMORE
:COMPSET
  set MV_MODE=C
  goto PARMORE
:GENSET
  set MV_MODE=G
  goto PARMORE
:DLOCSET
  shift
  if "%1"=="" goto ARGMISS
  set MV_DLOC=%1
  set MV_DLOCD=%1
  goto PARMORE
:CDISPSET
  set MV_CDISP=N
  goto PARMORE
:GDELSET
  set MV_GDEL=Y
  goto PARMORE
:GTITLESET
  shift
  if "%1"=="" goto ARGMISS
  set MV_GTITLE=%1
  goto PARMORE
:GINITSET
  shift
  if "%1"=="" goto ARGMISS
  set MV_GINIT=%1
  goto PARMORE
:GWIDTHSET
  shift
  if "%1"=="" goto ARGMISS
  set MV_GWIDTH=%1
  goto PARMORE
:GLEFTSET
  shift
  if "%1"=="" goto ARGMISS
  set MV_GLEFT=%1
  goto PARMORE
:GTOPSET
  shift
  if "%1"=="" goto ARGMISS
  set MV_GTOP=%1
  goto PARMORE
:GRIGHTSET
  shift
  if "%1"=="" goto ARGMISS
  set MV_GRIGHT=%1
  goto PARMORE
:GBOTTOMSET
  shift
  if "%1"=="" goto ARGMISS
  set MV_GBOTTOM=%1
  goto PARMORE
:PAUSESET
  set MV_PAUSE=Y
  goto PARMORE

:ARGMISS
  echo Missing argument after %0 option.
  goto SYNTERR

:OPCHECK
  rem Check that /D, /C, or /G specified
  if "%MV_MODE%"=="D" goto DECCHECK
  if "%MV_MODE%"=="C" goto COMPCHECK
  if "%MV_MODE%"=="G" goto GCHMCHECK
  echo Specify /D, /C, or /G.
  goto SYNTERR

:DECCHECK
  rem Check that CHM decompiler present
  if exist "%LOC_HH%\hh.exe" goto DCHMCHECK
  echo Cannot find hh.exe in %LOC_HH%.
  goto SYNTERR

:DCHMCHECK
  rem Check that CHM source exists
  if exist %MV_SRC%.chm goto DECOMP
  echo Cannot find %MV_SRC%.chm.
  goto SYNTERR

:DECOMP
  rem Decompile CHM file
  "%LOC_HH%\hh.exe" -decompile %MV_DLOC% %MV_SRC%.chm
  if not errorlevel 1 goto DSUCCESS
  echo.
  echo Decompile error.
  echo.
  goto END

:DSUCCESS
  rem Report decompilation success.
  echo %MV_SRC%.chm decompiled to %MV_DLOCD%.
  goto END

:COMPCHECK
  rem Check that CHM compiler present
  if exist "%LOC_HHC%\hhc.exe" goto CHHPCHECK
  echo Cannot find hhc.exe in %LOC_HHC%.
  goto SYNTERR

:CHHPCHECK
  rem Check that HHP source exists
  if exist %MV_SRC%.hhp goto COMP
  echo Cannot find %MV_SRC%.hhp.
  goto SYNTERR

:COMP
  rem Compile HHP file into CHM
  "%LOC_HHC%\hhc.exe" %MV_SRC%.hhp
  rem HHC errorlevel 0 = error, 1 = success
  if errorlevel 1 goto CSUCCESS
  echo.
  echo Compile error.
  echo.
  goto END

:CSUCCESS
  rem Display CHM or report compilation success.
  if %MV_CDISP%==Y %LOC_HH%\hh.exe %MV_SRC%.chm
  if %MV_CDISP%==N echo %MV_SRC%.chm compilation successful.
  goto END

:GCHMCHECK
  rem Check that HHP location does not have CHM file
  if     exist %MV_SRC%.chm if %MV_GDEL%==Y del %MV_SRC%.chm
  if not exist %MV_SRC%.chm goto GHHPCHECK
  echo.
  echo %MV_SRC%.chm should not be present for /G.
  echo.
  goto END

:GHHPCHECK
  rem Check that HHP location does not have HHP file
  if     exist %MV_SRC%.hhp if %MV_GDEL%==Y del %MV_SRC%.hhp
  if not exist %MV_SRC%.hhp goto GHHCCHECK
  echo.
  echo %MV_SRC%.hhp should not be present for /G.
  echo.
  goto END

:GHHCCHECK
  rem Check that HHP location has HHC file
  if exist *.hhc goto GHHKCHECK
  echo.
  echo Cannot find HHC file.
  echo.
  goto END

:GHHKCHECK
  rem Check that HHP location has HHK file
  if exist *.hhk goto GINITCHECK
  echo.
  echo Cannot find HHK file.
  echo.
  goto END

:GINITCHECK
  rem Check that HHP location has initial file
  if exist %MV_GINIT% goto GENHHP
  echo.
  echo Cannot find initial file %MV_GINIT%.
  echo.
  goto END

:GENHHP
  lfnfor on
  for %%f in (*.hhc) do set MV_HHC=%%f
  for %%f in (*.hhk) do set MV_HHK=%%f
  echo [OPTIONS]                      >%MV_SRC%.hhp
  echo Compiled file=%MV_SRC%.chm    >>%MV_SRC%.hhp
  echo Default Window=base           >>%MV_SRC%.hhp
  echo Default topic=%MV_GINIT%      >>%MV_SRC%.hhp
  echo Title=%MV_GTITLE%             >>%MV_SRC%.hhp
  echo Full-text search=Yes          >>%MV_SRC%.hhp
  echo.                              >>%MV_SRC%.hhp
  echo [FILES]                       >>%MV_SRC%.hhp
  for %%f in (*.*) do echo %%f       >>%MV_SRC%.hhp
  echo.                              >>%MV_SRC%.hhp
  echo [WINDOWS]                     >>%MV_SRC%.hhp
  echo base="%MV_GTITLE%","%MV_HHC%","%MV_HHK%","%MV_GINIT%","%MV_GINIT%",,,,,0x520,%MV_GWIDTH%,0x10304e,[%MV_GLEFT%,%MV_GTOP%,%MV_GRIGHT%,%MV_GBOTTOM%],0x0,0x0,1,0,0,0, >>%MV_SRC%.hhp
  goto GSUCCESS

:GSUCCESS
  echo %MV_SRC%.hhp successfully generated.
  goto end

:END
  rem Delete local variables
  if %MV_PAUSE%==Y pause
  set MV_SRC=
  set MV_MODE=
  set MV_DLOC=
  set MV_DLOCD=
  set MV_CDISP=
  set MV_GDEL=
  set MV_GTITLE=
  set MV_GINIT=
  set MV_GWIDTH=
  set MV_GLEFT=
  set MV_GTOP=
  set MV_GRIGHT=
  set MV_GBOTTOM=
  set MV_HHC=
  set MV_HHK=
  set MV_PAUSE=
