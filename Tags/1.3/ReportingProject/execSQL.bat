@ECHO OFF

SET SqlServer=%1
SET SqlUsername=%2
SET SqlPassword=%3
SET SqlFile=%4

REM - Exec Updating Schema Script ********************************************************************************************************
"C:\Program Files\Microsoft SQL Server\100\Tools\Binn\sqlcmd.exe" -S %SqlServer% -U %SqlUsername% -P %SqlPassword% -d Hemprod -i %SqlFile%
"C:\Program Files\Microsoft SQL Server\100\Tools\Binn\sqlcmd.exe" -S %SqlServer% -U %SqlUsername% -P %SqlPassword% -d Emiprod -i %SqlFile%
"C:\Program Files\Microsoft SQL Server\100\Tools\Binn\sqlcmd.exe" -S %SqlServer% -U %SqlUsername% -P %SqlPassword% -d Tmfprod -i %SqlFile%
REM **************************************************************************************************************************************