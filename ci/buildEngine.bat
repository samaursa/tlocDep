@echo off

:ENGINE_SPECIFIC

:: The following must be changed for each engine depending on the engine's
:: environment variables
cd..
SET TLOC_DEP_PATH=%CD%
SET WORKSPACE_PATH=%TLOC_DEP_PATH%
SET buildPath=%WORKSPACE_PATH%\proj\VS\2008\tlocDep.sln

:: The following are the batch file arguments, leave them alone
SET buildConfig=%1%
SET buildType=%2%
SET platform=%3%

:START

SET ColorBuilding=COLOR 9f
SET ColorError=COLOR 4f
SET ColorOk=COLOR 2f
SET ColorBuildFail=COLOR 6f

%ColorBuilding%

:CHECK_ARGUMENTS
:: Check whether we have the proper build configuration selected
IF NOT "%buildConfig%"=="debug" (
IF NOT "%buildConfig%"=="debug_dll" (
IF NOT "%buildConfig%"=="release" (
IF NOT "%buildConfig%"=="release_dll" (
IF NOT "%buildConfig%"=="release_debugInfo" (
IF NOT "%buildConfig%"=="release_debugInfo_dll" (
%ColorError%
ECHO  "ERROR: Unsupported build configuration (%buildConfig%) selected"
SET errorlevel=1
EXIT /B
)
)
)
)
)
)

:: Check whether we have the proper build type selected (build or rebuild)
IF NOT "%buildType%"=="build" (
IF NOT "%buildType%"=="rebuild" (
%ColorError%
ECHO  "ERROR: Unsupported build type (%buildType%) selected"
SET errorlevel=1
EXIT /B
)
)

:: Check whether we have the proper build type selected (build or rebuild)
IF NOT "%platform%"=="Win32" (
%ColorError%
ECHO  "ERROR: Unsupported platform type (%platform%) selected"
SET errorlevel=1
EXIT /B
)

:START_BUILDING

cd %WORKSPACE_PATH%\src\
CALL %WORKSPACE_PATH%\bat\extractSDKs.bat

SET currDir = %CD%
cd %VS90COMNTOOLS%\..\..\VC\vcpackages
c:

SET _buildType=Building
IF "%buildType%"=="rebuild" (
SET _buildType=Re-building
SET buildType=/rebuild
) ELSE (
SET buildType=
)

ECHO -------------------------------------------------------------------------------
ECHO %_buildType% %buildPath%
ECHO -------------------------------------------------------------------------------

vcbuild %buildType% /upgrade %buildPath% "%buildConfig%|%platform%" | %WORKSPACE_PATH%\ci\tee.exe %WORKSPACE_PATH%\ci\output.txt

cd %currDir%
cd %WORKSPACE_PATH%\ci\

:: Visual studio does not set the errorlevel flag, so we will search output.txt instead
:: We search for "0 Projects Failed" and error
FINDSTR /C:"0 Projects Failed" %WORKSPACE_PATH%\ci\output.txt

IF %ERRORLEVEL% NEQ 0 (
FINDSTR "error" %WORKSPACE_PATH%\ci\output.txt
)

:: Delete output.txt
del %WORKSPACE_PATH%\ci\output.txt

:: In bat files, ERRORLEVEL 1 = ERRORLEVEL 1 or higher
IF %ERRORLEVEL%==0 (
%ColorOk%
EXIT /b 0
) ELSE (
%ColorError%
EXIT /b %ERRORLEVEL%
)