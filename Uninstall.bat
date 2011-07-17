@echo off
ECHO -------------------------------------------------------------------------------
ECHO - UNINSTALLING TwoLoC Engine Dependencies -
ECHO -------------------------------------------------------------------------------

ECHO.
ECHO -------------------------------------------------------------------------------
ECHO Deleting environment variables
ECHO -------------------------------------------------------------------------------
SET /P DelEnv="Do you want to delete all environment variables(y/n)?"

IF "%DelEnv%"=="y" (
  IF NOT "%TLOC_DEP_PATH%" == "" (
  ECHO -!- Removing TLOC_DEP_PATH environment variable
  REG delete HKCU\Environment /V TLOC_DEP_PATH /F
  )
)

:PURGE_REPOSITORY
ECHO.
ECHO -------------------------------------------------------------------------------
ECHO Repository Cleanup
ECHO -------------------------------------------------------------------------------
SET /P PurgeRepo="Do you want to purge the repository(y/n)?"
IF "%PurgeRepo%"=="y" (
  ECHO -!- Puring repository...
  CALL bat/hgpurge.bat
  ECHO DONE!
  GOTO :RESTART_EXPLORER
)

:RESTART_EXPLORER
ECHO -------------------------------------------------------------------------------
ECHO Environment variables will not take effect unless Explore.exe is restarted.
ECHO A Log-off/on cycle may still be required.
ECHO -------------------------------------------------------------------------------

:DONE
ECHO DONE!
PAUSE
