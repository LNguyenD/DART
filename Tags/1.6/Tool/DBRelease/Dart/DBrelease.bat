setlocal
rem echo OFF
REM Assuming: 
REM URL to the root of repository, i.e. https://10.9.0.1/svn/repo/ecommerce/em-squared
REM You should only see 3 folder within: branches, tags, trunk
REM Note: No "/" at the end of URL
REM
REM URL
REM +--- branches
REM +--- tags
REM \--- trunk
REM      +--- DB (==UrlPath, start with / and end without /, e.g. by default /DB)
REM      \--- otherFolder
REM 
REM
REM
REM Steps:
REM * Pre-config the usernname & password for SVN
REM * Connect to control DB, get Last release number. 
REM * Run update and get the latest version from SVN (checkout)
REM * Tag the HEAD with new version number for DB release
REM * Extrct path list has been change since last release 
REM * Extact the files
REM * Copy the HEAD file to DBrelease_RXXX_XXX_XXX
REM * Merge all the files in order to HEAD copy 
REM * Add the tail
REM *
REM


REM * Pre-config the usernname & password for SVN
echo.
echo Preparing for release, reading parameters. 

cd %~dp0
cd %cd%
set local=%cd%\
rem %~dp0
set path=%path%;%~dp0EXEs;
set changeList=%local%changeList.tmp
set tmpChange=%local%tmpChange\
set pathToTrunk=%local%pathToTrunk\
rem filesToRelease
set destFolder=%local%SQL
rem https://192.168.18.151/svn/syd/utils/sql/trunk/
set URL=UrlNotGiven
set Urlpath=/DB
set branchName=/trunk
set name=NameNotGiven  
set pwd=PasswordNotGiven  
set fromVer=fromVersionNotGiven
set toVer=toVersionNotGiven  
set currentVersion=HeadNotGiven
set fromTag=fromTagNotGiven
set tag=TagNotGiven

:readArg
if "%1" =="-name" goto getName
if "%1" =="-pwd" goto getPwd
if "%1" =="-url" goto getURL
if "%1" =="-urlpath" goto getURLpath
if "%1" =="-fromTag" goto getFromTag
if "%1" =="-from" goto getFromVer
if "%1" =="-to" goto getToVer
if "%1" =="-tag" goto getTag
if "%1" =="-dest" goto getDest
if "%1" =="-branchName" goto getBranchName

goto checkout

:getURL
if not "%1" == "-url" goto readArg
if "%1" == "-url" shift
if not .%1 == . (
	set URL=%1
	shift
)
goto readArg

:getURLPath
if not "%1" == "-urlpath" goto readArg
if "%1" == "-urlpath" shift
if not .%1 == . (
	set urlPath=/%1
	shift
)
goto readArg

:getName
if not "%1" == "-name" goto readArg
if "%1" == "-name" shift
if not .%1 == . (
	set name=%1
	shift
)
goto readArg

:getPwd
if not "%1" == "-pwd" goto readArg
if "%1" == "-pwd" shift
if not .%1 == . (
	set pwd=%1
	shift
)
goto readArg

:getFromVer
if not "%1" == "-from" goto readArg
if "%1" == "-from" shift
if not .%1 == . (
	set fromVer=%1
	shift
)
goto readArg

:getFromTag
if not "%1" == "-fromTag" goto readArg
if "%1" == "-fromTag" shift
if not .%1 == . (
	set fromTag=%1
	shift
)
goto readArg

:getToVer  
if not "%1" == "-to" goto readArg
if "%1" == "-to" shift
if not .%1 == . (
	set toVer=%1
	shift
) 
goto readArg

:getTag
if not "%1" == "-tag" goto readArg
if "%1" == "-tag" shift
if not .%1 == . (
	set tag=%1
	shift
)
goto readArg

:getDest
if not "%1" == "-dest" goto readArg
if "%1" == "-dest" shift
if not .%1 == . (
	set destFolder=%1
	shift
)
goto readArg

rem /trunk
:getBranchName
if not "%1" == "-branchName" goto readArg
if "%1" == "-branchName" shift
if not .%1 == . (
	set branchName=%1
	shift
)
goto readArg

:checkout
REM * Connect to control DB, get Last release number.

REM * Run update and get the latest version from SVN (checkout)


rem Clean up the old checkout, not necessary, just ensure that's a clean folder
rem if exist %pathToTrunk% del /F /Q %pathToTrunk%
if not exist %pathToTrunk% mkdir %pathToTrunk%
if exist %tmpChange% del /F /Q %tmpChange%
if not exist %tmpChange% mkdir %tmpChange%

