	-- exclude claims are closed before October 2010
	if not exists(	select * from CONTROL
				where TYPE like '%Constants%'
				 and ITEM = 'DateClaimClosed') begin
		insert into CONTROL values ('Constants', 'DateClaimClosed', '9/30/2010 23:59:59', NULL)
	end
	-- payment group report 4.36
	if not exists(	select * from CONTROL
				where TYPE like '%ptype%'
				 and ITEM = 'PerfTotalClmsCosts') begin
		insert into CONTROL values ('PTypeList', 'PerfTotalClmsCosts',
		'*WPT?*WPP?*WPI?*PAS?*CLP*WCO?*PTA?*PTX?*CHA?*CHX?*DEN?*EPA?*OSA?*OSX?*RMA?*OPT?*OTT?*OAS?*NUR001*DOA?*PCA001*HVM?*MOB001*OAD001*AID001*OR?*VWT?*VRE?*VEQ001*VJC001*TRA?*INT001*WIG?*WIS?*WIE?*IIN101*IIN104*IIN105*IMG?*IMS?*IIN102*IIN106*IIN107*PUH?*PBI?*PSI?*PHR?*PTH?*RFD?*SCP?*RPE001*RCL001*RSC?*RES?*ROP001*'
		, NULL)
	end

	-- payment group report 4.37
	if not exists(	select * from CONTROL
				where TYPE like '%ptype%'
				 and ITEM = 'PerfWklyBbfPmntsBd') begin
		insert into CONTROL values ('PTypeList', 'PerfWklyBbfPmntsBd',
		'*WPT001*WPT002*WPT003*WPT004*WPP001*WPP002*WPP003*WPP004*'
		, NULL)
	end
	
	-- payment group report 4.38
	if not exists(	select * from CONTROL
				where TYPE like '%ptype%'
				 and ITEM = 'PerfMedicalPmntsBd') begin
		insert into CONTROL values ('PTypeList', 'PerfMedicalPmntsBd',
		'*55*WCO?*PTA?*PTX?*CHA?*CHX?*DEN?*EPA?*OSA?*OSX?*RMA?*OPT?*OTT?*OAS?*DOA?*NUR001*PCA001*HVM?*OAD001*MOB001*PUH?*PBI?*PSI?*PHR?*PTH?*'
		, NULL)
	end