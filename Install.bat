@echo off
ECHO -------------------------------------------------------------------------------
ECHO - INSTALLING 2LoC Engine Dependencies -
ECHO -------------------------------------------------------------------------------
ECHO NOTE: A Log-off/Log-on cycle may be
ECHO       neccessary for Visual Studio to 
ECHO       detect the new env variables
ECHO -------------------------------------------------------------------------------
ECHO.
ECHO Setting Environment Variables
ECHO -------------------------------------------------------------------------------
CALL:SET_ENV_PATHS
ECHO.
ECHO Extracting SDKs
ECHO -------------------------------------------------------------------------------
CALL:EXTRACT_SDKS
GOTO:DONE

:MAKE_ENV
ECHO Setting environment variable to %CD%
SETX TLOC_DEP_PATH %CD% -m

:SET_ENV_PATHS
SET envPath=%CD%
SET envName=TLOC_DEP_PATH
SET currEnvPath=%TLOC_DEP_PATH%
CALL:INSTALL_ENV

GOTO:EOF

:EXTRACT_SDKS
cd src/
CALL ../bat/extractSDKs.bat

GOTO:RESTART_EXPLORER

:INSTALL_ENV
IF "%currEnvPath%"=="" (
  ECHO --- Setting %envName% path to %envPath%
  SETX %envName% %envPath%
  SET %envName% %envPath%
  GOTO:EOF
)
ECHO -!- %envName% path already exists
GOTO:EOF

:RESTART_EXPLORER
ECHO -------------------------------------------------------------------------------
ECHO Environment variables will not take effect unless Explore.exe is restarted. 
ECHO A Log-off/on cycle may still be required.
ECHO.
ECHO If this is an UPGRADE, you can safely close this window right now.
ECHO -------------------------------------------------------------------------------

GOTO:DONE

:DONE
cd..
ECHO.
ECHO DONE!
PAUSE
EXIT