if not "%fromTag%" == "fromTagNotGiven" (
	rem Look up the version from the given tag 
	echo P|svn info %url%/tags/%fromTag% --username %name% --password %pwd%| grep -i "Last Changed Rev" | cut -d " " -f4 > %tmpChange%versionNo.ini
	set /p fromVer=<%tmpChange%versionNo.ini
	rem if exist %tmpChange%versionNo.ini del /F /Q %tmpChange%versionNo.ini
) 

echo ******Check Parameters *********

if .%URL%==.UrlNotGiven goto help
if .%name%==.NameNotGiven goto help  
if .%pwd%==.PasswordNotGiven goto help
if .%fromVer%==.fromVersionNotGiven goto help
if .%toVer%==.toVersionNotGiven  goto help

echo Parameters OK. 

echo ******Getting the changes*******
cd %pathToTrunk%
echo checkout the %fromVer% version
rem this is DB release, only get the DB folder
rem %URL%/trunk/DB by default, and save it locally to folder trunk
echo P|svn checkout -r %fromVer% %URL%%branchName%%Urlpath% trunk --depth infinity --username %name% --password %pwd%
cd trunk
echo getting the changes between %fromVer% and %toVer% 
REM * Extract path list has been change since last release
rem checkout the file on HEAD, and record the list of file as change to %changeList%
svn update -r %toVer% --username %name% --password %pwd% |grep -i -G "^Updat" -v |grep -i -G "^At revision " -v |cut -c6- | sort > %changeList%
 
REM * Extract the files to %tmpChange% folder
rem copy the file one by one to tmpChanges
for /F "tokens=*" %%a in (%changeList%) do (
	echo %%a
	REM Skip if the %%a is a folder (SVN does allow changes in folder and/or its properties)
	if not exist "%%a"\* (
		if exist "%%a" (
			echo F|xcopy /Y /i /Q .\"%%a" "%tmpChange%%%a"
		)
	)
)
isqlw %changeList%

rem get the current version number
rem svn info|grep -i "revision"| cut -d" " -f2 > %local%versionNo.ini
svnversion > %local%versionNo.ini
set /p currentVersion=<%local%versionNo.ini

cd %local%

goto MergeChanges

:MergeChanges
echo ******Prepare SQLs *******
REM 
REM * constract the dbUpdate file
REM
set SQLoutput=%local%SQL
set DbUpdate=%SQLoutput%\SchemaRelease.sql
if not exist %SQLoutput% mkdir %SQLoutput%

echo For schema changes
REM * Put the Header
cd %tmpChange%
echo Get Header file
rem if not exist %tmpChange%Header.sql echo Header.sql is not updated 
rem if not exist %tmpChange%Header.sql goto end 
rem type %tmpChange%Header.sql > %DbUpdate%
rem read the version number from Header.sql
rem type %tmpChange%Header.sql | grep "VERSION Number"| cut -d: -f2- >%local%versionNumber.ini
rem set /P versionNumber=<%local%versionNumber.ini
echo ************The version number is: %versionNumber% *************************

rem Should not use table folder, we only use it to export the schema and import back to SVN 
rem echo Table> %local%DbUpdateList.txt
echo SchemaChange> %local%DbUpdateList.tmp
echo UserDefinedFunction>> %local%DbUpdateList.tmp
echo View>> %local%DbUpdateList.tmp
echo StoredProcedure>> %local%DbUpdateList.tmp
rem echo Trigger>> %local%DbUpdateList.tmp


rem read the list and merge all the file into Header + files + footer
for /F "tokens=*" %%n in (%local%DbUpdateList.tmp) do (
	echo reading %%n
	echo ---------------------------------------------------------- >> %DbUpdate%
	echo ------------------- %%n >> %DbUpdate%
	echo ---------------------------------------------------------- >> %DbUpdate%
	if exist %tmpChange%%%n (
		echo %tmpChange%%%n
		cd %tmpChange%%%n
		dir "%tmpChange%%%n" /ON /B /S /C /A-D
		if exist %tmpChange%%%n-fileList.idx.tmp del /F /Q %tmpChange%%%n-fileList.idx.tmp 
		dir "%tmpChange%%%n" /ON /B /S /C /A-D > %tmpChange%%%n-fileList.idx.tmp
		echo read %tmpChange%%%n-fileList.idx.tmp
		for /F "tokens=*" %%a in (%tmpChange%%%n-fileList.idx.tmp) do (
			echo Reading  %%a
			echo.  >> "%DbUpdate%"
			echo --------------------------------  >> "%DbUpdate%"
			echo -- %%a  >> "%DbUpdate%"
			echo --------------------------------  >> "%DbUpdate%"
			type "%%a" >> "%DbUpdate%"
			echo --------------------------------  >> "%DbUpdate%"
			echo -- END of %%a  >> "%DbUpdate%"
			echo --------------------------------  >> "%DbUpdate%"
			echo Finish %%a
			
			if .%%n==.SchemaChange (
				rem To clean all the changes from schemaChange
				echo.>%%a
				echo clean all updates in %%a
			)
		)
	)	
) 

REM * Footer File???
cd %tmpChange%
echo Get Footer file
rem if not exist %tmpChange%Footer.sql echo Footer.sql is not updated 
rem if not exist %tmpChange%Footer.sql goto end 
rem type %tmpChange%Footer.sql >> %DbUpdate%
echo Done schema changes 
echo.

echo For reference data changes 
rem echo ReferenceData> %local%RefDataList.tmp
rem echo Fix>> %local%RefDataList.tmp

rem read the list and copy the files to SQL output folder
for /F "tokens=*" %%n in (%local%RefDataList.tmp) do (
	echo reading %%n
	if exist %tmpChange%%%n (
		echo %tmpChange%%%n
		cd %tmpChange%%%n
		dir "%tmpChange%%%n" /ON /B /S /C /A-D
		if exist %tmpChange%%%n-RefFileList.idx.tmp del /F /Q %tmpChange%%%n-RefFileList.idx.tmp
		dir "%tmpChange%%%n" /ON /B /S /C /A-D > %tmpChange%%%n-RefFileList.idx.tmp
		echo read %tmpChange%%%n-RefFileList.idx.tmp
		for /F "tokens=*" %%a in (%tmpChange%%%n-RefFileList.idx.tmp) do (
			Rem check if the file is empty, if yes, ignore it
			if %%~za GTR 0 (
				echo copy file %%a with size %%~za 
				echo D|xcopy /Y /i /Q %%a  %SQLoutput%\%%n
				echo.> %%a			
			)
		)
	)	
) 

echo Done. Reference changes ready

cd %local%

goto saveSQL

echo ****** Save the SQL ******
echo this part requires update if using in Sydney/dev environment
echo TODO: rename the files for another tool to apply the SQL on target environment
rem sample:
if exist "%destFolder%" rmdir /s /q "%destFolder%"
if not exist "%destFolder%" mkdir "%destFolder%"
if exist "%SQLoutput%" (
	echo Copy file to output folder
	rem cp -r "%SQLoutput%" "%destFolder%"
	xcopy /Y /E /i /Q "%SQLoutput%" "%destFolder%"
)

:saveSQL
set dbscriptFolder=%tmpChange%\DbScripts
if not exist %dbscriptFolder% mkdir %dbscriptFolder%
echo 000 *SchemaRelease.sql > %tmpChange%SQLscriptList.idx
echo 001 *AppVersion.sql >> %tmpChange%SQLscriptList.idx
echo 002 *Common_RefData.sql >> %tmpChange%SQLscriptList.idx
echo 003 *Sys_RefData.sql >> %tmpChange%SQLscriptList.idx
echo 004 *Common_Fix.sql >> %tmpChange%SQLscriptList.idx
echo 005 *Sys_Fix.sql >> %tmpChange%SQLscriptList.idx

for /F "tokens=1,2" %%a in (%tmpChange%SQLscriptList.idx) do (
	echo Copying %%n
	rem echo order=%%a
	rem echo pattern=%%b
	
	cd %SQLoutput%
	dir %SQLoutput%\%%b /ON /B /S /C /A-D>%tmpChange%Script.idx.tmp
	if exist %tmpChange%Script.idx.tmp (
		type %tmpChange%Script.idx.tmp
		for /F "tokens=*" %%n in (%tmpChange%Script.idx.tmp) do (
			if exist %%n ( 
				dir %%n /B >%tmpChange%filename.tmp
				type %tmpChange%filename.tmp
				for /F "tokens=*" %%x in (%tmpChange%filename.tmp) do (
					echo copy file %fileName%
					echo F|xcopy /Y /i /Q %%n %dbscriptFolder%\%versionNumber%_%%a_%%x
				)
			) 
		)
	)
	if exist %tmpChange%Script.idx.tmp del /Q /F %tmpChange%Script.idx.tmp
)
goto runSQL

:runSQL
echo ****** Testing SQL in control DB ******
echo this part is not done yet;
echo TODO: connect to SQL and test the sqls in control DB
rem check %SQLoutput% run SQL to control DB
cd %dbscriptFolder%
dir %dbscriptFolder% /ON /B /S /C /A-D | sort> %tmpChange%SQL_list.idx.tmp
echo -------------------------------------------
echo Run in control DB using SQL %tmpChange%SQL_list.idx.tmp
for /F "tokens=*" %%a in (%tmpChange%SQL_list.idx.tmp) do (
	echo ------Applying %%a
	isqlw %%a
	echo ------Finish %%a
	
	if .%%n==.SchemaChange (
		rem To clean all the changes from schemaChange
		echo.>%%a
		echo clean all updates in %%a
	)
)
echo End of apply SQL in control DB
echo -------------------------------------------
goto tagVersion

