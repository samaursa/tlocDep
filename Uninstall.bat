@echo off
ECHO -------------------------------------------------------------------------------
ECHO - UNINSTALLING 2LoC Engine Dependencies -
ECHO -------------------------------------------------------------------------------

CHOICE /M "Are you sure you want to uninstall"
IF ERRORLEVEL==2 (
  ECHO Aborting...
  GOTO:DONE
)

:START_UNINSTALL
IF EXIST Paths.bat (
  DEL Paths.bat
)

:PURGE_REPOSITORY
ECHO.
ECHO -------------------------------------------------------------------------------
ECHO Repository Cleanup
ECHO -------------------------------------------------------------------------------
CHOICE /M "Do you want to purge (clean-up) the repository"
IF ERRORLEVEL==2 (
  ECHO Repository not cleaned up...
  GOTO:DONE
)

ECHO -!- Puring repository...
CALL bat/hgpurge.bat
ECHO DONE!

:DONE
ECHO.
ECHO -------------------------------------------------------------------------------
ECHO UNINSTALL COMPLETE
ECHO -------------------------------------------------------------------------------
PAUSE
