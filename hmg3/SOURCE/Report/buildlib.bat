@echo off

SET HMGPATH=%~dp0%
SET HMGPATH1=%HMGPATH:~0,-15%

SET PATH=%HMGPATH1%\harbour\bin;%HMGPATH1%\mingw\bin;%PATH%

hbmk2 report.hbp -i%hmgpath1%\include
pause