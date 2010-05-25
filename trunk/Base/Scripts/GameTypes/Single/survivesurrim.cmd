echo off
path E:\Eigene Dateien\moon-c\MOON-C\Tools\
del "survivesurrim ????-??-?? ??-??.ecomp"
for /f "tokens=1,2,3 delims=/: " %%a in ('time/t') do set t=%%a-%%b%%c
for /f "tokens=1,2,3 delims=/. " %%a in ('date/t') do set d=%%c-%%b-%%a
cls
EarthCMP.exe survivesurrim.ec "survivesurrim %d% %t%.ecomp"
pause
