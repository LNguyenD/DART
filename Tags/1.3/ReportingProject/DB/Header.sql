
/************************************************************************************
STATUS:		Db Release
AUTHOR:		Auto Created from VSS 
DATE: 		28/10/2011
VERSION Number: 	1.0.0
DATABASE Name:			
DESCRIPTION:  	
************************************************************************************/
---	Changes 
------------------------------------------------------------------------------------	 

   
SET ANSI_PADDING OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO
SET NOCOUNT ON
GO

------------------------------------------------------------------------------------	
--	check db version number
------------------------------------------------------------------------------------
SELECT LTRIM(RTRIM(Object_Version_No))FROM RELEASE_VERSION WHERE Object_Code = 'MSSQL_DB' AND (CONVERT(INT,LEFT(LTRIM(RTRIM(Object_Version_No)),CHARINDEX('.', LTRIM(RTRIM(Object_Version_No)))-1)) * 1000000 )+(CONVERT(INT,SUBSTRING(LTRIM(RTRIM(Object_Version_No)),CHARINDEX('.', LTRIM(RTRIM(Object_Version_No)))+1, LEN(LTRIM(RTRIM(Object_Version_No))) - CHARINDEX('.', LTRIM(RTRIM(Object_Version_No))) - CHARINDEX('.', REVERSE(LTRIM(RTRIM(Object_Version_No))))))* 1000)+ CONVERT(INT,RIGHT(LTRIM(RTRIM(Object_Version_No)),CHARINDEX('.', REVERSE(LTRIM(RTRIM(Object_Version_No))))-1)) = (SELECT MAX((CONVERT(INT,LEFT(LTRIM(RTRIM(Object_Version_No)),CHARINDEX('.', LTRIM(RTRIM(Object_Version_No)))-1)) * 1000000 )+(CONVERT(INT,SUBSTRING(LTRIM(RTRIM(Object_Version_No)),CHARINDEX('.', LTRIM(RTRIM(Object_Version_No)))+1, LEN(LTRIM(RTRIM(Object_Version_No))) - CHARINDEX('.', LTRIM(RTRIM(Object_Version_No))) - CHARINDEX('.', REVERSE(LTRIM(RTRIM(Object_Version_No))))))* 1000)+ CONVERT(INT,RIGHT(LTRIM(RTRIM(Object_Version_No)),CHARINDEX('.', REVERSE(LTRIM(RTRIM(Object_Version_No))))-1)))FROM RELEASE_VERSION WHERE Object_Code = 'MSSQL_DB')
  
GO
	
