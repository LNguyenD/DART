@echo off

SET ReportingServer=%1
SET RootPath=%2
SET BuildPath=%3

IF "%ReportingServer%"=="?" GOTO :Error
IF "%ReportingServer%"=="" GOTO :Error
@%WinDir%\microsoft.net\Framework\v3.5\MSBuild %BuildPath%\SSRSMSBuildTaskDEMO.msbuild /t:FullDepoly /p:ReportingServerURL=%ReportingServer%;RootPath=%RootPath%
GOTO :End 

:Error
@Echo Usage:
@Echo "NativeUploadReports http://<ReportServer>/<ReportServerVirtualDirecory>"
GOTO :End

:End
pause

