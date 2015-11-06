SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		Dustin (DART)
-- CREATE date: 07/27/2015 10:00:00
-- Description:	SQL View to retrieve the estimates detail information
-- =============================================
IF EXISTS(SELECT * FROM sys.views WHERE name = 'vw_WOW_Estimates_Detail')
	DROP VIEW [dbo].[vw_WOW_Estimates_Detail]
GO
	CREATE VIEW [dbo].[vw_WOW_Estimates_Detail] 
	AS
    SELECT  E.EstimateID,
			D.Claim, 
			D.JurisdictionCode,
			E.ClaimID,
			T.EstimateCategoryId,
			C.[Description] AS EST_Category, 
			T.Id AS Estimate_Type, 
			T.[Description] AS EST_TYPE,
			E.EstDate,
			SUM(I.ItemCost) as ESTIMATE,
			SUM(I.ToDate) as PAID,
			SUM(I.Total) AS INCURRED
	FROM	vw_Shared_EstimatesCategories As C
			INNER JOIN vw_Shared_EstimatesTypes AS T ON C.Id = T.EstimateCategoryId
			INNER JOIN AccEstScenarioItem AS I ON T.Id = I.EstSummary
			INNER JOIN AccEstScenario AS S ON S.ScenarioID = I.ScenarioID 
			INNER JOIN AccEstimate AS E ON E.EstimateID = S.EstimateID
			INNER JOIN AccData AS D ON E.ClaimID = D.ClaimID
	GROUP BY	e.EstimateID, D.Claim, D.JurisdictionCode, e.ClaimID, c.Id, 
				c.[Description], t.[Description], t.Id, e.EstDate,t.EstimateCategoryId
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO