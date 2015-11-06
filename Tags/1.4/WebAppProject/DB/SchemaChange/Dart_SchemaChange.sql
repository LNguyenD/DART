--'delete FK constraint & SystemId column on Reports table'
IF EXISTS (SELECT * 
           FROM sys.foreign_keys 
           WHERE object_id = OBJECT_ID(N'[dbo].[FK_Reports_Systems]') 
             AND parent_object_id = OBJECT_ID(N'[dbo].[Reports]'))
BEGIN
   ALTER TABLE Reports drop FK_Reports_Systems
END

IF COL_LENGTH('Reports','SystemId') IS NOT NULL
BEGIN
	ALTER TABLE dbo.Reports DROP COLUMN SystemId
END

---Update Not assigned to Miscellaneous for old data existing--

Update TMF_AWC set [group] = 'Miscellaneous' where [group] like '%Not assigned%'
Update TMF_RTW set [group] = 'Miscellaneous' where [group] like '%Not assigned%'
Update TMF_AWC set [Team] = 'Miscellaneous' where [Team] like '%Not assigned%'
Update TMF_RTW set [Team] = 'Miscellaneous' where [Team] like '%Not assigned%'

Update EML_AWC set [group] = 'Miscellaneous' where [group] like '%Not assigned%'
Update EML_RTW set [group] = 'Miscellaneous' where [group] like '%Not assigned%'
Update EML_AWC set [Team] = 'Miscellaneous' where [Team] like '%Not assigned%'
Update EML_RTW set [Team] = 'Miscellaneous' where [Team] like '%Not assigned%'

Update HEM_AWC set [group] = 'Miscellaneous' where [group] like '%Not assigned%'
Update HEM_RTW set [group] = 'Miscellaneous' where [group] like '%Not assigned%'
Update HEM_AWC set [Team] = 'Miscellaneous' where [Team] like '%Not assigned%'
Update HEM_RTW set [Team] = 'Miscellaneous' where [Team] like '%Not assigned%'

Update HEM_AWC set [group] = 'Miscellaneous' where [group] not like 'hosp%'
Update HEM_RTW set [group] = 'Miscellaneous' where [group] not like 'hosp%'
Update HEM_Portfolio set [group] = 'Miscellaneous'  where [group] not like 'hosp%'

Update EML_AWC set [group] = 'Miscellaneous' where ([group] not like 'wcnsw%' or rtrim([group])='wcnsw(group)')
Update EML_RTW set [group] = 'Miscellaneous' where ([group] not like 'wcnsw%' or rtrim([group])='wcnsw(group)')
Update EML_Portfolio set [group] = 'Miscellaneous' where ([group] not like 'wcnsw%' or rtrim([group])='wcnsw(group)')

--Update TMF mapping between group & team
Update TMF_AWC set [Group] = (case when RTRIM(ISNULL(Team, '')) = '' 
										then 'Miscellaneous'
									when PATINDEX('%[A-Z]%',RTRIM(Team)) < 1
										then RTRIM(Team)
									when PATINDEX('%[A-Z]%',RTRIM(Team)) >= 1
										then(
											case when PATINDEX('%[A-Z]%',REPLACE(Team,'tmf','')) >=2 
													then 
													(
														case when PATINDEX('%[A-Z]%',SUBSTRING(REPLACE(Team,'tmf',''),1,PATINDEX('%[A-Z]%',REPLACE(Team,'tmf',''))-1)) <1
															then RTRIM(SUBSTRING(REPLACE(Team,'tmf',''),1,PATINDEX('%[A-Z]%',REPLACE(Team,'tmf',''))-1))
														else 'Miscellaneous' end
													)
													
											else 												 
													(case when PATINDEX('%[A-Z]%',RTRIM(REPLACE(Team,'tmf',''))) <1
														then RTRIM(REPLACE(Team,'tmf',''))
													else 'Miscellaneous' end)										
									end
										)
								end)

Update TMF_RTW set [Group] = (case when RTRIM(ISNULL(Team, '')) = '' 
										then 'Miscellaneous'
									when PATINDEX('%[A-Z]%',RTRIM(Team)) < 1
										then RTRIM(Team)
									when PATINDEX('%[A-Z]%',RTRIM(Team)) >= 1
										then(
											case when PATINDEX('%[A-Z]%',REPLACE(Team,'tmf','')) >=2 
													then 
													(
														case when PATINDEX('%[A-Z]%',SUBSTRING(REPLACE(Team,'tmf',''),1,PATINDEX('%[A-Z]%',REPLACE(Team,'tmf',''))-1)) <1
															then RTRIM(SUBSTRING(REPLACE(Team,'tmf',''),1,PATINDEX('%[A-Z]%',REPLACE(Team,'tmf',''))-1))
														else 'Miscellaneous' end
													)
													
											else 												 
													(case when PATINDEX('%[A-Z]%',RTRIM(REPLACE(Team,'tmf',''))) <1
														then RTRIM(REPLACE(Team,'tmf',''))
													else 'Miscellaneous' end)										
									end
										)
								end)
								
Update TMF_Portfolio set [Group] = (case when RTRIM(ISNULL(Team, '')) = '' 
										then 'Miscellaneous'
									when PATINDEX('%[A-Z]%',RTRIM(Team)) < 1
										then RTRIM(Team)
											when PATINDEX('%[A-Z]%',RTRIM(Team)) >= 1
												then(
													case when PATINDEX('%[A-Z]%',REPLACE(Team,'tmf','')) >=2 
															then 
															(
																case when PATINDEX('%[A-Z]%',SUBSTRING(REPLACE(Team,'tmf',''),1,PATINDEX('%[A-Z]%',REPLACE(Team,'tmf',''))-1)) <1
																	then RTRIM(SUBSTRING(REPLACE(Team,'tmf',''),1,PATINDEX('%[A-Z]%',REPLACE(Team,'tmf',''))-1))
																else 'Miscellaneous' end
															)
															
													else 												 
															(case when PATINDEX('%[A-Z]%',RTRIM(REPLACE(Team,'tmf',''))) <1
																then RTRIM(REPLACE(Team,'tmf',''))
															else 'Miscellaneous' end)										
											end
												)
										end)


