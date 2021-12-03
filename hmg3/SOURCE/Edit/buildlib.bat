@echo off

SET HMGPATH=%~dp0%
SET HMGPATH1=%HMGPATH:~0,-13%

SET PATH=%HMGPATH1%\harbour\bin;%HMGPATH1%\mingw\bin;%PATH%

hbmk2 edit.hbp -i%hmgpath1%\include
pause