:tagVersion
REM * Tag the HEAD with new version number for DB release
if "%tag%" == "TagNotGiven" echo Tag is not given, skip tagging 
if "%tag%" == "TagNotGiven" goto endTagVersion
if .%currentVersion%==.HeadNotGiven echo Unable to find the current version 
if .%currentVersion%==.HeadNotGiven goto help
echo ******Tag the version %Tag%*******
echo ------Check the tag if already exists
REM Check if the tag already exists
REM if exists, gives warning and return
svn info %url%/tags/%tag% --username %name% --password %pwd% > %tmpChange%\svnInfo%tag%.tmp 
if %errorlevel% == 0 (
	type %tmpChange%\svnInfo%tag%.tmp
	echo STOP: Tag version already exists, please check.
	goto End
)

echo ------Ignore the error above, we are creating a new tag, start to label the new Tag
REM When we tag, we are tagging the entire trunk 
svn copy -r %currentVersion% %url%/trunk %url%/tags/%tag% --username %name% --password %pwd% -m "Tag the version %tag%"
echo Done. Tagged version %tag% at %url%/tags/%tag%
:endTagVersion

goto copySQL

:copySQL
echo ************The version number is: %versionNumber% *************************
echo.
echo ****** Copy the SQL ******
rem sample:
if exist "%destFolder%" rmdir /s /q "%destFolder%"
if not exist "%destFolder%" mkdir "%destFolder%"
if exist "%dbscriptFolder%" (
	echo Copy file to output folder
	rem cp -r "%SQLoutput%" "%destFolder%"
	xcopy /Y /E /i /Q "%dbscriptFolder%" "%destFolder%"
)


goto End
rem if not exist "%DbUpdate%" echo Unable to find Dbupdate file
rem if not exist "%DbUpdate%" goto End
rem echo F|xcopy /Y /i /Q %DbUpdate% %destFolder%%tag%_000_dbUpdates.sql



rem for /F "tokens=*" %%n in (%local%RefDataList.tmp) do () 



rem clean up: clear the cached pwd

:help
echo -name [name]
echo login to SVN using [name]
echo -pwd [password]
echo login to SVN using [password]
echo -url [url]
echo login to SVN in [url]
echo -urlPath [urlPath] (Optional)
echo The path from [url]/trunk to the folder you want to be checkout, by default: /DB
echo -from [fromVersion]
echo Reference start version
echo -to [toVersion]
echo Reference end version
echo -tag [tag] (Optional)
echo the name of the label, if ignored, No tag will be created.
echo -Dest [Folder] 
echo Where to save the output files
echo.
echo Exmple: 
echo DBrelease.bat -name yourname -pwd "password here" -url https://192.168.18.151/svn/syd/utils/sql -fromTag R1.0.1 -to HEAD -dest SQLoutput -tag R1.0.5
echo.
echo c:\pb11_svn\Trunk\PBSVN\Tool\DbReleaseTool\DBrelease.bat -name name -pwd "my password" -url https://192.168.18.151/svn/syd/project1 -from 389 -to HEAD -dest s:\temp\DbreleaseSQL
echo URL to the root of repository, i.e. https://10.9.0.1/svn/repo/ecommerce/em-squared
echo You should only see 3 folder within: branches, tags, trunk
echo Note: No "/" at the end of URL
echo.
echo to
echo.
echo URL
echo +--- branches
echo +--- tags
echo \--- trunk
echo 		+--- DB (this is the default UrlPath, start with / and end without / )
echo 		\--- otherFolder
echo
echo ****** Clean up before finish
:End
cd %local%
rem if exist "%AppData%\Subversion\auth" rmdir /s /q "%AppData%\Subversion\auth"
if exist "%pathToTrunk%" rmdir /s /q "%pathToTrunk%"
if exist "%SQLoutput%" rmdir /s /q "%SQLoutput%"
if exist "%tmpChange%" rmdir /s /q "%tmpChange%"
if exist "%local%\changeList.tmp" del /Q /F "%local%\changeList.tmp"
if exist "%local%\DbUpdateList.tmp" del /Q /F "%local%\DbUpdateList.tmp"
if exist "%local%\RefDataList.tmp" del /Q /F "%local%\RefDataList.tmp"
if exist "%local%\RefDataList.txt" del /Q /F "%local%\RefDataList.txt"

REM * Merge all the files in order to HEAD copy 
REM * Add the tail
endlocal
