@echo off

cd..
SET TLOC_DEP_PATH=%CD%
cd ci

SET buildConfig=debug
SET buildPath=%TLOC_DEP_PATH%\proj\vs\2008\TwoLocDep.sln
SET buildType=build

SET _buildType=Building
IF "%buildType%"=="rebuild" (
SET _buildType=Re-building
)

ECHO -------------------------------------------------------------------------------
ECHO Extracting SDKs
ECHO -------------------------------------------------------------------------------
CALL %TLOC_DEP_PATH%\bat\extractSDKs.bat

ECHO -------------------------------------------------------------------------------
ECHO %_buildType% %buildPath%
ECHO -------------------------------------------------------------------------------
MSBuild %buildPath% /t:%buildType% /p:Configuration=%buildConfig% /maxcpucount:4 /clp:PerformanceSummary /nologo

PAUSE

ECHO.
ECHO -------------------------------------------------------------------------------
