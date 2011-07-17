@echo off
:EXTRACT_SDKS
set nextSdk=philsquared-Catch-f721a96
CALL:INSTALL

GOTO:EOF

:INSTALL
set extract=false
IF EXIST %nextSdk% SET extract=true
IF "%extract%"=="true" ( 
  ECHO -!- %nextSdk% already exists, skipping unzip...
  GOTO:EOF
)
ECHO --- Extracting %nextSdk%...
%nextSdk% -y
GOTO:EOF