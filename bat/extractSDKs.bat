@echo off

ECHO -------------------------------------------------------------------------------
ECHO Extracting SDKs
ECHO -------------------------------------------------------------------------------

:: Set the following depending on the engine's environment variable
SET sdkDir=%TLOC_DEP_PATH%\src\

:EXTRACT_SDKS
SET nextSdk=%sdkDir%philsquared-Catch-f721a96
CALL:INSTALL

GOTO:EOF

:INSTALL
SET extract=false
IF EXIST %nextSdk% SET extract=true
IF "%extract%"=="true" ( 
  ECHO -!- %nextSdk% already exists, skipping unzip...
  GOTO:EOF
)
ECHO --- Extracting %nextSdk%...
%nextSdk% -y
GOTO:EOF