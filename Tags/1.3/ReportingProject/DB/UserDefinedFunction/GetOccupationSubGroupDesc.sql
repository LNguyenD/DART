/****** Object:  UserDefinedFunction [dbo].[udf_GetOccupationSubGroupDesc]    Script Date: 12/29/2011 09:31:35 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_GetOccupationSubGroupDesc]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_GetOccupationSubGroupDesc]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_GetOccupationSubGroupDesc]    Script Date: 12/29/2011 09:31:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[udf_GetOccupationSubGroupDesc](@occupation_code varchar(50))
	returns varchar(300)
as
begin
	return CASE WHEN @occupation_code like '11%' THEN '11 Chief Executives, General Managers and Legislators'
				WHEN @occupation_code like '12%' THEN '12 Farmers and Farm Managers'
				WHEN @occupation_code like '13%' THEN '13 Specialist Managers'
				WHEN @occupation_code like '14%' THEN '14 Hospitality, Retail and Service Managers'
				WHEN @occupation_code like '21%' THEN '21 Arts and Media Professionals'
				WHEN @occupation_code like '22%' THEN '22 Business, Human Resource and Marketing Professionals'
				WHEN @occupation_code like '23%' THEN '23 Design, Engineering, Science and Transport Professionals'
				WHEN @occupation_code like '24%' THEN '24 Education Professionals'				
				WHEN @occupation_code like '25%' THEN '25 Health Professionals'
				WHEN @occupation_code like '26%' THEN '26 ICT Professionals'
				WHEN @occupation_code like '27%' THEN '27 Legal, Social and Welfare Professionals'
				WHEN @occupation_code like '31%' THEN '31 Engineering, ICT and Science Technicians'
				WHEN @occupation_code like '32%' THEN '32 Automotive and Engineering Trades Workers'
				WHEN @occupation_code like '33%' THEN '33 Construction Trades Workers'
				WHEN @occupation_code like '34%' THEN '34 Electrotechnology and Telecommunications Trades Workers'
				WHEN @occupation_code like '35%' THEN '35 Food Trades Workers'
				WHEN @occupation_code like '36%' THEN '36 Skilled Animal and Horticultural Workers'
				WHEN @occupation_code like '39%' THEN '39 Other Technicians and Trades Workers'
				WHEN @occupation_code like '41%' THEN '41 Health and Welfare Support Workers'
				WHEN @occupation_code like '42%' THEN '42 Carers and Aides'
				WHEN @occupation_code like '43%' THEN '43 Hospitality Workers'
				WHEN @occupation_code like '44%' THEN '44 Protective Service Workers'				
				WHEN @occupation_code like '45%' THEN '45 Sports and Personal Service Workers'
				WHEN @occupation_code like '51%' THEN '51 Office Managers and Program Administrators'
				WHEN @occupation_code like '52%' THEN '52 Personal Assistants and Secretaries'
				WHEN @occupation_code like '53%' THEN '53 General Clerical Workers'
				WHEN @occupation_code like '54%' THEN '54 Inquiry Clerks and Receptionists'
				WHEN @occupation_code like '55%' THEN '55 Numerical Clerks 4'
				WHEN @occupation_code like '56%' THEN '56 Clerical and Office Support Workers'
				WHEN @occupation_code like '59%' THEN '59 Other Clerical and Administrative Workers'
				WHEN @occupation_code like '61%' THEN '61 Sales Representatives and Agents'
				WHEN @occupation_code like '62%' THEN '62 Sales Assistants and Salespersons'				
				WHEN @occupation_code like '63%' THEN '63 Sales Support Workers'
				WHEN @occupation_code like '71%' THEN '71 Machine and Stationary Plant Operators'
				WHEN @occupation_code like '72%' THEN '72 PMobile Plant Operators'
				WHEN @occupation_code like '73%' THEN '73 Road and Rail Drivers'
				WHEN @occupation_code like '74%' THEN '74 Storepersons'
				WHEN @occupation_code like '81%' THEN '81 Cleaners and Laundry Workers'
				WHEN @occupation_code like '82%' THEN '82 Construction and Mining Labourers'
				WHEN @occupation_code like '83%' THEN '83 Factory Process Workers'
				WHEN @occupation_code like '84%' THEN '84 Farm, Forestry and Garden Workers'
				WHEN @occupation_code like '85%' THEN '85 Food Preparation Assistants'
				WHEN @occupation_code like '89%' THEN '89 Other Labourers'
				WHEN @occupation_code like '99%' THEN '99 Others'			
		END
end

GO

GRANT  EXECUTE  ON [dbo].[udf_GetOccupationSubGroupDesc]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[udf_GetOccupationSubGroupDesc]  TO [emius]
GO