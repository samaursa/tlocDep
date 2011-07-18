@echo off
cd..
SET TLOC_DEP_PATH=%CD%
cd %TLOC_DEP_PATH%\ci\

SET buildConfig=debug
SET buildPath=%TLOC_DEP_PATH%\proj\VS\2008\tlocDep.sln
SET buildType=build
SET platform=Win32

cd %TLOC_DEP_PATH%\src\
CALL %TLOC_DEP_PATH%\bat\extractSDKs.bat

CALL %TLOC_DEP_PATH%\ci\buildEngine.bat

cd %TLOC_DEP_PATH%\ci\
ECHO.
ECHO -------------------------------------------------------------------------------
