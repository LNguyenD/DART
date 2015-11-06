IF EXISTS(select * FROM sys.views where name = 'uv_PORT_Get_All_Claim_Type')
	DROP VIEW [dbo].[uv_PORT_Get_All_Claim_Type]
GO

/****** Object:  UserDefinedFunction [dbo].[uv_PORT_Get_All_Claim_Type]    Script Date: 12/30/2013 17:12:04 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE VIEW [dbo].[uv_PORT_Get_All_Claim_Type]
AS
		-- NEW CLAIMS
		SELECT  Claim_Type = 'claim_new_all'
		union SELECT Claim_Type = 'claim_new_nlt'
		union SELECT Claim_Type = 'claim_new_lt'
		
		-- BEGIN: OPEN CLAIMS	
			
		union SELECT Claim_Type = 'claim_open_all'
		union SELECT Claim_Type = 'claim_open_nlt'
		
		-- OPEN CLAIMS: NCMM
		union SELECT Claim_Type = 'claim_open_ncmm_this_week'
		union SELECT Claim_Type = 'claim_open_ncmm_next_week'
		
		-- OPEN CLAIMS: RTW
		union SELECT Claim_Type = 'claim_open_0_13'
		union SELECT Claim_Type = 'claim_open_13_26'
		union SELECT Claim_Type = 'claim_open_26_52'
		union SELECT Claim_Type = 'claim_open_52_78'
		union SELECT Claim_Type = 'claim_open_0_78'
		union SELECT Claim_Type = 'claim_open_78_130'
		union SELECT Claim_Type = 'claim_open_gt_130'
		
		-- OPEN CLAIMS: THERAPY TREATMENTS
		union SELECT Claim_Type = 'claim_open_acupuncture'
		union SELECT Claim_Type = 'claim_open_chiro'
		union SELECT Claim_Type = 'claim_open_massage'
		union SELECT Claim_Type = 'claim_open_osteo'
		union SELECT Claim_Type = 'claim_open_physio'
		union SELECT Claim_Type = 'claim_open_rehab'
		
		-- OPEN CLAIMS: LUMP SUM INTIMATIONS
		union SELECT Claim_Type = 'claim_open_death'
		union SELECT Claim_Type = 'claim_open_industrial_deafness'
		union SELECT Claim_Type = 'claim_open_ppd'
		union SELECT Claim_Type = 'claim_open_recovery'
		
		-- OPEN CLAIMS: LUMP SUM INTIMATIONS - WPI
		union SELECT Claim_Type = 'claim_open_wpi_all'
		union SELECT Claim_Type = 'claim_open_wpi_0_10'
		union SELECT Claim_Type = 'claim_open_wpi_11_14'
		union SELECT Claim_Type = 'claim_open_wpi_15_20'
		union SELECT Claim_Type = 'claim_open_wpi_21_30'
		union SELECT Claim_Type = 'claim_open_wpi_31_more'
		
		union SELECT Claim_Type = 'claim_open_wid'
		
		-- END: OPEN CLAIMS
		
		-- CLAIM CLOSURES
		union SELECT Claim_Type = 'claim_closure'
		union SELECT Claim_Type = 'claim_re_open'
		union SELECT Claim_Type = 'claim_still_open'

GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO