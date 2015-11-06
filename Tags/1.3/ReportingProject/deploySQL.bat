@ECHO OFF

SET StorePath=%1
SHIFT
SET StoreName=%1
SET FunctionPath=%2
SET FunctionName=%3
SET ViewPath=%4
SET ViewName=%5
SET LocationPath=%6
SET SqlServer=%7
SET SqlUsername=%8
SET SqlPassword=%9

REM Merge Store Procedure and User Defined Function ***************
C:\Apps\MergeSQLs.exe %StorePath% %LocationPath% %StoreName%
C:\Apps\MergeSQLs.exe %FunctionPath% %LocationPath% %FunctionName%
C:\Apps\MergeSQLs.exe %ViewPath% %LocationPath% %ViewName%
REM ***************************************************************

REM - Exec Store Procedure and User Defined Function Script *********************************************

REM - HemProd *******************************************************************************************
"C:\Program Files\Microsoft SQL Server\100\Tools\Binn\sqlcmd.exe" -S %SqlServer% -U %SqlUsername% -P %SqlPassword% -d Hemprod -i %LocationPath%\%StoreName%
"C:\Program Files\Microsoft SQL Server\100\Tools\Binn\sqlcmd.exe" -S %SqlServer% -U %SqlUsername% -P %SqlPassword% -d Hemprod -i %LocationPath%\%FunctionName%
"C:\Program Files\Microsoft SQL Server\100\Tools\Binn\sqlcmd.exe" -S %SqlServer% -U %SqlUsername% -P %SqlPassword% -d Hemprod -i %LocationPath%\%ViewName%
REM *****************************************************************************************************

REM - Emiprod *******************************************************************************************
"C:\Program Files\Microsoft SQL Server\100\Tools\Binn\sqlcmd.exe" -S %SqlServer% -U %SqlUsername% -P %SqlPassword% -d Emiprod -i %LocationPath%\%StoreName%
"C:\Program Files\Microsoft SQL Server\100\Tools\Binn\sqlcmd.exe" -S %SqlServer% -U %SqlUsername% -P %SqlPassword% -d Emiprod -i %LocationPath%\%FunctionName%
"C:\Program Files\Microsoft SQL Server\100\Tools\Binn\sqlcmd.exe" -S %SqlServer% -U %SqlUsername% -P %SqlPassword% -d Emiprod -i %LocationPath%\%ViewName%
REM *****************************************************************************************************

REM - Tmfprod *******************************************************************************************
"C:\Program Files\Microsoft SQL Server\100\Tools\Binn\sqlcmd.exe" -S %SqlServer% -U %SqlUsername% -P %SqlPassword% -d Tmfprod -i %LocationPath%\%StoreName%
"C:\Program Files\Microsoft SQL Server\100\Tools\Binn\sqlcmd.exe" -S %SqlServer% -U %SqlUsername% -P %SqlPassword% -d Tmfprod -i %LocationPath%\%FunctionName%
"C:\Program Files\Microsoft SQL Server\100\Tools\Binn\sqlcmd.exe" -S %SqlServer% -U %SqlUsername% -P %SqlPassword% -d Tmfprod -i %LocationPath%\%ViewName%
REM *****************************************************************************************************

REM *****************************************************************************************************