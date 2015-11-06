echo "merge store scripts"
D:\Working\ecommerce\em-reporting\trunk\WebAppProject\MergeSQLs\bin\Debug\MergeSQLs.exe  D:\Working\ecommerce\em-reporting\trunk\ReportingProject\DB\StoredProcedure Stores.sql
echo "merge UDF scripts"
D:\Working\ecommerce\em-reporting\trunk\WebAppProject\MergeSQLs\bin\Debug\MergeSQLs.exe D:\Working\ecommerce\em-reporting\trunk\ReportingProject\DB\UserDefinedFunction udf.sql
echo "Run UDF scripts"  
sqlcmd -S 10.9.0.21 -U vnteam -P vnteam -d emiprod -i D:\Working\ecommerce\em-reporting\trunk\ReportingProject\DB\UserDefinedFunction\udf.sql
echo "Run Store scripts" 
sqlcmd -S 10.9.0.21 -U vnteam -P vnteam -d emiprod -i D:\Working\ecommerce\em-reporting\trunk\ReportingProject\DB\StoredProcedure\Stores.sql
pause