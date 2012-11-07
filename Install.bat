@echo off
ECHO -------------------------------------------------------------------------------
ECHO - INSTALLING 2LoC Engine Dependencies -
ECHO -------------------------------------------------------------------------------
ECHO.
ECHO Setting Paths.bat 
ECHO -------------------------------------------------------------------------------
CALL:SET_PATH_BAT
ECHO.
ECHO Extracting SDKs
ECHO -------------------------------------------------------------------------------
CALL:EXTRACT_SDKS
GOTO:DONE

:SET_PATH_BAT
IF NOT "%TLOC_DEP_PATH%"=="" ECHO Warning:TLOC_DEP_PATH is already globally defined (recommend removing).

SET Paths_template_file=Paths.bat.template
SET Paths_file=Paths.bat

:CHECK_EXIT_TEMPLATE
IF NOT EXIST %Paths_template_file% (
  ECHO %Paths_template_file% does not exist!
  GOTO:ERROR
)

:CHECK_OVERWRITE
IF EXIST %Paths_file% (
  CHOICE /M "%Paths_file% already exists, over-write"
  IF ERRORLEVEL==2 (
    ECHO Existing file not over-written...
    GOTO:EOF
  )

  ECHO Over-writing existing %Paths_file% and creating backup - %Paths_file%.bak
  COPY %Paths_file% %Paths_file%.bak
)

:CREATE_PATHS
COPY %Paths_template_file% %Paths_file%

ECHO.
ECHO ----------------------------------------------------------
ECHO Please adjust absolute paths in your new Paths.bat file...
ECHO ----------------------------------------------------------

GOTO:EOF

:EXTRACT_SDKS
cd bat/
CALL extractSDKs.bat

GOTO:EOF

:DONE
ECHO.
ECHO ******************************
ECHO * FINISHED INSTALLING Dependencies*
ECHO ******************************
PAUSE
EXIT /b 0

:ERROR
PAUSE
EXIT /b -1
