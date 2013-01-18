@echo off

ECHO -------------------------------------------------------------------------------
ECHO Extracting SDKs
ECHO -------------------------------------------------------------------------------

:: Set the following depending on the engine's environment variable
SET sdkDir=..\src\

:SET_ARGUMENTS
SET forceUnzip=%1%

:EXTRACT_SDKS
SET nextSdk=%sdkDir%WinSDK
CALL:INSTALL

GOTO:EOF

:INSTALL
SET extract=false
IF EXIST %nextSdk% SET extract=true
IF "%extract%"=="true" ( 
	IF NOT "%forceUnzip%"=="-f" (
		ECHO -!- %nextSdk% already exists, skipping unzip...		
		GOTO:EOF
	)
)
ECHO --- Extracting %nextSdk%...
%nextSdk% -y
GOTO:EOF
