
------------------------------------------------------------------------------------
---	Update version_control Table    ---
------------------------------------------------------------------------------------
-- Claim System 

INSERT INTO Release_Version (Release_Version_No,Object_Code,Object_Version_No,LastModifiedDate,Owner)
VALUES ('00.01.00','MSSQL_DB','1.0.0',Getdate(),'DBA') 

SELECT LTRIM(RTRIM(Object_Version_No))FROM RELEASE_VERSION WHERE Object_Code = 'MSSQL_DB' AND (CONVERT(INT,LEFT(LTRIM(RTRIM(Object_Version_No)),CHARINDEX('.', LTRIM(RTRIM(Object_Version_No)))-1)) * 1000000 )+(CONVERT(INT,SUBSTRING(LTRIM(RTRIM(Object_Version_No)),CHARINDEX('.', LTRIM(RTRIM(Object_Version_No)))+1, LEN(LTRIM(RTRIM(Object_Version_No))) - CHARINDEX('.', LTRIM(RTRIM(Object_Version_No))) - CHARINDEX('.', REVERSE(LTRIM(RTRIM(Object_Version_No))))))* 1000)+ CONVERT(INT,RIGHT(LTRIM(RTRIM(Object_Version_No)),CHARINDEX('.', REVERSE(LTRIM(RTRIM(Object_Version_No))))-1)) = (SELECT MAX((CONVERT(INT,LEFT(LTRIM(RTRIM(Object_Version_No)),CHARINDEX('.', LTRIM(RTRIM(Object_Version_No)))-1)) * 1000000 )+(CONVERT(INT,SUBSTRING(LTRIM(RTRIM(Object_Version_No)),CHARINDEX('.', LTRIM(RTRIM(Object_Version_No)))+1, LEN(LTRIM(RTRIM(Object_Version_No))) - CHARINDEX('.', LTRIM(RTRIM(Object_Version_No))) - CHARINDEX('.', REVERSE(LTRIM(RTRIM(Object_Version_No))))))* 1000)+ CONVERT(INT,RIGHT(LTRIM(RTRIM(Object_Version_No)),CHARINDEX('.', REVERSE(LTRIM(RTRIM(Object_Version_No))))-1)))FROM RELEASE_VERSION WHERE Object_Code = 'MSSQL_DB')
   
  


------------------------------------------------------------------------------------
SET ANSI_PADDING ON
GO
SET NOCOUNT OFF
GO
----------------------------------- End of Script ----------------------------------

