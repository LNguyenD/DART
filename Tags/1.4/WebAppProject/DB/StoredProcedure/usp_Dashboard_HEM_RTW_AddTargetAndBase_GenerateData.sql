SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
-- execute [usp_Dashboard_HEM_RTW_AddTargetAndBase] 2013, 2
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_HEM_RTW_AddTargetAndBase_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_HEM_RTW_AddTargetAndBase_GenerateData]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_HEM_RTW_AddTargetAndBase_GenerateData]

AS
BEGIN
	DELETE FROM [dbo].[HEM_RTW_Target_Base]
	DBCC CHECKIDENT('HEM_RTW_Target_Base', RESEED, 0)
	
	INSERT INTO [HEM_RTW_Target_Base]([Type], [Value], [Sub_Value], 
				[Measure], [Target], [Base],[Create_Date],Remuneration)
	
	-- HEM --
	SELECT [Type] = ''
		   ,[Value] = 'Hospitality'
		   ,[Sub_Value] = NULL
		   ,[Measure]= tmp.measure 	   
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))
		 			   FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							)
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))*1.15
						FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							)					
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END 
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select [Value]='') as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp

	-- Group --
	UNION ALL
	SELECT [Type] = 'group'
		   ,[Value] = tmp.[group] 
		   ,[Sub_Value] = NULL
		   ,[Measure]= tmp.measure 	   
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))
		 			   FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.[group]) =RTRIM([group]))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))*1.15
						FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.[group]) =RTRIM([group]))					
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END 
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select distinct  [group] from HEM_RTW) as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp
		
	-- Portfolio --
	UNION ALL
	SELECT [Type] = 'portfolio'
		   ,[Value] = tmp.Portfolio 
		   ,[Sub_Value] = NULL
		   ,[Measure]= tmp.measure 	   
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))
		 			   FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.Portfolio) =RTRIM(Portfolio))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))*1.15
						FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.Portfolio) =RTRIM(Portfolio))
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END 
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select distinct  [Portfolio] from HEM_RTW) as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp
		
	-- Portfolio: Hotel Summary --
	UNION ALL
	SELECT [Type] = 'portfolio'
		   ,[Value] = 'Hotel'
		   ,[Sub_Value] = NULL
		   ,[Measure]= tmp.measure
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))
		 			   FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(Portfolio) in ('Accommodation','Pubs, Taverns and Bars'))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))*1.15
						FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(Portfolio) in ('Accommodation','Pubs, Taverns and Bars'))
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END 
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select [Portfolio] = 'Hotel') as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp
		
	-- Account Manager --
	UNION ALL
	SELECT [Type] = 'account_manager'
		   ,[Value] = tmp.Account_Manager 
		   ,[Sub_Value] = NULL
		   ,[Measure]= tmp.measure 	   
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))
		 			   FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.Account_Manager) =RTRIM(Account_Manager))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))*1.15
						FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.Account_Manager) =RTRIM(Account_Manager))
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END 
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select distinct  [Account_Manager] from HEM_RTW) as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp

	-- Group -> Team --
	UNION ALL
	SELECT [Type] = 'group'
		   ,[Value] = tmp.[group]
		   ,[Sub_Value] = tmp.Team
		   ,[Measure]= tmp.measure 	   
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))
		 			   FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.[group]) =RTRIM([group])
							AND RTRIM(tmp.[Team]) =RTRIM([Team]))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))*1.15
						FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.[group]) =RTRIM([group])
							AND RTRIM(tmp.[Team]) =RTRIM([Team]))					
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END 
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select distinct  [group],[Team] from HEM_RTW) as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp

	-- Portfolio - Employer Size --
	UNION ALL
	SELECT [Type] = 'portfolio'
		   ,[Value] = tmp.Portfolio 
		   ,[Sub_Value] = tmp.EMPL_SIZE
		   ,[Measure]= tmp.measure 	   
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))
		 			   FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.Portfolio) =RTRIM(Portfolio)
							AND RTRIM(tmp.EMPL_SIZE) =RTRIM(EMPL_SIZE))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))*1.15
						FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.Portfolio) =RTRIM(Portfolio)
							AND RTRIM(tmp.EMPL_SIZE) =RTRIM(EMPL_SIZE))
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar)
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select distinct  [Portfolio],[EMPL_SIZE] from HEM_RTW) as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp
		
	--Account Manager - Employer Size--
	UNION ALL
	SELECT [Type] = 'account_manager'
		   ,[Value] = tmp.Account_Manager 
		   ,[Sub_Value] = tmp.EMPL_SIZE
		   ,[Measure]= tmp.measure
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))
		 			   FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.Account_Manager) =RTRIM(Account_Manager)
							AND RTRIM(tmp.EMPL_SIZE) =RTRIM(EMPL_SIZE))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))*1.15
						FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.Account_Manager) =RTRIM(Account_Manager)
							AND RTRIM(tmp.EMPL_SIZE) =RTRIM(EMPL_SIZE))
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select distinct  [Account_Manager],[EMPL_SIZE] from HEM_RTW) as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp
END


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
