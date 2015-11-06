---------------------------------------------------------- 
------------------- SchemaChange 
---------------------------------------------------------- 
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\SchemaChange\EML_Agencies_Sub_Category.sql  
--------------------------------  
/****** Object:Table [dbo].[EML_Agencies_Sub_Category]Script Date: 01/28/2014 10:44:02 ******/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EML_Agencies_Sub_Category]') AND type in (N'U'))	
	DROP TABLE [dbo].[EML_Agencies_Sub_Category]
GO
/****** Object:  Table [dbo].[EML_Agencies_Sub_Category]    Script Date: 01/28/2014 10:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EML_Agencies_Sub_Category](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AgencyId] [varchar](20) NULL,
	[AgencyName] [char](20) NULL,
	[Sub_Category] [varchar](256) NULL,
	[POLICY_NO] [char](19) NULL,
 CONSTRAINT [PK_EML_Agencies_Sub_Category] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[EML_Agencies_Sub_Category] ON
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1194, N'10010', N'Other               ', N'Premier & Cabinet', N'WC900321           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1195, N'10015', N'Other               ', N'Premier & Cabinet', N'WC900331           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1196, N'10015', N'Other               ', N'Premier & Cabinet', N'WC900772           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1197, N'10020', N'Other               ', N'Premier & Cabinet', N'WC900665           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1198, N'10020', N'Other               ', N'Premier & Cabinet', N'WC900275           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1199, N'10025', N'Other               ', N'Premier & Cabinet', N'WC900773           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1200, N'10035', N'Other               ', N'Premier & Cabinet', N'WC900547           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1201, N'10045', N'Other               ', N'Premier & Cabinet', N'WC900327           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1202, N'10050', N'Other               ', N'Premier & Cabinet', N'WC900305           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1203, N'10052', N'Other               ', N'Premier & Cabinet', N'T10083             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1204, N'10060', N'Other               ', N'Premier & Cabinet', N'WC900311           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1205, N'10065', N'Other               ', N'Premier & Cabinet', N'WC900310           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1206, N'10069', N'Other               ', N'Planning & Local Government', N'WC900306           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1207, N'10069', N'Other               ', N'Planning & Local Government', N'WC900695           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1208, N'10090', N'Other               ', N'Planning & Local Government', N'WC900397           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1209, N'10090', N'Other               ', N'Planning & Local Government', N'WC900398           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1210, N'10090J', N'Health              ', N'Childrens Hospital', N'WC900246           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1211, N'10090J', N'Health              ', N'Childrens Hospital', N'T10078             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1212, N'10090J', N'Health              ', N'Childrens Hospital', N'T10029             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1213, N'10090J', N'Health              ', N'Childrens Hospital', N'WC900675           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1214, N'10090K', N'Health              ', N'Greater Southern Area', N'WC900376           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1215, N'10090K', N'Health              ', N'Greater Southern Area', N'WC900338           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1216, N'10090K', N'Health              ', N'Greater Southern Area', N'WC900202           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1217, N'10090K', N'Health              ', N'Greater Southern Area', N'T1                 ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1218, N'10090K', N'Health              ', N'Greater Southern Area', N'WC900362           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1219, N'10090K', N'Health              ', N'Greater Southern Area', N'WC900489           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1220, N'10090K', N'Health              ', N'Greater Southern Area', N'WC900370           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1221, N'10090K', N'Health              ', N'Greater Southern Area', N'WC900354           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1222, N'10090K', N'Health              ', N'Greater Southern Area', N'WC900186           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1223, N'10090K', N'Health              ', N'Greater Southern Area', N'WC900060           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1224, N'10090L', N'Health              ', N'Greater Western Area', N'WC900188           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1225, N'10090L', N'Health              ', N'Greater Western Area', N'WC900180           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1226, N'10090L', N'Health              ', N'Greater Western Area', N'WC900490           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1227, N'10090L', N'Health              ', N'Greater Western Area', N'WC900355           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1228, N'10090L', N'Health              ', N'Greater Western Area', N'WC900473           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1229, N'10090L', N'Health              ', N'Greater Western Area', N'WC900369           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1230, N'10090L', N'Health              ', N'Greater Western Area', N'WC900357           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1231, N'10090R', N'Health              ', N'Other', N'WC900359           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1232, N'10090R', N'Health              ', N'Other', N'WC900525           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1233, N'10090R', N'Health              ', N'Other', N'WC900356           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1234, N'10090R', N'Health              ', N'Other', N'WC900488           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1235, N'10090R', N'Health              ', N'Other', N'WC900494           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1236, N'10090R', N'Health              ', N'Other', N'WC900531           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1237, N'10090R', N'Health              ', N'Other', N'WC900472           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1238, N'10090R', N'Health              ', N'Other', N'WC900821           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1239, N'10090R', N'Health              ', N'Other', N'T10022             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1240, N'10090R', N'Health              ', N'Other', N'T10024             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1241, N'10090R', N'Health              ', N'Other', N'WC900034           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1242, N'10090R', N'Health              ', N'Other', N'WC900241           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1243, N'10090R', N'Health              ', N'Other', N'WC900340           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1244, N'10090S', N'Health              ', N'Sydney South West Area', N'WC900471           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1245, N'10090S', N'Health              ', N'Sydney South West Area', N'WC900486           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1246, N'10090S', N'Health              ', N'Sydney South West Area', N'WC900385           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1247, N'10090S', N'Health              ', N'Sydney South West Area', N'WC900605           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1248, N'10090Y', N'Health              ', N'Health Support', N'T10049             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1249, N'10090Y', N'Health              ', N'Health Support', N'T10034             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1250, N'10090Y', N'Health              ', N'Health Support', N'T10041             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1251, N'10090Y', N'Health              ', N'Health Support', N'T10047             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1252, N'10090Y', N'Health              ', N'Health Support', N'T10045             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1253, N'10090Y', N'Health              ', N'Health Support', N'T10042             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1254, N'10090Y', N'Health              ', N'Health Support', N'T10019             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1255, N'10090Y', N'Health              ', N'Health Support', N'T10033             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1256, N'10090Y', N'Health              ', N'Health Support', N'T10046             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1257, N'10090Y', N'Health              ', N'Health Support', N'T10032             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1258, N'10090Y', N'Health              ', N'Health Support', N'T10017             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1259, N'10090Y', N'Health              ', N'Health Support', N'T10020             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1260, N'10090Y', N'Health              ', N'Health Support', N'T10018             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1261, N'10090Y', N'Health              ', N'Health Support', N'T10043             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1262, N'10090Y', N'Health              ', N'Health Support', N'T10048             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1263, N'10090Y', N'Health              ', N'Health Support', N'T10021             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1264, N'10090Y', N'Health              ', N'Health Support', N'T10044             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1265, N'10090Y', N'Health              ', N'Health Support', N'T10028             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1266, N'10090Y', N'Health              ', N'Health Support', N'WC900352           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1267, N'10142', N'Other               ', N'Premier & Cabinet', N'MWJ3333309         ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1268, N'10250', N'Police              ', N'Northern Region', N'WC900727           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1269, N'10250', N'Police              ', N'Other', N'WC900723           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1270, N'10250', N'Police              ', N'Northern Region', N'WC900721           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1271, N'10250', N'Police              ', N'Northern Region', N'WC900724           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1272, N'10250', N'Police              ', N'Other', N'WC900731           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1273, N'10250', N'Police              ', N'Other', N'WC900734           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1274, N'10250', N'Police              ', N'Southern Region', N'WC900726           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1275, N'10250', N'Police              ', N'Other', N'WC900725           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1276, N'10250', N'Police              ', N'Other', N'WC900631           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1277, N'10250', N'Police              ', N'South West Metro', N'WC900728           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1278, N'10250', N'Police              ', N'Other', N'WC900722           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1279, N'10250', N'Police              ', N'Specialist Operations', N'WC900733           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1280, N'10250', N'Police              ', N'Other', N'WC900732           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1281, N'10250', N'Police              ', N'Other', N'WC900720           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1282, N'10250', N'Police              ', N'North West Metro', N'WC900729           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1283, N'10250', N'Police              ', N'Western Region', N'WC900730           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1284, N'10250', N'Police              ', N'Operation Support', N'WC900735           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1285, N'10250', N'Police              ', N'North West Metro', N'WC900540           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1286, N'10250', N'Police              ', N'Operation Support', N'WC900538           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1287, N'10250', N'Police              ', N'Other', N'WC900544           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1288, N'10250', N'Police              ', N'Western Region', N'WC900542           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1289, N'10250', N'Police              ', N'Other', N'WC900543           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1290, N'10250', N'Police              ', N'Southern Region', N'WC900541           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1291, N'10250', N'Police              ', N'Northern Region', N'WC900539           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1292, N'10250', N'Police              ', N'Other', N'WC900537           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1293, N'10250', N'Police              ', N'Other', N'WC900332           ')
GO
print 'Processed 100 total records'
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1294, N'10250', N'Police              ', N'Other', N'WC900264           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1295, N'10250', N'Police              ', N'North West Metro', N'WC900855           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1296, N'10250', N'Police              ', N'Western Region', N'WC900862           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1297, N'10250', N'Police              ', N'Northern Region', N'WC900856           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1298, N'10250', N'Police              ', N'Corporate Service', N'WC900861           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1299, N'10250', N'Police              ', N'Central Metro', N'WC900854           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1300, N'10250', N'Police              ', N'Specialist Operations', N'WC900859           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1301, N'10250', N'Police              ', N'Southern Region', N'WC900857           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1302, N'10250', N'Police              ', N'Operation Support', N'WC900860           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1303, N'10250', N'Police              ', N'South West Metro', N'MWJ3333297         ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1304, N'10255', N'Police              ', N'Other', N'WC900630           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1305, N'10260', N'Police              ', N'Emergency Services', N'WC900477           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1306, N'10260', N'Police              ', N'Emergency Services', N'WC900266           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1307, N'10265', N'Police              ', N'Emergency Services', N'T10082             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1308, N'10270', N'Other               ', N'Corrective Services', N'WC900594           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1309, N'10270', N'Other               ', N'Corrective Services', N'WC900592           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1310, N'10270', N'Other               ', N'Corrective Services', N'WC900595           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1311, N'10270', N'Other               ', N'Corrective Services', N'WC900593           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1312, N'10270', N'Other               ', N'Corrective Services', N'WC900790           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1313, N'10270', N'Other               ', N'Corrective Services', N'WC900596           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1314, N'10270', N'Other               ', N'Corrective Services', N'WC900789           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1315, N'10270', N'Other               ', N'Corrective Services', N'WC900597           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1316, N'10270', N'Other               ', N'Corrective Services', N'WC900276           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1317, N'10275', N'Other               ', N'Juvenile Justice', N'WC900536           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1318, N'10280', N'Other               ', N'Juvenile Justice', N'WC900302           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1319, N'10305', N'Other               ', N'Planning & Local Government', N'WC900871           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1320, N'10305', N'Other               ', N'Planning & Local Government', N'T10067             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1321, N'10305', N'Other               ', N'Planning & Local Government', N'WC900746           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1322, N'10305', N'Other               ', N'Planning & Local Government', N'MWJ3333320         ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1323, N'10305', N'Other               ', N'Planning & Local Government', N'MWJ3333319         ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1324, N'10355', N'Fire                ', N'Cancelled', N'WC900263           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1325, N'10355', N'Fire                ', N'Other', N'T10119             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1326, N'10355', N'Fire                ', N'Other', N'T10130             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1327, N'10355', N'Fire                ', N'South Metro', N'T10124             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1328, N'10355', N'Fire                ', N'West Metro', N'T10125             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1329, N'10355', N'Fire                ', N'Reginal West', N'T10128             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1330, N'10355', N'Fire                ', N'North Metro', N'T10123             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1331, N'10355', N'Fire                ', N'Regional South', N'T10127             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1332, N'10355', N'Fire                ', N'East Metro', N'T10122             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1333, N'10355', N'Fire                ', N'Other', N'T10118             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1334, N'10355', N'Fire                ', N'Other', N'T10117             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1335, N'10355', N'Fire                ', N'Other', N'T10129             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1336, N'10355', N'Fire                ', N'Other', N'T10116             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1337, N'10355', N'Fire                ', N'Other', N'T10120             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1338, N'10355', N'Fire                ', N'Other', N'T10131             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1339, N'10355', N'Fire                ', N'Other', N'T10121             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1340, N'10355', N'Fire                ', N'Regional North', N'T10126             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1341, N'10405', N'Fire                ', N'Rural Fire Services', N'WC900265           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1342, N'10460', N'Other               ', N'Planning & Local Government', N'WC900599           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1343, N'10475', N'Other               ', N'Planning & Local Government', N'WC900907           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1344, N'10500', N'Other               ', N'Planning & Local Government', N'WC900694           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1345, N'10500', N'Other               ', N'Planning & Local Government', N'MWJ3333294         ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1346, N'10594', N'Other               ', N'Planning & Local Government', N'T10087             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1347, N'10597', N'Other               ', N'Planning & Local Government', N'T10084             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1348, N'10644', N'Other               ', N'Planning & Local Government', N'T10132             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1349, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900010           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1350, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900011           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1351, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900816           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1352, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900662           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1353, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900702           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1354, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900230           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1355, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900245           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1356, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900235           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1357, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900530           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1358, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900371           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1359, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900386           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1360, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900366           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1361, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900422           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1362, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900577           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1363, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900451           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1364, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900817           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1365, N'15090A', N'Health              ', N'Sydeny Local Health District', N'T10076             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1366, N'15090A', N'Health              ', N'Sydeny Local Health District', N'T10096             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1367, N'15090A', N'Health              ', N'Sydeny Local Health District', N'T10135             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1368, N'15090A', N'Health              ', N'Sydeny Local Health District', N'T10134             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1369, N'15090A', N'Health              ', N'Sydeny Local Health District', N'T10133             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1370, N'15090A', N'Health              ', N'Sydeny Local Health District', N'T10095             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1371, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900007           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1372, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900008           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1373, N'15090A', N'Health              ', N'Sydeny Local Health District', N'T10092             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1374, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900252           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1375, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900059           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1376, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900074           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1377, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900780           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1378, N'15090A', N'Health              ', N'Sydeny Local Health District', N'T10058             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1379, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900533           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1380, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900437           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1381, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900436           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1382, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900501           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1383, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900372           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1384, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900500           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1385, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900499           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1386, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900390           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1387, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900534           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1388, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900056           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1389, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900233           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1390, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900238           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1391, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900228           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1392, N'15090B', N'Health              ', N'South Western Sydney LHD', N'T10014             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1393, N'15090B', N'Health              ', N'South Western Sydney LHD', N'T10059             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1394, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900686           ')
GO
print 'Processed 200 total records'
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1395, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900054           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1396, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900052           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1397, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900051           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1398, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900053           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1399, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900055           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1400, N'15090B', N'Health              ', N'South Western Sydney LHD', N'T10136             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1401, N'15090B', N'Health              ', N'South Western Sydney LHD', N'T10094             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1402, N'15090B', N'Health              ', N'South Western Sydney LHD', N'T10138             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1403, N'15090B', N'Health              ', N'South Western Sydney LHD', N'T10137             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1404, N'15090B', N'Health              ', N'South Western Sydney LHD', N'T10097             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1405, N'15090B', N'Health              ', N'South Western Sydney LHD', N'T10093             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1406, N'15090B', N'Health              ', N'South Western Sydney LHD', N'T10077             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1407, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900014           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1408, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900016           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1409, N'15090C', N'Health              ', N'South East Sydney LHD', N'T10113             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1410, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900017           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1411, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900013           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1412, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900677           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1413, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900676           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1414, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900678           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1415, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900674           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1416, N'15090C', N'Health              ', N'South East Sydney LHD', N'T10057             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1417, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900240           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1418, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900232           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1419, N'15090C', N'Health              ', N'South East Sydney LHD', N'T10115             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1420, N'15090C', N'Health              ', N'South East Sydney LHD', N'T10114             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1421, N'15090C', N'Health              ', N'South East Sydney LHD', N'T10112             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1422, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900015           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1423, N'15090C', N'Health              ', N'South East Sydney LHD', N'T10111             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1424, N'15090C', N'Health              ', N'South East Sydney LHD', N'T10110             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1425, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900082           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1426, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900058           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1427, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900057           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1428, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900079           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1429, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900392           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1430, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900440           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1431, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900452           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1432, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900818           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1433, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900822           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1434, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900820           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1435, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900193           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1436, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900038           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1437, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900036           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1438, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900035           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1439, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'T10107             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1440, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'T10106             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1441, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'T10105             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1442, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'T10104             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1443, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900041           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1444, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900040           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1445, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900039           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1446, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900037           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1447, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900033           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1448, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'T10109             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1449, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'T10108             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1450, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900749           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1451, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'T10056             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1452, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'T10030             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1453, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900819           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1454, N'15090E', N'Health              ', N'Western Sydney LHD', N'WC900684           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1455, N'15090E', N'Health              ', N'Western Sydney LHD', N'WC900375           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1456, N'15090E', N'Health              ', N'Western Sydney LHD', N'WC900391           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1457, N'15090E', N'Health              ', N'Western Sydney LHD', N'T10013             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1458, N'15090E', N'Health              ', N'Western Sydney LHD', N'T10012             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1459, N'15090E', N'Health              ', N'Western Sydney LHD', N'T10011             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1460, N'15090E', N'Health              ', N'Western Sydney LHD', N'WC900068           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1461, N'15090E', N'Health              ', N'Western Sydney LHD', N'WC900069           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1462, N'15090E', N'Health              ', N'Western Sydney LHD', N'WC900070           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1463, N'15090E', N'Health              ', N'Western Sydney LHD', N'WC900083           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1464, N'15090E', N'Health              ', N'Western Sydney LHD', N'T10086             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1465, N'15090E', N'Health              ', N'Western Sydney LHD', N'T10039             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1466, N'15090E', N'Health              ', N'Western Sydney LHD', N'T10038             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1467, N'15090E', N'Health              ', N'Western Sydney LHD', N'T10040             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1468, N'15090E', N'Health              ', N'Western Sydney LHD', N'T10075             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1469, N'15090E', N'Health              ', N'Western Sydney LHD', N'T10073             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1470, N'15090E', N'Health              ', N'Western Sydney LHD', N'T10010             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1471, N'15090E', N'Health              ', N'Western Sydney LHD', N'T10060             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1472, N'15090E', N'Health              ', N'Western Sydney LHD', N'WC900377           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1473, N'15090E', N'Health              ', N'Western Sydney LHD', N'WC900239           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1474, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900178           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1475, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900171           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1476, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900063           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1477, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900085           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1478, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900066           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1479, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900065           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1480, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900062           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1481, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900911           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1482, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900910           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1483, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900529           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1484, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900528           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1485, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900446           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1486, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900445           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1487, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'T10062             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1488, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'T10063             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1489, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'T10061             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1490, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'T10037             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1491, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'T10074             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1492, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'T10072             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1493, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'T10064             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1494, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900061           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1495, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900064           ')
GO
print 'Processed 300 total records'
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1496, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900546           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1497, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'T10081             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1498, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'T10085             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1499, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'T10080             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1500, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900170           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1501, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900199           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1502, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900191           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1503, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900341           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1504, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900187           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1505, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900226           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1506, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900204           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1507, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'T10103             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1508, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'T10102             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1509, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'T10101             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1510, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'T10054             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1511, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'T10069             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1512, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900655           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1513, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900794           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1514, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900113           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1515, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900090           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1516, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900099           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1517, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900102           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1518, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900098           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1519, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900114           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1520, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900111           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1521, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900110           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1522, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900107           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1523, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900106           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1524, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900105           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1525, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900104           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1526, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900103           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1527, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900101           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1528, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900159           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1529, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900095           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1530, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900097           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1531, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900108           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1532, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900091           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1533, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900096           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1534, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900094           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1535, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900100           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1536, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900092           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1537, N'15090K', N'Health              ', N'Southern NSW LHD', N'WC900050           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1538, N'15090K', N'Health              ', N'Southern NSW LHD', N'T10055             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1539, N'15090K', N'Health              ', N'Southern NSW LHD', N'WC900200           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1540, N'15090K', N'Health              ', N'Southern NSW LHD', N'WC900198           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1541, N'15090K', N'Health              ', N'Southern NSW LHD', N'WC900189           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1542, N'15090K', N'Health              ', N'Southern NSW LHD', N'WC900195           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1543, N'15090K', N'Health              ', N'Southern NSW LHD', N'WC900256           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1544, N'15090K', N'Health              ', N'Southern NSW LHD', N'WC900194           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1545, N'15090K', N'Health              ', N'Southern NSW LHD', N'WC900192           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1546, N'15090K', N'Health              ', N'Southern NSW LHD', N'WC900190           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1547, N'15090K', N'Health              ', N'Southern NSW LHD', N'WC900229           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1548, N'15090K', N'Health              ', N'Southern NSW LHD', N'WC900227           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1549, N'15090K', N'Health              ', N'Southern NSW LHD', N'WC900203           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1550, N'15090K', N'Health              ', N'Southern NSW LHD', N'WC900201           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1551, N'15090K', N'Health              ', N'Southern NSW LHD', N'T10100             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1552, N'15090K', N'Health              ', N'Southern NSW LHD', N'T10099             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1553, N'15090K', N'Health              ', N'Southern NSW LHD', N'T10098             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1554, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900172           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1555, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900176           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1556, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900122           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1557, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900123           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1558, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900132           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1559, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900131           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1560, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900127           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1561, N'15090L', N'Health              ', N'Western NSW LHD', N'T10065             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1562, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900667           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1563, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900601           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1564, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900671           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1565, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900748           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1566, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900374           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1567, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900935           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1568, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900975           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1569, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900125           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1570, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900124           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1571, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900121           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1572, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900120           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1573, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900119           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1574, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900117           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1575, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900116           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1576, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900166           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1577, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900165           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1578, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900164           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1579, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900163           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1580, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900161           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1581, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900160           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1582, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900138           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1583, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900137           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1584, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900136           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1585, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900133           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1586, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900162           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1587, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900130           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1588, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900126           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1589, N'15090L', N'Health              ', N'Western NSW LHD', N'T10089             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1590, N'15090L', N'Health              ', N'Western NSW LHD', N'T10088             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1591, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900169           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1592, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900173           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1593, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900183           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1594, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900167           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1595, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900182           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1596, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900181           ')
GO
print 'Processed 400 total records'
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1597, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900175           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1598, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900174           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1599, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900168           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1600, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900185           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1601, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900648           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1602, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900647           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1603, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900646           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1604, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900645           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1605, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900644           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1606, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900643           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1607, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900642           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1608, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900641           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1609, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900640           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1610, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900670           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1611, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900669           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1612, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900639           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1613, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900668           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1614, N'15090M', N'Health              ', N'Far West LHD', N'WC900604           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1615, N'15090M', N'Health              ', N'Far West LHD', N'WC900603           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1616, N'15090M', N'Health              ', N'Far West LHD', N'T10066             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1617, N'15090M', N'Health              ', N'Far West LHD', N'T10091             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1618, N'15090M', N'Health              ', N'Far West LHD', N'T10090             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1619, N'15090M', N'Health              ', N'Far West LHD', N'WC900089           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1620, N'15090M', N'Health              ', N'Far West LHD', N'WC900118           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1621, N'15090M', N'Health              ', N'Far West LHD', N'WC900115           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1622, N'15090M', N'Health              ', N'Far West LHD', N'WC900139           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1623, N'15090M', N'Health              ', N'Far West LHD', N'WC900134           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1624, N'15090M', N'Health              ', N'Far West LHD', N'WC900129           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1625, N'15090M', N'Health              ', N'Far West LHD', N'WC900745           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1626, N'15090R', N'Health              ', N'Southern NSW LHD', N'T10052             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1627, N'15090S', N'Health              ', N'Western NSW LHD', N'T10053             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1628, N'15090U', N'Health              ', N'Other', N'T10050             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1629, N'15090U', N'Health              ', N'Other', N'WC900793           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1630, N'15090U', N'Health              ', N'Other', N'WC900783           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1631, N'15090U', N'Health              ', N'Other', N'WC900673           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1632, N'15090U', N'Health              ', N'Other', N'WC900751           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1633, N'15090U', N'Health              ', N'Other', N'WC900796           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1634, N'15090U', N'Health              ', N'Other', N'WC900080           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1635, N'15090U', N'Health              ', N'Other', N'WC900196           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1636, N'15090U', N'Health              ', N'Other', N'WC900259           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1637, N'15090U', N'Health              ', N'Other', N'WC900504           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1638, N'15090U', N'Health              ', N'Other', N'WC900503           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1639, N'15090U', N'Health              ', N'Other', N'WC900502           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1640, N'15090U', N'Health              ', N'Other', N'WC900444           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1641, N'15090U', N'Health              ', N'Other', N'WC900441           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1642, N'15090U', N'Health              ', N'Other', N'WC900535           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1643, N'15090U', N'Health              ', N'Other', N'WC900654           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1644, N'15090U', N'Health              ', N'Other', N'WC900679           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1645, N'15090U', N'Health              ', N'Other', N'WC900778           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1646, N'15090U', N'Health              ', N'Other', N'WC900776           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1647, N'15090U', N'Health              ', N'Other', N'T10023             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1648, N'15090U', N'Health              ', N'Other', N'T10027             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1649, N'15090U', N'Health              ', N'Other', N'T10026             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1650, N'15090U', N'Health              ', N'Other', N'T10025             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1651, N'15090U', N'Health              ', N'Other', N'WC900349           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1652, N'15090U', N'Health              ', N'Other', N'WC900345           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1653, N'15090U', N'Health              ', N'Other', N'WC900779           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1654, N'15090V', N'Health              ', N'Other', N'WC900666           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1655, N'15090V', N'Health              ', N'Other', N'WC900703           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1656, N'15090V', N'Health              ', N'Other', N'WC900602           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1657, N'15090V', N'Health              ', N'Other', N'WC900607           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1658, N'15090V', N'Health              ', N'Other', N'WC900791           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1659, N'15090V', N'Health              ', N'Other', N'WC900348           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1660, N'15090V', N'Health              ', N'Other', N'WC900346           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1661, N'15090V', N'Health              ', N'Other', N'WC900342           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1662, N'15090V', N'Health              ', N'Other', N'WC900339           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1663, N'15090V', N'Health              ', N'Other', N'WC900365           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1664, N'15090V', N'Health              ', N'Other', N'WC900523           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1665, N'15090V', N'Health              ', N'Other', N'WC900586           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1666, N'15090V', N'Health              ', N'Other', N'WC900383           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1667, N'15090V', N'Health              ', N'Other', N'T10007             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1668, N'15090V', N'Health              ', N'Other', N'T10006             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1669, N'15090V', N'Health              ', N'Other', N'T10051             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1670, N'15090V', N'Health              ', N'Other', N'T10005             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1671, N'15090V', N'Health              ', N'Other', N'T10004             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1672, N'15090V', N'Health              ', N'Other', N'T10016             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1673, N'15090V', N'Health              ', N'Other', N'T10003             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1674, N'15090V', N'Health              ', N'Other', N'T10036             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1675, N'15090V', N'Health              ', N'Other', N'T10071             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1676, N'15090V', N'Health              ', N'Other', N'T10009             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1677, N'15090V', N'Health              ', N'Other', N'T10008             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1678, N'15090V', N'Health              ', N'Other', N'WC900833           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1679, N'15090V', N'Health              ', N'Other', N'WC900832           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1680, N'15090V', N'Health              ', N'Other', N'WC900837           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1681, N'15090V', N'Health              ', N'Other', N'WC900803           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1682, N'15090V', N'Health              ', N'Other', N'WC900830           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1683, N'15090V', N'Health              ', N'Other', N'WC900829           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1684, N'15090V', N'Health              ', N'Other', N'WC900840           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1685, N'15090V', N'Health              ', N'Other', N'WC900839           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1686, N'15090V', N'Health              ', N'Other', N'WC900838           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1687, N'15090V', N'Health              ', N'Other', N'WC900959           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1688, N'15090V', N'Health              ', N'Other', N'WC900836           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1689, N'15090V', N'Health              ', N'Other', N'WC900835           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1690, N'15090V', N'Health              ', N'Other', N'WC900906           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1691, N'15090V', N'Health              ', N'Other', N'WC900834           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1692, N'15090V', N'Health              ', N'Other', N'WC900831           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1693, N'15090V', N'Health              ', N'Other', N'WC900881           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1694, N'15090V', N'Health              ', N'Other', N'WC900343           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1695, N'15090V', N'Health              ', N'Other', N'WC900606           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1696, N'15090V', N'Health              ', N'Other', N'WC900435           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1697, N'15090V', N'Health              ', N'Other', N'WC900487           ')
GO
print 'Processed 500 total records'
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1698, N'15090V', N'Health              ', N'Other', N'WC900474           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1699, N'15090V', N'Health              ', N'Other', N'WC900384           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1700, N'15090V', N'Health              ', N'Other', N'WC900450           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1701, N'15090W', N'Health              ', N'Other', N'WC900249           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1702, N'15090W', N'Health              ', N'Other', N'T10070             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1703, N'15090W', N'Health              ', N'Other', N'WC900081           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1704, N'15090W', N'Health              ', N'Other', N'WC900078           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1705, N'15190C', N'Health              ', N'Other', N'T10035             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1706, N'15190G', N'Health              ', N'Other', N'T10079             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1707, N'15190L', N'Health              ', N'Mercy Care', N'WC900197           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1708, N'15190L', N'Health              ', N'Mercy Care', N'WC900777           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1709, N'15190L', N'Health              ', N'Mercy Care', N'WC900109           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1710, N'15506', N'Other               ', N'Premier & Cabinet', N'WC900288           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1711, N'15513', N'Other               ', N'Planning & Local Government', N'WC900795           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1712, N'15523', N'Other               ', N'Planning & Local Government', N'WC900317           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1713, N'15524', N'Other               ', N'Planning & Local Government', N'WC900565           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1714, N'15549', N'Other               ', N'Planning & Local Government', N'WC900318           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1715, N'15595', N'Other               ', N'Planning & Local Government', N'MWJ3333303         ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1716, N'15596', N'Other               ', N'Planning & Local Government', N'MWJ3333315         ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1717, N'15851', N'Other               ', N'Planning & Local Government', N'WC900576           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1718, N'15864', N'Other               ', N'Planning & Local Government', N'WC900608           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1719, N'15864', N'Other               ', N'Planning & Local Government', N'WC900611           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1720, N'15900', N'Other               ', N'Planning & Local Government', N'T10139             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1721, N'15905', N'Other               ', N'Planning & Local Government', N'T10140             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1722, N'15920', N'Other               ', N'Planning & Local Government', N'T10141             ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1723, N'20608', N'Other               ', N'Planning & Local Government', N'WC900633           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1724, N'20653', N'Other               ', N'Planning & Local Government', N'WC900291           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1725, N'20653', N'Other               ', N'Planning & Local Government', N'WC900415           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1726, N'20653', N'Other               ', N'Planning & Local Government', N'WC900775           ')
INSERT [dbo].[EML_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1727, N'25664', N'Other               ', N'Planning & Local Government', N'T10068             ')
SET IDENTITY_INSERT [dbo].[EML_Agencies_Sub_Category] OFF

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\SchemaChange\EML_Agencies_Sub_Category.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\SchemaChange\EML_SIW.sql  
--------------------------------  
/****** Object:  Table [dbo].[EML_SIW]    Script Date: 30/12/2013 08:24:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EML_SIW]') AND type in (N'U'))	
	DROP TABLE [dbo].[EML_SIW]
GO
/****** Object:  Table [dbo].[EML_SIW]    Script Date: 30/12/2013 08:24:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EML_SIW](
	[Claim_no] [varchar](20) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'107672016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'108301016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'112062016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'114079016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'129066016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'138561016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'144549016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'154794016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'154925016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'155159016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'158578016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'162143016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'162625016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'162819016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'163788016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'164337016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'167311016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'175780016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'178215016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'183512016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'186829016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'186897016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'189373016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'189796016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'190347016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'191194016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'194408016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'196294016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'197100016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'201222016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'201259016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'201503016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'203539016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'206119016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'207514016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'209481016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'211845016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'212677016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'213724016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'216016016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'216269016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'216332016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'217731016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'217790016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'218554016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'218904016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'219024016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'221955016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'223565016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'230118016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'232716016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'232858016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'233002016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'233063016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'265699016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'272124122')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'871099016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'912289016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'941722016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'954221016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'964101016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'2162946122')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'3005566122')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'95881468122')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'97723597122')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'97738938122')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'97919288122')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'98060033122')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'98070748122')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'98160530122')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'98179214122')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'101425420122')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'101431308122')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'338001070122')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'388000805122')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'2MAB0097326122')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'2MCF0082209122')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'2MLN0096236122')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'930018A016')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'C0048468122')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'O1029105122')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'O6005782122')
INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'O8000270122')

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  SELECT  ON [dbo].[EML_SIW] TO [EMICS]
GRANT  SELECT  ON [dbo].[EML_SIW] TO [EMIUS]
GRANT  SELECT  ON [dbo].[EML_SIW] TO [DART_Role]
GO
--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\SchemaChange\EML_SIW.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\SchemaChange\HEM_Agencies_Sub_Category.sql  
--------------------------------  
/****** Object:Table [dbo].[HEM_Agencies_Sub_Category]Script Date: 01/28/2014 10:44:02 ******/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HEM_Agencies_Sub_Category]') AND type in (N'U'))	
	DROP TABLE [dbo].[HEM_Agencies_Sub_Category]
GO
/****** Object:  Table [dbo].[HEM_Agencies_Sub_Category]    Script Date: 01/28/2014 10:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HEM_Agencies_Sub_Category](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AgencyId] [varchar](20) NULL,
	[AgencyName] [char](20) NULL,
	[Sub_Category] [varchar](256) NULL,
	[POLICY_NO] [char](19) NULL,
 CONSTRAINT [PK_HEM_Agencies_Sub_Category] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[HEM_Agencies_Sub_Category] ON
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1194, N'10010', N'Other               ', N'Premier & Cabinet', N'WC900321           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1195, N'10015', N'Other               ', N'Premier & Cabinet', N'WC900331           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1196, N'10015', N'Other               ', N'Premier & Cabinet', N'WC900772           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1197, N'10020', N'Other               ', N'Premier & Cabinet', N'WC900665           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1198, N'10020', N'Other               ', N'Premier & Cabinet', N'WC900275           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1199, N'10025', N'Other               ', N'Premier & Cabinet', N'WC900773           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1200, N'10035', N'Other               ', N'Premier & Cabinet', N'WC900547           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1201, N'10045', N'Other               ', N'Premier & Cabinet', N'WC900327           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1202, N'10050', N'Other               ', N'Premier & Cabinet', N'WC900305           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1203, N'10052', N'Other               ', N'Premier & Cabinet', N'T10083             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1204, N'10060', N'Other               ', N'Premier & Cabinet', N'WC900311           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1205, N'10065', N'Other               ', N'Premier & Cabinet', N'WC900310           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1206, N'10069', N'Other               ', N'Planning & Local Government', N'WC900306           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1207, N'10069', N'Other               ', N'Planning & Local Government', N'WC900695           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1208, N'10090', N'Other               ', N'Planning & Local Government', N'WC900397           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1209, N'10090', N'Other               ', N'Planning & Local Government', N'WC900398           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1210, N'10090J', N'Health              ', N'Childrens Hospital', N'WC900246           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1211, N'10090J', N'Health              ', N'Childrens Hospital', N'T10078             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1212, N'10090J', N'Health              ', N'Childrens Hospital', N'T10029             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1213, N'10090J', N'Health              ', N'Childrens Hospital', N'WC900675           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1214, N'10090K', N'Health              ', N'Greater Southern Area', N'WC900376           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1215, N'10090K', N'Health              ', N'Greater Southern Area', N'WC900338           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1216, N'10090K', N'Health              ', N'Greater Southern Area', N'WC900202           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1217, N'10090K', N'Health              ', N'Greater Southern Area', N'T1                 ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1218, N'10090K', N'Health              ', N'Greater Southern Area', N'WC900362           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1219, N'10090K', N'Health              ', N'Greater Southern Area', N'WC900489           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1220, N'10090K', N'Health              ', N'Greater Southern Area', N'WC900370           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1221, N'10090K', N'Health              ', N'Greater Southern Area', N'WC900354           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1222, N'10090K', N'Health              ', N'Greater Southern Area', N'WC900186           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1223, N'10090K', N'Health              ', N'Greater Southern Area', N'WC900060           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1224, N'10090L', N'Health              ', N'Greater Western Area', N'WC900188           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1225, N'10090L', N'Health              ', N'Greater Western Area', N'WC900180           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1226, N'10090L', N'Health              ', N'Greater Western Area', N'WC900490           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1227, N'10090L', N'Health              ', N'Greater Western Area', N'WC900355           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1228, N'10090L', N'Health              ', N'Greater Western Area', N'WC900473           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1229, N'10090L', N'Health              ', N'Greater Western Area', N'WC900369           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1230, N'10090L', N'Health              ', N'Greater Western Area', N'WC900357           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1231, N'10090R', N'Health              ', N'Other', N'WC900359           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1232, N'10090R', N'Health              ', N'Other', N'WC900525           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1233, N'10090R', N'Health              ', N'Other', N'WC900356           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1234, N'10090R', N'Health              ', N'Other', N'WC900488           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1235, N'10090R', N'Health              ', N'Other', N'WC900494           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1236, N'10090R', N'Health              ', N'Other', N'WC900531           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1237, N'10090R', N'Health              ', N'Other', N'WC900472           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1238, N'10090R', N'Health              ', N'Other', N'WC900821           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1239, N'10090R', N'Health              ', N'Other', N'T10022             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1240, N'10090R', N'Health              ', N'Other', N'T10024             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1241, N'10090R', N'Health              ', N'Other', N'WC900034           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1242, N'10090R', N'Health              ', N'Other', N'WC900241           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1243, N'10090R', N'Health              ', N'Other', N'WC900340           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1244, N'10090S', N'Health              ', N'Sydney South West Area', N'WC900471           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1245, N'10090S', N'Health              ', N'Sydney South West Area', N'WC900486           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1246, N'10090S', N'Health              ', N'Sydney South West Area', N'WC900385           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1247, N'10090S', N'Health              ', N'Sydney South West Area', N'WC900605           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1248, N'10090Y', N'Health              ', N'Health Support', N'T10049             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1249, N'10090Y', N'Health              ', N'Health Support', N'T10034             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1250, N'10090Y', N'Health              ', N'Health Support', N'T10041             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1251, N'10090Y', N'Health              ', N'Health Support', N'T10047             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1252, N'10090Y', N'Health              ', N'Health Support', N'T10045             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1253, N'10090Y', N'Health              ', N'Health Support', N'T10042             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1254, N'10090Y', N'Health              ', N'Health Support', N'T10019             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1255, N'10090Y', N'Health              ', N'Health Support', N'T10033             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1256, N'10090Y', N'Health              ', N'Health Support', N'T10046             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1257, N'10090Y', N'Health              ', N'Health Support', N'T10032             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1258, N'10090Y', N'Health              ', N'Health Support', N'T10017             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1259, N'10090Y', N'Health              ', N'Health Support', N'T10020             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1260, N'10090Y', N'Health              ', N'Health Support', N'T10018             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1261, N'10090Y', N'Health              ', N'Health Support', N'T10043             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1262, N'10090Y', N'Health              ', N'Health Support', N'T10048             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1263, N'10090Y', N'Health              ', N'Health Support', N'T10021             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1264, N'10090Y', N'Health              ', N'Health Support', N'T10044             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1265, N'10090Y', N'Health              ', N'Health Support', N'T10028             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1266, N'10090Y', N'Health              ', N'Health Support', N'WC900352           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1267, N'10142', N'Other               ', N'Premier & Cabinet', N'MWJ3333309         ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1268, N'10250', N'Police              ', N'Northern Region', N'WC900727           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1269, N'10250', N'Police              ', N'Other', N'WC900723           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1270, N'10250', N'Police              ', N'Northern Region', N'WC900721           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1271, N'10250', N'Police              ', N'Northern Region', N'WC900724           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1272, N'10250', N'Police              ', N'Other', N'WC900731           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1273, N'10250', N'Police              ', N'Other', N'WC900734           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1274, N'10250', N'Police              ', N'Southern Region', N'WC900726           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1275, N'10250', N'Police              ', N'Other', N'WC900725           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1276, N'10250', N'Police              ', N'Other', N'WC900631           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1277, N'10250', N'Police              ', N'South West Metro', N'WC900728           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1278, N'10250', N'Police              ', N'Other', N'WC900722           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1279, N'10250', N'Police              ', N'Specialist Operations', N'WC900733           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1280, N'10250', N'Police              ', N'Other', N'WC900732           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1281, N'10250', N'Police              ', N'Other', N'WC900720           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1282, N'10250', N'Police              ', N'North West Metro', N'WC900729           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1283, N'10250', N'Police              ', N'Western Region', N'WC900730           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1284, N'10250', N'Police              ', N'Operation Support', N'WC900735           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1285, N'10250', N'Police              ', N'North West Metro', N'WC900540           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1286, N'10250', N'Police              ', N'Operation Support', N'WC900538           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1287, N'10250', N'Police              ', N'Other', N'WC900544           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1288, N'10250', N'Police              ', N'Western Region', N'WC900542           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1289, N'10250', N'Police              ', N'Other', N'WC900543           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1290, N'10250', N'Police              ', N'Southern Region', N'WC900541           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1291, N'10250', N'Police              ', N'Northern Region', N'WC900539           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1292, N'10250', N'Police              ', N'Other', N'WC900537           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1293, N'10250', N'Police              ', N'Other', N'WC900332           ')
GO
print 'Processed 100 total records'
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1294, N'10250', N'Police              ', N'Other', N'WC900264           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1295, N'10250', N'Police              ', N'North West Metro', N'WC900855           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1296, N'10250', N'Police              ', N'Western Region', N'WC900862           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1297, N'10250', N'Police              ', N'Northern Region', N'WC900856           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1298, N'10250', N'Police              ', N'Corporate Service', N'WC900861           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1299, N'10250', N'Police              ', N'Central Metro', N'WC900854           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1300, N'10250', N'Police              ', N'Specialist Operations', N'WC900859           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1301, N'10250', N'Police              ', N'Southern Region', N'WC900857           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1302, N'10250', N'Police              ', N'Operation Support', N'WC900860           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1303, N'10250', N'Police              ', N'South West Metro', N'MWJ3333297         ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1304, N'10255', N'Police              ', N'Other', N'WC900630           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1305, N'10260', N'Police              ', N'Emergency Services', N'WC900477           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1306, N'10260', N'Police              ', N'Emergency Services', N'WC900266           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1307, N'10265', N'Police              ', N'Emergency Services', N'T10082             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1308, N'10270', N'Other               ', N'Corrective Services', N'WC900594           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1309, N'10270', N'Other               ', N'Corrective Services', N'WC900592           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1310, N'10270', N'Other               ', N'Corrective Services', N'WC900595           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1311, N'10270', N'Other               ', N'Corrective Services', N'WC900593           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1312, N'10270', N'Other               ', N'Corrective Services', N'WC900790           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1313, N'10270', N'Other               ', N'Corrective Services', N'WC900596           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1314, N'10270', N'Other               ', N'Corrective Services', N'WC900789           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1315, N'10270', N'Other               ', N'Corrective Services', N'WC900597           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1316, N'10270', N'Other               ', N'Corrective Services', N'WC900276           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1317, N'10275', N'Other               ', N'Juvenile Justice', N'WC900536           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1318, N'10280', N'Other               ', N'Juvenile Justice', N'WC900302           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1319, N'10305', N'Other               ', N'Planning & Local Government', N'WC900871           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1320, N'10305', N'Other               ', N'Planning & Local Government', N'T10067             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1321, N'10305', N'Other               ', N'Planning & Local Government', N'WC900746           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1322, N'10305', N'Other               ', N'Planning & Local Government', N'MWJ3333320         ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1323, N'10305', N'Other               ', N'Planning & Local Government', N'MWJ3333319         ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1324, N'10355', N'Fire                ', N'Cancelled', N'WC900263           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1325, N'10355', N'Fire                ', N'Other', N'T10119             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1326, N'10355', N'Fire                ', N'Other', N'T10130             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1327, N'10355', N'Fire                ', N'South Metro', N'T10124             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1328, N'10355', N'Fire                ', N'West Metro', N'T10125             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1329, N'10355', N'Fire                ', N'Reginal West', N'T10128             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1330, N'10355', N'Fire                ', N'North Metro', N'T10123             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1331, N'10355', N'Fire                ', N'Regional South', N'T10127             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1332, N'10355', N'Fire                ', N'East Metro', N'T10122             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1333, N'10355', N'Fire                ', N'Other', N'T10118             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1334, N'10355', N'Fire                ', N'Other', N'T10117             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1335, N'10355', N'Fire                ', N'Other', N'T10129             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1336, N'10355', N'Fire                ', N'Other', N'T10116             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1337, N'10355', N'Fire                ', N'Other', N'T10120             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1338, N'10355', N'Fire                ', N'Other', N'T10131             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1339, N'10355', N'Fire                ', N'Other', N'T10121             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1340, N'10355', N'Fire                ', N'Regional North', N'T10126             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1341, N'10405', N'Fire                ', N'Rural Fire Services', N'WC900265           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1342, N'10460', N'Other               ', N'Planning & Local Government', N'WC900599           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1343, N'10475', N'Other               ', N'Planning & Local Government', N'WC900907           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1344, N'10500', N'Other               ', N'Planning & Local Government', N'WC900694           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1345, N'10500', N'Other               ', N'Planning & Local Government', N'MWJ3333294         ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1346, N'10594', N'Other               ', N'Planning & Local Government', N'T10087             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1347, N'10597', N'Other               ', N'Planning & Local Government', N'T10084             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1348, N'10644', N'Other               ', N'Planning & Local Government', N'T10132             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1349, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900010           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1350, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900011           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1351, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900816           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1352, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900662           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1353, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900702           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1354, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900230           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1355, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900245           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1356, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900235           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1357, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900530           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1358, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900371           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1359, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900386           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1360, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900366           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1361, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900422           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1362, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900577           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1363, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900451           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1364, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900817           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1365, N'15090A', N'Health              ', N'Sydeny Local Health District', N'T10076             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1366, N'15090A', N'Health              ', N'Sydeny Local Health District', N'T10096             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1367, N'15090A', N'Health              ', N'Sydeny Local Health District', N'T10135             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1368, N'15090A', N'Health              ', N'Sydeny Local Health District', N'T10134             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1369, N'15090A', N'Health              ', N'Sydeny Local Health District', N'T10133             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1370, N'15090A', N'Health              ', N'Sydeny Local Health District', N'T10095             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1371, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900007           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1372, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900008           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1373, N'15090A', N'Health              ', N'Sydeny Local Health District', N'T10092             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1374, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900252           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1375, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900059           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1376, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900074           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1377, N'15090A', N'Health              ', N'Sydeny Local Health District', N'WC900780           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1378, N'15090A', N'Health              ', N'Sydeny Local Health District', N'T10058             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1379, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900533           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1380, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900437           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1381, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900436           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1382, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900501           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1383, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900372           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1384, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900500           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1385, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900499           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1386, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900390           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1387, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900534           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1388, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900056           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1389, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900233           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1390, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900238           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1391, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900228           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1392, N'15090B', N'Health              ', N'South Western Sydney LHD', N'T10014             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1393, N'15090B', N'Health              ', N'South Western Sydney LHD', N'T10059             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1394, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900686           ')
GO
print 'Processed 200 total records'
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1395, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900054           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1396, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900052           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1397, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900051           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1398, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900053           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1399, N'15090B', N'Health              ', N'South Western Sydney LHD', N'WC900055           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1400, N'15090B', N'Health              ', N'South Western Sydney LHD', N'T10136             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1401, N'15090B', N'Health              ', N'South Western Sydney LHD', N'T10094             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1402, N'15090B', N'Health              ', N'South Western Sydney LHD', N'T10138             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1403, N'15090B', N'Health              ', N'South Western Sydney LHD', N'T10137             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1404, N'15090B', N'Health              ', N'South Western Sydney LHD', N'T10097             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1405, N'15090B', N'Health              ', N'South Western Sydney LHD', N'T10093             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1406, N'15090B', N'Health              ', N'South Western Sydney LHD', N'T10077             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1407, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900014           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1408, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900016           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1409, N'15090C', N'Health              ', N'South East Sydney LHD', N'T10113             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1410, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900017           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1411, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900013           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1412, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900677           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1413, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900676           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1414, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900678           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1415, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900674           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1416, N'15090C', N'Health              ', N'South East Sydney LHD', N'T10057             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1417, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900240           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1418, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900232           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1419, N'15090C', N'Health              ', N'South East Sydney LHD', N'T10115             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1420, N'15090C', N'Health              ', N'South East Sydney LHD', N'T10114             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1421, N'15090C', N'Health              ', N'South East Sydney LHD', N'T10112             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1422, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900015           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1423, N'15090C', N'Health              ', N'South East Sydney LHD', N'T10111             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1424, N'15090C', N'Health              ', N'South East Sydney LHD', N'T10110             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1425, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900082           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1426, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900058           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1427, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900057           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1428, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900079           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1429, N'15090C', N'Health              ', N'South East Sydney LHD', N'WC900392           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1430, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900440           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1431, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900452           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1432, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900818           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1433, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900822           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1434, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900820           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1435, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900193           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1436, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900038           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1437, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900036           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1438, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900035           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1439, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'T10107             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1440, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'T10106             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1441, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'T10105             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1442, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'T10104             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1443, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900041           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1444, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900040           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1445, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900039           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1446, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900037           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1447, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900033           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1448, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'T10109             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1449, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'T10108             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1450, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900749           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1451, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'T10056             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1452, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'T10030             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1453, N'15090D', N'Health              ', N'Illawarra Shoalhaven LHD', N'WC900819           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1454, N'15090E', N'Health              ', N'Western Sydney LHD', N'WC900684           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1455, N'15090E', N'Health              ', N'Western Sydney LHD', N'WC900375           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1456, N'15090E', N'Health              ', N'Western Sydney LHD', N'WC900391           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1457, N'15090E', N'Health              ', N'Western Sydney LHD', N'T10013             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1458, N'15090E', N'Health              ', N'Western Sydney LHD', N'T10012             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1459, N'15090E', N'Health              ', N'Western Sydney LHD', N'T10011             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1460, N'15090E', N'Health              ', N'Western Sydney LHD', N'WC900068           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1461, N'15090E', N'Health              ', N'Western Sydney LHD', N'WC900069           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1462, N'15090E', N'Health              ', N'Western Sydney LHD', N'WC900070           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1463, N'15090E', N'Health              ', N'Western Sydney LHD', N'WC900083           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1464, N'15090E', N'Health              ', N'Western Sydney LHD', N'T10086             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1465, N'15090E', N'Health              ', N'Western Sydney LHD', N'T10039             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1466, N'15090E', N'Health              ', N'Western Sydney LHD', N'T10038             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1467, N'15090E', N'Health              ', N'Western Sydney LHD', N'T10040             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1468, N'15090E', N'Health              ', N'Western Sydney LHD', N'T10075             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1469, N'15090E', N'Health              ', N'Western Sydney LHD', N'T10073             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1470, N'15090E', N'Health              ', N'Western Sydney LHD', N'T10010             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1471, N'15090E', N'Health              ', N'Western Sydney LHD', N'T10060             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1472, N'15090E', N'Health              ', N'Western Sydney LHD', N'WC900377           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1473, N'15090E', N'Health              ', N'Western Sydney LHD', N'WC900239           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1474, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900178           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1475, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900171           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1476, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900063           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1477, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900085           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1478, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900066           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1479, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900065           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1480, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900062           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1481, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900911           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1482, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900910           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1483, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900529           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1484, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900528           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1485, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900446           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1486, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900445           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1487, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'T10062             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1488, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'T10063             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1489, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'T10061             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1490, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'T10037             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1491, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'T10074             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1492, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'T10072             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1493, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'T10064             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1494, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900061           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1495, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900064           ')
GO
print 'Processed 300 total records'
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1496, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'WC900546           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1497, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'T10081             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1498, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'T10085             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1499, N'15090F', N'Health              ', N'Blue Mountains/Springwood/Lithgow/Nepean Hospitals', N'T10080             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1500, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900170           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1501, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900199           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1502, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900191           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1503, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900341           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1504, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900187           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1505, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900226           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1506, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900204           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1507, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'T10103             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1508, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'T10102             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1509, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'T10101             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1510, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'T10054             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1511, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'T10069             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1512, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900655           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1513, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900794           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1514, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900113           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1515, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900090           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1516, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900099           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1517, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900102           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1518, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900098           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1519, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900114           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1520, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900111           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1521, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900110           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1522, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900107           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1523, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900106           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1524, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900105           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1525, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900104           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1526, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900103           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1527, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900101           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1528, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900159           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1529, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900095           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1530, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900097           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1531, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900108           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1532, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900091           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1533, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900096           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1534, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900094           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1535, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900100           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1536, N'15090J', N'Health              ', N'Murrumbidgee LHD', N'WC900092           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1537, N'15090K', N'Health              ', N'Southern NSW LHD', N'WC900050           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1538, N'15090K', N'Health              ', N'Southern NSW LHD', N'T10055             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1539, N'15090K', N'Health              ', N'Southern NSW LHD', N'WC900200           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1540, N'15090K', N'Health              ', N'Southern NSW LHD', N'WC900198           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1541, N'15090K', N'Health              ', N'Southern NSW LHD', N'WC900189           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1542, N'15090K', N'Health              ', N'Southern NSW LHD', N'WC900195           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1543, N'15090K', N'Health              ', N'Southern NSW LHD', N'WC900256           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1544, N'15090K', N'Health              ', N'Southern NSW LHD', N'WC900194           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1545, N'15090K', N'Health              ', N'Southern NSW LHD', N'WC900192           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1546, N'15090K', N'Health              ', N'Southern NSW LHD', N'WC900190           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1547, N'15090K', N'Health              ', N'Southern NSW LHD', N'WC900229           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1548, N'15090K', N'Health              ', N'Southern NSW LHD', N'WC900227           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1549, N'15090K', N'Health              ', N'Southern NSW LHD', N'WC900203           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1550, N'15090K', N'Health              ', N'Southern NSW LHD', N'WC900201           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1551, N'15090K', N'Health              ', N'Southern NSW LHD', N'T10100             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1552, N'15090K', N'Health              ', N'Southern NSW LHD', N'T10099             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1553, N'15090K', N'Health              ', N'Southern NSW LHD', N'T10098             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1554, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900172           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1555, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900176           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1556, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900122           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1557, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900123           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1558, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900132           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1559, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900131           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1560, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900127           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1561, N'15090L', N'Health              ', N'Western NSW LHD', N'T10065             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1562, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900667           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1563, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900601           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1564, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900671           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1565, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900748           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1566, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900374           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1567, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900935           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1568, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900975           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1569, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900125           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1570, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900124           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1571, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900121           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1572, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900120           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1573, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900119           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1574, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900117           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1575, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900116           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1576, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900166           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1577, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900165           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1578, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900164           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1579, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900163           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1580, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900161           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1581, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900160           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1582, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900138           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1583, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900137           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1584, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900136           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1585, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900133           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1586, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900162           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1587, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900130           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1588, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900126           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1589, N'15090L', N'Health              ', N'Western NSW LHD', N'T10089             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1590, N'15090L', N'Health              ', N'Western NSW LHD', N'T10088             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1591, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900169           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1592, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900173           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1593, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900183           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1594, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900167           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1595, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900182           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1596, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900181           ')
GO
print 'Processed 400 total records'
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1597, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900175           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1598, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900174           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1599, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900168           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1600, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900185           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1601, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900648           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1602, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900647           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1603, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900646           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1604, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900645           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1605, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900644           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1606, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900643           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1607, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900642           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1608, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900641           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1609, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900640           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1610, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900670           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1611, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900669           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1612, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900639           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1613, N'15090L', N'Health              ', N'Western NSW LHD', N'WC900668           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1614, N'15090M', N'Health              ', N'Far West LHD', N'WC900604           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1615, N'15090M', N'Health              ', N'Far West LHD', N'WC900603           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1616, N'15090M', N'Health              ', N'Far West LHD', N'T10066             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1617, N'15090M', N'Health              ', N'Far West LHD', N'T10091             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1618, N'15090M', N'Health              ', N'Far West LHD', N'T10090             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1619, N'15090M', N'Health              ', N'Far West LHD', N'WC900089           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1620, N'15090M', N'Health              ', N'Far West LHD', N'WC900118           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1621, N'15090M', N'Health              ', N'Far West LHD', N'WC900115           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1622, N'15090M', N'Health              ', N'Far West LHD', N'WC900139           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1623, N'15090M', N'Health              ', N'Far West LHD', N'WC900134           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1624, N'15090M', N'Health              ', N'Far West LHD', N'WC900129           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1625, N'15090M', N'Health              ', N'Far West LHD', N'WC900745           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1626, N'15090R', N'Health              ', N'Southern NSW LHD', N'T10052             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1627, N'15090S', N'Health              ', N'Western NSW LHD', N'T10053             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1628, N'15090U', N'Health              ', N'Other', N'T10050             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1629, N'15090U', N'Health              ', N'Other', N'WC900793           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1630, N'15090U', N'Health              ', N'Other', N'WC900783           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1631, N'15090U', N'Health              ', N'Other', N'WC900673           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1632, N'15090U', N'Health              ', N'Other', N'WC900751           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1633, N'15090U', N'Health              ', N'Other', N'WC900796           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1634, N'15090U', N'Health              ', N'Other', N'WC900080           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1635, N'15090U', N'Health              ', N'Other', N'WC900196           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1636, N'15090U', N'Health              ', N'Other', N'WC900259           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1637, N'15090U', N'Health              ', N'Other', N'WC900504           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1638, N'15090U', N'Health              ', N'Other', N'WC900503           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1639, N'15090U', N'Health              ', N'Other', N'WC900502           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1640, N'15090U', N'Health              ', N'Other', N'WC900444           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1641, N'15090U', N'Health              ', N'Other', N'WC900441           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1642, N'15090U', N'Health              ', N'Other', N'WC900535           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1643, N'15090U', N'Health              ', N'Other', N'WC900654           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1644, N'15090U', N'Health              ', N'Other', N'WC900679           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1645, N'15090U', N'Health              ', N'Other', N'WC900778           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1646, N'15090U', N'Health              ', N'Other', N'WC900776           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1647, N'15090U', N'Health              ', N'Other', N'T10023             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1648, N'15090U', N'Health              ', N'Other', N'T10027             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1649, N'15090U', N'Health              ', N'Other', N'T10026             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1650, N'15090U', N'Health              ', N'Other', N'T10025             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1651, N'15090U', N'Health              ', N'Other', N'WC900349           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1652, N'15090U', N'Health              ', N'Other', N'WC900345           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1653, N'15090U', N'Health              ', N'Other', N'WC900779           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1654, N'15090V', N'Health              ', N'Other', N'WC900666           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1655, N'15090V', N'Health              ', N'Other', N'WC900703           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1656, N'15090V', N'Health              ', N'Other', N'WC900602           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1657, N'15090V', N'Health              ', N'Other', N'WC900607           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1658, N'15090V', N'Health              ', N'Other', N'WC900791           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1659, N'15090V', N'Health              ', N'Other', N'WC900348           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1660, N'15090V', N'Health              ', N'Other', N'WC900346           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1661, N'15090V', N'Health              ', N'Other', N'WC900342           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1662, N'15090V', N'Health              ', N'Other', N'WC900339           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1663, N'15090V', N'Health              ', N'Other', N'WC900365           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1664, N'15090V', N'Health              ', N'Other', N'WC900523           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1665, N'15090V', N'Health              ', N'Other', N'WC900586           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1666, N'15090V', N'Health              ', N'Other', N'WC900383           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1667, N'15090V', N'Health              ', N'Other', N'T10007             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1668, N'15090V', N'Health              ', N'Other', N'T10006             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1669, N'15090V', N'Health              ', N'Other', N'T10051             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1670, N'15090V', N'Health              ', N'Other', N'T10005             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1671, N'15090V', N'Health              ', N'Other', N'T10004             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1672, N'15090V', N'Health              ', N'Other', N'T10016             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1673, N'15090V', N'Health              ', N'Other', N'T10003             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1674, N'15090V', N'Health              ', N'Other', N'T10036             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1675, N'15090V', N'Health              ', N'Other', N'T10071             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1676, N'15090V', N'Health              ', N'Other', N'T10009             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1677, N'15090V', N'Health              ', N'Other', N'T10008             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1678, N'15090V', N'Health              ', N'Other', N'WC900833           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1679, N'15090V', N'Health              ', N'Other', N'WC900832           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1680, N'15090V', N'Health              ', N'Other', N'WC900837           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1681, N'15090V', N'Health              ', N'Other', N'WC900803           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1682, N'15090V', N'Health              ', N'Other', N'WC900830           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1683, N'15090V', N'Health              ', N'Other', N'WC900829           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1684, N'15090V', N'Health              ', N'Other', N'WC900840           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1685, N'15090V', N'Health              ', N'Other', N'WC900839           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1686, N'15090V', N'Health              ', N'Other', N'WC900838           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1687, N'15090V', N'Health              ', N'Other', N'WC900959           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1688, N'15090V', N'Health              ', N'Other', N'WC900836           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1689, N'15090V', N'Health              ', N'Other', N'WC900835           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1690, N'15090V', N'Health              ', N'Other', N'WC900906           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1691, N'15090V', N'Health              ', N'Other', N'WC900834           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1692, N'15090V', N'Health              ', N'Other', N'WC900831           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1693, N'15090V', N'Health              ', N'Other', N'WC900881           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1694, N'15090V', N'Health              ', N'Other', N'WC900343           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1695, N'15090V', N'Health              ', N'Other', N'WC900606           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1696, N'15090V', N'Health              ', N'Other', N'WC900435           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1697, N'15090V', N'Health              ', N'Other', N'WC900487           ')
GO
print 'Processed 500 total records'
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1698, N'15090V', N'Health              ', N'Other', N'WC900474           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1699, N'15090V', N'Health              ', N'Other', N'WC900384           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1700, N'15090V', N'Health              ', N'Other', N'WC900450           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1701, N'15090W', N'Health              ', N'Other', N'WC900249           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1702, N'15090W', N'Health              ', N'Other', N'T10070             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1703, N'15090W', N'Health              ', N'Other', N'WC900081           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1704, N'15090W', N'Health              ', N'Other', N'WC900078           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1705, N'15190C', N'Health              ', N'Other', N'T10035             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1706, N'15190G', N'Health              ', N'Other', N'T10079             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1707, N'15190L', N'Health              ', N'Mercy Care', N'WC900197           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1708, N'15190L', N'Health              ', N'Mercy Care', N'WC900777           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1709, N'15190L', N'Health              ', N'Mercy Care', N'WC900109           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1710, N'15506', N'Other               ', N'Premier & Cabinet', N'WC900288           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1711, N'15513', N'Other               ', N'Planning & Local Government', N'WC900795           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1712, N'15523', N'Other               ', N'Planning & Local Government', N'WC900317           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1713, N'15524', N'Other               ', N'Planning & Local Government', N'WC900565           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1714, N'15549', N'Other               ', N'Planning & Local Government', N'WC900318           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1715, N'15595', N'Other               ', N'Planning & Local Government', N'MWJ3333303         ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1716, N'15596', N'Other               ', N'Planning & Local Government', N'MWJ3333315         ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1717, N'15851', N'Other               ', N'Planning & Local Government', N'WC900576           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1718, N'15864', N'Other               ', N'Planning & Local Government', N'WC900608           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1719, N'15864', N'Other               ', N'Planning & Local Government', N'WC900611           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1720, N'15900', N'Other               ', N'Planning & Local Government', N'T10139             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1721, N'15905', N'Other               ', N'Planning & Local Government', N'T10140             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1722, N'15920', N'Other               ', N'Planning & Local Government', N'T10141             ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1723, N'20608', N'Other               ', N'Planning & Local Government', N'WC900633           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1724, N'20653', N'Other               ', N'Planning & Local Government', N'WC900291           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1725, N'20653', N'Other               ', N'Planning & Local Government', N'WC900415           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1726, N'20653', N'Other               ', N'Planning & Local Government', N'WC900775           ')
INSERT [dbo].[HEM_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO]) VALUES (1727, N'25664', N'Other               ', N'Planning & Local Government', N'T10068             ')
SET IDENTITY_INSERT [dbo].[HEM_Agencies_Sub_Category] OFF

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\SchemaChange\HEM_Agencies_Sub_Category.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\SchemaChange\HEM_SIW.sql  
--------------------------------  
/****** Object:  Table [dbo].[HEM_SIW]    Script Date: 30/12/2013 08:24:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HEM_SIW]') AND type in (N'U'))	
	DROP TABLE [dbo].[HEM_SIW]
GO
/****** Object:  Table [dbo].[HEM_SIW]    Script Date: 30/12/2013 08:24:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HEM_SIW](
	[Claim_no] [varchar](20) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  SELECT  ON [dbo].[HEM_SIW] TO [EMICS]
GRANT  SELECT  ON [dbo].[HEM_SIW] TO [EMIUS]
GRANT  SELECT  ON [dbo].[HEM_SIW] TO [DART_Role]
GO

--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\SchemaChange\HEM_SIW.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\SchemaChange\TMF_Agencies_Sub_Category.sql  
--------------------------------  
/****** Object:  Table [dbo].[TMF_Agencies_Sub_Category]    Script Date: 05/26/2014 17:20:48 ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TMF_Agencies_Sub_Category]') AND type in (N'U'))
	DROP TABLE [dbo].[TMF_Agencies_Sub_Category]
GO
/****** Object:  Table [dbo].[TMF_Agencies_Sub_Category]    Script Date: 05/26/2014 17:20:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TMF_Agencies_Sub_Category](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AgencyId] [varchar](20) NULL,
	[AgencyName] [char](20) NULL,
	[Sub_Category] [varchar](256) NULL,
	[POLICY_NO] [char](19) NULL,
	[Group] [varchar](50) NULL,
 CONSTRAINT [PK_TMF_Agencies_Sub_Category] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[TMF_Agencies_Sub_Category] ON
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2791, N'10010', N'OTHER               ', N'THE LEGISLATURE', N'WC900321           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2792, N'10015', N'OTHER               ', N'CABINET OFFICE', N'WC900331           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2793, N'10015', N'OTHER               ', N'CABINET OFFICE', N'WC900772           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2794, N'10020', N'OTHER               ', N'DEPARTMENT OF PREMIER AND CABINET', N'WC900275           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2795, N'10020', N'OTHER               ', N'PUBLIC EMPLOYMENT OFFICE', N'WC900665           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2796, N'10025', N'OTHER               ', N'PARLIAMENTARY COUNSEL''S OFFICE', N'WC900773           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2797, N'10035', N'OTHER               ', N'INDEPENDENT PRICING AND REGULATORY TRIBUNAL', N'WC900547           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2798, N'10045', N'OTHER               ', N'INDEPENDENT COMMISSION AGAINST CORRUPTION', N'WC900327           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2799, N'10050', N'OTHER               ', N'NSW OMBUDSMAN', N'WC900305           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2800, N'10052', N'OTHER               ', N'PUBLIC SERVICE COMMISSION', N'T10083             ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2801, N'10060', N'OTHER               ', N'NSW ELECTORAL COMMISSION', N'WC900311           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2802, N'10065', N'OTHER               ', N'NSW CRIME COMMISSION', N'WC900310           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2803, N'10069', N'OTHER               ', N'DEPARTMENT OF URBAN AFFAIRS', N'WC900306           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2804, N'10069', N'OTHER               ', N'MINISTRY OF URBAN INFRASTRUCTURE MANAGEM', N'WC900695           ', N'Miscellaneous')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2805, N'10090', N'OTHER               ', N'SOUTHERN METROPOLITIAN DEVELOP', N'WC900397           ', N'Miscellaneous')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2806, N'10090', N'OTHER               ', N'WESTERN SYDNEY DEVELOPMENTAL DISABILITY', N'WC900398           ', N'Miscellaneous')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2807, N'10142', N'OTHER               ', N'WORLD YOUTH DAY COORDINATION', N'MWJ3333309         ', N'Miscellaneous')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2808, N'10250', N'POLICE              ', N'SOUTH WEST METRO', N'MWJ3333297         ', N'7')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2809, N'10250', N'POLICE              ', N'POLICE - OTHER', N'WC900264           ', N'8')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2810, N'10250', N'POLICE              ', N'POLICE - OTHER', N'WC900332           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2811, N'10250', N'POLICE              ', N'POLICE - OTHER', N'WC900537           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2812, N'10250', N'POLICE              ', N'OPERATIONAL SUPPORT', N'WC900538           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2813, N'10250', N'POLICE              ', N'NORTHERN REGION', N'WC900539           ', N'7')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2814, N'10250', N'POLICE              ', N'NORTH-WEST REGION', N'WC900540           ', N'7')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2815, N'10250', N'POLICE              ', N'SOUTHERN REGION', N'WC900541           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2816, N'10250', N'POLICE              ', N'POLICE - OTHER', N'WC900542           ', N'7')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2817, N'10250', N'POLICE              ', N'POLICE - OTHER', N'WC900543           ', N'8')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2818, N'10250', N'POLICE              ', N'POLICE - OTHER', N'WC900544           ', N'8')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2819, N'10250', N'POLICE              ', N'POLICE - OTHER', N'WC900631           ', N'7')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2820, N'10250', N'POLICE              ', N'POLICE - OTHER', N'WC900720           ', N'7')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2821, N'10250', N'POLICE              ', N'POLICE - OTHER', N'WC900721           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2822, N'10250', N'POLICE              ', N'POLICE - OTHER', N'WC900722           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2823, N'10250', N'POLICE              ', N'POLICE - OTHER', N'WC900723           ', N'7')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2824, N'10250', N'POLICE              ', N'POLICE - OTHER', N'WC900724           ', N'7')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2825, N'10250', N'POLICE              ', N'POLICE - OTHER', N'WC900725           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2826, N'10250', N'POLICE              ', N'POLICE - OTHER', N'WC900726           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2827, N'10250', N'POLICE              ', N'POLICE - OTHER', N'WC900727           ', N'7')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2828, N'10250', N'POLICE              ', N'POLICE - OTHER', N'WC900728           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2829, N'10250', N'POLICE              ', N'POLICE - OTHER', N'WC900729           ', N'7')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2830, N'10250', N'POLICE              ', N'POLICE - OTHER', N'WC900730           ', N'8')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2831, N'10250', N'POLICE              ', N'POLICE - OTHER', N'WC900731           ', N'8')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2832, N'10250', N'POLICE              ', N'POLICE - OTHER', N'WC900732           ', N'8')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2833, N'10250', N'POLICE              ', N'POLICE - OTHER', N'WC900733           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2834, N'10250', N'POLICE              ', N'POLICE - OTHER', N'WC900734           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2835, N'10250', N'POLICE              ', N'POLICE - OTHER', N'WC900735           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2836, N'10250', N'POLICE              ', N'CENTRAL METROPOLITAN', N'WC900854           ', N'8')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2837, N'10250', N'POLICE              ', N'NORTH WEST METRO', N'WC900855           ', N'7')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2838, N'10250', N'POLICE              ', N'NORTHERN REGION', N'WC900856           ', N'7')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2839, N'10250', N'POLICE              ', N'SOUTHERN REGION', N'WC900857           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2840, N'10250', N'POLICE              ', N'SPECIALIST OPERATIONS', N'WC900859           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2841, N'10250', N'POLICE              ', N'OPERATIONS SUPPORT', N'WC900860           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2842, N'10250', N'POLICE              ', N'POLICE - OTHER', N'WC900861           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2843, N'10250', N'POLICE              ', N'WESTERN REGION', N'WC900862           ', N'8')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2844, N'10255', N'POLICE              ', N'POLICE - OTHER', N'WC900630           ', N'7')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2845, N'10260', N'OTHER               ', N'SES', N'WC900266           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2846, N'10260', N'OTHER               ', N'SES', N'WC900477           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2847, N'10265', N'OTHER               ', N'SES', N'T10082             ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2848, N'10270', N'OTHER               ', N'DCS', N'WC900276           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2849, N'10270', N'OTHER               ', N'DCS', N'WC900592           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2850, N'10270', N'OTHER               ', N'DCS', N'WC900593           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2851, N'10270', N'OTHER               ', N'DCS', N'WC900594           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2852, N'10270', N'OTHER               ', N'DCS', N'WC900595           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2853, N'10270', N'OTHER               ', N'DCS', N'WC900596           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2854, N'10270', N'OTHER               ', N'DCS', N'WC900597           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2855, N'10270', N'OTHER               ', N'DCS', N'WC900789           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2856, N'10270', N'OTHER               ', N'DCS', N'WC900790           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2857, N'10275', N'OTHER               ', N'DJJ', N'WC900536           ', N'5')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2858, N'10280', N'OTHER               ', N'DEPARTMENT OF LOCAL GOVERNMENT', N'WC900302           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2859, N'10305', N'OTHER               ', N'LPMA-STRATEGIC LANDS', N'MWJ3333319         ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2860, N'10305', N'OTHER               ', N'LPMA - HUNTER DEVELOPMENT CORP', N'MWJ3333320         ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2861, N'10305', N'OTHER               ', N'WASTE ASSET MANAGEMENT CORPORATION', N'T10067             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2862, N'10305', N'OTHER               ', N'LAND PROPERTY INFORMATION', N'WC900746           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2863, N'10305', N'OTHER               ', N'LAND AND PROPERTY MANAGEMENT AUTHORITY', N'WC900871           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2864, N'10355', N'FIRE                ', N'FIRE AND RESCUE NSW', N'WC900263           ', N'8')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2865, N'10355', N'FIRE                ', N'FIRE - OTHER', N'T10116             ', N'8')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2866, N'10355', N'FIRE                ', N'FIRE - OTHER', N'T10117             ', N'8')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2867, N'10355', N'FIRE                ', N'FIRE - OTHER', N'T10118             ', N'8')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2868, N'10355', N'FIRE                ', N'FIRE - OTHER', N'T10119             ', N'8')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2869, N'10355', N'FIRE                ', N'FIRE - OTHER', N'T10120             ', N'8')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2870, N'10355', N'FIRE                ', N'FIRE - OTHER', N'T10121             ', N'8')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2871, N'10355', N'FIRE                ', N'METROPOLITAN', N'T10122             ', N'8')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2872, N'10355', N'FIRE                ', N'METROPOLITAN', N'T10123             ', N'8')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2873, N'10355', N'FIRE                ', N'METROPOLITAN', N'T10124             ', N'8')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2874, N'10355', N'FIRE                ', N'METROPOLITAN', N'T10125             ', N'8')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2875, N'10355', N'FIRE                ', N'REGIONAL', N'T10126             ', N'8')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2876, N'10355', N'FIRE                ', N'REGIONAL', N'T10127             ', N'8')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2877, N'10355', N'FIRE                ', N'REGIONAL', N'T10128             ', N'8')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2878, N'10355', N'FIRE                ', N'FIRE - OTHER', N'T10129             ', N'8')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2879, N'10355', N'FIRE                ', N'FIRE - OTHER', N'T10130             ', N'8')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2880, N'10355', N'FIRE                ', N'FIRE - OTHER', N'T10131             ', N'8')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2881, N'10405', N'FIRE                ', N'DEPARTMENT OF RURAL FIRE SERVICES', N'WC900265           ', N'8')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2882, N'10460', N'OTHER               ', N'THE DEPARTMENT FOR WOMEN', N'WC900599           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2883, N'10475', N'OTHER               ', N'REDFERN WATERLOO AUTHORITY', N'WC900907           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2884, N'10500', N'OTHER               ', N'DEPARTMENT OF PLANNING', N'MWJ3333294         ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2885, N'10500', N'OTHER               ', N'HERITAGE OFFICE', N'WC900694           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2886, N'10594', N'OTHER               ', N'INFRASTRUCTURE NSW', N'T10087             ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2887, N'10597', N'OTHER               ', N'DEVELOPMENT AUTHORITY', N'T10084             ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2888, N'10644', N'OTHER               ', N'TRANSGRID', N'T10132             ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2889, N'15506', N'OTHER               ', N'THE AUDIT OFFICE OF NSW', N'WC900288           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2890, N'15513', N'OTHER               ', N'CORPORATION SOLE', N'WC900795           ', N'3')
GO
print 'Processed 100 total records'
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2891, N'15523', N'OTHER               ', N'LAND AND PROPERTY INFORMATION', N'WC900317           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2892, N'15524', N'OTHER               ', N'LUNA PARK RESERVE TRUST', N'WC900565           ', N'Miscellaneous')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2893, N'15549', N'OTHER               ', N'VALUER GENERAL S OFFICE', N'WC900318           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2894, N'15595', N'OTHER               ', N'LPMA - STATE PROPERTY AUTHORITY', N'MWJ3333303         ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2895, N'15596', N'OTHER               ', N'BARANGAROO DELIVERY AUTHORITY', N'MWJ3333315         ', N'Miscellaneous')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2896, N'15851', N'OTHER               ', N'ANZAC MEMORIAL TRUST', N'WC900576           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2897, N'15864', N'OTHER               ', N'NATIONAL TRUST OF AUSTRALIA (NSW)', N'WC900608           ', N'Miscellaneous')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2898, N'15864', N'OTHER               ', N'NATIONAL TRUST OF AUSTRALIA (NSW)', N'WC900611           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2899, N'20608', N'OTHER               ', N'CITY WEST HOUSING', N'WC900633           ', N'Miscellaneous')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2900, N'20653', N'OTHER               ', N'SYDNEY HARBOUR FORESHORE AUTHORITY', N'WC900291           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2901, N'20653', N'OTHER               ', N'SYDNEY HARBOUR FORESHORE AUTHORITY', N'WC900415           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2902, N'20653', N'OTHER               ', N'SYDNEY HARBOUR FORESHORE AUTHORITY', N'WC900775           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2903, N'25664', N'OTHER               ', N'COBBORA HOLDING COMPANY PTY LTD', N'T10068             ', N'Miscellaneous')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2904, N'10090J', N'HEALTH              ', N'SYDNEY CHILDREN''S HOSPITAL NETWORK', N'T10029             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2905, N'10090J', N'HEALTH              ', N'SYDNEY CHILDREN''S HOSPITAL NETWORK', N'T10078             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2906, N'10090J', N'HEALTH              ', N'SYDNEY CHILDREN''S HOSPITAL NETWORK', N'WC900246           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2907, N'10090J', N'HEALTH              ', N'SYDNEY CHILDREN''S HOSPITAL NETWORK', N'WC900675           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2908, N'10090K', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'WC900060           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2909, N'10090K', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'WC900186           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2910, N'10090K', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'WC900202           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2911, N'10090K', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'WC900338           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2912, N'10090K', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'WC900354           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2913, N'10090K', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'WC900362           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2914, N'10090K', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'WC900370           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2915, N'10090K', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'WC900376           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2916, N'10090K', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'WC900489           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2917, N'10090L', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'WC900180           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2918, N'10090L', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'WC900188           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2919, N'10090L', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'WC900355           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2920, N'10090L', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'WC900357           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2921, N'10090L', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'WC900369           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2922, N'10090L', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'WC900473           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2923, N'10090L', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'WC900490           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2924, N'10090R', N'HEALTH              ', N'ST VINCENT LOCAL HEALTH NETWORK', N'T10022             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2925, N'10090R', N'HEALTH              ', N'ST VINCENT LOCAL HEALTH NETWORK', N'T10024             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2926, N'10090R', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'WC900034           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2927, N'10090R', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900241           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2928, N'10090R', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900340           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2929, N'10090R', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'WC900356           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2930, N'10090R', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'WC900359           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2931, N'10090R', N'HEALTH              ', N'SOUTHERN NSW LOCAL HEALTH DISTRICT', N'WC900472           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2932, N'10090R', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900488           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2933, N'10090R', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900494           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2934, N'10090R', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900525           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2935, N'10090R', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'WC900531           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2936, N'10090R', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'WC900821           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2937, N'10090S', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'WC900385           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2938, N'10090S', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900471           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2939, N'10090S', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'WC900486           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2940, N'10090S', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900605           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2941, N'10090Y', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'T10017             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2942, N'10090Y', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'T10018             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2943, N'10090Y', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'T10019             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2944, N'10090Y', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'T10020             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2945, N'10090Y', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'T10021             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2946, N'10090Y', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'T10028             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2947, N'10090Y', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'T10032             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2948, N'10090Y', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'T10033             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2949, N'10090Y', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'T10034             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2950, N'10090Y', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'T10041             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2951, N'10090Y', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'T10042             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2952, N'10090Y', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'T10043             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2953, N'10090Y', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'T10044             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2954, N'10090Y', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'T10045             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2955, N'10090Y', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'T10046             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2956, N'10090Y', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'T10047             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2957, N'10090Y', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'T10048             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2958, N'10090Y', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'T10049             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2959, N'10090Y', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'WC900352           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2960, N'10090Y', N'HEALTH              ', N'HEALTH SUPPORT SERVICES', N'WC900375           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2961, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'T10058             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2962, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'T10076             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2963, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900007           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2964, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900008           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2965, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900010           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2966, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900011           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2967, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900059           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2968, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900074           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2969, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900230           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2970, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900235           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2971, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900245           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2972, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900252           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2973, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900366           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2974, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900371           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2975, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900386           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2976, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900422           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2977, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900451           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2978, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900530           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2979, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900577           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2980, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900662           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2981, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900702           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2982, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900780           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2983, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900816           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2984, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'WC900817           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2985, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'T10092             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2986, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'T10095             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2987, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'T10096             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2988, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'T10133             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2989, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'T10134             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2990, N'15090A', N'HEALTH              ', N'SYDNEY LOCAL HEALTH DISTRICT', N'T10135             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2991, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'T10014             ', N'2')
GO
print 'Processed 200 total records'
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2992, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'T10059             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2993, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'T10077             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2994, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'WC900051           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2995, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'WC900052           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2996, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'WC900053           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2997, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'WC900054           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2998, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'WC900055           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (2999, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'WC900056           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3000, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'WC900228           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3001, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'WC900233           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3002, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'WC900238           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3003, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'WC900372           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3004, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'WC900390           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3005, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'WC900436           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3006, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'WC900437           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3007, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'WC900499           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3008, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'WC900500           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3009, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'WC900501           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3010, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'WC900533           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3011, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'WC900534           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3012, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'WC900686           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3013, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'T10093             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3014, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'T10094             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3015, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'T10097             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3016, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'T10136             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3017, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'T10137             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3018, N'15090B', N'HEALTH              ', N'SOUTH WEST SYDNEY HEALTH DISTRICT', N'T10138             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3019, N'15090C', N'HEALTH              ', N'SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'T10057             ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3020, N'15090C', N'HEALTH              ', N'SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'WC900013           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3021, N'15090C', N'HEALTH              ', N'SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'WC900014           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3022, N'15090C', N'HEALTH              ', N'SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'WC900015           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3023, N'15090C', N'HEALTH              ', N'SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'WC900016           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3024, N'15090C', N'HEALTH              ', N'SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'WC900017           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3025, N'15090C', N'HEALTH              ', N'SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'WC900057           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3026, N'15090C', N'HEALTH              ', N'SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'WC900058           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3027, N'15090C', N'HEALTH              ', N'SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'WC900079           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3028, N'15090C', N'HEALTH              ', N'SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'WC900082           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3029, N'15090C', N'HEALTH              ', N'SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'WC900232           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3030, N'15090C', N'HEALTH              ', N'SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'WC900240           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3031, N'15090C', N'HEALTH              ', N'SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'WC900392           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3032, N'15090C', N'HEALTH              ', N'SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'WC900674           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3033, N'15090C', N'HEALTH              ', N'SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'WC900676           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3034, N'15090C', N'HEALTH              ', N'SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'WC900677           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3035, N'15090C', N'HEALTH              ', N'SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'WC900678           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3036, N'15090C', N'HEALTH              ', N'SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'T10110             ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3037, N'15090C', N'HEALTH              ', N'SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'T10111             ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3038, N'15090C', N'HEALTH              ', N'SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'T10112             ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3039, N'15090C', N'HEALTH              ', N'SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'T10113             ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3040, N'15090C', N'HEALTH              ', N'SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'T10114             ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3041, N'15090C', N'HEALTH              ', N'SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'T10115             ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3042, N'15090D', N'HEALTH              ', N'ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'T10030             ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3043, N'15090D', N'HEALTH              ', N'ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'T10056             ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3044, N'15090D', N'HEALTH              ', N'ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'WC900033           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3045, N'15090D', N'HEALTH              ', N'ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'WC900035           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3046, N'15090D', N'HEALTH              ', N'ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'WC900036           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3047, N'15090D', N'HEALTH              ', N'ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'WC900037           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3048, N'15090D', N'HEALTH              ', N'ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'WC900038           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3049, N'15090D', N'HEALTH              ', N'ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'WC900039           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3050, N'15090D', N'HEALTH              ', N'ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'WC900040           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3051, N'15090D', N'HEALTH              ', N'ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'WC900041           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3052, N'15090D', N'HEALTH              ', N'ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'WC900193           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3053, N'15090D', N'HEALTH              ', N'ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'WC900440           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3054, N'15090D', N'HEALTH              ', N'ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'WC900452           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3055, N'15090D', N'HEALTH              ', N'ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'WC900749           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3056, N'15090D', N'HEALTH              ', N'ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'WC900818           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3057, N'15090D', N'HEALTH              ', N'ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'WC900819           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3058, N'15090D', N'HEALTH              ', N'ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'WC900820           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3059, N'15090D', N'HEALTH              ', N'ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'WC900822           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3060, N'15090D', N'HEALTH              ', N'ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'T10104             ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3061, N'15090D', N'HEALTH              ', N'ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'T10105             ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3062, N'15090D', N'HEALTH              ', N'ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'T10106             ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3063, N'15090D', N'HEALTH              ', N'ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'T10107             ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3064, N'15090D', N'HEALTH              ', N'ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'T10108             ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3065, N'15090D', N'HEALTH              ', N'ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'T10109             ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3066, N'15090E', N'HEALTH              ', N'WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'T10010             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3067, N'15090E', N'HEALTH              ', N'WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'T10011             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3068, N'15090E', N'HEALTH              ', N'WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'T10012             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3069, N'15090E', N'HEALTH              ', N'WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'T10013             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3070, N'15090E', N'HEALTH              ', N'WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'T10038             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3071, N'15090E', N'HEALTH              ', N'WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'T10039             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3072, N'15090E', N'HEALTH              ', N'WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'T10040             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3073, N'15090E', N'HEALTH              ', N'WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'T10060             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3074, N'15090E', N'HEALTH              ', N'WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'T10073             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3075, N'15090E', N'HEALTH              ', N'WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'T10075             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3076, N'15090E', N'HEALTH              ', N'WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'T10086             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3077, N'15090E', N'HEALTH              ', N'WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'WC900068           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3078, N'15090E', N'HEALTH              ', N'WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'WC900069           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3079, N'15090E', N'HEALTH              ', N'WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'WC900070           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3080, N'15090E', N'HEALTH              ', N'WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'WC900083           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3081, N'15090E', N'HEALTH              ', N'WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'WC900239           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3082, N'15090E', N'HEALTH              ', N'WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'WC900377           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3083, N'15090E', N'HEALTH              ', N'WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'WC900391           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3084, N'15090E', N'HEALTH              ', N'WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'WC900684           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3085, N'15090F', N'HEALTH              ', N'NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'T10037             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3086, N'15090F', N'HEALTH              ', N'NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'T10061             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3087, N'15090F', N'HEALTH              ', N'NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'T10062             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3088, N'15090F', N'HEALTH              ', N'NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'T10063             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3089, N'15090F', N'HEALTH              ', N'NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'T10064             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3090, N'15090F', N'HEALTH              ', N'NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'T10072             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3091, N'15090F', N'HEALTH              ', N'NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'T10074             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3092, N'15090F', N'HEALTH              ', N'NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'T10080             ', N'3')
GO
print 'Processed 300 total records'
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3093, N'15090F', N'HEALTH              ', N'NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'T10081             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3094, N'15090F', N'HEALTH              ', N'NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'T10085             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3095, N'15090F', N'HEALTH              ', N'NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'WC900061           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3096, N'15090F', N'HEALTH              ', N'NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'WC900062           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3097, N'15090F', N'HEALTH              ', N'NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'WC900063           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3098, N'15090F', N'HEALTH              ', N'NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'WC900064           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3099, N'15090F', N'HEALTH              ', N'NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'WC900065           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3100, N'15090F', N'HEALTH              ', N'NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'WC900066           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3101, N'15090F', N'HEALTH              ', N'NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'WC900085           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3102, N'15090F', N'HEALTH              ', N'NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'WC900171           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3103, N'15090F', N'HEALTH              ', N'NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'WC900178           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3104, N'15090F', N'HEALTH              ', N'NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'WC900445           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3105, N'15090F', N'HEALTH              ', N'NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'WC900446           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3106, N'15090F', N'HEALTH              ', N'NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'WC900528           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3107, N'15090F', N'HEALTH              ', N'NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'WC900529           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3108, N'15090F', N'HEALTH              ', N'NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'WC900546           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3109, N'15090F', N'HEALTH              ', N'NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'WC900910           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3110, N'15090F', N'HEALTH              ', N'NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'WC900911           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3111, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'T10054             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3112, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'T10069             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3113, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900090           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3114, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900091           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3115, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900092           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3116, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900094           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3117, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900095           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3118, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900096           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3119, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900097           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3120, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900098           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3121, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900099           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3122, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900100           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3123, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900101           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3124, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900102           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3125, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900103           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3126, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900104           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3127, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900105           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3128, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900106           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3129, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900107           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3130, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900108           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3131, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900109           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3132, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900110           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3133, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900111           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3134, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900113           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3135, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900114           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3136, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900159           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3137, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900170           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3138, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900187           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3139, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900191           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3140, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900197           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3141, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900199           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3142, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900204           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3143, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900226           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3144, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900341           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3145, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900655           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3146, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900777           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3147, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'WC900794           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3148, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'T10101             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3149, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'T10102             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3150, N'15090J', N'HEALTH              ', N'MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'T10103             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3151, N'15090K', N'HEALTH              ', N'SOUTHERN NSW LOCAL HEALTH DISTRICT', N'T10055             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3152, N'15090K', N'HEALTH              ', N'SOUTHERN NSW LOCAL HEALTH DISTRICT', N'WC900050           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3153, N'15090K', N'HEALTH              ', N'SOUTHERN NSW LOCAL HEALTH DISTRICT', N'WC900189           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3154, N'15090K', N'HEALTH              ', N'SOUTHERN NSW LOCAL HEALTH DISTRICT', N'WC900190           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3155, N'15090K', N'HEALTH              ', N'SOUTHERN NSW LOCAL HEALTH DISTRICT', N'WC900192           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3156, N'15090K', N'HEALTH              ', N'SOUTHERN NSW LOCAL HEALTH DISTRICT', N'WC900194           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3157, N'15090K', N'HEALTH              ', N'SOUTHERN NSW LOCAL HEALTH DISTRICT', N'WC900195           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3158, N'15090K', N'HEALTH              ', N'SOUTHERN NSW LOCAL HEALTH DISTRICT', N'WC900198           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3159, N'15090K', N'HEALTH              ', N'SOUTHERN NSW LOCAL HEALTH DISTRICT', N'WC900200           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3160, N'15090K', N'HEALTH              ', N'SOUTHERN NSW LOCAL HEALTH DISTRICT', N'WC900201           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3161, N'15090K', N'HEALTH              ', N'SOUTHERN NSW LOCAL HEALTH DISTRICT', N'WC900203           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3162, N'15090K', N'HEALTH              ', N'SOUTHERN NSW LOCAL HEALTH DISTRICT', N'WC900227           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3163, N'15090K', N'HEALTH              ', N'SOUTHERN NSW LOCAL HEALTH DISTRICT', N'WC900229           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3164, N'15090K', N'HEALTH              ', N'SOUTHERN NSW LOCAL HEALTH DISTRICT', N'WC900256           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3165, N'15090K', N'HEALTH              ', N'SOUTHERN NSW LOCAL HEALTH DISTRICT', N'T10098             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3166, N'15090K', N'HEALTH              ', N'SOUTHERN NSW LOCAL HEALTH DISTRICT', N'T10099             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3167, N'15090K', N'HEALTH              ', N'SOUTHERN NSW LOCAL HEALTH DISTRICT', N'T10100             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3168, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'T10065             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3169, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'T10088             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3170, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'T10089             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3171, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900116           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3172, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900117           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3173, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900119           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3174, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900120           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3175, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900121           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3176, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900122           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3177, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900123           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3178, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900124           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3179, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900125           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3180, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900126           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3181, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900127           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3182, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900130           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3183, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900131           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3184, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900132           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3185, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900133           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3186, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900136           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3187, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900137           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3188, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900138           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3189, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900160           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3190, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900161           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3191, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900162           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3192, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900163           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3193, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900164           ', N'3')
GO
print 'Processed 400 total records'
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3194, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900165           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3195, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900166           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3196, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900167           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3197, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900168           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3198, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900169           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3199, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900172           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3200, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900173           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3201, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900174           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3202, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900175           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3203, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900176           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3204, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900181           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3205, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900182           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3206, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900183           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3207, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900185           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3208, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900374           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3209, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900601           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3210, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900639           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3211, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900640           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3212, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900641           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3213, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900642           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3214, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900643           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3215, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900644           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3216, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900645           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3217, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900646           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3218, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900647           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3219, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900648           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3220, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900667           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3221, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900668           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3222, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900669           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3223, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900670           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3224, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900671           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3225, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900748           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3226, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900935           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3227, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900959           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3228, N'15090L', N'HEALTH              ', N'WESTERN NSW LOCAL DISTRICT', N'WC900975           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3229, N'15090M', N'HEALTH              ', N'FAR WEST LOCAL HEALTH DISTRICT', N'T10066             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3230, N'15090M', N'HEALTH              ', N'FAR WEST LOCAL HEALTH DISTRICT', N'WC900089           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3231, N'15090M', N'HEALTH              ', N'FAR WEST LOCAL HEALTH DISTRICT', N'WC900115           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3232, N'15090M', N'HEALTH              ', N'FAR WEST LOCAL HEALTH DISTRICT', N'WC900118           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3233, N'15090M', N'HEALTH              ', N'FAR WEST LOCAL HEALTH DISTRICT', N'WC900129           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3234, N'15090M', N'HEALTH              ', N'FAR WEST LOCAL HEALTH DISTRICT', N'WC900134           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3235, N'15090M', N'HEALTH              ', N'FAR WEST LOCAL HEALTH DISTRICT', N'WC900139           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3236, N'15090M', N'HEALTH              ', N'FAR WEST LOCAL HEALTH DISTRICT', N'WC900603           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3237, N'15090M', N'HEALTH              ', N'FAR WEST LOCAL HEALTH DISTRICT', N'WC900604           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3238, N'15090M', N'HEALTH              ', N'FAR WEST LOCAL HEALTH DISTRICT', N'WC900745           ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3239, N'15090M', N'HEALTH              ', N'FAR WEST LOCAL HEALTH DISTRICT', N'T10090             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3240, N'15090M', N'HEALTH              ', N'FAR WEST LOCAL HEALTH DISTRICT', N'T10091             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3241, N'15090R', N'HEALTH              ', N'CLINICAL SUPPORT CLUSTER', N'T10052             ', N'Miscellaneous')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3242, N'15090S', N'HEALTH              ', N'CLINICAL SUPPORT CLUSTER', N'T10053             ', N'Miscellaneous')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3243, N'15090U', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'T10023             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3244, N'15090U', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'T10025             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3245, N'15090U', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'T10026             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3246, N'15090U', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'T10027             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3247, N'15090U', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'T10050             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3248, N'15090U', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'WC900080           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3249, N'15090U', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'WC900196           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3250, N'15090U', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'WC900259           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3251, N'15090U', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'WC900345           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3252, N'15090U', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'WC900349           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3253, N'15090U', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'WC900441           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3254, N'15090U', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'WC900444           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3255, N'15090U', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'WC900502           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3256, N'15090U', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'WC900503           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3257, N'15090U', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'WC900504           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3258, N'15090U', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'WC900535           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3259, N'15090U', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'WC900654           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3260, N'15090U', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'WC900673           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3261, N'15090U', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'WC900679           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3262, N'15090U', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'WC900751           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3263, N'15090U', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'WC900776           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3264, N'15090U', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'WC900778           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3265, N'15090U', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'WC900779           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3266, N'15090U', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'WC900783           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3267, N'15090U', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'WC900793           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3268, N'15090U', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'WC900796           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3269, N'15090V', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'T10003             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3270, N'15090V', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'T10004             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3271, N'15090V', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'T10005             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3272, N'15090V', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'T10006             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3273, N'15090V', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'T10007             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3274, N'15090V', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'T10008             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3275, N'15090V', N'HEALTH              ', N'HEALTH REFORM TRANSITIONAL OFFICE', N'T10009             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3276, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'T10016             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3277, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'T10036             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3278, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'T10051             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3279, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'T10071             ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3280, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900339           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3281, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900342           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3282, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900343           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3283, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900346           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3284, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900348           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3285, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900365           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3286, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900383           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3287, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900384           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3288, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900435           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3289, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900450           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3290, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900474           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3291, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900487           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3292, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900523           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3293, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900586           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3294, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900602           ', N'2')
GO
print 'Processed 500 total records'
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3295, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900606           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3296, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900607           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3297, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900666           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3298, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900703           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3299, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900791           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3300, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900803           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3301, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900829           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3302, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900830           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3303, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900831           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3304, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900832           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3305, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900833           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3306, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900834           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3307, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900835           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3308, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900836           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3309, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900837           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3310, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900838           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3311, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900839           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3312, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900840           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3313, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900881           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3314, N'15090V', N'HEALTH              ', N'PATHOLOGY SERVICES', N'WC900906           ', N'2')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3315, N'15090W', N'HEALTH              ', N'ST VINCENT LOCAL HEALTH NETWORK', N'T10070             ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3316, N'15090W', N'HEALTH              ', N'ST VINCENT LOCAL HEALTH NETWORK', N'WC900078           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3317, N'15090W', N'HEALTH              ', N'ST VINCENT LOCAL HEALTH NETWORK', N'WC900081           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3318, N'15090W', N'HEALTH              ', N'ST VINCENT LOCAL HEALTH NETWORK', N'WC900249           ', N'1')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3319, N'15190C', N'HEALTH              ', N'ALBURY WODONGA HEALTH', N'T10035             ', N'3')
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Id], [AgencyId], [AgencyName], [Sub_Category], [POLICY_NO], [Group]) VALUES (3320, N'15190G', N'HEALTH              ', N'NSW SERVICE FOR THE TREATMENT AND REHABILITATION OF TORTURE AND TRAUMA SURVIVORS', N'T10079             ', N'1')
SET IDENTITY_INSERT [dbo].[TMF_Agencies_Sub_Category] OFF

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\SchemaChange\TMF_Agencies_Sub_Category.sql  
--------------------------------  
---------------------------------------------------------- 
------------------- UserDefinedFunction 
---------------------------------------------------------- 
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_CheckPositiveOrNegative.sql  
--------------------------------  
/****** Object:  UserDefinedFunction [dbo].[udf_CheckPositiveOrNegative]    Script Date: 02/21/2013 11:19:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_CheckPositiveOrNegative]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_CheckPositiveOrNegative]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_CheckPositiveOrNegative]    Script Date: 02/21/2013 11:19:48 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[udf_CheckPositiveOrNegative](@Is_negative money)
	returns INTEGER
as
BEGIN
	return CASE WHEN  @Is_negative < 0 THEN -1
				ELSE 1
			END

end

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[udf_CheckPositiveOrNegative] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_CheckPositiveOrNegative] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_CheckPositiveOrNegative] TO [DART_Role]
GO
--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_CheckPositiveOrNegative.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_ExtractMedCertStatus.sql  
--------------------------------  
/****** Object:  UserDefinedFunction [dbo].[udf_ExtractMedCertStatus]    Script Date: 02/21/2013 11:19:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_ExtractMedCertStatus]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_ExtractMedCertStatus]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_ExtractMedCertStatus]    Script Date: 02/21/2013 11:19:48 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].[udf_ExtractMedCertStatus](@Med_Cert_Type char)
RETURNS varchar (20) 
AS 
BEGIN
	return (CASE WHEN @Med_Cert_Type = 'T' THEN 'Totally Unfit'
			WHEN @Med_Cert_Type = 'S' THEN 'Suitable Duties'
			WHEN @Med_Cert_Type = 'P' THEN 'No Time Lost'
			WHEN @Med_Cert_Type = 'M' THEN 'Permanently Modified Duties' ELSE 'Pre-Injury Duties' END)
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[udf_ExtractMedCertStatus] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_ExtractMedCertStatus] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_ExtractMedCertStatus] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_ExtractMedCertStatus.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_ExtractMedCertStatus_Code.sql  
--------------------------------  
/****** Object:  UserDefinedFunction [dbo].[udf_ExtractMedCertStatus_Code]    Script Date: 02/21/2013 11:19:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_ExtractMedCertStatus_Code]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_ExtractMedCertStatus_Code]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_ExtractMedCertStatus_Code]    Script Date: 02/21/2013 11:19:48 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].[udf_ExtractMedCertStatus_Code](@Med_Cert_Type char)
RETURNS varchar (20) 
AS 
BEGIN
	return (CASE WHEN @Med_Cert_Type = 'T' THEN 'TU'
			WHEN @Med_Cert_Type = 'S' THEN 'SID'
			WHEN @Med_Cert_Type = 'P' THEN 'UNK'
			WHEN @Med_Cert_Type = 'M' THEN 'PMD'
			WHEN @Med_Cert_Type = 'I' THEN 'PID' ELSE 'Nil TL' END)
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[udf_ExtractMedCertStatus_Code] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_ExtractMedCertStatus_Code] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_ExtractMedCertStatus_Code] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_ExtractMedCertStatus_Code.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_GetAgencyNameByPolicyNo.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetAgencyNameByPolicyNo') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetAgencyNameByPolicyNo
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetAgencyNameByPolicyNo    Script Date: 02/21/2013 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
--select dbo.udf_GetAgencyNameByPolicyNo('gdfgdfg')
CREATE function [dbo].udf_GetAgencyNameByPolicyNo(@Policy_no char(19))
	returns char(20)
as
begin
	declare @AgencyName char(20)
	select @AgencyName =  AgencyName from dbo.TMF_Agencies_Sub_Category where Policy_no = @Policy_no	
	RETURN 	rtrim(isnull(@AgencyName,'Miscellaneous'))	
end

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON


GO
GRANT  EXECUTE  ON [dbo].udf_GetAgencyNameByPolicyNo TO [EMICS]
GRANT  EXECUTE  ON [dbo].udf_GetAgencyNameByPolicyNo TO [EMIUS]
GRANT  EXECUTE  ON [dbo].udf_GetAgencyNameByPolicyNo TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_GetAgencyNameByPolicyNo.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_GetGroupByPolicyNo.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetGroupByPolicyNo') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetGroupByPolicyNo
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetGroupByPolicyNo    Script Date: 02/21/2013 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
--select dbo.udf_GetGroupByPolicyNo('fsdfsdf')
CREATE function [dbo].udf_GetGroupByPolicyNo(@Policy_no char(19))
	returns varchar(20)	 
AS
	BEGIN
		declare @Group char(20)
		select @Group =  [Group] from dbo.TMF_Agencies_Sub_Category where Policy_no = @Policy_no	
		RETURN 	rtrim(isnull(@Group,'Miscellaneous'))		
	END 
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON


GO
GRANT  EXECUTE  ON [dbo].udf_GetGroupByPolicyNo TO [EMICS]
GRANT  EXECUTE  ON [dbo].udf_GetGroupByPolicyNo TO [EMIUS]
GRANT  EXECUTE  ON [dbo].udf_GetGroupByPolicyNo TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_GetGroupByPolicyNo.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_GetIncapWeekForEntitlement.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_GetIncapWeekForEntitlement]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_GetIncapWeekForEntitlement]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_GetIncapWeekForEntitlement]    Script Date: 08/11/2014 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].[udf_GetIncapWeekForEntitlement](@IncapWeekStart DATETIME, @IncapWeekEnd DATETIME)    
RETURNS Int As
BEGIN
	DECLARE @NoOfWeeks INT
	SET @NoOfWeeks = ISNULL(DATEDIFF(WEEK, @IncapWeekStart, @IncapWeekEnd), 0)
	
	DECLARE @k INT
	SET @k = -1
			
	DECLARE @i INT
	SET @i = 0
	
	WHILE (@i <= @NoOfWeeks)
	BEGIN
		IF @IncapWeekStart + 7 * @i <= @IncapWeekEnd
		BEGIN
			SET @k = @i
		END
		SET @i = @i + 1
	END
	
	RETURN @k
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

GRANT  EXECUTE  ON [dbo].[udf_GetIncapWeekForEntitlement] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_GetIncapWeekForEntitlement] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_GetIncapWeekForEntitlement] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_GetIncapWeekForEntitlement.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_GetLiabilityStatusById.sql  
--------------------------------  
/****** Object:  UserDefinedFunction [dbo].[udf_GetLiabilityStatusById]    Script Date: 02/21/2013 11:19:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_GetLiabilityStatusById]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_GetLiabilityStatusById]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_GetLiabilityStatusById]    Script Date: 02/21/2013 11:19:48 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE function [dbo].[udf_GetLiabilityStatusById](@Liability_Status smallint)
	returns nvarchar(256)
as
BEGIN
	return CASE WHEN @Liability_Status = 1 then 'Notification of work related injury'
				WHEN @Liability_Status =2 then 'Liability accepted'
				WHEN @Liability_Status =5 then 'Liability not yet determined'
				WHEN @Liability_Status =6 then 'Administration error'
				WHEN @Liability_Status =7 then 'Liability denied'
				WHEN @Liability_Status =8 then 'Provisional liability accepted - weekly and medical payments'
				WHEN @Liability_Status =9 then 'Reasonable excuse'
				WHEN @Liability_Status =10 then 'Provisional liability discontinued'
				WHEN @Liability_Status =11 then 'Provisional liability accepted - medical only, weekly payments not applicable'
				WHEN @Liability_Status =12 then 'No action after notification'
				ELSE ''
			END
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[udf_GetLiabilityStatusById] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_GetLiabilityStatusById] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_GetLiabilityStatusById] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_GetLiabilityStatusById.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_GetSubCategoryByPolicyNo.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetSubCategoryByPolicyNo') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetSubCategoryByPolicyNo
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetSubCategoryByPolicyNo    Script Date: 02/21/2013 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
--select dbo.udf_GetSubCategoryByPolicyNo('fsdfsdf')
CREATE function [dbo].udf_GetSubCategoryByPolicyNo(@Policy_no char(19))
	returns varchar(256)
as
	BEGIN
		declare @sub_category varchar(256)
		select @sub_category =  sub_category from dbo.TMF_Agencies_Sub_Category where Policy_no = @Policy_no	
		RETURN 	isnull(@sub_category,'Miscellaneous')		
	END 

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON


GO
GRANT  EXECUTE  ON [dbo].udf_GetSubCategoryByPolicyNo TO [EMICS]
GRANT  EXECUTE  ON [dbo].udf_GetSubCategoryByPolicyNo TO [EMIUS]
GRANT  EXECUTE  ON [dbo].udf_GetSubCategoryByPolicyNo TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_GetSubCategoryByPolicyNo.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_MaxDay.sql  
--------------------------------  
/****** Object:  UserDefinedFunction [dbo].[udf_MaxDay]    Script Date: 02/21/2013 11:11:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_MaxDay]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_MaxDay]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_MaxDay]    Script Date: 02/21/2013 11:11:26 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


create function [dbo].[udf_MaxDay](@day1 DATETIME, @day2 DATETIME, @day3 DATETIME)
	returns DATETIME
as
begin
	return CASE WHEN @day1 >= @day2 and @day1 >= @day3 then @day1
				WHEN @day2 >= @day1 and @day2 >= @day3 then @day2
				WHEN @day3 >= @day1 and @day3 >= @day2 then @day3
			END
end

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[udf_MaxDay] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_MaxDay] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_MaxDay] TO [DART_Role]
GO

--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_MaxDay.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_MaxValue.sql  
--------------------------------  
/****** Object:  UserDefinedFunction [dbo].[udf_MaxValue]    Script Date: 05/27/2013 14:42:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_MaxValue]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_MaxValue]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_MaxValue]    Script Date: 05/27/2013 14:42:39 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO




CREATE FUNCTION [dbo].[udf_MaxValue](@num1 FLOAT, @num2 FLOAT)  
RETURNS FLOAT As  
BEGIN
	return CASE WHEN  @num1 >= @num2 THEN @num1
				ELSE @num2
			END
END  


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF

GO
GRANT  EXECUTE  ON [dbo].[udf_MaxValue] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_MaxValue] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_MaxValue] TO [DART_Role]
GO


--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_MaxValue.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_MinDay.sql  
--------------------------------  
/****** Object:  UserDefinedFunction [dbo].[udf_MinDay]    Script Date: 02/21/2013 11:12:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_MinDay]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_MinDay]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_MinDay]    Script Date: 02/21/2013 11:12:21 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


create function [dbo].[udf_MinDay](@day1 DATETIME, @day2 DATETIME, @day3 DATETIME)
	returns DATETIME
as
begin
	return CASE WHEN @day1 <= @day2 and @day1 <= @day3 then @day1
				WHEN @day2 <= @day1 and @day2 <= @day3 then @day2
				WHEN @day3 <= @day1 and @day3 <= @day2 then @day3
			END
end


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[udf_MinDay] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_MinDay] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_MinDay] TO [DART_Role]
GO


--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_MinDay.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_MinValue.sql  
--------------------------------  
/****** Object:  UserDefinedFunction [dbo].[udf_MinValue]    Script Date: 05/27/2013 14:43:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_MinValue]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_MinValue]
GO
/****** Object:  UserDefinedFunction [dbo].[udf_MinValue]    Script Date: 05/27/2013 14:43:37 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO




CREATE FUNCTION [dbo].[udf_MinValue](@num1 FLOAT, @num2 FLOAT)  
RETURNS FLOAT As  
BEGIN
	return CASE WHEN  @num1 >= @num2 THEN @num2
				ELSE @num1
			END
END


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF

GO
GRANT  EXECUTE  ON [dbo].[udf_MinValue] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_MinValue] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_MinValue] TO [DART_Role]
GO
--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_MinValue.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_NoOfDaysWithoutWeekend.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_NoOfDaysWithoutWeekend]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_NoOfDaysWithoutWeekend]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_NoOfDaysWithoutWeekend]    Script Date: 02/21/2013 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].[udf_NoOfDaysWithoutWeekend](@StartDate DATETIME, @Enddate DATETIME)    
RETURNS Int As    
BEGIN   


return  ((DATEDIFF(dd, @StartDate, @EndDate) + 1)

-(DATEDIFF(wk, @StartDate, @EndDate) * 2)

-(CASE WHEN DATENAME(dw, @StartDate) = 'Sunday' THEN 1 ELSE 0 END)

-(CASE WHEN DATENAME(dw, @EndDate) = 'Saturday' THEN 1 ELSE 0 END))
  
END 


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[udf_NoOfDaysWithoutWeekend] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_NoOfDaysWithoutWeekend] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_NoOfDaysWithoutWeekend] TO [DART_Role]
GO
 --------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_NoOfDaysWithoutWeekend.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_TMF_GetGroupByTeam.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_TMF_GetGroupByTeam') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_TMF_GetGroupByTeam
GO

/****** Object:  UserDefinedFunction [dbo].udf_TMF_GetGroupByTeam    Script Date: 02/21/2013 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
--select dbo.udf_TMF_GetGroupByTeam('fsdfsdf')
CREATE function [dbo].udf_TMF_GetGroupByTeam(@Team varchar(20))
	returns varchar(20)	 
AS
	BEGIN
		declare @strReturn varchar(20)
		
		if RTRIM(ISNULL(@Team, '')) = ''
			begin
				set @strReturn = 'Miscellaneous'
			end
		else
			begin
				set @strReturn= replace(@Team,'tmf','')
			end
		select @strReturn =(case when PATINDEX('%[A-Z]%',@strReturn) >=2 
					then substring(@strReturn,1,PATINDEX('%[A-Z]%',@strReturn)-1)
		else @strReturn end)		
	
		
		RETURN 	(case when PATINDEX('%[A-Z]%',@strReturn) <1
					then @strReturn
				else 'Miscellaneous' end)	
	END 
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON


GO
GRANT  EXECUTE  ON [dbo].udf_TMF_GetGroupByTeam TO [EMICS]
GRANT  EXECUTE  ON [dbo].udf_TMF_GetGroupByTeam TO [EMIUS]
GRANT  EXECUTE  ON [dbo].udf_TMF_GetGroupByTeam TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_TMF_GetGroupByTeam.sql  
--------------------------------  
---------------------------------------------------------- 
------------------- View 
---------------------------------------------------------- 
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\View\uv_submitted_Transaction_Payments.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uv_submitted_Transaction_Payments]'))
DROP VIEW [dbo].[uv_submitted_Transaction_Payments]
GO

CREATE VIEW [dbo].[uv_submitted_Transaction_Payments]
AS
SELECT     dbo.Payment_Recovery.Claim_No, dbo.Payment_Recovery.WC_Payment_Type, CASE WHEN dbo.CLAIM_PAYMENT_RUN.Authorised_dte IS NOT NULL AND 
                      Payment_Recovery.Transaction_date < dbo.CLAIM_PAYMENT_RUN.Authorised_dte THEN dbo.CLAIM_PAYMENT_RUN.Authorised_dte ELSE Payment_Recovery.Transaction_date
                       END AS submitted_trans_date, dbo.Payment_Recovery.Payment_Type, dbo.Payment_Recovery.Trans_Amount, dbo.Payment_Recovery.Adjust_Trans_Flag, 
                      dbo.Payment_Recovery.Reversed, dbo.Payment_Recovery.wc_Tape_Month, dbo.Payment_Recovery.Payment_no, dbo.Payment_Recovery.itc, 
                      dbo.Payment_Recovery.gst, dbo.Payment_Recovery.Period_Start_Date, dbo.Payment_Recovery.Period_End_Date, dbo.Payment_Recovery.Estimate_type, 
                      dbo.Payment_Recovery.dam, CASE WHEN payment_type IN ('13','14', '15', '16','WPT001', 'WPT002','WPT003', 'WPT004','WPT005','WPT006','WPT007'
, 'WPP001','WPP002','WPP003','WPP004', 'WPP005', 'WPP006', 'WPP007','WPP008') THEN 1 ELSE 0 END AS WeeklyPayment
FROM         dbo.Payment_Recovery INNER JOIN
                      dbo.CLAIM_PAYMENT_RUN ON dbo.Payment_Recovery.Payment_no = dbo.CLAIM_PAYMENT_RUN.Payment_no
WHERE     (dbo.Payment_Recovery.wc_Tape_Month IS NOT NULL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

GRANT  SELECT  ON [dbo].[uv_submitted_Transaction_Payments] TO [EMICS]
GRANT  SELECT  ON [dbo].[uv_submitted_Transaction_Payments] TO [EMIUS]
GRANT  SELECT  ON [dbo].[uv_submitted_Transaction_Payments] TO [DART_Role]
GO

--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\View\uv_submitted_Transaction_Payments.sql  
--------------------------------  
---------------------------------------------------------- 
------------------- StoredProcedure 
---------------------------------------------------------- 
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_EML_AWC.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
-- execute [usp_Dashboard_EML_AWC] 2013, 1
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_EML_AWC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_EML_AWC]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_EML_AWC]
      @year int = 2011,
      @month int = 1
AS
BEGIN
	SET NOCOUNT ON
	IF OBJECT_ID('tempdb..#_Claim_list_adjusted') IS NOT NULL DROP TABLE #_Claim_list_adjusted
	IF OBJECT_ID('tempdb..#_Claim_Detail') IS NOT NULL DROP TABLE #_Claim_Detail
	IF OBJECT_ID('tempdb..#_Claim_List') IS NOT NULL DROP TABLE #_Claim_List		
	IF OBJECT_ID('tempdb..#AWC_list') IS NOT NULL DROP table #AWC_list
	IF OBJECT_ID('tempdb..#policy') IS NOT NULL DROP table #policy
	
	declare @startdate datetime = cast(cast(@year as char(4)) + '/'  + cast(@month as char(2)) + '/01' as datetime)
	declare @enddate datetime  = dateadd(dd, -1, dateadd(mm, 1, @startdate)) + '23:59'
	
	declare @SQL varchar(500)

	--Check temp table existing then drop	
	IF OBJECT_ID('tempdb..#_CLAIM_ESTIMATE_SUMMARY') IS NULL
	BEGIN
		create table #_CLAIM_ESTIMATE_SUMMARY
		(
			CLAIM_NO varCHAR(19)
			,TotalAmount MONEY
		) 
		
		SET @SQL = 'CREATE INDEX pk_CLAIM_ESTIMATE_SUMMARY'+CONVERT(VARCHAR, @@SPID)+' ON #_CLAIM_ESTIMATE_SUMMARY(CLAIM_NO, TotalAmount)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
			 
		INSERT INTO #_CLAIM_ESTIMATE_SUMMARY
			SELECT CLAIM_NO, SUM(ISNULL(Amount, 0)) 
			FROM ESTIMATE_DETAILS
			GROUP BY claim_no
	END
	
	CREATE TABLE #_Claim_Detail
	(
		policy_no char(19)
		,Claim_no varchar(19)
		,Claim_Closed_Flag CHAR(1)
		,Claim_Liability_Indicator TINYINT
		,renewal_no INT
	)
	
	SET @SQL = 'CREATE INDEX pk_Claim_Detail_'+CONVERT(VARCHAR, @@SPID)+' ON #_Claim_Detail(policy_no, Claim_no, Claim_Closed_Flag, Claim_Liability_Indicator)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	INSERT INTO #_Claim_Detail
		-- claim detail here
		SELECT  policy_no, 
				Claim_Number,
				Claim_Closed_Flag,
				Claim_Liability_Indicator, 
				Renewal_No
		FROM CLAIM_DETAIL cd INNER JOIN CLAIM_ACTIVITY_DETAIL cad 
			ON rtrim(cd.Claim_Number) =  rtrim(cad.Claim_no)
				AND Date_Created <= @enddate AND Claim_Number <> ''
				LEFT OUTER JOIN amendment_exemptions ae ON cd.Claim_Number = ae.claim_no

	CREATE TABLE #_Claim_List
	(
		Claim_no varchar(19)
		,EXCLUDE BIT
	)
	
	SET @SQL = 'CREATE INDEX pk_Claim_List'+CONVERT(VARCHAR, @@SPID)+' ON #_Claim_List(Claim_no, EXCLUDE)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	INSERT INTO #_Claim_List
	SELECT cd.Claim_no
		   ,EXCLUDE = (CASE WHEN (cd.Claim_Liability_Indicator IN (1,6,12)) 
								 OR (cd.Claim_Liability_Indicator IN (4) 
									AND ces.TotalAmount <= 0) 
								 OR (cd.Claim_Closed_Flag = 'Y' AND ces.TotalAmount = 0)  
							   THEN 1 
						   ELSE 0 
					   END)
	FROM #_Claim_Detail cd INNER JOIN #_CLAIM_ESTIMATE_SUMMARY ces 
									  ON cd.Claim_no = ces.CLAIM_NO

	CREATE TABLE #_Claim_list_adjusted
	(
		 Claim_no varchar(19)
		 ,submitted_trans_date datetime
		 ,Period_Start_Date datetime
		 ,Period_End_Date datetime
		 ,WC_Payment_Type varchar(8)
		 ,Payment_Type varchar(15)
		 ,Trans_Amount money
	)
	
	SET @SQL = 'CREATE NONCLUSTERED INDEX pk_Claim_List_submitted_trans_date_
				ON [dbo].[#_Claim_list_adjusted] (submitted_trans_date)
				INCLUDE ([Claim_no])'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	INSERT  INTO #_Claim_list_adjusted
	SELECT  u.claim_no
			, submitted_trans_date
			, Period_Start_Date
			, Period_End_Date
			, WC_Payment_Type
			, Payment_Type 
			,Trans_Amount = (SELECT SUM(ISNULL(u1.Trans_Amount, 0)) 
								FROM uv_submitted_Transaction_Payments u1
								WHERE u1.Claim_No = u.claim_no 
								and u1.Period_Start_Date = u.Period_Start_Date
								and u1.Period_End_Date = u.Period_End_Date 
								and u1.WC_Payment_Type = u.WC_Payment_Type 
								and u1.Payment_Type = u.payment_type)
	FROM uv_submitted_Transaction_Payments u
	WHERE u.submitted_trans_date = (SELECT min(u1.submitted_trans_date) 
									FROM uv_submitted_Transaction_Payments u1 
									WHERE u1.Claim_No = u.claim_no 
										  and u1.Period_Start_Date = u.Period_Start_Date 
										  and u1.Period_End_Date = u.Period_End_Date 
										  and u1.WC_Payment_Type = u.WC_Payment_Type 
										  and u1.Payment_Type = u.payment_type)
		and u.submitted_trans_date between @startdate and @enddate
		and u.WeeklyPayment = 1
	GROUP BY u.claim_no, submitted_trans_date
			 ,Period_Start_Date, Period_End_Date
			 ,WC_Payment_Type, Payment_Type
	ORDER BY claim_no, payment_type, Period_Start_Date, Period_End_Date


	SET @SQL = 'CREATE NONCLUSTERED INDEX pk_Claim_List_submitted_trans_date_Trans_Amount
				ON [dbo].[#_Claim_list_adjusted] (Trans_Amount)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	DELETE FROM #_Claim_list_adjusted WHERE Trans_Amount = 0
	DELETE FROM #_Claim_list_adjusted 
		   WHERE CLAIM_NO in (SELECT cla1.claim_no 
							  FROM #_Claim_list_adjusted cla1 
									inner join #_Claim_List cl on cla1.Claim_no = cl.Claim_no 
												and cl.EXCLUDE = 1)

	CREATE TABLE #AWC_list 
	(
		claim_no varchar (19)
		,date_of_injury datetime
	)
	
	SET @SQL = 'CREATE INDEX pk_AWC_list'+CONVERT(VARCHAR, @@SPID)+' ON #AWC_list(Claim_no,date_of_injury)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	INSERT INTO #AWC_list
		SELECT DISTINCT rtrim(cla.claim_no),ca.Date_of_Injury 
		FROM #_Claim_list_adjusted cla 
			 INNER JOIN cd_audit ca ON cla.Claim_no = ca.claim_no 
									   AND cla.submitted_trans_date between @startdate and @enddate
									   AND ca.id = (SELECT MAX(id) 
													FROM cd_audit 
													WHERE ca.claim_no = claim_no 
													AND create_date < @enddate)
										AND ca.fund <> 98

	/* create #policy table to store policy info for claim */
	CREATE TABLE #policy
	(
		policyno CHAR(19)
		,renewal_no INT
		,bastarif MONEY
		,wages MONEY
		,const_flag_final int
	)
	
	/* create index for #policy table */
	SET @SQL = 'CREATE INDEX pk_policy_'+CONVERT(VARCHAR, @@SPID)+' ON #policy(policyno, renewal_no)'
	EXEC(@SQL)

	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
			
	INSERT INTO #policy
		SELECT	POLICY_NO
				, RENEWAL_NO
				, BTP					
				, WAGES0
				, Process_Flags					
			FROM dbo.PREMIUM_DETAIL pd
			WHERE EXISTS (SELECT 1 FROM #_Claim_Detail cd where cd.policy_no = pd.POLICY_NO)
			ORDER BY POLICY_NO,RENEWAL_NO
	
	SELECT	Time_ID = @enddate
			,Claim_no = awc_list.Claim_no	
			,'Group' = CASE WHEN (rtrim(isnull(co.Grp,''))='') 
							--Match Miscellaneous group for all group that inactive--	
							OR NOT EXISTS (select distinct grp 
												from claims_officers 
												where active = 1 and len(rtrim(ltrim(grp))) > 0 
													  and grp like co.Grp+'%')
							OR (co.Grp NOT LIKE 'wcnsw%' or PATINDEX('WCNSW', RTRIM(co.Grp))>0)
								THEN 'Miscellaneous'
							WHEN PATINDEX('WCNSW%', co.Grp) = 0 THEN Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1)
							WHEN rtrim(co.Grp) = 'WCNSW' THEN 'WCNSW(Group)'
							ELSE SUBSTRING(Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1), 1, 
									CASE WHEN PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 6, LEN(rtrim(co.Grp)) - 5)) > 0 
										THEN (PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 6, LEN(rtrim(co.Grp)) - 5)) + 4) 
										ELSE LEN(rtrim(co.Grp)) 
									END)
							END
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' THEN 'Miscellaneous' ELSE RTRIM(UPPER(co.Grp)) END				
			,Case_manager = ISNULL ( UPPER(co.First_Name+' '+ co.Last_Name), 'Miscellaneous')					
			
			,AgencyName =dbo.udf_GetAgencyNameByPolicyNo(cd.Policy_no)
			,awc_list.Date_of_Injury
			,create_date = getdate()
			,cd.policy_no
			,Agency_id = UPPER(ptda.Agency_id)
			,Sub_category = rtrim(dbo.udf_GetSubCategoryByPolicyNo(cd.Policy_no))
			,Empl_Size = (CASE WHEN pd.bastarif IS NULL OR pd.const_flag_final IS NULL OR pd.wages IS NULL then 'A - Small'
							  WHEN pd.wages <= 300000 then 'A - Small'
							  WHEN pd.wages > 300000 AND pd.wages <= 1000000 AND pd.const_flag_final = 1 then 'A - Small'
							  WHEN pd.wages > 300000 AND pd.wages <= 1000000 AND pd.const_flag_final <> 1 then 'B - Small-Medium'
							  WHEN pd.wages > 1000000 AND pd.wages <= 5000000 then 'C - Medium'
							  WHEN pd.wages > 5000000 AND pd.wages <= 15000000 AND pd.bastarif <= 100000 then 'C - Medium'
							  WHEN pd.wages > 15000000 then 'D - Large'
							  WHEN pd.wages > 5000000 AND pd.bastarif > 100000 then 'D - Large'
							  ELSE 'A - Small'
						  END)
			,Cert_Type = case when mc.TYPE = 'P' 
								then 'No Time Lost' 
						      when mc.TYPE = 'T' 
								then 'Totally Unfit'
							  when mc.TYPE = 'S' 
								then 'Suitable Duties'
							  when mc.TYPE = 'I' 
								then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' 
								then 'Permanently Modified Duties'
							  else 'Invalid type' 
						 end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,Cell_no = NULL
			,Portfolio = ''
			
	FROM	#AWC_list awc_list
			INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = awc_list.claim_no
			LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
			INNER JOIN #_Claim_Detail cd on awc_list.claim_no = cd.Claim_No		
			INNER JOIN cad_audit cada1 on cada1.Claim_No = awc_list.claim_no 
			INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
			INNER JOIN ptd_audit ptda ON cd.Policy_No = ptda.Policy_No
			LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
          	LEFT JOIN #policy pd on pd.policyno = cd.policy_no and pd.renewal_no = cd.renewal_no 	
          	LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
						left join Broker Br on PTD.Broker_No = Br.Broker_no 
						left join UnderWriters U on  BR.emi_Contact = U.Alias 
						where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no		
			
	WHERE   cada1.id = (SELECT MAX(cada2.id) 
					      FROM  cad_audit cada2 
					      WHERE cada2.claim_no = cada1.claim_no
							    AND cada2.transaction_date <= @enddate) 
			AND coa1.id = (SELECT   MAX(coa2.id) 
						     FROM   CO_audit coa2
						     WHERE  coa2.officer_id = coa1.officer_id
								    AND coa2.create_date <= @enddate)
			AND ptda.id = (SELECT MAX(ptda2.id) 
							FROM ptd_audit ptda2
							WHERE ptda2.policy_no = ptda.policy_no 
								  AND ptda2.create_date <= @enddate)
				  
	--drop all temp table
	IF OBJECT_ID('tempdb..#_Claim_list_adjusted') IS NOT NULL DROP TABLE #_Claim_list_adjusted
	IF OBJECT_ID('tempdb..#_Claim_Detail') IS NOT NULL DROP TABLE #_Claim_Detail	
	IF OBJECT_ID('tempdb..#_Claim_List') IS NOT NULL DROP TABLE #_Claim_List
	IF OBJECT_ID('tempdb..#AWC_list') IS NOT NULL DROP TABLE #AWC_list
	IF OBJECT_ID('tempdb..#policy') IS NOT NULL DROP table #policy	
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_AWC] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_AWC] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_AWC] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_EML_AWC.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_EML_AWC_GenerateData.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_EML_AWC_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_EML_AWC_GenerateData]
Go
-- For example
-- exec [usp_Dashboard_EML_AWC_GenerateData] 2011, 1
-- this will return all result with time id range from 2011-01-31 23:59 till now

CREATE PROCEDURE [dbo].[usp_Dashboard_EML_AWC_GenerateData]
	@start_period_year int = 2012,
	@start_period_month int = 10
AS
BEGIN	
	SET NOCOUNT ON;
	declare @start_period datetime = CAST(CAST(@start_period_year as varchar) + '/' + CAST(@start_period_month as varchar) + '/01' as datetime)
	declare @end_period datetime = getdate()
	
	declare @loop_time int = DATEDIFF(month, @start_period, @end_period)
	declare @i int = @loop_time 
	declare @temp datetime
	declare @SQL varchar(500)

	---delete last transaction lag number months in dart db---	
	exec('DELETE FROM [DART].[dbo].[EML_AWC] 
			WHERE Time_ID in (select distinct top 3 Time_ID 
			from [DART].[dbo].[EML_AWC] order by Time_ID desc)')
	---end delete--	

	--Check temp table existing then drop	
	IF OBJECT_ID('tempdb..#_CLAIM_ESTIMATE_SUMMARY') IS NOT NULL DROP TABLE #_CLAIM_ESTIMATE_SUMMARY
		
	create table #_CLAIM_ESTIMATE_SUMMARY
	(
		CLAIM_NO varCHAR(19),
		TotalAmount MONEY
	) 
	
	SET @SQL = 'CREATE INDEX pk_CLAIM_ESTIMATE_SUMMARY'+CONVERT(VARCHAR, @@SPID)+' ON #_CLAIM_ESTIMATE_SUMMARY(CLAIM_NO, TotalAmount)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		 
	INSERT INTO #_CLAIM_ESTIMATE_SUMMARY
		select CLAIM_NO, SUM(ISNULL(Amount, 0))
		from ESTIMATE_DETAILS
		group by claim_no
	WHILE (@i >= 0)
	BEGIN
		set @temp = DATEADD(mm, @i, @start_period)
		declare @year int = YEAR(@temp)
		declare @month int = MONTH(@temp)
		
		If NOT EXISTS(select 1 from [DART].[dbo].[EML_AWC] 
							where Year(Time_ID) = @year and
							Month(Time_ID ) = @month)
		   AND cast(CAST(@year as varchar) + '/' +  CAST(@month as varchar) + '/01' as datetime)
				< cast(CAST(year(getdate()) as varchar) + '/' +  CAST(month(getdate()) as varchar) + '/01' as datetime)
		BEGIN		
			print @temp
			--DELETE FROM dbo.EML_AWC where Time_ID = DATEADD(dd, -1, DATEADD(mm, 1, @temp)) + '23:59'
			--INSERT INTO dbo.EML_AWC exec usp_Dashboard_EML_AWC @year, @month
			INSERT INTO [Dart].[dbo].[EML_AWC] exec usp_Dashboard_EML_AWC @year, @month			
		END
		SET @i = @i - 1
	END
	
	--drop temp table
	IF OBJECT_ID('tempdb..#_CLAIM_ESTIMATE_SUMMARY') IS NOT NULL drop table #_CLAIM_ESTIMATE_SUMMARY	
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_AWC_GenerateData] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_AWC_GenerateData] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_AWC_GenerateData] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_EML_AWC_GenerateData.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_EML_RTW.sql  
--------------------------------  
/****** Object:  StoredProcedure [dbo].[usp_Dashboard_EML_RTW]    Script Date: 12/26/2013 14:31:45 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
--  exec [usp_Dashboard_EML_RTW] 2013, 6, 12
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_EML_RTW]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_EML_RTW]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_EML_RTW]
	@yy int,
	@mm int,
	@RollingMonth int, -- 1, 3, 6, 12
	@AsAt datetime
AS
BEGIN
	SET NOCOUNT ON;
	IF OBJECT_ID('tempdb..#measures') IS NOT NULL DROP TABLE #measures
	
	declare @SQL varchar(500)
	
	declare @measure_month_13 int
	declare @measure_month_26 int
	declare @measure_month_52 int
	declare @measure_month_78 int
	declare @measure_month_104 int
	
	declare @remuneration_start datetime
	declare @remuneration_end datetime
	
	declare @transaction_lag_remuneration_start datetime
	declare @transaction_lag_remuneration_end datetime
	
	declare @paystartdt datetime
	
	declare @transaction_lag int	
	
	set @measure_month_13 = 3	-- 13weeks = 3
	set @measure_month_26 = 6	-- 26weeks = 6
	set @measure_month_52 = 12  -- 52weeks = 12
	set @measure_month_78 = 18  -- 78weeks = 18
	set @measure_month_104 = 24 -- 104weeks = 24
	
	set @transaction_lag = 3 -- for EML
	
	set @remuneration_end = cast(CAST(@yy as varchar) + '/' +  CAST(@mm as varchar) + '/01' as datetime)
	set @remuneration_start = DATEADD(mm,-@RollingMonth, @remuneration_end)
	
	set @remuneration_end = DATEADD(dd, -1, @remuneration_end) + '23:59'
	
	set @transaction_lag_remuneration_start = DATEADD(mm, @transaction_lag, @remuneration_start)
	set @transaction_lag_remuneration_end = DATEADD(mm, @transaction_lag, @remuneration_end)
	
	set @paystartdt = DATEADD(mm, -@transaction_lag, DATEADD(YY, -2, @remuneration_Start))
	
	IF OBJECT_ID('tempdb..#claim') IS NULL
	BEGIN
		/* create #claim table to store claim detail info */
		CREATE TABLE #claim
		(
			claim CHAR(19)
			,policyno CHAR(19)
			,renewal_no INT
			,hrswrkwk numeric(5,2)
			,injdate datetime
			,_13WEEKS_ DATETIME
			,_26WEEKS_ DATETIME
			,_52WEEKS_ DATETIME
			,_78WEEKS_ DATETIME
			,_104WEEKS_ DATETIME
			,DAYS13 int
			,DAYS26 int
			,DAYS52 int
			,DAYS78 int
			,DAYS104 int
			,DAYS13_PRD int
			,DAYS26_PRD int
			,DAYS52_PRD int
			,DAYS78_PRD int
			,DAYS104_PRD int
		)	

		/* create index for #claim table */
		SET @SQL = 'CREATE INDEX pk_claim_' + CONVERT(VARCHAR, @@SPID) + ' ON #claim(claim, policyno, injdate)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

		INSERT INTO #claim
			SELECT	cd.Claim_Number
					, cda.Policy_No
					, Renewal_No
					, cd.Work_Hours
					, cd.Date_of_Injury
					
					-- calculate 13 weeks from date of injury
					, _13WEEKS_ = dateadd(mm, @measure_month_13, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
					
					-- calculate 26 weeks from date of injury
					, _26WEEKS_ = dateadd(mm, @measure_month_26, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
					
					-- calculate 52 weeks from date of injury
					, _52WEEKS_ = dateadd(mm, @measure_month_52, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
					
					-- calculate 78 weeks from date of injury
					, _78WEEKS_ = dateadd(mm, @measure_month_78, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
					
					-- calculate 104 weeks from date of injury
					, _104WEEKS_ = dateadd(mm, @measure_month_104, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
					
					, DAYS13 = 0
					, DAYS26 = 0
					, DAYS52 = 0
					, DAYS78 = 0
					, DAYS104 = 0
					
					,DAYS13_PRD = 0
					,DAYS26_PRD = 0
					,DAYS52_PRD = 0
					,DAYS78_PRD = 0
					,DAYS104_PRD = 0
			FROM dbo.CLAIM_DETAIL cd INNER JOIN cd_audit cda on cda.claim_no = cd.claim_number
				AND isnull(cd.Claim_Number,'') <> ''
				AND cd.Date_of_Injury >= @paystartdt
				AND cda.id = (select max(id) 
								from cd_audit cda1 
								where cda1.claim_no = cd.claim_number 
									and cda1.create_date < @remuneration_end)
			/* exclude Serious Claims */
			WHERE cd.claim_number not in (select Claim_no from EML_SIW)
	END
		
	UPDATE #claim
		-- calculate days off work between 13 weeks and date of injury
		SET	DAYS13 = dbo.udf_NoOfDaysWithoutWeekend(injdate, _13WEEKS_) 
				+ (case when datepart(dw,injdate) not IN(1,7) then 1 else 0 end)
		
		-- calculate days off work between 26 weeks and date of injury
		,DAYS26 = dbo.udf_NoOfDaysWithoutWeekend(injdate, _26WEEKS_) 
				+ (case when datepart(dw,injdate) not IN(1,7) then 1 else 0 end)
		
		-- calculate days off work between 52 weeks and date of injury
		,DAYS52 = dbo.udf_NoOfDaysWithoutWeekend(_26WEEKS_, _52WEEKS_) 
				+ (case when datepart(dw,_26WEEKS_) not IN(1,7) then 1 else 0 end)
		
		-- calculate days off work between 78 weeks and date of injury
		,DAYS78 = dbo.udf_NoOfDaysWithoutWeekend(_52WEEKS_, _78WEEKS_) 
				+ (case when datepart(dw,_52WEEKS_) not IN(1,7) then 1 else 0 end)
		
		-- calculate days off work between 104 weeks and date of injury
		,DAYS104 = dbo.udf_NoOfDaysWithoutWeekend(_52WEEKS_, _104WEEKS_) 
				+ (case when datepart(dw,_52WEEKS_) not IN(1,7) then 1 else 0 end)
		
		/* calculate days off work between MAX(date of injury, remuneration start) 
			and MIN(13 weeks, remuneration end) */
		,	DAYS13_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(injdate, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _13WEEKS_), @remuneration_End,'2222/01/01'))
						+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(injdate, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
		,	DAYS26_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(injdate, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _26WEEKS_), @remuneration_End,'2222/01/01'))
						+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(injdate, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
		,	DAYS52_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(_26WEEKS_, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _52WEEKS_), @remuneration_End,'2222/01/01'))
						+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(_26WEEKS_, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
		,	DAYS78_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _78WEEKS_), @remuneration_End,'2222/01/01'))
						+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
		,	DAYS104_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _104WEEKS_), @remuneration_End,'2222/01/01'))
						+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end

	
	IF OBJECT_ID('tempdb..#rtw_raworig_temp') IS NULL
	BEGIN
		/* create #rtw_raworig temp table to store transaction data */
		CREATE TABLE #rtw_raworig_temp
		(
			 claim varchar(19)
			 ,paydate datetime
			 ,paytype varchar(15)
			 ,rtw_paytype varchar(9)
			 ,adjflag varchar(1)
			 ,payamt money
			 ,payment_no int
			 ,ppstart datetime
			 ,ppend datetime
			 ,hrs_per_week numeric(5,2)
			 ,hrs_total numeric(14,3)
			 ,DET_weekly money
		)

		/* create index for #rtw_raworig_temp table */
		SET @SQL = 'CREATE INDEX pk_rtw_raworig_temp_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig_temp(claim, payment_no)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		INSERT INTO #rtw_raworig_temp
		SELECT  pr.Claim_No
				, CONVERT(varchar(10), pr.Transaction_date, 120)
				,pr.WC_Payment_Type
				,rtw_paytype=  (CASE WHEN wc_payment_type IN ('14', '15', 'WPT001', 'WPT002', 'WPT003', 'WPT004') 
										THEN 'TI'
									 WHEN wc_payment_type IN ('13', 'WPP001', 'WPP003') 
										THEN 'S38'
									 WHEN wc_payment_type IN ('16', 'WPP002', 'WPP004') 
										THEN 'S40'
									 WHEN wc_payment_type IN ('WPT005', 'WPT006', 'WPT007') 
										THEN 'NOWORKCAP'
									 WHEN wc_payment_type IN ('WPP005', 'WPP006', 'WPP007', 'WPP008') 
										THEN 'WORKCAP' 
								END)
				,Adjust_Trans_Flag
				,Trans_Amount
				,pr.Payment_no
				,Period_Start_Date
				,Period_End_Date
				,pr.hours_per_week
				,hrs_total = (isnull(WC_MINUTES, 0) / 60.0)
								 + isnull(WC_HOURS, 0)
								 + isnull(WC_WEEKS * HOURS_PER_WEEK, 0)
				,isnull(Rate, 0)
		FROM dbo.Payment_Recovery pr
				INNER JOIN dbo.CLAIM_PAYMENT_RUN
						   ON pr.Payment_no = dbo.CLAIM_PAYMENT_RUN.Payment_no
				INNER JOIN #claim cl on pr.Claim_No = cl.claim
		WHERE	Transaction_date >= @paystartdt
				AND Transaction_date <= @AsAt
				AND wc_Tape_Month IS NOT NULL 
				AND LEFT(wc_Tape_Month, 4) <= @yy
				AND wc_Tape_Month <= CONVERT(int, 
										CONVERT(varchar(8), @transaction_lag_remuneration_end,112))
				AND wc_payment_type IN ('WPT001', 'WPT003', 'WPT002'
										 ,'WPT004', 'WPP001', 'WPP003'
										 ,'WPP002', 'WPP004','WPT005'
										 ,'WPT006', 'WPT007', 'WPP005'
										 ,'WPP006', 'WPP007', 'WPP008'
										 ,'13', '14', '15', '16')
										 
		/* Adjust DET weekly field */
	
		SELECT distinct claim, ppstart, ppend, paytype, DET_weekly = max(DET_weekly) 
			INTO #summary
			FROM #rtw_raworig_temp
		GROUP BY claim,
				ppstart, 
				ppend, 
				paytype		

		UPDATE #rtw_raworig_temp 
			SET DET_weekly = su.DET_weekly
			FROM #summary su
			WHERE	#rtw_raworig_temp.claim = su.claim
					AND #rtw_raworig_temp.ppstart = su.ppstart
					AND #rtw_raworig_temp.ppend = su.ppend
					AND #rtw_raworig_temp.paytype = su.paytype
		
		/* end of adjusting DET weekly field */	
	END
	
	IF OBJECT_ID('tempdb..#rtw_raworig') IS NULL
	BEGIN
		/* create #rtw_raworig table to store transaction data after summarizing step #1 */
		CREATE TABLE #rtw_raworig
		(
			 claim varchar(19)
			 ,paydate datetime
			 ,paytype varchar(15)
			 ,rtw_paytype varchar(9)
			 ,payamt money
			 ,ppstart datetime
			 ,ppend datetime
			 ,hrs_per_week numeric(5,2)
			 ,hrs_total numeric(14,3)
			 ,DET_weekly money
		)	
		
		/* create index for #rtw_raworig table */
		SET @SQL = 'CREATE INDEX pk_rtw_raworig_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig(claim, rtw_paytype, paydate)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END		
		
		/* summarised trasactions by claim, paydate, paytype, ppstart, ppend */
		INSERT INTO #rtw_raworig
		SELECT  claim
				,paydate
				,paytype
				,rtw_paytype
				,payamt = (SELECT SUM(payamt)
								FROM #rtw_raworig_temp rtw1 
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paydate = rtw.paydate
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart 
										and rtw1.ppend = rtw.ppend)							
				,ppstart
				,ppend
				,hrs_per_week
				,hrs_total = (SELECT SUM(hrs_total)
								FROM #rtw_raworig_temp rtw1
								WHERE rtw1.claim = rtw.claim 
										and rtw1.paydate = rtw.paydate
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
				,DET_weekly = (SELECT MAX(DET_weekly) 
								FROM #rtw_raworig_temp rtw1
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paydate = rtw.paydate
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
		FROM #rtw_raworig_temp rtw
		GROUP BY claim,
				paydate,
				paytype,
				rtw_paytype,
				ppstart,
				ppend,
				hrs_per_week
				
		/*	
		Records with payment amount and hours paid for total incapacity are both zero are removed.
		*/
		DELETE FROM #rtw_raworig WHERE hrs_total = 0 and payamt = 0
		
		/*	
			Records with a negative payment amount, but positive hours paid for total incapacity
				have their hours paid changed to be negative.
		*/
		UPDATE #rtw_raworig SET hrs_total = -hrs_total 
			WHERE hrs_total > 0 AND payamt < 0			
	END
	
	IF OBJECT_ID('tempdb..#rtw_raworig_2') IS NULL
	BEGIN
		/* create #rtw_raworig_2 table to store transaction data after summarizing for step #2 */
		CREATE TABLE #rtw_raworig_2
		(
			 claim varchar(19)
			 ,paydate datetime
			 ,rtw_paytype varchar(9)
			 ,payamt money
			 ,ppstart datetime
			 ,ppend datetime
			 ,hrs_per_week numeric(5,2)
			 ,hrs_total numeric(14,3)
			 ,DET_weekly money
		)	
		
		/* create index for #rtw_raworig_2 table */
		SET @SQL = 'CREATE INDEX pk_rtw_raworig_2_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig_2(claim, rtw_paytype, paydate)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END		
		
		/* summarised trasactions by claim, paytype, ppstart, ppend */
		INSERT INTO #rtw_raworig_2
		SELECT  claim
				,paydate = (SELECT MIN(paydate) 
								FROM #rtw_raworig rtw1
								WHERE	rtw1.claim = rtw.claim										
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
				,rtw_paytype
				,payamt = (SELECT SUM(payamt)
								FROM #rtw_raworig rtw1 
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart 
										and rtw1.ppend = rtw.ppend)							
				,ppstart
				,ppend
				,hrs_per_week
				,hrs_total = (SELECT SUM(hrs_total)
								FROM #rtw_raworig rtw1
								WHERE rtw1.claim = rtw.claim 
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
				,DET_weekly = (SELECT MAX(DET_weekly) 
								FROM #rtw_raworig rtw1
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
		FROM #rtw_raworig rtw
		GROUP BY claim,
				paytype,
				rtw_paytype,
				ppstart,
				ppend,
				hrs_per_week
				
		/*	
		- Records with payment amount equal to zero are removed;
		- Records associated with payments of pre-reform benefits (s36, s37, s38, s40) with hours
		paid for partial incapacity and hours paid for total incapacity both equal to zero are
		removed;
		*/
		DELETE FROM #rtw_raworig_2 WHERE payamt = 0 or (hrs_total = 0 
			and rtw_paytype in ('TI', 'S38', 'S40'))
	END
	
	IF OBJECT_ID('tempdb..#policy') IS NULL
	BEGIN
		/* create #policy table to store policy info for claim */
		CREATE TABLE #policy
		(
			policyno CHAR(19)
			,renewal_no INT
			,bastarif MONEY
			,wages MONEY
			,const_flag_final int
		)
		
		/* create index for #policy table */
		SET @SQL = 'CREATE INDEX pk_policy_'+CONVERT(VARCHAR, @@SPID)+' ON #policy(policyno, renewal_no)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

		INSERT INTO #policy
			SELECT	POLICY_NO
					, RENEWAL_NO
					, BTP					
					, WAGES0
					, Process_Flags					
				FROM dbo.PREMIUM_DETAIL pd
				WHERE EXISTS (SELECT 1 FROM #claim cd where cd.policyno = pd.POLICY_NO)
				ORDER BY POLICY_NO,RENEWAL_NO
	END
	
	/* create #measures table that contains all of necessary columns 
		for calculating RTW measures */
	CREATE TABLE #measures
	(
		claim CHAR(19)
		,policyno CHAR(19)
		,injdate datetime
		,paytype varchar(9)
		,ppstart datetime
		,ppend datetime
		,payamt money
		,hrs_per_week_adjusted numeric(5,2)
		,weeks_paid_adjusted float
		,hrs_total numeric(14,3)
		,DET_weekly money
		,days_for_TI int
		,LT_TI float
		,LT_S38 float
		,LT_S40 float
		,LT_NWC float
		,LT_WC float
		,empl_size varchar(256)
		,CAP_CUR_13 float	
		,CAP_PRE_13 float	
		,DAYS13_TRANS float
		,DAYS13_TRANS_PRIOR float
		,LT13_TRANS FLOAT
		,LT13_TRANS_PRIOR FLOAT
		,LT13 FLOAT
		,CAP_CUR_26 float	
		,CAP_PRE_26 float	
		,DAYS26_TRANS float
		,DAYS26_TRANS_PRIOR float
		,LT26_TRANS FLOAT
		,LT26_TRANS_PRIOR FLOAT
		,LT26 FLOAT
		,CAP_CUR_52 float
		,CAP_PRE_52 float
		,DAYS52_TRANS float	
		,DAYS52_TRANS_PRIOR float	
		,LT52_TRANS FLOAT	
		,LT52_TRANS_PRIOR FLOAT	
		,LT52 FLOAT
		,CAP_CUR_78 float
		,CAP_PRE_78 float
		,DAYS78_TRANS float	
		,DAYS78_TRANS_PRIOR float	
		,LT78_TRANS FLOAT	
		,LT78_TRANS_PRIOR FLOAT	
		,LT78 FLOAT
		,CAP_CUR_104 float
		,CAP_PRE_104 float
		,DAYS104_TRANS float	
		,DAYS104_TRANS_PRIOR float	
		,LT104_TRANS FLOAT	
		,LT104_TRANS_PRIOR FLOAT	
		,LT104 FLOAT
		,include_13 bit
		,include_26 bit
		,include_52 bit
		,include_78 bit
		,include_104 bit
		,include_13_trans bit
		,include_26_trans bit
		,include_52_trans bit
		,include_78_trans bit
		,include_104_trans bit
		,Total_LT FLOAT
		,_13WEEKS_ DATETIME
		,_26WEEKS_ DATETIME
		,_52WEEKS_ DATETIME
		,_78WEEKS_ DATETIME
		,_104WEEKS_ DATETIME
		,DAYS13_PRD_CALC int
		,DAYS26_PRD_CALC int
		,DAYS52_PRD_CALC int
		,DAYS78_PRD_CALC int
		,DAYS104_PRD_CALC int
		,DAYS13_CALC int
		,DAYS26_CALC int
		,DAYS52_CALC int
		,DAYS78_CALC int
		,DAYS104_CALC int
	)
	 
	/* create index for #measures table */
	SET @SQL = 'CREATE INDEX pk_measures_' + CONVERT(VARCHAR, @@SPID) + ' ON #measures(claim,policyno,injdate)'
	EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	INSERT INTO #measures
	SELECT DISTINCT 
			pr.Claim
			,cd.policyno
			,injdate
			,pr.rtw_paytype
			,pr.ppstart
			,pr.ppend
			,pr.payamt
			
			-- adjust hours worked per week to be a minimum of 1 and a maximum of 40;
			,hrs_per_week_adjusted = dbo.udf_MinValue(40
													  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0
																then cd.hrswrkwk 
															 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															 else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													  )
			,weeks_paid_adjusted = 1.0 
									* pr.hrs_total 
									/ nullif(dbo.udf_MinValue(40 
														 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
																when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1 
																else isnull(cd.hrswrkwk,pr.hrs_per_week) 
															end)
														), 0)
			,pr.hrs_total
			,pr.DET_weekly
			
			-- calculate total incapacity days off work
			,days_for_TI = (case when rtw_paytype = 'TI'
										and datepart(dw,pr.ppstart) IN (1,7)
										and datepart(dw,pr.ppend) IN(1,7) 
										and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
									then DATEDIFF(day,pr.ppstart,pr.ppend) + 1					
								when pr.ppstart = pr.ppend 
									then 1 
								else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
							end)
							
			-- calculate days off work for pre-reform claims - Total incapacity payment
			,LT_TI = (CASE when	rtw_paytype = 'TI'
								and dbo.udf_MinValue(40 
												   ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
															 then cd.hrswrkwk 
														  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1
															 then 1 
														  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
													 end
													 )
													) >= 35 
								then 1.0 
									 * (pr.hrs_total* 5)
									 / nullif(dbo.udf_MinValue(40
													   ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													   ),0) 
									* dbo.udf_CheckPositiveOrNegative(pr.payamt)
						 when rtw_paytype = 'TI' 
							  and dbo.udf_MinValue(40 
												  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
															then cd.hrswrkwk
														when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
															then 1  
														else isnull(cd.hrswrkwk,pr.hrs_per_week) 
													end)
												 ) < 35 
							then 1.0 
								 * (pr.hrs_total * 5 /37.5)
								 * dbo.udf_CheckPositiveOrNegative(pr.payamt)
						else 0 
					END)
					
			-- calculate days off work for pre-reform claims - Section 38 payment
			,LT_S38 = (CASE when rtw_paytype = 'S38'
								 and (case when pr.ppstart = pr.ppend 
												then 1 
										   else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									 end) = 0 
								then 0
							when rtw_paytype = 'S38' 
								 and dbo.udf_MinValue(40
													 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													 ) >= 35 
								then 1.0
									 *(case when  rtw_paytype = 'TI' 
													and datepart(dw,pr.ppstart) IN(1,7) 
													and datepart(dw,pr.ppend) IN(1,7) 
													and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
												 then DATEDIFF(day,pr.ppstart,pr.ppend) + 1					
											  when pr.ppstart = pr.ppend 
												then 1 
											  else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
										 end) 
									 * dbo.udf_CheckPositiveOrNegative(pr.payamt) 
							when rtw_paytype = 'S38' 
								 and dbo.udf_MinValue(40
													  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															 else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													  ) < 35  
								and dbo.udf_MinValue(40
													 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1 
															else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													) > 0 
								then 1.0
									 *(case	when rtw_paytype = 'TI' 
												 and datepart(dw,pr.ppstart) IN(1,7) 
												 and datepart(dw,pr.ppend) IN(1,7) 
												 and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
											  then DATEDIFF(day,pr.ppstart,pr.ppend) + 1
											when pr.ppstart = pr.ppend 
											  then 1 
											else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									  end)
									  * dbo.udf_CheckPositiveOrNegative(pr.payamt) 
									  * dbo.udf_MinValue(40
														 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
																when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1
																else isnull(cd.hrswrkwk,pr.hrs_per_week)
															end)
														 )
									  /37.5
										
							else 0 
					END)
					
			-- calculate days off work for pre-reform claims - Section 40 payment
			,LT_S40 = (CASE when rtw_paytype = 'S40'
								and (case when pr.ppstart = pr.ppend 
												then 1 
										  else
												dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									end) = 0 
								then 0
							when rtw_paytype = 'S40'
								 and dbo.udf_MinValue(40
													  , (case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
															  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
												      ) >= 35 
								then 1.0
									 *(case when  rtw_paytype = 'TI' 
												 and datepart(dw,pr.ppstart) IN(1,7) 
												 and datepart(dw,pr.ppend) IN(1,7) 
												 and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
											 then DATEDIFF(day,pr.ppstart,pr.ppend) + 1
										   when pr.ppstart = pr.ppend 
											 then 1 
										   else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									 end)
									 * 0.75
									 * dbo.udf_CheckPositiveOrNegative(pr.payamt) 
							when rtw_paytype = 'S40' 
								 and dbo.udf_MinValue(40
													 , (case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															 else isnull(cd.hrswrkwk,pr.hrs_per_week) end)
														) < 35
								then 1.0
									 *(case when		rtw_paytype = 'TI' 
													and datepart(dw,pr.ppstart) IN(1,7) 
													and datepart(dw,pr.ppend) IN(1,7) 
													and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
												then DATEDIFF(day,pr.ppstart,pr.ppend) + 1					
											when pr.ppstart = pr.ppend 
												then 1 
											else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									   end)
									   * 0.75 
									   * dbo.udf_CheckPositiveOrNegative(pr.payamt) 
									   * dbo.udf_MinValue(40
														  , (case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
																  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1  
																  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
															 end)
															)
										/37.5
								else 0 
						END)
						
			-- calculate days off work for post reform claims - no current work capacity
			,LT_NWC = (CASE when rtw_paytype = 'NOWORKCAP' 
								and dbo.udf_MinValue(40
													 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1 
															else isnull(cd.hrswrkwk,pr.hrs_per_week) 
													  end)
													  ) >= 35 
								then 1.0 * (pr.payamt* 5)/ nullif(pr.DET_weekly,0)
							when rtw_paytype = 'NOWORKCAP' 
								 and dbo.udf_MinValue(40 
													  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															 else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													  ) < 35 
								then 1.0 
									 * (pr.payamt / nullif(pr.DET_weekly,0) / 37.5)
									 * 5
									 *dbo.udf_MinValue(40
														,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																   then cd.hrswrkwk 
															   when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1  
															   else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														  end)
														  )
								else 0 
						END)
						
			-- calculate days off work for post reform claims - current work capacity
			,LT_WC = (CASE when rtw_paytype = 'WORKCAP'
								  and dbo.udf_MinValue(40
														,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																   then cd.hrswrkwk 
															   when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																   then 1 
															   else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														 end)
														) >= 35 
								 then 1.0 * (pr.payamt* 5) / nullif(pr.DET_weekly,0)
							  when rtw_paytype = 'WORKCAP' 
								  and dbo.udf_MinValue(40 
														,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																   then cd.hrswrkwk 
															   when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																   then 1  
															   else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													   ) < 35 
								 then 1.0 
									  * (pr.payamt / nullif(pr.DET_weekly,0) / 37.5)
									  * 5
									  *dbo.udf_MinValue(40
														 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
																when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1  
																else isnull(cd.hrswrkwk,pr.hrs_per_week) 
															end)
														   )
							  else 0 
						END)
						
			/*  determine employer size: Small, Small-Medium, Medium or Large */
			
			-- set default to Small when missing policy data;
			,EMPL_SIZE = (CASE WHEN pd.bastarif IS NULL OR pd.const_flag_final IS NULL OR pd.wages IS NULL then 'A - Small'
							  WHEN pd.wages <= 300000 then 'A - Small'
							  WHEN pd.wages > 300000 AND pd.wages <= 1000000 AND pd.const_flag_final = 1 then 'A - Small'
							  WHEN pd.wages > 300000 AND pd.wages <= 1000000 AND pd.const_flag_final <> 1 then 'B - Small-Medium'
							  WHEN pd.wages > 1000000 AND pd.wages <= 5000000 then 'C - Medium'
							  WHEN pd.wages > 5000000 AND pd.wages <= 15000000 AND pd.bastarif <= 100000 then 'C - Medium'
							  WHEN pd.wages > 15000000 then 'D - Large'
							  WHEN pd.wages > 5000000 AND pd.bastarif > 100000 then 'D - Large'
							  ELSE 'A - Small'
						 END)
			/*  determine employer size: A, B, C or D */
						 
			/* 13 weeks */
			
			-- caps applied to measure, compare with remuneration end as threshold
			,CAP_CUR_13 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate),
													dbo.udf_MinDay(DATEADD(dd, -1, _13WEEKS_), @remuneration_End, '2222/01/01')
													) + case when DATEPART(dw,injdate) not in (1,7) 
																then 1 
															else 0 
														end)
			
			-- caps applied to measure, compare with remuneration start as threshold
			,CAP_PRE_13 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate),
													dbo.udf_MinDay(DATEADD(dd, -1, _13WEEKS_), 
															DATEADD(dd, -1, @remuneration_Start), '2222/01/01')
													) +	case when DATEPART(dw,injdate) not in (1,7) 
																then 1 
															else 0 
														end)
			
			-- determine days off work between payment period start and end dates, compare with remuneration end as threshold
			,DAYS13_TRANS = case when ppstart <= @remuneration_end 
										and paydate < DATEADD(MM, @Transaction_lag, _13WEEKS_)
										and paydate <= @transaction_lag_remuneration_end 
									then case when dbo.udf_MinDay(@remuneration_End,
															DATEADD(dd, -1, _13WEEKS_), ppend) >= ppstart 
												then dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _13WEEKS_), ppend))
																		) +	case when DATEPART(dw,ppstart) not in (1,7) 
																					then 1
																				when rtw_paytype = 'TI' 
																					and DATEPART(dw,ppstart) in (1,7) 
																					and DATEPART(dw,ppend) in (1,7) 
																					and DATEDIFF(DD,ppstart, ppend) <= 1
																					then 1 + DATEDIFF(DD,ppstart, ppend) 
																				else 0 
																			end
										else dbo.udf_MaxValue(0, 
												dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
													dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _13WEEKS_), ppend))) 
									end
								else 0 
							end
			
			-- determine days off work between payment period start and end dates, compare with remuneration start as threshold
			,DAYS13_TRANS_PRIOR = case when ppstart < @remuneration_start
											and paydate < DATEADD(MM, @Transaction_lag, _13WEEKS_)
											and paydate <= @transaction_lag_remuneration_start
										then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
															DATEADD(dd, -1, _13WEEKS_), ppend) >= ppstart 
													then dbo.udf_MaxValue(0, 
																dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																		dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																				DATEADD(dd, -1, _13WEEKS_), ppend))
																			) + case when DATEPART(dw,ppstart) not in (1,7) 
																						then 1
																					when rtw_paytype = 'TI' 
																						and DATEPART(dw,ppstart) in (1,7) 
																						and DATEPART(dw,ppend) in (1,7) 
																						and DATEDIFF(DD,ppstart, ppend) <= 1
																					then 1 + DATEDIFF(DD,ppstart, ppend) 
																					else 0 
																				end
										else dbo.udf_MaxValue(0, 
													dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
															dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																	DATEADD(dd, -1, _13WEEKS_), ppend)
																					)
															) 
										end
									else 0 
								end
			,LT13_TRANS = 0
			,LT13_TRANS_PRIOR = 0
			,LT13 = 0
			
			/* 13 weeks */
			
			/* 26 weeks */
			
			-- caps applied to measure, compare with remuneration end as threshold
			,CAP_CUR_26 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _26WEEKS_), 
															@remuneration_End, '2222/01/01')
														) + case when DATEPART(dw,injdate) not in (1,7) 
																	then 1 
																else 0 
															end)		
			
			-- caps applied to measure, compare with remuneration start as threshold
			,CAP_PRE_26 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
														dbo.udf_MinDay(DATEADD(dd, -1, _26WEEKS_), 
																DATEADD(dd, -1, @remuneration_Start), '2222/01/01')
															) + case when DATEPART(dw,injdate) not in (1,7) 
																		then 1 
																	else 0 
																end)
			
			-- determine days off work between payment period start and end dates, compare with remuneration end as threshold
			,DAYS26_TRANS = case when ppstart <= @remuneration_end 
									and paydate < DATEADD(MM, @Transaction_lag, _26WEEKS_)
									and paydate <= @transaction_lag_remuneration_end
									then case when dbo.udf_MinDay(@remuneration_End, 
														DATEADD(dd, -1, _26WEEKS_), ppend) >= ppstart 
												then dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _26WEEKS_), ppend)
																				)
																		) + case when DATEPART(dw,ppstart) not in (1,7) 
																					then 1
																				when rtw_paytype = 'TI' 
																					and DATEPART(dw,ppstart) in (1,7) 
																					and DATEPART(dw,ppend) in (1,7) 
																					and DATEDIFF(DD,ppstart, ppend) <= 1
																					 then 1 + DATEDIFF(DD,ppstart, ppend) 
																				else 0 
																			end
										else dbo.udf_MaxValue(0, 
													dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
															dbo.udf_MinDay(@remuneration_End, 
																	DATEADD(dd, -1, _26WEEKS_), ppend))) 
										end
									else 0
								end
			
			-- determine days off work between payment period start and end dates, compare with remuneration start as threshold
			,DAYS26_TRANS_PRIOR = case when ppstart < @remuneration_start 
											and paydate < DATEADD(MM, @Transaction_lag, _26WEEKS_)
											and paydate <= @transaction_lag_remuneration_start
											then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																	DATEADD(dd, -1, _26WEEKS_), ppend) >= ppstart 
															then dbo.udf_MaxValue(0, 
																		dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																				dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																						DATEADD(dd, -1, _26WEEKS_), ppend)
																										)
																				) + case when DATEPART(dw,ppstart) not in (1,7) 
																							then 1
																						 when rtw_paytype = 'TI' 
																							and DATEPART(dw,ppstart) in (1,7) 
																							and DATEPART(dw,ppend) in (1,7) 
																							and DATEDIFF(DD,ppstart, ppend) <= 1
																							then 1 + DATEDIFF(DD,ppstart, ppend) 
																						else 0 
																					end
									
											else dbo.udf_MaxValue(0, 
													dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
															dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																	DATEADD(dd, -1, _26WEEKS_), ppend)
																					)
																)
										end
									else 0 
								end
			,LT26_TRANS = 0
			,LT26_TRANS_PRIOR = 0
			,LT26 = 0
			
			/* 26 weeks */
			
			/* 52 weeks */
			
			-- caps applied to measure, compare with remuneration end as threshold
			,CAP_CUR_52 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _52WEEKS_), 
															@remuneration_End, '2222/01/01')
																			) +	case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0
																				end)
			
			-- caps applied to measure, compare with remuneration start as threshold
			,CAP_PRE_52 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _52WEEKS_), 
															DATEADD(dd, -1, @remuneration_Start), '2222/01/01')
																			) +	case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0 
																				end)
			
			-- determine days off work between payment period start and end dates, compare with remuneration end as threshold
			,DAYS52_TRANS = case when ppstart <= @remuneration_end 
										and paydate < DATEADD(MM, @Transaction_lag, _52WEEKS_)
										and paydate <= @transaction_lag_remuneration_end
									then case when dbo.udf_MinDay(@remuneration_End, 
															DATEADD(dd, -1, _52WEEKS_), ppend) >= ppstart 
												then dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _52WEEKS_), ppend)
																							)
																	) +	case when DATEPART(dw,ppstart) not in (1,7) 
																				then 1
																			 when rtw_paytype = 'TI' 
																				and DATEPART(dw,ppstart) in (1,7) 
																				and DATEPART(dw,ppend) in (1,7) 
																				and DATEDIFF(DD,ppstart, ppend) <= 1
																				then 1 + DATEDIFF(DD,ppstart, ppend) 
																			else 0
												end
										else dbo.udf_MaxValue(0, 
													dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
															dbo.udf_MinDay(@remuneration_End, 
																	DATEADD(dd, -1, _52WEEKS_), ppend))) 
									end
								else 0 
							end
			
			-- determine days off work between payment period start and end dates, compare with remuneration start as threshold
			,DAYS52_TRANS_PRIOR = case when ppstart < @remuneration_start 
											and paydate < DATEADD(MM, @Transaction_lag, _52WEEKS_)
											and paydate <= @transaction_lag_remuneration_start
										then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
															DATEADD(dd, -1, _52WEEKS_), ppend) >= ppstart 
													then dbo.udf_MaxValue(0, 
																dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																		dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																				DATEADD(dd, -1, _52WEEKS_), ppend)
																								)
																		) + case when DATEPART(dw,ppstart) not in (1,7) 
																					then 1
																				 when rtw_paytype = 'TI' 
																					and DATEPART(dw,ppstart) in (1,7) 
																					and DATEPART(dw,ppend) in (1,7) 
																					and DATEDIFF(DD,ppstart, ppend) <= 1
																					then 1 + DATEDIFF(DD,ppstart, ppend) 
																				else 0
																			end
												else dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																			DATEADD(dd, -1, _52WEEKS_), ppend)
																							)
																	) 
											end
										else 0
									end
			,LT52_TRANS = 0	
			,LT52_TRANS_PRIOR = 0	
			,LT52 = 0
			
			/* 52 weeks */
			
			/* 78 weeks */
			
			-- caps applied to measure, compare with remuneration end as threshold
			,CAP_CUR_78 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _78WEEKS_), 
															@remuneration_End, '2222/01/01')
																			) + case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0 
																				end)
			
			-- caps applied to measure, compare with remuneration start as threshold
			,CAP_PRE_78 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _78WEEKS_), 
															DATEADD(dd, -1, @remuneration_Start), '2222/01/01')
																			) +	case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0
																				end)
			
			-- determine days off work between payment period start and end dates, compare with remuneration end as threshold
			,DAYS78_TRANS = case when ppstart <= @remuneration_end 
										and paydate < DATEADD(MM, @Transaction_lag, _78WEEKS_)
										and paydate <= @transaction_lag_remuneration_end
									then case when dbo.udf_MinDay(@remuneration_End, 
															DATEADD(dd, -1, _78WEEKS_), ppend) >= ppstart 
												then dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _78WEEKS_), ppend)
																							)
																	) +	case when DATEPART(dw,ppstart) not in (1,7) 
																				then 1
																			 when rtw_paytype = 'TI' 
																				and DATEPART(dw,ppstart) in (1,7) 
																				and DATEPART(dw,ppend) in (1,7) 
																				and DATEDIFF(DD,ppstart, ppend) <= 1
																				then 1 + DATEDIFF(DD,ppstart, ppend) 
																			else 0 
																		end
											else dbo.udf_MaxValue(0, 
														dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																dbo.udf_MinDay(@remuneration_End, 
																		DATEADD(dd, -1, _78WEEKS_), ppend))) 
											end
									else 0
								end
			
			-- determine days off work between payment period start and end dates, compare with remuneration start as threshold
			,DAYS78_TRANS_PRIOR = case when ppstart < @remuneration_start 
											and paydate < DATEADD(MM, @Transaction_lag, _78WEEKS_)
											and paydate <= @transaction_lag_remuneration_start								
											then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																	DATEADD(dd, -1, _78WEEKS_), ppend) >= ppstart 
														then dbo.udf_MaxValue(0, 
																	dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																			dbo.udf_MinDay(DATEADD(dd, -1, 
																					@remuneration_Start), 
																					DATEADD(dd, -1, _78WEEKS_), ppend)
																							)
																			) + case when DATEPART(dw,ppstart) not in (1,7) 
																						then 1
																					 when rtw_paytype = 'TI' 
																							and DATEPART(dw,ppstart) in (1,7) 
																							and DATEPART(dw,ppend) in (1,7) 
																							and DATEDIFF(DD,ppstart, ppend) <= 1
																						then 1 + DATEDIFF(DD,ppstart, ppend) 
																					else 0 
																				end
														else dbo.udf_MaxValue(0, 
																	dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																			dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																					DATEADD(dd, -1, _78WEEKS_), ppend)
																									)
																			) 
													end
											else 0 
									end
			,LT78_TRANS = 0	
			,LT78_TRANS_PRIOR = 0
			,LT78 = 0
			
			/* 78 weeks */
			
			/* 104 weeks */
			
			-- caps applied to measure, compare with remuneration end as threshold
			,CAP_CUR_104 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _104WEEKS_), 
															@remuneration_End, '2222/01/01')
																			) + case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0 
																				end)
			
			-- caps applied to measure, compare with remuneration start as threshold
			,CAP_PRE_104 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _104WEEKS_), 
															DATEADD(dd, -1, @remuneration_Start), '2222/01/01')
																			) + case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0 
																				end)
			
			-- determine days off work between payment period start and end dates, compare with remuneration end as threshold
			,DAYS104_TRANS = case when ppstart <= @remuneration_end 
										and paydate < DATEADD(MM, @Transaction_lag, _104WEEKS_)
										and paydate <= @transaction_lag_remuneration_end
									then case when dbo.udf_MinDay(@remuneration_End, 
															DATEADD(dd, -1, _104WEEKS_), ppend) >= ppstart 
												then dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _104WEEKS_), ppend)
																							)
																	) +	case when DATEPART(dw,ppstart) not in (1,7) 
																				then 1
																			 when rtw_paytype = 'TI' 
																				and DATEPART(dw,ppstart) in (1,7) 
																				and DATEPART(dw,ppend) in (1,7) 
																				and DATEDIFF(DD,ppstart, ppend) <= 1
																				then 1 + DATEDIFF(DD,ppstart, ppend) 
																			else 0
																		end
												else dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _104WEEKS_), ppend))) 
										end
									else 0
								end
			
			-- determine days off work between payment period start and end dates, compare with remuneration start as threshold
			,DAYS104_TRANS_PRIOR = case when ppstart < @remuneration_start 
											and paydate < DATEADD(MM, @Transaction_lag, _104WEEKS_)
											and paydate <= @transaction_lag_remuneration_start
											then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																	DATEADD(dd, -1, _104WEEKS_), ppend) >= ppstart 
														then dbo.udf_MaxValue(0, 
																	dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																			dbo.udf_MinDay(DATEADD(dd, -1, 
																					@remuneration_Start), 
																					DATEADD(dd, -1, _104WEEKS_), ppend)
																									)
																			) +	case when DATEPART(dw,ppstart) not in (1,7) 
																						then 1
																					 when rtw_paytype = 'TI' and DATEPART(dw,ppstart) in (1,7) 
																						and DATEPART(dw,ppend) in (1,7) 
																						and DATEDIFF(DD,ppstart, ppend) <= 1
																						then 1 + DATEDIFF(DD,ppstart, ppend) 
																					else 0
																				end
											else dbo.udf_MaxValue(0, 
														dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																dbo.udf_MinDay(DATEADD(dd, -1, 
																		@remuneration_Start), 
																		DATEADD(dd, -1, _104WEEKS_), ppend)
																					)
																)
											end
									else 0
								end
			,LT104_TRANS = 0
			,LT104_TRANS_PRIOR = 0
			,LT104 = 0
			
			/* 104 weeks */
			
			/* flags determine transaction's incapacity periods is lied within 13, 26, 52, 78, 104 weeks injury or not */
			,include_13 = (case when (injdate between @remuneration_Start and @remuneration_End) 
									or (_13WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (@remuneration_Start between  injdate and _13WEEKS_) 
									or (@remuneration_End between  injdate and _13WEEKS_) 
									then 1 
								else 0 
						  end)
			,include_26 = (case when (injdate between @remuneration_Start and @remuneration_End) 
									or (_26WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (@remuneration_Start between  injdate and _26WEEKS_) 
									or (@remuneration_End between  injdate and _26WEEKS_) 
									then 1 
								else 0 
						   end)
			,include_52 = (case when (_26WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (_52WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (@remuneration_Start between  _26WEEKS_ and _52WEEKS_) 
									or (@remuneration_End between  _26WEEKS_ and _52WEEKS_) 
									then 1 
								else 0 
						   end)
			,include_78 = (case when (_52WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (_78WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (@remuneration_Start between  _52WEEKS_ and _78WEEKS_) 
									or (@remuneration_End between  _52WEEKS_ and _78WEEKS_) 
									then 1 
								else 0 
						   end)
			,include_104 = (case when (_52WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (_104WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (@remuneration_Start between  _52WEEKS_ and _104WEEKS_) 
									or (@remuneration_End between  _52WEEKS_ and _104WEEKS_) 
									then 1 
								 else 0 
							end)
			
			/* flags determine transaction is included in the 13, 26, 52, 78, 104 week measures or not */
			,include_13_trans = (case when pr.paydate <  DATEADD(MM, @Transaction_lag, _13WEEKS_) 
											   and pr.paydate <= @transaction_lag_remuneration_end 	
											   then 1 
										  else 0 
									end)
			,include_26_trans = (case when pr.paydate <  DATEADD(MM, @Transaction_lag, _26WEEKS_) 
										   and pr.paydate <= @transaction_lag_remuneration_end	
										  then 1 
									  else 0 
								end)
			,include_52_trans = (case when  pr.paydate <  DATEADD(MM, @Transaction_lag, _52WEEKS_) 
											and pr.paydate <= @transaction_lag_remuneration_end 	
										  then 1 
									  else 0 
								end)
			,include_78_trans = (case when  pr.paydate <  DATEADD(MM, @Transaction_lag, _78WEEKS_) 
												and pr.paydate <= @transaction_lag_remuneration_end 	
											  then 1 
										   else 0 
									 end)
			,include_104_trans = (case when pr.paydate <  DATEADD(MM, @Transaction_lag, _104WEEKS_) 
											and pr.paydate <= @transaction_lag_remuneration_end 	
											then 1 
										else 0 
								  end)
			
			,Total_LT = 0
			,_13WEEKS_
			,_26WEEKS_
			,_52WEEKS_
			,_78WEEKS_
			,_104WEEKS_
			
			/* recalculate days off work between MAX(date of injury, remuneration start) 
				and MIN(13 weeks, remuneration end): exclude Saturday or Sunday at right threshold */
			,DAYS13_PRD_CALC = DAYS13_PRD 
											 
			/* recalculate days off work between MAX(date of injury, remuneration start) 
				and MIN(26 weeks, remuneration end): exclude Saturday or Sunday at right threshold */
			,DAYS26_PRD_CALC = DAYS26_PRD 
											 
			/* recalculate days off work between MAX(date of injury, remuneration start) 
				and MIN(52 weeks, remuneration end): exclude Saturday or Sunday at right threshold */
			,DAYS52_PRD_CALC = DAYS52_PRD 
											
			/* recalculate days off work between MAX(date of injury, remuneration start) 
				and MIN(78 weeks, remuneration end): exclude Saturday or Sunday at right threshold */
			,DAYS78_PRD_CALC = DAYS78_PRD 
											 
			/* recalculate days off work between MAX(date of injury, remuneration start) 
				and MIN(104 weeks, remuneration end): exclude Saturday or Sunday at right threshold */
			,DAYS104_PRD_CALC = DAYS104_PRD 
											  
			/* recalculate days off work between 13 weeks and date of injury: 
				exclude Saturday or Sunday at right threshold */
			,DAYS13_CALC = DAYS13 
									 
			/* recalculate days off work between 26 weeks and date of injury: 
				exclude Saturday or Sunday at right threshold */
			,DAYS26_CALC = DAYS26 
									 
			/* recalculate days off work between 52 weeks and date of injury: 
				exclude Saturday or Sunday at right threshold */
			,DAYS52_CALC = DAYS52 
									 
			/* recalculate days off work between 78 weeks and date of injury: 
				exclude Saturday or Sunday at right threshold */
			,DAYS78_CALC = DAYS78 
									 
			/* recalculate days off work between 104 weeks and date of injury: 
				exclude Saturday or Sunday at right threshold */
			,DAYS104_CALC = DAYS104 
	FROM #claim cd INNER JOIN #rtw_raworig_2 pr ON cd.Claim = pr.Claim
				   LEFT JOIN  #policy pd ON pd.policyno = cd.policyno
											AND pd.renewal_no = cd.renewal_no
											AND PR.ppstart <= @remuneration_end

	/* update LT_TRANS and LT_TRANS_PRIOR */
	UPDATE #measures
		SET LT13_TRANS = (case when days_for_TI = 0 
									then 0 
								else 1.0
									 * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
									 * DAYS13_TRANS / nullif(days_for_TI,0)
					    end)
			,LT13_TRANS_PRIOR = (case when days_for_TI = 0 
										then 0 
									else 1.0 
										 * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
										 * DAYS13_TRANS_PRIOR / nullif(days_for_TI,0)
								end)
			,LT26_TRANS = (case when days_for_TI = 0 
									then 0 
								else 1.0 
									 * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
									 * DAYS26_TRANS / nullif(days_for_TI,0)
							end)
			,LT26_TRANS_PRIOR = (case when days_for_TI = 0 
										then 0 
									  else 1.0 
											* (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
											* DAYS26_TRANS_PRIOR / nullif(days_for_TI,0)
								end)
			,LT52_TRANS = (case when days_for_TI = 0 
									then 0 
								else 1.0
									 * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
									 * DAYS52_TRANS / nullif(days_for_TI,0)
						   end)
			,LT52_TRANS_PRIOR = (case when days_for_TI = 0 
										then 0 
									  else 1.0 
											* (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
											* DAYS52_TRANS_PRIOR / nullif(days_for_TI,0)
								end)
			,LT78_TRANS = (case when days_for_TI = 0 then 0 
								else 1.0 
									 * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC)
									 * DAYS78_TRANS / nullif(days_for_TI,0)
						   end)
			,LT78_TRANS_PRIOR = (case when days_for_TI = 0 
										then 0 
									  else 1.0 
											* (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
										    * DAYS78_TRANS_PRIOR / nullif(days_for_TI,0)
								end)
			,LT104_TRANS = (case when days_for_TI = 0 
									then 0 
								 else 1.0
									  * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
									  * DAYS104_TRANS / nullif(days_for_TI,0)
							end)
			,LT104_TRANS_PRIOR = (case when days_for_TI = 0 
											then 0 
									   else 1.0 
											* (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
											* DAYS104_TRANS_PRIOR / nullif(days_for_TI,0)
								 end)
			,Total_LT = (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC)
						* (case when ppend <= @remuneration_end or days_for_TI = 0 
									 then 1
								when ppstart > @remuneration_end 
									 then 0
								else 1.0 
									 * dbo.udf_NoOfDaysWithoutWeekend(ppstart, @remuneration_end) 
									 / nullif(days_for_TI,0)
						  end)

	/* end of updating LT_TRANS and LT_TRANS_PRIOR */
	
	/* delete small transactions */

	/* small transactions with $2 per day for S40 and WC payments */
	DELETE FROM #measures WHERE (CASE WHEN paytype in ('S40') AND days_for_TI <> 0 
											AND hrs_per_week_adjusted >= 35 
											AND (1.0 * payamt / nullif(days_for_TI,0)) < 2 
										THEN 1
									 WHEN paytype in ('S40') AND days_for_TI <> 0 
											AND hrs_per_week_adjusted < 35 
											AND (1.0 * payamt / nullif(((days_for_TI*hrs_per_week_adjusted)/37.5),0)) < 2 
										THEN 1 
									 WHEN paytype in ('S40') AND days_for_TI = 0 
											AND LT_S40 <> 0 AND (1.0 * payamt / nullif(LT_S40,0)) < 2  
										THEN 1
									 WHEN paytype in ('WORKCAP') AND LT_WC <> 0 AND (1.0 * payamt / nullif(LT_WC,0)) < 2 
										THEN 1
									 ELSE 0
								  END = 1)

	/* other small transactions with payment amount < $20 per day */
	DELETE FROM #measures WHERE (CASE WHEN  paytype in ('S38','TI','NOWORKCAP') 
										    and (LT_TI + LT_S38 + LT_NWC) <> 0 
										    and (1.0 * payamt / nullif((LT_TI + LT_S38 + LT_NWC),0)) < 20 
										  THEN 1
									  ELSE 0
								 END = 1)
	/* end delete small transactions */
	
	/* Extract claims 13 weeks from #measures table and some additional tables */
	--SELECT  'Remuneration_Start' = dateadd(mm, 1, @remuneration_start)
	--		,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0, @remuneration_end) 
	--			+ @Transaction_lag - 1, 0)) + '23:59'
	SELECT  'Remuneration_Start' = @remuneration_start
			,'Remuneration_End' = @remuneration_end
			,Measure_months = @measure_month_13
			,'Group' = CASE WHEN (rtrim(isnull(co.Grp,''))='') 
								--Match Miscellaneous group for all group that inactive--	
							OR NOT EXISTS (select distinct grp 
												from claims_officers 
												where active = 1 and len(rtrim(ltrim(grp))) > 0 
													  and grp like co.Grp+'%')	
							OR (co.Grp NOT LIKE 'wcnsw%' or PATINDEX('WCNSW', RTRIM(co.Grp))>0)
								THEN 'Miscellaneous'
							WHEN PATINDEX('WCNSW%', co.Grp) = 0 THEN Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1)
							WHEN rtrim(co.Grp) = 'WCNSW' THEN 'WCNSW(Group)'
							ELSE SUBSTRING(Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1), 1, 
									CASE WHEN PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 6, LEN(rtrim(co.Grp)) - 5)) > 0 
										THEN (PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 6, LEN(rtrim(co.Grp)) - 5)) + 4) 
										ELSE LEN(rtrim(co.Grp)) 
									END)
							END
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' THEN 'Miscellaneous' ELSE RTRIM(UPPER(co.Grp)) END		
			,Case_manager = ISNULL(UPPER(coa1.First_Name + ' ' + coa1.Last_Name), 'Miscellaneous')			
			,Agency_id = ''
			,cd.Claim_no
			,cd.injdate
			,cd.policyno
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,AgencyName = ''
			,Sub_category = ''
			,Measure = 13
			,Cert_Type = case when mc.TYPE = 'P' then 'No Time Lost' 
						      when mc.TYPE = 'T' then 'Totally Unfit'
							  when mc.TYPE = 'S' then 'Suitable Duties'
							  when mc.TYPE = 'I' then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' then 'Permanently Modified Duties'
							  else 'Invalid type' end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,Cell_no = NULL
			,Portfolio = ''
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag

	FROM (
			SELECT rtrim(cla.claim) as Claim_no
					,cla.injdate
					,cla.policyno
					,round(dbo.udf_MinValue(sum(cla.LT13_TRANS), 
									avg(CAP_CUR_13)) - dbo.udf_MinValue(sum(cla.LT13_TRANS_PRIOR), 
																AVG(CAP_PRE_13)), 10) as LT					
					,round(dbo.udf_MinValue(1, 1.0 * DAYS13_PRD_CALC / nullif(DAYS13_CALC,0)), 10) as WGT
					,cla.EMPL_SIZE
					,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
					,_13WEEKS_
			FROM #measures cla 
			WHERE cla.include_13 = 1 and cla.include_13_trans = 1
			GROUP BY cla.claim,policyno,
					cla.injdate,
					_13WEEKS_,
					DAYS13_PRD_CALC, 
					DAYS13_CALC, 
					cla.EMPL_SIZE
			HAVING round(SUM(total_LT),10) > 5 
					and round(sum(LT13_TRANS),10) > 5
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias 
		INNER JOIN ptd_audit ptda ON cd.policyno = ptda.Policy_No
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
				  left join Broker Br on PTD.Broker_No = Br.Broker_no 
				  left join UnderWriters U on  BR.emi_Contact = U.Alias 
					where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no
		
	WHERE cada1.id = (SELECT MAX(cada2.id) 
						FROM cad_audit cada2 
						WHERE cada2.claim_no = cada1.claim_no 
							and cada2.transaction_date <= dbo.udf_MinDay(cd._13WEEKS_,
						  @remuneration_end, cd._13WEEKS_))
		AND coa1.id = (SELECT MAX(coa2.id)
						  FROM CO_audit coa2
						  WHERE coa2.officer_id = coa1.officer_id 
						  and coa2.create_date < dbo.udf_MinDay(cd._13WEEKS_,
						  @remuneration_end, cd._13WEEKS_))
		AND ptda.id = (SELECT MAX(ptda2.id) 
						FROM ptd_audit ptda2
						WHERE ptda2.policy_no = ptda.policy_no 
							and ptda2.create_date <= @remuneration_end)
		
	UNION ALL
	
	/* Extract claims 26 weeks from #measures table and some additional tables */
	--SELECT  'Remuneration_Start' = dateadd(mm, 1, @remuneration_start)
	--		,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0, @remuneration_end) 
	--			+ @Transaction_lag - 1, 0)) + '23:59'
	SELECT  'Remuneration_Start' = @remuneration_start
			,'Remuneration_End' = @remuneration_end
			,Measure_months = @Measure_month_26
			,'Group' = CASE WHEN (rtrim(isnull(co.Grp,''))='') 
								--Match Miscellaneous group for all group that inactive--	
							OR NOT EXISTS (select distinct grp 
												from claims_officers 
												where active = 1 and len(rtrim(ltrim(grp))) > 0 
													  and grp like co.Grp+'%')	
							OR (co.Grp NOT LIKE 'wcnsw%' or PATINDEX('WCNSW', RTRIM(co.Grp))>0)
								THEN 'Miscellaneous'
							WHEN PATINDEX('WCNSW%', co.Grp) = 0 THEN Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1)
							WHEN rtrim(co.Grp) = 'WCNSW' THEN 'WCNSW(Group)'
							ELSE SUBSTRING(Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1), 1, 
									CASE WHEN PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 6, LEN(rtrim(co.Grp)) - 5)) > 0 
										THEN (PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 6, LEN(rtrim(co.Grp)) - 5)) + 4) 
										ELSE LEN(rtrim(co.Grp)) 
									END)
							END
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' THEN 'Miscellaneous' ELSE RTRIM(UPPER(co.Grp)) END		
			,Case_manager = ISNULL ( UPPER(coa1.First_Name+' '+ coa1.Last_Name), 'Miscellaneous')			
			,Agency_id = ''
			,cd.Claim_no
			,cd.injdate
			,cd.policyno
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,AgencyName = ''
			,Sub_category = ''
			,Measure = 26
			,Cert_Type = case when mc.TYPE = 'P' then 'No Time Lost' 
						      when mc.TYPE = 'T' then 'Totally Unfit'
							  when mc.TYPE = 'S' then 'Suitable Duties'
							  when mc.TYPE = 'I' then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' then 'Permanently Modified Duties'
							  else 'Invalid type' end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,Cell_no = NULL
			,Portfolio = ''
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag

	FROM (
			SELECT rtrim(cla.claim) as Claim_no
				,cla.injdate
				,cla.policyno
				,round(dbo.udf_MinValue(sum(cla.LT26_TRANS), 
								avg(CAP_CUR_26)) - dbo.udf_MinValue(sum(cla.LT26_TRANS_PRIOR), 
															AVG(CAP_PRE_26)), 10) as LT				
				,round(dbo.udf_MinValue(1, 1.0 * DAYS26_PRD_CALC / nullif(DAYS26_CALC,0)), 10) as WGT
				,cla.EMPL_SIZE
				,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
				,_26WEEKS_
			FROM #measures cla 
			where cla.include_26 = 1 and cla.include_26_trans = 1
			GROUP BY cla.claim,
					policyno,
					cla.injdate,
					_26WEEKS_,
					DAYS26_PRD_CALC,
					DAYS26_CALC, 
					cla.EMPL_SIZE
			HAVING round(SUM(total_LT),10) > 5 
						and round(sum(LT26_TRANS),10) > 5
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_no = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		INNER JOIN ptd_audit ptda ON cd.policyno = ptda.Policy_No
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
					left join Broker Br on PTD.Broker_No = Br.Broker_no 
					left join UnderWriters U on  BR.emi_Contact = U.Alias 
					where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no
	
	WHERE cada1.id = (SELECT MAX(cada2.id) 
						FROM cad_audit cada2
						WHERE cada2.claim_no = cada1.claim_no
							and cada2.transaction_date <= dbo.udf_MinDay(cd._26WEEKS_,
						  @remuneration_end, cd._26WEEKS_))
		AND coa1.id = (SELECT MAX(coa2.id)
						  FROM CO_audit coa2
						  WHERE coa2.officer_id = coa1.officer_id 
						  and coa2.create_date < dbo.udf_MinDay(cd._26WEEKS_,
						  @remuneration_end, cd._26WEEKS_))
		AND ptda.id = (SELECT MAX(ptda2.id) 
						FROM ptd_audit ptda2
						WHERE ptda2.policy_no = ptda.policy_no 
							and ptda2.create_date <= @remuneration_end)
		
	UNION ALL
	
	/* Extract claims 52 weeks from #measures table and some additional tables */
	--SELECT  'Remuneration_Start' = dateadd(mm, 1, @remuneration_start)
	--		,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0, @remuneration_end) 
	--			+ @Transaction_lag - 1, 0)) + '23:59'
	SELECT  'Remuneration_Start' = @remuneration_start
			,'Remuneration_End' = @remuneration_end
			,Measure_months = @Measure_month_52
			,'Group' = CASE WHEN (rtrim(isnull(co.Grp,''))='') 
								--Match Miscellaneous group for all group that inactive--	
							OR NOT EXISTS (select distinct grp 
												from claims_officers 
												where active = 1 and len(rtrim(ltrim(grp))) > 0 
													  and grp like co.Grp+'%')	
							OR (co.Grp NOT LIKE 'wcnsw%' or PATINDEX('WCNSW', RTRIM(co.Grp))>0)
								THEN 'Miscellaneous'
							WHEN PATINDEX('WCNSW%', co.Grp) = 0 THEN Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1)
							WHEN rtrim(co.Grp) = 'WCNSW' THEN 'WCNSW(Group)'
							ELSE SUBSTRING(Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1), 1, 
									CASE WHEN PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 6, LEN(rtrim(co.Grp)) - 5)) > 0 
										THEN (PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 6, LEN(rtrim(co.Grp)) - 5)) + 4) 
										ELSE LEN(rtrim(co.Grp)) 
									END)
							END
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' THEN 'Miscellaneous' ELSE RTRIM(UPPER(co.Grp)) END		
			,Case_manager = ISNULL ( UPPER(coa1.First_Name + ' ' + coa1.Last_Name), 'Miscellaneous')			
			,Agency_id = ''
			,cd.Claim_no
			,cd.injdate
			,cd.policyno
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,AgencyName = ''
			,Sub_category = ''
			,Measure = 52
			,Cert_Type = case when mc.TYPE = 'P' then 'No Time Lost' 
						      when mc.TYPE = 'T' then 'Totally Unfit'
							  when mc.TYPE = 'S' then 'Suitable Duties'
							  when mc.TYPE = 'I' then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' then 'Permanently Modified Duties'
							  else 'Invalid type' end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,Cell_no = NULL
			,Portfolio = ''
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag

	FROM (
			SELECT	rtrim(cla.claim) as Claim_no	
					,cla.injdate	
					,cla.policyno	
					,	(round(dbo.udf_MinValue(sum(cla.LT52_TRANS), 
										avg(CAP_CUR_52)) - dbo.udf_MinValue(sum(cla.LT52_TRANS_PRIOR), 
																AVG(CAP_PRE_52)), 10)
						- (round(dbo.udf_MinValue(sum(cla.LT26_TRANS), 
										avg(CAP_CUR_26)) - dbo.udf_MinValue(sum(cla.LT26_TRANS_PRIOR), 
																AVG(CAP_PRE_26)), 10))
					) as LT						
					,round(dbo.udf_MinValue(1, 1.0 * DAYS52_PRD_CALC / nullif(DAYS52_CALC,0)), 10) as WGT
					,cla.EMPL_SIZE
					,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
					,_52WEEKS_
			FROM #measures cla
			WHERE cla.include_52 = 1 and cla.include_52_trans = 1
			GROUP BY cla.claim,
					cla.policyno,
					cla.injdate,
					_52WEEKS_,
					DAYS52_PRD_CALC, 
					DAYS52_CALC, 
					cla.EMPL_SIZE
			HAVING round(SUM(total_LT),10) > 5 and round(sum(LT52_TRANS),10) > 5	
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		INNER JOIN ptd_audit ptda ON cd.policyno = ptda.Policy_No
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
					left join Broker Br on PTD.Broker_No = Br.Broker_no 
					left join UnderWriters U on  BR.emi_Contact = U.Alias 
					where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no
		
	WHERE cada1.id = (SELECT MAX(cada2.id) 
						FROM cad_audit cada2 
						WHERE cada2.claim_no = cada1.claim_no 
							and cada2.transaction_date <= dbo.udf_MinDay(cd._52WEEKS_,
						  @remuneration_end, cd._52WEEKS_))
		AND coa1.id = (SELECT MAX(coa2.id)
						  FROM CO_audit coa2
						  WHERE coa2.officer_id = coa1.officer_id 
						  and coa2.create_date < dbo.udf_MinDay(cd._52WEEKS_,
						  @remuneration_end, cd._52WEEKS_))
		AND ptda.id = (SELECT MAX(ptda2.id) 
						FROM ptd_audit ptda2
						WHERE ptda2.policy_no = ptda.policy_no 
							and ptda2.create_date <= @remuneration_end)
		
	UNION ALL
	
	/* Extract claims 78 weeks from #measures table and some additional tables */
	--SELECT  'Remuneration_Start' = dateadd(mm, 1, @remuneration_start)
	--		,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0, @remuneration_end) 
	--			+ @Transaction_lag - 1, 0)) + '23:59'
	SELECT  'Remuneration_Start' = @remuneration_start
			,'Remuneration_End' = @remuneration_end
			,Measure_months = @Measure_month_78
			,'Group' = CASE WHEN (rtrim(isnull(co.Grp,''))='') 
								--Match Miscellaneous group for all group that inactive--	
							OR NOT EXISTS (select distinct grp 
												from claims_officers 
												where active = 1 and len(rtrim(ltrim(grp))) > 0 
													  and grp like co.Grp+'%')	
							OR (co.Grp NOT LIKE 'wcnsw%' or PATINDEX('WCNSW', RTRIM(co.Grp))>0)
								THEN 'Miscellaneous'	
							WHEN PATINDEX('WCNSW%', co.Grp) = 0 THEN Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1)
							WHEN rtrim(co.Grp) = 'WCNSW' THEN 'WCNSW(Group)'
							ELSE SUBSTRING(Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1), 1, 
									CASE WHEN PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 6, LEN(rtrim(co.Grp)) - 5)) > 0 
										THEN (PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 6, LEN(rtrim(co.Grp)) - 5)) + 4) 
										ELSE LEN(rtrim(co.Grp)) 
									END)
							END
			
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' THEN 'Miscellaneous' ELSE RTRIM(UPPER(co.Grp)) END		
			,Case_manager = ISNULL ( UPPER(coa1.First_Name+' '+ coa1.Last_Name), 'Miscellaneous')			
			,Agency_id = ''
			,cd.Claim_no
			,cd.injdate
			,cd.policyno
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,AgencyName = ''
			,Sub_category = ''
			,Measure = 78
			,Cert_Type = case when mc.TYPE = 'P' then 'No Time Lost' 
						      when mc.TYPE = 'T' then 'Totally Unfit'
							  when mc.TYPE = 'S' then 'Suitable Duties'
							  when mc.TYPE = 'I' then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' then 'Permanently Modified Duties'
							  else 'Invalid type' end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,Cell_no = NULL
			,Portfolio = ''
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
	FROM (
			SELECT	rtrim(cla.claim) as Claim_no
					,cla.injdate	
					,cla.policyno	
					,	(round(dbo.udf_MinValue(sum(cla.LT78_TRANS), 
													avg(CAP_CUR_78)) - dbo.udf_MinValue(sum(cla.LT78_TRANS_PRIOR), 
																							AVG(CAP_PRE_78)), 10)
						- (round(dbo.udf_MinValue(sum(cla.LT52_TRANS), 
													avg(CAP_CUR_52)) - dbo.udf_MinValue(sum(cla.LT52_TRANS_PRIOR), 
																							AVG(CAP_PRE_52)), 10))
					) as LT
					,round(dbo.udf_MinValue(1, 1.0 * DAYS78_PRD_CALC / nullif(DAYS78_CALC,0)), 10) as WGT
					,cla.EMPL_SIZE
					,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
					,_78WEEKS_
			FROM #measures cla
			WHERE cla.include_78 = 1 and cla.include_78_trans = 1
			GROUP BY cla.claim,
					cla.policyno,
					cla.injdate,
					_78WEEKS_, 
					DAYS78_PRD_CALC, 
					DAYS78_CALC, 
					cla.EMPL_SIZE
			HAVING round(SUM(total_LT),10) > 5 and round(sum(LT78_TRANS),10) > 5
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		INNER JOIN ptd_audit ptda ON cd.policyno = ptda.Policy_No
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
					left join Broker Br on PTD.Broker_No = Br.Broker_no 
					left join UnderWriters U on  BR.emi_Contact = U.Alias 
					where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no	
		
	WHERE cada1.id = (SELECT MAX(cada2.id) 
						FROM cad_audit cada2 
						WHERE cada2.claim_no = cada1.claim_no 
							and cada2.transaction_date <= dbo.udf_MinDay(cd._78WEEKS_,
						  @remuneration_end, cd._78WEEKS_))
		AND coa1.id = (SELECT MAX(coa2.id)
						  FROM CO_audit coa2
						  WHERE coa2.officer_id = coa1.officer_id 
						  and coa2.create_date < dbo.udf_MinDay(cd._78WEEKS_,
						  @remuneration_end, cd._78WEEKS_))
		AND ptda.id = (SELECT MAX(ptda2.id)
						FROM ptd_audit ptda2
						WHERE ptda2.policy_no = ptda.policy_no 
							and ptda2.create_date <= @remuneration_end)
					
	UNION ALL
	
	/* Extract claims 104 weeks from #measures table and some additional tables */
	--SELECT  'Remuneration_Start' = dateadd(mm, 1, @remuneration_start)
	--		,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0, @remuneration_end) 
	--			+ @Transaction_lag - 1, 0)) + '23:59'
	SELECT  'Remuneration_Start' = @remuneration_start
			,'Remuneration_End' = @remuneration_end
			,Measure_months = @Measure_month_104
			,'Group' = CASE WHEN (rtrim(isnull(co.Grp,''))='') 
								--Match Miscellaneous group for all group that inactive--	
							OR NOT EXISTS (select distinct grp 
												from claims_officers 
												where active = 1 and len(rtrim(ltrim(grp))) > 0 
													  and grp like co.Grp+'%')							
							OR (co.Grp NOT LIKE 'wcnsw%' or PATINDEX('WCNSW', RTRIM(co.Grp))>0)
								THEN 'Miscellaneous'
							WHEN PATINDEX('WCNSW%', co.Grp) = 0 THEN Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1)
							WHEN rtrim(co.Grp) = 'WCNSW' THEN 'WCNSW(Group)'
							ELSE SUBSTRING(Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1), 1, 
									CASE WHEN PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 6, LEN(rtrim(co.Grp)) - 5)) > 0 
										THEN (PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 6, LEN(rtrim(co.Grp)) - 5)) + 4) 
										ELSE LEN(rtrim(co.Grp)) 
									END)
							END
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' THEN 'Miscellaneous' ELSE RTRIM(UPPER(co.Grp)) END		
			,Case_manager = ISNULL(UPPER(coa1.First_Name + ' ' + coa1.Last_Name), 'Miscellaneous')			
			,Agency_id = ''
			,cd.Claim_no
			,cd.injdate
			,cd.policyno
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,AgencyName = ''
			,Sub_category = ''
			,Measure = 104
			,Cert_Type = case when mc.TYPE = 'P' then 'No Time Lost' 
						      when mc.TYPE = 'T' then 'Totally Unfit'
							  when mc.TYPE = 'S' then 'Suitable Duties'
							  when mc.TYPE = 'I' then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' then 'Permanently Modified Duties'
							  else 'Invalid type' end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To	
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,Cell_no = NULL
			,Portfolio = ''
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
	FROM (
			SELECT	rtrim(cla.claim) as Claim_no
				,cla.injdate	
				,cla.policyno	
				,	(round(dbo.udf_MinValue(sum(cla.LT104_TRANS), 
									avg(CAP_CUR_104)) - dbo.udf_MinValue(sum(cla.LT104_TRANS_PRIOR), 
																AVG(CAP_PRE_104)), 10)
					- round(dbo.udf_MinValue(sum(cla.LT52_TRANS), 
									avg(CAP_CUR_52)) - dbo.udf_MinValue(sum(cla.LT52_TRANS_PRIOR), 
																AVG(CAP_PRE_52)), 10)
				) as LT					
				,round(dbo.udf_MinValue(1, 1.0 * DAYS104_PRD_CALC / nullif(DAYS104_CALC,0)), 10) as WGT
				,cla.EMPL_SIZE
				,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
				,_104WEEKS_
			FROM #measures cla 
			WHERE cla.include_104 = 1 and cla.include_104_trans = 1
			GROUP BY cla.claim,
					cla.policyno,
					cla.injdate,
					_104WEEKS_, 
					DAYS104_PRD_CALC, 
					DAYS104_CALC, 
					cla.EMPL_SIZE
			HAVING round(SUM(total_LT),10) > 5 and round(sum(LT104_TRANS),10) > 5		
		) as cd 
		
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		INNER JOIN ptd_audit ptda ON cd.policyno = ptda.Policy_No
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
					left join Broker Br on PTD.Broker_No = Br.Broker_no 
					left join UnderWriters U on  BR.emi_Contact = U.Alias 
					where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no	
		
	WHERE cada1.id = (SELECT MAX(cada2.id) 
						FROM cad_audit cada2 
						WHERE cada2.claim_no = cada1.claim_no 
							and cada2.transaction_date <= dbo.udf_MinDay(cd._104WEEKS_,
						  @remuneration_end, cd._104WEEKS_))
		AND coa1.id = (SELECT MAX(coa2.id)
						  FROM CO_audit coa2
						  WHERE coa2.officer_id = coa1.officer_id 
						  and coa2.create_date < dbo.udf_MinDay(cd._104WEEKS_,
						  @remuneration_end, cd._104WEEKS_))
		AND ptda.id = (SELECT MAX(ptda2.id) 
						FROM ptd_audit ptda2
						WHERE ptda2.policy_no = ptda.policy_no 
							and ptda2.create_date <= @remuneration_end)
		
	/* drop all temp table */
	IF OBJECT_ID('tempdb..#measures') IS NOT NULL drop table #measures	
	/* end drop all temp table */
END--------------------------------  
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_RTW] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_RTW] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_RTW] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_EML_RTW.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_EML_RTW_GenerateData.sql  
--------------------------------  
/****** Object:  StoredProcedure [dbo].[usp_Dashboard_EML_RTW_GenerateData]    Script Date: 12/26/2013 14:40:33 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_EML_RTW_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_EML_RTW_GenerateData]
GO

-- For example
-- exec [usp_Dashboard_EML_RTW_GenerateData] 2013, 6
CREATE PROCEDURE [dbo].[usp_Dashboard_EML_RTW_GenerateData]
	@start_period_year int = 2010,
	@start_period_month int = 11	
AS
BEGIN
	SET NOCOUNT ON;
	declare @SQL varchar(500)
	
	declare @measure_month_13 int
	declare @measure_month_26 int
	declare @measure_month_52 int
	declare @measure_month_78 int
	declare @measure_month_104 int
	
	declare @AsAt datetime
	declare @remuneration_start datetime
	declare @remuneration_end datetime
	
	declare @transaction_lag_remuneration_end datetime
	
	declare @paystartdt datetime
	declare @transaction_lag int	
	
	set @measure_month_13 = 3	-- 13weeks = 3
	set @measure_month_26 = 6	-- 26weeks = 6
	set @measure_month_52 = 12  -- 52weeks = 12
	set @measure_month_78 = 18  -- 78weeks = 18
	set @measure_month_104 = 24 -- 104weeks = 24	
	
	set @transaction_lag = 3 -- for EML
	
	---delete last transaction lag number months in dart db---	
	exec('DELETE FROM [DART].[dbo].[EML_RTW] 
			WHERE remuneration_end in (select distinct top '+@transaction_lag+' remuneration_end 
			from [DART].[dbo].[EML_RTW] order by remuneration_end desc)')
	---end delete--
	
	declare @start_period datetime = CAST(CAST(@start_period_year as varchar) + '/' 
										+ CAST(@start_period_month as varchar) + '/01' as datetime)
	declare @end_period datetime = DATEADD(MM, 0, getdate())
	
	declare @loop_time int = datediff(month, @start_period, @end_period)
	declare @i int = @loop_time
	declare @yy int
	declare @mm int
	declare @temp datetime
	
	-- Check temp table existing then drop
	IF OBJECT_ID('tempdb..#claim') IS NOT NULL drop table #claim
	IF OBJECT_ID('tempdb..#rtw_raworig_temp') IS NOT NULL DROP TABLE #rtw_raworig_temp
	IF OBJECT_ID('tempdb..#rtw_raworig') IS NOT NULL DROP TABLE #rtw_raworig
	IF OBJECT_ID('tempdb..#rtw_raworig_2') IS NOT NULL DROP TABLE #rtw_raworig_2
	IF OBJECT_ID('tempdb..#policy') IS NOT NULL drop table #policy
	-- Check temp table existing then drop
	
	/* create #claim table to store claim detail info */
	CREATE TABLE #claim
	(
		claim CHAR(19)
		,policyno CHAR(19)
		,renewal_no INT
		,hrswrkwk numeric(5,2)
		,injdate datetime
		,_13WEEKS_ DATETIME
		,_26WEEKS_ DATETIME
		,_52WEEKS_ DATETIME
		,_78WEEKS_ DATETIME
		,_104WEEKS_ DATETIME
		,DAYS13 int
		,DAYS26 int
		,DAYS52 int
		,DAYS78 int
		,DAYS104 int
		,DAYS13_PRD int
		,DAYS26_PRD int
		,DAYS52_PRD int
		,DAYS78_PRD int
		,DAYS104_PRD int
	)	

	/* create index for #claim table */
	SET @SQL = 'CREATE INDEX pk_claim_' + CONVERT(VARCHAR, @@SPID) + ' ON #claim(claim, policyno, injdate)'
	EXEC(@SQL)

	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	/* create #rtw_raworig temp table to store transaction data */
	CREATE TABLE #rtw_raworig_temp
	(
		 claim varchar(19)
		 ,paydate datetime
		 ,paytype varchar(15)
		 ,rtw_paytype varchar(9)
		 ,adjflag varchar(1)
		 ,payamt money
		 ,payment_no int
		 ,ppstart datetime
		 ,ppend datetime
		 ,hrs_per_week numeric(5,2)
		 ,hrs_total numeric(14,3)
		 ,DET_weekly money
	)

	/* create index for #rtw_raworig_temp table */
	SET @SQL = 'CREATE INDEX pk_rtw_raworig_temp_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig_temp(claim, payment_no)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	/* create #rtw_raworig table to store transaction data after summarizing step #1 */
	CREATE TABLE #rtw_raworig
	(
		 claim varchar(19)
		 ,paydate datetime
		 ,paytype varchar(15)
		 ,rtw_paytype varchar(9)
		 ,payamt money
		 ,ppstart datetime
		 ,ppend datetime
		 ,hrs_per_week numeric(5,2)
		 ,hrs_total numeric(14,3)
		 ,DET_weekly money
	)	
	
	/* create index for #rtw_raworig table */
	SET @SQL = 'CREATE INDEX pk_rtw_raworig_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig(claim, rtw_paytype, paydate)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	/* create #rtw_raworig_2 table to store transaction data after summarizing for step #2 */
	CREATE TABLE #rtw_raworig_2
	(
		 claim varchar(19)
		 ,paydate datetime
		 ,rtw_paytype varchar(9)
		 ,payamt money
		 ,ppstart datetime
		 ,ppend datetime
		 ,hrs_per_week numeric(5,2)
		 ,hrs_total numeric(14,3)
		 ,DET_weekly money
	)	
	
	/* create index for #rtw_raworig_2 table */
	SET @SQL = 'CREATE INDEX pk_rtw_raworig_2_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig_2(claim, rtw_paytype, paydate)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	/* create #policy table to store policy info for claim */
	CREATE TABLE #policy
	(
		policyno CHAR(19)
		,renewal_no INT
		,bastarif MONEY
		,wages MONEY
		,const_flag_final int
	)
	
	/* create index for #policy table */
	SET @SQL = 'CREATE INDEX pk_policy_'+CONVERT(VARCHAR, @@SPID)+' ON #policy(policyno, renewal_no)'
	EXEC(@SQL)

	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	WHILE (@i) >= 0
	BEGIN	
		set @temp = dateadd(mm, @i, @start_period)
		set @yy = year(@temp)
		set @mm = month(@temp)
		
		/* delete all data in the temp tables */
		delete from #claim
		delete from #rtw_raworig_temp
		delete from #rtw_raworig
		delete from #rtw_raworig_2
		delete from #policy
		IF OBJECT_ID('tempdb..#summary') IS NOT NULL DROP TABLE #summary
		
		set @remuneration_end = cast(CAST(@yy as varchar) + '/' +  CAST(@mm as varchar) + '/01' as datetime)
		set @remuneration_start = DATEADD(mm,-12, @remuneration_end) -- get max rolling month = 12
		--set @AsAt = DATEADD(dd, -1, DATEADD(mm, 1, @remuneration_end)) + '23:59'
		
		set @remuneration_end = DATEADD(dd, -1, @remuneration_end) + '23:59'		
		set @transaction_lag_remuneration_end = DATEADD(mm, @transaction_lag, @remuneration_end)
		
		-- use transaction flag = 3
		set @AsAt = @transaction_lag_remuneration_end
		
		set @paystartdt = DATEADD(mm, -@transaction_lag, DATEADD(YY, -2, @remuneration_Start))
		
		If NOT EXISTS(select 1 from [DART].[dbo].[EML_RTW] 
							where Year(remuneration_end ) = Year(@remuneration_end) and
							Month(remuneration_end ) = Month(@remuneration_end))
			AND cast(CAST(year(@remuneration_end) as varchar) + '/' +  CAST(month(@remuneration_end) as varchar) + '/01' as datetime)
				< cast(CAST(year(getdate()) as varchar) + '/' +  CAST(month(getdate()) as varchar) + '/01' as datetime)
		BEGIN	
		
			print cast(YEAR(@remuneration_end) as varchar) + ' and ' + cast(MONTH(@remuneration_end) as varchar)
			print 'Start to delete data in EML_RTW table first...'
			--delete from dbo.EML_RTW
			--	   where Year(Remuneration_End) = Year(@remuneration_end)
			--			 and Month(Remuneration_End) = Month(@remuneration_end)
			
			/* retrieve claim detail info */
			INSERT INTO #claim
				SELECT	cd.Claim_Number
						, cda.Policy_No
						, Renewal_No
						, cd.Work_Hours
						, cd.Date_of_Injury
						
						-- calculate 13 weeks from date of injury
						, _13WEEKS_ = dateadd(mm, @measure_month_13, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
						
						-- calculate 26 weeks from date of injury
						, _26WEEKS_ = dateadd(mm, @measure_month_26, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
						
						-- calculate 52 weeks from date of injury
						, _52WEEKS_ = dateadd(mm, @measure_month_52, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
						
						-- calculate 78 weeks from date of injury
						, _78WEEKS_ = dateadd(mm, @measure_month_78, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
						
						-- calculate 104 weeks from date of injury
						, _104WEEKS_ = dateadd(mm, @measure_month_104, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
						
						, DAYS13 = 0
						, DAYS26 = 0
						, DAYS52 = 0
						, DAYS78 = 0
						, DAYS104 = 0
						
						,DAYS13_PRD = 0
						,DAYS26_PRD = 0
						,DAYS52_PRD = 0
						,DAYS78_PRD = 0
						,DAYS104_PRD = 0
				FROM dbo.CLAIM_DETAIL cd INNER JOIN cd_audit cda on cda.claim_no = cd.claim_number
					AND isnull(cd.Claim_Number,'') <> ''
					AND cd.Date_of_Injury >= @paystartdt
					AND cda.id = (select max(id) 
									from cd_audit cda1 
									where cda1.claim_no = cd.claim_number 
										and cda1.create_date < @remuneration_end)
				/* exclude Serious Claims */
				WHERE cd.claim_number not in (select Claim_no from EML_SIW)
			
			/* retrieve transactions data */
			INSERT INTO #rtw_raworig_temp
			SELECT  pr.Claim_No
					, CONVERT(varchar(10), pr.Transaction_date, 120)
					,pr.WC_Payment_Type
					,rtw_paytype=  (CASE WHEN wc_payment_type IN ('14', '15', 'WPT001', 'WPT002', 'WPT003', 'WPT004') 
											THEN 'TI'
										 WHEN wc_payment_type IN ('13', 'WPP001', 'WPP003') 
											THEN 'S38'
										 WHEN wc_payment_type IN ('16', 'WPP002', 'WPP004') 
											THEN 'S40'
										 WHEN wc_payment_type IN ('WPT005', 'WPT006', 'WPT007') 
											THEN 'NOWORKCAP'
										 WHEN wc_payment_type IN ('WPP005', 'WPP006', 'WPP007', 'WPP008') 
											THEN 'WORKCAP' 
									END)
					,Adjust_Trans_Flag
					,Trans_Amount
					,pr.Payment_no
					,Period_Start_Date
					,Period_End_Date
					,pr.hours_per_week
					,hrs_total = (isnull(WC_MINUTES, 0) / 60.0)
									 + isnull(WC_HOURS, 0)
									 + isnull(WC_WEEKS * HOURS_PER_WEEK, 0)
					,isnull(Rate, 0)
			FROM dbo.Payment_Recovery pr
					INNER JOIN dbo.CLAIM_PAYMENT_RUN
							   ON pr.Payment_no = dbo.CLAIM_PAYMENT_RUN.Payment_no
					INNER JOIN #claim cl on pr.Claim_No = cl.claim
			WHERE	Transaction_date >= @paystartdt
					AND Transaction_date <= @AsAt
					AND wc_Tape_Month IS NOT NULL 
					AND LEFT(wc_Tape_Month, 4) <= @yy
					AND wc_Tape_Month <= CONVERT(int, 
											CONVERT(varchar(8), @transaction_lag_remuneration_end,112))
					AND wc_payment_type IN ('WPT001', 'WPT003', 'WPT002'
											 ,'WPT004', 'WPP001', 'WPP003'
											 ,'WPP002', 'WPP004','WPT005'
											 ,'WPT006', 'WPT007', 'WPP005'
											 ,'WPP006', 'WPP007', 'WPP008'
											 ,'13', '14', '15', '16')
											 
			/* Adjust DET weekly field */
			SELECT distinct claim, ppstart, ppend, paytype, DET_weekly = max(DET_weekly) 
				INTO #summary
				FROM #rtw_raworig_temp
			GROUP BY claim,
					ppstart, 
					ppend, 
					paytype		

			UPDATE #rtw_raworig_temp 
				SET DET_weekly = su.DET_weekly
				FROM #summary su
				WHERE	#rtw_raworig_temp.claim = su.claim
						AND #rtw_raworig_temp.ppstart = su.ppstart
						AND #rtw_raworig_temp.ppend = su.ppend
						AND #rtw_raworig_temp.paytype = su.paytype		
			/* end of adjusting DET weekly field */
			
			/* summarised transactions by claim, paydate, paytype, ppstart, ppend */
			INSERT INTO #rtw_raworig
			SELECT  claim
					,paydate
					,paytype
					,rtw_paytype
					,payamt = (SELECT SUM(payamt)
									FROM #rtw_raworig_temp rtw1 
									WHERE	rtw1.claim = rtw.claim 
											and rtw1.paydate = rtw.paydate
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart 
											and rtw1.ppend = rtw.ppend)							
					,ppstart
					,ppend
					,hrs_per_week
					,hrs_total = (SELECT SUM(hrs_total)
									FROM #rtw_raworig_temp rtw1
									WHERE rtw1.claim = rtw.claim 
											and rtw1.paydate = rtw.paydate
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart
											and rtw1.ppend = rtw.ppend)
					,DET_weekly = (SELECT MAX(DET_weekly) 
									FROM #rtw_raworig_temp rtw1
									WHERE	rtw1.claim = rtw.claim 
											and rtw1.paydate = rtw.paydate
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart
											and rtw1.ppend = rtw.ppend)
			FROM #rtw_raworig_temp rtw
			GROUP BY claim,
					paydate,
					paytype,
					rtw_paytype,
					ppstart,
					ppend,
					hrs_per_week
					
			/*	
			Records with payment amount and hours paid for total incapacity are both zero are removed.
			*/
			DELETE FROM #rtw_raworig WHERE hrs_total = 0 and payamt = 0
			
			/*	
				Records with a negative payment amount, but positive hours paid for total incapacity
					have their hours paid changed to be negative.
			*/
			UPDATE #rtw_raworig SET hrs_total = -hrs_total 
				WHERE hrs_total > 0 AND payamt < 0
				
			/* summarised trasactions by claim, paytype, ppstart, ppend */
			INSERT INTO #rtw_raworig_2
			SELECT  claim
					,paydate = (SELECT MIN(paydate) 
									FROM #rtw_raworig rtw1
									WHERE	rtw1.claim = rtw.claim										
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart
											and rtw1.ppend = rtw.ppend)
					,rtw_paytype
					,payamt = (SELECT SUM(payamt)
									FROM #rtw_raworig rtw1 
									WHERE	rtw1.claim = rtw.claim 
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart 
											and rtw1.ppend = rtw.ppend)							
					,ppstart
					,ppend
					,hrs_per_week
					,hrs_total = (SELECT SUM(hrs_total)
									FROM #rtw_raworig rtw1
									WHERE rtw1.claim = rtw.claim 
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart
											and rtw1.ppend = rtw.ppend)
					,DET_weekly = (SELECT MAX(DET_weekly) 
									FROM #rtw_raworig rtw1
									WHERE	rtw1.claim = rtw.claim 
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart
											and rtw1.ppend = rtw.ppend)
			FROM #rtw_raworig rtw
			GROUP BY claim,
					paytype,
					rtw_paytype,
					ppstart,
					ppend,
					hrs_per_week
					
			/*	
			- Records with payment amount equal to zero are removed;
			- Records associated with payments of pre-reform benefits (s36, s37, s38, s40) with hours
			paid for partial incapacity and hours paid for total incapacity both equal to zero are
			removed;
			*/
			DELETE FROM #rtw_raworig_2 WHERE payamt = 0 or (hrs_total = 0 
				and rtw_paytype in ('TI', 'S38', 'S40'))
				
			/* retrieve claim policy info */
			INSERT INTO #policy
				SELECT	POLICY_NO
						, RENEWAL_NO
						, BTP					
						, WAGES0
						, Process_Flags					
					FROM dbo.PREMIUM_DETAIL pd
					WHERE EXISTS (SELECT 1 FROM #claim cd where cd.policyno = pd.POLICY_NO)
					ORDER BY POLICY_NO,RENEWAL_NO
			
			print 'Start to insert data to EML_RTW table...'
			--INSERT INTO dbo.EML_RTW EXEC [dbo].[usp_Dashboard_EML_RTW] @yy, @mm, 12, @AsAt
			--INSERT INTO dbo.EML_RTW EXEC [dbo].[usp_Dashboard_EML_RTW] @yy, @mm, 6, @AsAt
			--INSERT INTO dbo.EML_RTW EXEC [dbo].[usp_Dashboard_EML_RTW] @yy, @mm, 3, @AsAt
			--INSERT INTO dbo.EML_RTW EXEC [dbo].[usp_Dashboard_EML_RTW] @yy, @mm, 1, @AsAt
			
			INSERT INTO [Dart].[dbo].[EML_RTW]  EXEC [dbo].[usp_Dashboard_EML_RTW] @yy, @mm, 12, @AsAt
			INSERT INTO [Dart].[dbo].[EML_RTW]  EXEC [dbo].[usp_Dashboard_EML_RTW] @yy, @mm, 6, @AsAt
			INSERT INTO [Dart].[dbo].[EML_RTW]  EXEC [dbo].[usp_Dashboard_EML_RTW] @yy, @mm, 3, @AsAt
			INSERT INTO [Dart].[dbo].[EML_RTW]  EXEC [dbo].[usp_Dashboard_EML_RTW] @yy, @mm, 1, @AsAt
			
		END
		set @i = @i - 1
	END	
	
	-- drop all temp tables
	IF OBJECT_ID('tempdb..#claim') IS NOT NULL drop table #claim
	IF OBJECT_ID('tempdb..#rtw_raworig_temp') IS NOT NULL DROP TABLE #rtw_raworig_temp
	IF OBJECT_ID('tempdb..#summary') IS NOT NULL DROP TABLE #summary
	IF OBJECT_ID('tempdb..#rtw_raworig') IS NOT NULL DROP TABLE #rtw_raworig
	IF OBJECT_ID('tempdb..#rtw_raworig_2') IS NOT NULL DROP TABLE #rtw_raworig_2
	IF OBJECT_ID('tempdb..#policy') IS NOT NULL drop table #policy
	
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_RTW_GenerateData] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_RTW_GenerateData] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_RTW_GenerateData] TO [DART_Role]
GO


--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_EML_RTW_GenerateData.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_GenerateData_Master.sql  
--------------------------------  
/****** Object:  StoredProcedure [dbo].[usp_Dashboard_GenerateData_Master]    Script Date: 23/04/2014 14:31:45 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_GenerateData_Master]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_GenerateData_Master]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_GenerateData_Master]
	@System varchar(20)
AS
BEGIN
	-- Setup period in generating data for RTW and AWC
	DECLARE @start_period_year int = 2010
	DECLARE @start_period_month int = 9
	
	-- Setup cut-off date in generating data for Portfolio
	DECLARE @AsAt datetime = null
	
	-- First date of current month
	-- Just run RTW from day 10th of month
	DECLARE @firstDateOfMonth datetime = DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)
	
	IF EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_Payment_Recovery_RTW') 
		DROP INDEX idx_Payment_Recovery_RTW ON Payment_Recovery ; 
	
	CREATE NONCLUSTERED INDEX [idx_Payment_Recovery_RTW] ON [dbo].[Payment_Recovery]([Transaction_date],[wc_Tape_Month],[Payment_Type]) 
	INCLUDE ([Claim_No],[Payment_no],[Trans_Amount],[hours_per_week],[Period_Start_Date],[Period_End_Date],[wc_Hours],[wc_Minutes],[wc_Weeks])	
	
	IF UPPER(@System) = 'TMF'
		BEGIN
			-- Just run RTW from day 10th of month
			IF DATEDIFF(DD,@firstDateOfMonth,GETDATE()) >= 9
			BEGIN
				EXEC usp_Dashboard_TMF_RTW_GenerateData @start_period_year , @start_period_month
				EXEC [Dart].[dbo].[usp_Dashboard_TMF_RTW_AddTargetAndBase_GenerateData]
			END
			
			EXEC usp_Dashboard_TMF_AWC_GenerateData @start_period_year , @start_period_month
			EXEC usp_Dashboard_Portfolio_GenerateData 'TMF',@AsAt
		END
	ELSE IF UPPER(@System) = 'EML' 
		BEGIN
			-- Just run RTW from day 10th of month
			IF DATEDIFF(DD,@firstDateOfMonth,GETDATE()) >= 9
			BEGIN
				EXEC usp_Dashboard_EML_RTW_GenerateData @start_period_year , @start_period_month
				EXEC [Dart].[dbo].[usp_Dashboard_EML_RTW_AddTargetAndBase_GenerateData]
			END
			
			EXEC usp_Dashboard_EML_AWC_GenerateData @start_period_year , @start_period_month
			EXEC usp_Dashboard_Portfolio_GenerateData 'EML',@AsAt
		END
	ELSE
		BEGIN
			-- Just run RTW from day 10th of month
			IF DATEDIFF(DD,@firstDateOfMonth,GETDATE()) >= 9
			BEGIN
				EXEC usp_Dashboard_HEM_RTW_GenerateData @start_period_year , @start_period_month
				EXEC [Dart].[dbo].[usp_Dashboard_HEM_RTW_AddTargetAndBase_GenerateData]
			END
			
			EXEC usp_Dashboard_HEM_AWC_GenerateData @start_period_year , @start_period_month
			EXEC usp_Dashboard_Portfolio_GenerateData 'HEM',@AsAt
		END	
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_GenerateData_Master] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_GenerateData_Master] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_GenerateData_Master] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_GenerateData_Master.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_HEM_AWC.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
-- execute [usp_Dashboard_HEM_AWC] 2013, 1
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_HEM_AWC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_HEM_AWC]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_HEM_AWC]
      @year int = 2011,
      @month int = 1
AS
BEGIN
	SET NOCOUNT ON
	IF OBJECT_ID('tempdb..#_Claim_list_adjusted') IS NOT NULL DROP TABLE #_Claim_list_adjusted
	IF OBJECT_ID('tempdb..#_Claim_Detail') IS NOT NULL DROP TABLE #_Claim_Detail
	IF OBJECT_ID('tempdb..#_Claim_List') IS NOT NULL DROP TABLE #_Claim_List		
	IF OBJECT_ID('tempdb..#AWC_list') IS NOT NULL DROP table #AWC_list
	IF OBJECT_ID('tempdb..#policy') IS NOT NULL DROP table #policy
	IF OBJECT_ID('tempdb..#activity_detail_audit') IS NOT NULL DROP table #activity_detail_audit
	
	declare @startdate datetime = cast(cast(@year as char(4)) + '/'  + cast(@month as char(2)) + '/01' as datetime)
	declare @enddate datetime  = dateadd(dd, -1, dateadd(mm, 1, @startdate)) + '23:59'
	
	declare @SQL varchar(500)

	--Check temp table existing then drop	
	IF OBJECT_ID('tempdb..#_CLAIM_ESTIMATE_SUMMARY') IS NULL
	BEGIN
		create table #_CLAIM_ESTIMATE_SUMMARY
		(
			CLAIM_NO varCHAR(19)
			,TotalAmount MONEY
		) 
		
		SET @SQL = 'CREATE INDEX pk_CLAIM_ESTIMATE_SUMMARY'+CONVERT(VARCHAR, @@SPID)+' ON #_CLAIM_ESTIMATE_SUMMARY(CLAIM_NO, TotalAmount)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
			 
		INSERT INTO #_CLAIM_ESTIMATE_SUMMARY
			SELECT CLAIM_NO, SUM(ISNULL(Amount, 0))
			FROM ESTIMATE_DETAILS
			GROUP BY claim_no
	END
	
	CREATE TABLE #_Claim_Detail
	(
		policy_no char(19)
		,Claim_no varchar(19)
		,Claim_Closed_Flag CHAR(1)
		,Claim_Liability_Indicator TINYINT
		,renewal_no INT
		,anzsic varchar(255)
	)
	
	SET @SQL = 'CREATE INDEX pk_Claim_Detail_'+CONVERT(VARCHAR, @@SPID)+' ON #_Claim_Detail(policy_no, Claim_no, Claim_Closed_Flag, Claim_Liability_Indicator)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	INSERT INTO #_Claim_Detail
		-- claim detail here
		SELECT  policy_no, 
				Claim_Number,
				Claim_Closed_Flag,
				Claim_Liability_Indicator, 
				Renewal_No,
				anz.DESCRIPTION
		FROM CLAIM_DETAIL cd INNER JOIN CLAIM_ACTIVITY_DETAIL cad 
			ON rtrim(cd.Claim_Number) =  rtrim(cad.Claim_no)
				AND Date_Created <= @enddate AND Claim_Number <> ''
			LEFT OUTER JOIN amendment_exemptions ae ON cd.Claim_Number = ae.claim_no
			LEFT JOIN ANZSIC anz on cd.ANZSIC = anz.CODE
		WHERE ISNULL(anz.ID, 1) = ISNULL((SELECT MAX(ID) FROM ANZSIC anz2 
											WHERE anz2.CODE = anz.CODE),1)

	CREATE TABLE #_Claim_List
	(
		Claim_no varchar(19)
		,EXCLUDE BIT
	)
	
	SET @SQL = 'CREATE INDEX pk_Claim_List'+CONVERT(VARCHAR, @@SPID)+' ON #_Claim_List(Claim_no, EXCLUDE)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	INSERT INTO #_Claim_List
	SELECT cd.Claim_no
		   ,EXCLUDE = (CASE WHEN (cd.Claim_Liability_Indicator IN (1,6,12)) 
								 OR (cd.Claim_Liability_Indicator IN (4) 
									AND ces.TotalAmount <= 0) 
								 OR (cd.Claim_Closed_Flag = 'Y' AND ces.TotalAmount = 0)  
							   THEN 1 
						   ELSE 0 
					   END)
	FROM #_Claim_Detail cd INNER JOIN #_CLAIM_ESTIMATE_SUMMARY ces 
									  ON cd.Claim_no = ces.CLAIM_NO

	CREATE TABLE #_Claim_list_adjusted
	(
		 Claim_no varchar(19)
		 ,submitted_trans_date datetime
		 ,Period_Start_Date datetime
		 ,Period_End_Date datetime
		 ,WC_Payment_Type varchar(8)
		 ,Payment_Type varchar(15)
		 ,Trans_Amount money
	)
	
	SET @SQL = 'CREATE NONCLUSTERED INDEX pk_Claim_List_submitted_trans_date_
				ON [dbo].[#_Claim_list_adjusted] (submitted_trans_date)
				INCLUDE ([Claim_no])'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	INSERT  INTO #_Claim_list_adjusted
	SELECT  u.claim_no
			, submitted_trans_date
			, Period_Start_Date
			, Period_End_Date
			, WC_Payment_Type
			, Payment_Type 
			,Trans_Amount = (SELECT SUM(ISNULL(u1.Trans_Amount, 0))
								FROM uv_submitted_Transaction_Payments u1
								WHERE u1.Claim_No = u.claim_no
								and u1.Period_Start_Date = u.Period_Start_Date
								and u1.Period_End_Date = u.Period_End_Date
								and u1.WC_Payment_Type = u.WC_Payment_Type
								and u1.Payment_Type = u.payment_type)
	FROM uv_submitted_Transaction_Payments u
	WHERE u.submitted_trans_date = (SELECT min(u1.submitted_trans_date) 
									FROM uv_submitted_Transaction_Payments u1 
									WHERE u1.Claim_No = u.claim_no 
										  and u1.Period_Start_Date = u.Period_Start_Date 
										  and u1.Period_End_Date = u.Period_End_Date 
										  and u1.WC_Payment_Type = u.WC_Payment_Type 
										  and u1.Payment_Type = u.payment_type)
		and u.submitted_trans_date between @startdate and @enddate
		and u.WeeklyPayment = 1
	GROUP BY u.claim_no, submitted_trans_date
			 ,Period_Start_Date, Period_End_Date
			 ,WC_Payment_Type, Payment_Type
	ORDER BY claim_no, payment_type, Period_Start_Date, Period_End_Date


	SET @SQL = 'CREATE NONCLUSTERED INDEX pk_Claim_List_submitted_trans_date_Trans_Amount
				ON [dbo].[#_Claim_list_adjusted] (Trans_Amount)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	DELETE FROM #_Claim_list_adjusted WHERE Trans_Amount = 0
	DELETE FROM #_Claim_list_adjusted 
		   WHERE CLAIM_NO in (SELECT cla1.claim_no 
							  FROM #_Claim_list_adjusted cla1 
									inner join #_Claim_List cl on cla1.Claim_no = cl.Claim_no 
												and cl.EXCLUDE = 1)

	CREATE TABLE #AWC_list 
	(
		claim_no varchar (19)
		,date_of_injury datetime
	)
	
	SET @SQL = 'CREATE INDEX pk_AWC_list'+CONVERT(VARCHAR, @@SPID)+' ON #AWC_list(Claim_no,date_of_injury)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	INSERT INTO #AWC_list
		SELECT DISTINCT rtrim(cla.claim_no),ca.Date_of_Injury 
		FROM #_Claim_list_adjusted cla 
			 INNER JOIN cd_audit ca ON cla.Claim_no = ca.claim_no 
									   AND cla.submitted_trans_date between @startdate and @enddate
									   AND ca.id = (SELECT MAX(id) 
													FROM cd_audit 
													WHERE ca.claim_no = claim_no 
													AND create_date < @enddate)
										AND ca.fund <> 98

	/* create #policy table to store policy info for claim */
	CREATE TABLE #policy
	(
		policyno CHAR(19)
		,renewal_no INT
		,bastarif MONEY
		,wages MONEY
		,const_flag_final int
	)
	
	/* create index for #policy table */
	SET @SQL = 'CREATE INDEX pk_policy_'+CONVERT(VARCHAR, @@SPID)+' ON #policy(policyno, renewal_no)'
	EXEC(@SQL)

	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
			
	INSERT INTO #policy
		SELECT	POLICY_NO
				, RENEWAL_NO
				, BTP					
				, WAGES0
				, Process_Flags					
			FROM dbo.PREMIUM_DETAIL pd
			WHERE EXISTS (SELECT 1 FROM #_Claim_Detail cd where cd.policy_no = pd.POLICY_NO)
			ORDER BY POLICY_NO,RENEWAL_NO
			
	/* create #activity_detail_audit table to store policy info for claim */
	CREATE TABLE #activity_detail_audit
	(
		policyno CHAR(19)
		,renewal_no INT
		,tariff INT
		,wages_shifts MONEY
	)
	
	/* create index for #activity_detail_audit table */
	SET @SQL = 'CREATE INDEX pk_activity_detail_audit_'+CONVERT(VARCHAR, @@SPID)
		+' ON #activity_detail_audit(policyno, renewal_no, tariff)'
	EXEC(@SQL)

	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
			
	INSERT INTO #activity_detail_audit
		SELECT Policy_No, Renewal_No, Tariff, SUM(ISNULL(Wages_Shifts, 0))
			FROM ACTIVITY_DETAIL_AUDIT ada
			GROUP BY Policy_No, Renewal_No, Tariff
			HAVING EXISTS (SELECT 1 FROM #_Claim_Detail cd where cd.policy_no = ada.Policy_No)
	
	SELECT	Time_ID = @enddate
			,Claim_no = awc_list.Claim_no
			
			-- retrieve group info like 'HEM*'
			,'Group' = CASE WHEN (rtrim(isnull(co.Grp,''))='') 
							OR NOT EXISTS (select distinct grp 
												from claims_officers 
												where active = 1 and len(rtrim(ltrim(grp))) > 0 
													  and grp like co.Grp+'%')
								OR co.Grp NOT LIKE 'hosp%'	
								THEN 'Miscellaneous'
							WHEN PATINDEX('HEM%', co.Grp) = 0 THEN Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1)
							ELSE SUBSTRING(Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1), 1, 
									CASE WHEN PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 4, LEN(rtrim(co.Grp)) - 3)) > 0 
										THEN (PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 4, LEN(rtrim(co.Grp)) - 3)) + 2) 
										ELSE LEN(rtrim(co.Grp)) 
									END)
							END							
			
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' THEN 'Miscellaneous' ELSE RTRIM(UPPER(co.Grp)) END		
			,Case_manager = ISNULL ( UPPER(co.First_Name+' '+ co.Last_Name), 'Miscellaneous')					
			
			,AgencyName =dbo.udf_GetAgencyNameByPolicyNo(cd.Policy_no)
			,awc_list.Date_of_Injury
			,create_date = getdate()
			,cd.policy_no
			,Agency_id = UPPER(ptda.Agency_id)
			,Sub_category = rtrim(dbo.udf_GetSubCategoryByPolicyNo(cd.Policy_no))
			,Empl_Size = (CASE WHEN pd.bastarif IS NULL OR pd.const_flag_final IS NULL OR pd.wages IS NULL then 'A - Small'
							  WHEN pd.wages <= 300000 then 'A - Small'
							  WHEN pd.wages > 300000 AND pd.wages <= 1000000 AND pd.const_flag_final = 1 then 'A - Small'
							  WHEN pd.wages > 300000 AND pd.wages <= 1000000 AND pd.const_flag_final <> 1 then 'B - Small-Medium'
							  WHEN pd.wages > 1000000 AND pd.wages <= 5000000 then 'C - Medium'
							  WHEN pd.wages > 5000000 AND pd.wages <= 15000000 AND pd.bastarif <= 100000 then 'C - Medium'
							  WHEN pd.wages > 15000000 then 'D - Large'
							  WHEN pd.wages > 5000000 AND pd.bastarif > 100000 then 'D - Large'
							  ELSE 'A - Small'
						  END)
			,Cert_Type = case when mc.TYPE = 'P' 
								then 'No Time Lost' 
						      when mc.TYPE = 'T' 
								then 'Totally Unfit'
							  when mc.TYPE = 'S' 
								then 'Suitable Duties'
							  when mc.TYPE = 'I' 
								then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' 
								then 'Permanently Modified Duties'
							  else 'Invalid type' 
						 end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,cno.CELL_NO as Cell_no
			
			-- retrieve portfolio info
			,Portfolio = case when isnull(cd.anzsic,'')<>''
								then
									case when UPPER(cd.anzsic) = 'ACCOMMODATION' 
											or UPPER(cd.anzsic) = 'PUBS, TAVERNS AND BARS' 
											or UPPER(cd.anzsic) = 'CLUBS (HOSPITALITY)' then cd.anzsic
										else 'Other'
									end
								else
									case when LEFT(ada.tariff, 1) = '1' and LEN(ada.tariff) = 7
											then 
												case when SUBSTRING(CAST(ada.tariff as CHAR(7)), 2, 6) = '571000'
													then 'Accommodation'
												when SUBSTRING(CAST(ada.tariff as CHAR(7)), 2, 6) = '572000'
													then 'Pubs, Taverns and Bars'
												when SUBSTRING(CAST(ada.tariff as CHAR(7)), 2, 6) = '574000'
													then 'Clubs'
												else 'Other'
											end
										else 
											case when ada.tariff = 571000 then 'Accommodation'
												when ada.tariff = 572000 then 'Pubs, Taverns and Bars'
												when ada.tariff = 574000 then 'Clubs'
												else 'Other'
											end
									end
							end
		
	FROM	#AWC_list awc_list
			INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = awc_list.claim_no
			LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
			INNER JOIN #_Claim_Detail cd on awc_list.claim_no = cd.Claim_No		
			INNER JOIN cad_audit cada1 on cada1.Claim_No = awc_list.claim_no 
			INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
			INNER JOIN ptd_audit ptda ON cd.Policy_No = ptda.Policy_No
			LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
          	LEFT JOIN #policy pd on pd.policyno = cd.policy_no and pd.renewal_no = cd.renewal_no 	
          	LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number 
          				FROM CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
							left join Broker Br on PTD.Broker_No = Br.Broker_no 
							left join UnderWriters U on  BR.emi_Contact = U.Alias 
						where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no	
			
			-- for retrieving cell number info
			LEFT JOIN (SELECT CELL_NO, claim_number
						FROM CLAIM_DETAIL cld inner join POLICY_TERM_DETAIL ptd on cld.Policy_No = ptd.POLICY_NO) as cno
						on cno.Claim_Number = cd.Claim_no
						
			-- for retrieving WIC info
			LEFT JOIN #activity_detail_audit ada 
				ON ada.policyno = cd.policy_no AND ada.renewal_no = cd.renewal_no
					
	WHERE   cada1.id = (SELECT MAX(cada2.id) 
					      FROM  cad_audit cada2 
					      WHERE cada2.claim_no = cada1.claim_no
							    AND cada2.transaction_date <= @enddate) 
			AND coa1.id = (SELECT   MAX(coa2.id) 
						     FROM   CO_audit coa2
						     WHERE  coa2.officer_id = coa1.officer_id
								    AND coa2.create_date <= @enddate)
			AND ptda.id = (SELECT MAX(ptda2.id) 
							FROM ptd_audit ptda2
							WHERE ptda2.policy_no = ptda.policy_no 
								  AND ptda2.create_date <= @enddate)
			AND ada.wages_shifts = (SELECT MAX(ada2.wages_shifts) 
									FROM #activity_detail_audit ada2
									WHERE ada2.policyno = ada.policyno
										AND ada2.renewal_no = ada.renewal_no)
				  
	--drop all temp table
	IF OBJECT_ID('tempdb..#_Claim_list_adjusted') IS NOT NULL DROP TABLE #_Claim_list_adjusted
	IF OBJECT_ID('tempdb..#_Claim_Detail') IS NOT NULL DROP TABLE #_Claim_Detail	
	IF OBJECT_ID('tempdb..#_Claim_List') IS NOT NULL DROP TABLE #_Claim_List
	IF OBJECT_ID('tempdb..#AWC_list') IS NOT NULL DROP TABLE #AWC_list
	IF OBJECT_ID('tempdb..#policy') IS NOT NULL DROP table #policy
	IF OBJECT_ID('tempdb..#activity_detail_audit') IS NOT NULL DROP table #activity_detail_audit
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_AWC] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_AWC] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_AWC] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_HEM_AWC.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_HEM_AWC_GenerateData.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_HEM_AWC_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_HEM_AWC_GenerateData]
Go
-- For example
-- exec [usp_Dashboard_HEM_AWC_GenerateData] 2011, 1
-- this will return all result with time id range from 2011-01-31 23:59 till now

CREATE PROCEDURE [dbo].[usp_Dashboard_HEM_AWC_GenerateData]
	@start_period_year int = 2012,
	@start_period_month int = 10
AS
BEGIN	
	SET NOCOUNT ON;
	declare @start_period datetime = CAST(CAST(@start_period_year as varchar) + '/' + CAST(@start_period_month as varchar) + '/01' as datetime)
	declare @end_period datetime = getdate()
	
	declare @loop_time int = DATEDIFF(month, @start_period, @end_period)
	declare @i int = @loop_time 
	declare @temp datetime
	declare @SQL varchar(500)

	---delete last transaction lag number months in dart db---	
	exec('DELETE FROM [DART].[dbo].[HEM_AWC] 
			WHERE Time_ID in (select distinct top 3 Time_ID 
			from [DART].[dbo].[HEM_AWC] order by Time_ID desc)')
	---end delete--	
	
	--Check temp table existing then drop	
	IF OBJECT_ID('tempdb..#_CLAIM_ESTIMATE_SUMMARY') IS NOT NULL DROP TABLE #_CLAIM_ESTIMATE_SUMMARY
		
	create table #_CLAIM_ESTIMATE_SUMMARY
	(
		CLAIM_NO varCHAR(19),
		TotalAmount MONEY
	) 
	
	SET @SQL = 'CREATE INDEX pk_CLAIM_ESTIMATE_SUMMARY'+CONVERT(VARCHAR, @@SPID)+' ON #_CLAIM_ESTIMATE_SUMMARY(CLAIM_NO, TotalAmount)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		 
	INSERT INTO #_CLAIM_ESTIMATE_SUMMARY
		select CLAIM_NO, SUM(ISNULL(Amount, 0))
		from ESTIMATE_DETAILS
		group by claim_no
	WHILE (@i >= 0)
	BEGIN
		set @temp = DATEADD(mm, @i, @start_period)
		declare @year int = YEAR(@temp)
		declare @month int = MONTH(@temp)
		
		If NOT EXISTS(select 1 from [DART].[dbo].[HEM_AWC] 
							where Year(Time_ID) = @year and
							Month(Time_ID ) = @month)
		   AND cast(CAST(@year as varchar) + '/' +  CAST(@month as varchar) + '/01' as datetime)
				< cast(CAST(year(getdate()) as varchar) + '/' +  CAST(month(getdate()) as varchar) + '/01' as datetime)
		BEGIN		
			print @temp
			--delete from dbo.HEM_AWC where Time_ID = DATEADD(dd, -1, DATEADD(mm, 1, @temp)) + '23:59'
			--insert into dbo.HEM_AWC exec usp_Dashboard_HEM_AWC @year, @month
			INSERT INTO [DART].[dbo].[HEM_AWC] exec usp_Dashboard_HEM_AWC @year, @month
		END
		set @i = @i - 1
	END
	
	--drop temp table
	IF OBJECT_ID('tempdb..#_CLAIM_ESTIMATE_SUMMARY') IS NOT NULL drop table #_CLAIM_ESTIMATE_SUMMARY	
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_AWC_GenerateData] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_AWC_GenerateData] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_AWC_GenerateData] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_HEM_AWC_GenerateData.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_HEM_RTW.sql  
--------------------------------  
/****** Object:  StoredProcedure [dbo].[usp_Dashboard_HEM_RTW]    Script Date: 12/26/2013 14:31:45 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
--  exec [usp_Dashboard_HEM_RTW] 2013, 6, 12
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_HEM_RTW]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_HEM_RTW]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_HEM_RTW]
	@yy int,
	@mm int,
	@RollingMonth int, -- 1, 3, 6, 12
	@AsAt datetime
AS
BEGIN
	SET NOCOUNT ON;
	IF OBJECT_ID('tempdb..#measures') IS NOT NULL DROP TABLE #measures
	
	declare @SQL varchar(500)
	
	declare @measure_month_13 int
	declare @measure_month_26 int
	declare @measure_month_52 int
	declare @measure_month_78 int
	declare @measure_month_104 int
	
	declare @remuneration_start datetime
	declare @remuneration_end datetime
	
	declare @transaction_lag_remuneration_start datetime
	declare @transaction_lag_remuneration_end datetime
	
	declare @paystartdt datetime
	
	declare @transaction_lag int	
	
	set @measure_month_13 = 3	-- 13weeks = 3
	set @measure_month_26 = 6	-- 26weeks = 6
	set @measure_month_52 = 12  -- 52weeks = 12
	set @measure_month_78 = 18  -- 78weeks = 18
	set @measure_month_104 = 24 -- 104weeks = 24
	
	set @transaction_lag = 3 -- for HEM
	
	set @remuneration_end = cast(CAST(@yy as varchar) + '/' +  CAST(@mm as varchar) + '/01' as datetime)
	set @remuneration_start = DATEADD(mm,-@RollingMonth, @remuneration_end)
	
	set @remuneration_end = DATEADD(dd, -1, @remuneration_end) + '23:59'
	
	set @transaction_lag_remuneration_start = DATEADD(mm, @transaction_lag, @remuneration_start)
	set @transaction_lag_remuneration_end = DATEADD(mm, @transaction_lag, @remuneration_end)
	
	set @paystartdt = DATEADD(mm, -@transaction_lag, DATEADD(YY, -2, @remuneration_Start))
	
	IF OBJECT_ID('tempdb..#claim') IS NULL
	BEGIN
		/* create #claim table to store claim detail info */
		CREATE TABLE #claim
		(
			claim CHAR(19)
			,policyno CHAR(19)
			,renewal_no INT
			,anzsic varchar(255)
			,hrswrkwk numeric(5,2)
			,injdate datetime
			,_13WEEKS_ DATETIME
			,_26WEEKS_ DATETIME
			,_52WEEKS_ DATETIME
			,_78WEEKS_ DATETIME
			,_104WEEKS_ DATETIME
			,DAYS13 int
			,DAYS26 int
			,DAYS52 int
			,DAYS78 int
			,DAYS104 int
			,DAYS13_PRD int
			,DAYS26_PRD int
			,DAYS52_PRD int
			,DAYS78_PRD int
			,DAYS104_PRD int
		)	

		/* create index for #claim table */
		SET @SQL = 'CREATE INDEX pk_claim_' + CONVERT(VARCHAR, @@SPID) + ' ON #claim(claim, policyno, injdate)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

		INSERT INTO #claim
			SELECT	cd.Claim_Number
					, cda.Policy_No
					, Renewal_No
					, anz.DESCRIPTION
					, cd.Work_Hours
					, cd.Date_of_Injury
					
					-- calculate 13 weeks from date of injury
					, _13WEEKS_ = dateadd(mm, @measure_month_13, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
					
					-- calculate 26 weeks from date of injury
					, _26WEEKS_ = dateadd(mm, @measure_month_26, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
					
					-- calculate 52 weeks from date of injury
					, _52WEEKS_ = dateadd(mm, @measure_month_52, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
					
					-- calculate 78 weeks from date of injury
					, _78WEEKS_ = dateadd(mm, @measure_month_78, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
					
					-- calculate 104 weeks from date of injury
					, _104WEEKS_ = dateadd(mm, @measure_month_104, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
					
					, DAYS13 = 0
					, DAYS26 = 0
					, DAYS52 = 0
					, DAYS78 = 0
					, DAYS104 = 0
					
					,DAYS13_PRD = 0
					,DAYS26_PRD = 0
					,DAYS52_PRD = 0
					,DAYS78_PRD = 0
					,DAYS104_PRD = 0
			FROM dbo.CLAIM_DETAIL cd INNER JOIN cd_audit cda on cda.claim_no = cd.claim_number
				AND isnull(cd.Claim_Number,'') <> ''
				AND cd.Date_of_Injury >= @paystartdt
				AND cda.id = (select max(id) 
								from cd_audit cda1 
								where cda1.claim_no = cd.claim_number 
									and cda1.create_date < @remuneration_end)
				LEFT JOIN ANZSIC anz on cd.ANZSIC = anz.CODE
			/* exclude Serious Claims */
			WHERE cd.claim_number not in (select Claim_no from HEM_SIW)
					AND ISNULL(anz.ID, 1) = ISNULL((SELECT MAX(ID) FROM ANZSIC anz2 
														WHERE anz2.CODE = anz.CODE), 1)
	END
		
	UPDATE #claim
		-- calculate days off work between 13 weeks and date of injury
		SET	DAYS13 = dbo.udf_NoOfDaysWithoutWeekend(injdate, _13WEEKS_) 
				+ (case when datepart(dw,injdate) not IN(1,7) then 1 else 0 end)
		
		-- calculate days off work between 26 weeks and date of injury
		,DAYS26 = dbo.udf_NoOfDaysWithoutWeekend(injdate, _26WEEKS_) 
				+ (case when datepart(dw,injdate) not IN(1,7) then 1 else 0 end)
		
		-- calculate days off work between 52 weeks and date of injury
		,DAYS52 = dbo.udf_NoOfDaysWithoutWeekend(_26WEEKS_, _52WEEKS_) 
				+ (case when datepart(dw,_26WEEKS_) not IN(1,7) then 1 else 0 end)
		
		-- calculate days off work between 78 weeks and date of injury
		,DAYS78 = dbo.udf_NoOfDaysWithoutWeekend(_52WEEKS_, _78WEEKS_) 
				+ (case when datepart(dw,_52WEEKS_) not IN(1,7) then 1 else 0 end)
		
		-- calculate days off work between 104 weeks and date of injury
		,DAYS104 = dbo.udf_NoOfDaysWithoutWeekend(_52WEEKS_, _104WEEKS_) 
				+ (case when datepart(dw,_52WEEKS_) not IN(1,7) then 1 else 0 end)
		
		/* calculate days off work between MAX(date of injury, remuneration start) 
			and MIN(13 weeks, remuneration end) */
		,	DAYS13_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(injdate, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _13WEEKS_), @remuneration_End,'2222/01/01'))
						+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(injdate, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
		,	DAYS26_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(injdate, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _26WEEKS_), @remuneration_End,'2222/01/01'))
						+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(injdate, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
		,	DAYS52_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(_26WEEKS_, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _52WEEKS_), @remuneration_End,'2222/01/01'))
						+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(_26WEEKS_, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
		,	DAYS78_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _78WEEKS_), @remuneration_End,'2222/01/01'))
						+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
		,	DAYS104_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _104WEEKS_), @remuneration_End,'2222/01/01'))
						+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
	
	IF OBJECT_ID('tempdb..#rtw_raworig_temp') IS NULL
	BEGIN
		/* create #rtw_raworig temp table to store transaction data */
		CREATE TABLE #rtw_raworig_temp
		(
			 claim varchar(19)
			 ,paydate datetime
			 ,paytype varchar(15)
			 ,rtw_paytype varchar(9)
			 ,adjflag varchar(1)
			 ,payamt money
			 ,payment_no int
			 ,ppstart datetime
			 ,ppend datetime
			 ,hrs_per_week numeric(5,2)
			 ,hrs_total numeric(14,3)
			 ,DET_weekly money
		)

		/* create index for #rtw_raworig_temp table */
		SET @SQL = 'CREATE INDEX pk_rtw_raworig_temp_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig_temp(claim, payment_no)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		INSERT INTO #rtw_raworig_temp
		SELECT  pr.Claim_No
				, CONVERT(varchar(10), pr.Transaction_date, 120)
				,pr.WC_Payment_Type
				,rtw_paytype=  (CASE WHEN wc_payment_type IN ('14', '15', 'WPT001', 'WPT002', 'WPT003', 'WPT004') 
										THEN 'TI'
									 WHEN wc_payment_type IN ('13', 'WPP001', 'WPP003') 
										THEN 'S38'
									 WHEN wc_payment_type IN ('16', 'WPP002', 'WPP004') 
										THEN 'S40'
									 WHEN wc_payment_type IN ('WPT005', 'WPT006', 'WPT007') 
										THEN 'NOWORKCAP'
									 WHEN wc_payment_type IN ('WPP005', 'WPP006', 'WPP007', 'WPP008') 
										THEN 'WORKCAP' 
								END)
				,Adjust_Trans_Flag
				,Trans_Amount
				,pr.Payment_no
				,Period_Start_Date
				,Period_End_Date
				,pr.hours_per_week
				,hrs_total = (isnull(WC_MINUTES, 0) / 60.0)
								 + isnull(WC_HOURS, 0)
								 + isnull(WC_WEEKS * HOURS_PER_WEEK, 0)
				,isnull(Rate, 0)
		FROM dbo.Payment_Recovery pr
				INNER JOIN dbo.CLAIM_PAYMENT_RUN
						   ON pr.Payment_no = dbo.CLAIM_PAYMENT_RUN.Payment_no
				INNER JOIN #claim cl on pr.Claim_No = cl.claim
		WHERE	Transaction_date >= @paystartdt
				AND Transaction_date <= @AsAt
				AND wc_Tape_Month IS NOT NULL 
				AND LEFT(wc_Tape_Month, 4) <= @yy
				AND wc_Tape_Month <= CONVERT(int, 
										CONVERT(varchar(8), @transaction_lag_remuneration_end,112))
				AND wc_payment_type IN ('WPT001', 'WPT003', 'WPT002'
										 ,'WPT004', 'WPP001', 'WPP003'
										 ,'WPP002', 'WPP004','WPT005'
										 ,'WPT006', 'WPT007', 'WPP005'
										 ,'WPP006', 'WPP007', 'WPP008'
										 ,'13', '14', '15', '16')
										 
		/* Adjust DET weekly field */
	
		SELECT distinct claim, ppstart, ppend, paytype, DET_weekly = max(DET_weekly) 
			INTO #summary
			FROM #rtw_raworig_temp
		GROUP BY claim,
				ppstart, 
				ppend, 
				paytype		

		UPDATE #rtw_raworig_temp 
			SET DET_weekly = su.DET_weekly
			FROM #summary su
			WHERE	#rtw_raworig_temp.claim = su.claim
					AND #rtw_raworig_temp.ppstart = su.ppstart
					AND #rtw_raworig_temp.ppend = su.ppend
					AND #rtw_raworig_temp.paytype = su.paytype
		
		/* end of adjusting DET weekly field */	
	END
	
	IF OBJECT_ID('tempdb..#rtw_raworig') IS NULL
	BEGIN
		/* create #rtw_raworig table to store transaction data after summarizing step #1 */
		CREATE TABLE #rtw_raworig
		(
			 claim varchar(19)
			 ,paydate datetime
			 ,paytype varchar(15)
			 ,rtw_paytype varchar(9)
			 ,payamt money
			 ,ppstart datetime
			 ,ppend datetime
			 ,hrs_per_week numeric(5,2)
			 ,hrs_total numeric(14,3)
			 ,DET_weekly money
		)	
		
		/* create index for #rtw_raworig table */
		SET @SQL = 'CREATE INDEX pk_rtw_raworig_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig(claim, rtw_paytype, paydate)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END		
		
		/* summarised trasactions by claim, paydate, paytype, ppstart, ppend */
		INSERT INTO #rtw_raworig
		SELECT  claim
				,paydate
				,paytype
				,rtw_paytype
				,payamt = (SELECT SUM(payamt)
								FROM #rtw_raworig_temp rtw1 
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paydate = rtw.paydate
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart 
										and rtw1.ppend = rtw.ppend)							
				,ppstart
				,ppend
				,hrs_per_week
				,hrs_total = (SELECT SUM(hrs_total)
								FROM #rtw_raworig_temp rtw1
								WHERE rtw1.claim = rtw.claim 
										and rtw1.paydate = rtw.paydate
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
				,DET_weekly = (SELECT MAX(DET_weekly) 
								FROM #rtw_raworig_temp rtw1
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paydate = rtw.paydate
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
		FROM #rtw_raworig_temp rtw
		GROUP BY claim,
				paydate,
				paytype,
				rtw_paytype,
				ppstart,
				ppend,
				hrs_per_week
				
		/*	
		Records with payment amount and hours paid for total incapacity are both zero are removed.
		*/
		DELETE FROM #rtw_raworig WHERE hrs_total = 0 and payamt = 0
		
		/*	
			Records with a negative payment amount, but positive hours paid for total incapacity
				have their hours paid changed to be negative.
		*/
		UPDATE #rtw_raworig SET hrs_total = -hrs_total 
			WHERE hrs_total > 0 AND payamt < 0			
	END
	
	IF OBJECT_ID('tempdb..#rtw_raworig_2') IS NULL
	BEGIN
		/* create #rtw_raworig_2 table to store transaction data after summarizing for step #2 */
		CREATE TABLE #rtw_raworig_2
		(
			 claim varchar(19)
			 ,paydate datetime
			 ,rtw_paytype varchar(9)
			 ,payamt money
			 ,ppstart datetime
			 ,ppend datetime
			 ,hrs_per_week numeric(5,2)
			 ,hrs_total numeric(14,3)
			 ,DET_weekly money
		)	
		
		/* create index for #rtw_raworig_2 table */
		SET @SQL = 'CREATE INDEX pk_rtw_raworig_2_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig_2(claim, rtw_paytype, paydate)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END		
		
		/* summarised trasactions by claim, paytype, ppstart, ppend */
		INSERT INTO #rtw_raworig_2
		SELECT  claim
				,paydate = (SELECT MIN(paydate) 
								FROM #rtw_raworig rtw1
								WHERE	rtw1.claim = rtw.claim										
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
				,rtw_paytype
				,payamt = (SELECT SUM(payamt)
								FROM #rtw_raworig rtw1 
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart 
										and rtw1.ppend = rtw.ppend)							
				,ppstart
				,ppend
				,hrs_per_week
				,hrs_total = (SELECT SUM(hrs_total)
								FROM #rtw_raworig rtw1
								WHERE rtw1.claim = rtw.claim 
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
				,DET_weekly = (SELECT MAX(DET_weekly) 
								FROM #rtw_raworig rtw1
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
		FROM #rtw_raworig rtw
		GROUP BY claim,
				paytype,
				rtw_paytype,
				ppstart,
				ppend,
				hrs_per_week
				
		/*	
		- Records with payment amount equal to zero are removed;
		- Records associated with payments of pre-reform benefits (s36, s37, s38, s40) with hours
		paid for partial incapacity and hours paid for total incapacity both equal to zero are
		removed;
		*/
		DELETE FROM #rtw_raworig_2 WHERE payamt = 0 or (hrs_total = 0 
			and rtw_paytype in ('TI', 'S38', 'S40'))
	END
	
	IF OBJECT_ID('tempdb..#policy') IS NULL
	BEGIN
		/* create #policy table to store policy info for claim */
		CREATE TABLE #policy
		(
			policyno CHAR(19)
			,renewal_no INT
			,bastarif MONEY
			,wages MONEY
			,const_flag_final int
		)
		
		/* create index for #policy table */
		SET @SQL = 'CREATE INDEX pk_policy_'+CONVERT(VARCHAR, @@SPID)+' ON #policy(policyno, renewal_no)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

		INSERT INTO #policy
			SELECT	POLICY_NO
					, RENEWAL_NO
					, BTP					
					, WAGES0
					, Process_Flags					
				FROM dbo.PREMIUM_DETAIL pd
				WHERE EXISTS (SELECT 1 FROM #claim cd where cd.policyno = pd.POLICY_NO)
				ORDER BY POLICY_NO,RENEWAL_NO
	END
	
	IF OBJECT_ID('tempdb..#activity_detail_audit') IS NULL
	BEGIN
		/* create #activity_detail_audit table to store policy info for claim */
		CREATE TABLE #activity_detail_audit
		(
			policyno CHAR(19)
			,renewal_no INT
			,tariff INT
			,wages_shifts MONEY
		)
		
		/* create index for #activity_detail_audit table */
		SET @SQL = 'CREATE INDEX pk_activity_detail_audit_'+CONVERT(VARCHAR, @@SPID)
			+' ON #activity_detail_audit(policyno, renewal_no, tariff)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
				
		INSERT INTO #activity_detail_audit
			SELECT Policy_No, Renewal_No, Tariff, SUM(ISNULL(Wages_Shifts, 0))
				FROM ACTIVITY_DETAIL_AUDIT ada
				GROUP BY Policy_No, Renewal_No, Tariff
				HAVING EXISTS (SELECT 1 FROM #claim cd where cd.policyno = ada.Policy_No)
	END
	
	/* create #measures table that contains all of necessary columns 
		for calculating RTW measures */
	CREATE TABLE #measures
	(
		claim CHAR(19)
		,policyno CHAR(19)
		,portfolio varchar(256)
		,injdate datetime
		,paytype varchar(9)
		,ppstart datetime
		,ppend datetime
		,payamt money
		,hrs_per_week_adjusted numeric(5,2)
		,weeks_paid_adjusted float
		,hrs_total numeric(14,3)
		,DET_weekly money
		,days_for_TI int
		,LT_TI float
		,LT_S38 float
		,LT_S40 float
		,LT_NWC float
		,LT_WC float
		,empl_size varchar(256)
		,CAP_CUR_13 float	
		,CAP_PRE_13 float	
		,DAYS13_TRANS float
		,DAYS13_TRANS_PRIOR float
		,LT13_TRANS FLOAT
		,LT13_TRANS_PRIOR FLOAT
		,LT13 FLOAT
		,CAP_CUR_26 float	
		,CAP_PRE_26 float	
		,DAYS26_TRANS float
		,DAYS26_TRANS_PRIOR float
		,LT26_TRANS FLOAT
		,LT26_TRANS_PRIOR FLOAT
		,LT26 FLOAT
		,CAP_CUR_52 float
		,CAP_PRE_52 float
		,DAYS52_TRANS float	
		,DAYS52_TRANS_PRIOR float	
		,LT52_TRANS FLOAT	
		,LT52_TRANS_PRIOR FLOAT	
		,LT52 FLOAT
		,CAP_CUR_78 float
		,CAP_PRE_78 float
		,DAYS78_TRANS float	
		,DAYS78_TRANS_PRIOR float	
		,LT78_TRANS FLOAT	
		,LT78_TRANS_PRIOR FLOAT	
		,LT78 FLOAT
		,CAP_CUR_104 float
		,CAP_PRE_104 float
		,DAYS104_TRANS float	
		,DAYS104_TRANS_PRIOR float	
		,LT104_TRANS FLOAT	
		,LT104_TRANS_PRIOR FLOAT	
		,LT104 FLOAT
		,include_13 bit
		,include_26 bit
		,include_52 bit
		,include_78 bit
		,include_104 bit
		,include_13_trans bit
		,include_26_trans bit
		,include_52_trans bit
		,include_78_trans bit
		,include_104_trans bit
		,Total_LT FLOAT
		,_13WEEKS_ DATETIME
		,_26WEEKS_ DATETIME
		,_52WEEKS_ DATETIME
		,_78WEEKS_ DATETIME
		,_104WEEKS_ DATETIME
		,DAYS13_PRD_CALC int
		,DAYS26_PRD_CALC int
		,DAYS52_PRD_CALC int
		,DAYS78_PRD_CALC int
		,DAYS104_PRD_CALC int
		,DAYS13_CALC int
		,DAYS26_CALC int
		,DAYS52_CALC int
		,DAYS78_CALC int
		,DAYS104_CALC int
	)
	 
	/* create index for #measures table */
	SET @SQL = 'CREATE INDEX pk_measures_' + CONVERT(VARCHAR, @@SPID) + ' ON #measures(claim,policyno,injdate)'
	EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	INSERT INTO #measures
	SELECT DISTINCT 
			pr.Claim
			,cd.policyno
			,portfolio = case when isnull(cd.anzsic,'')<>''
								then
									case when UPPER(cd.anzsic) = 'ACCOMMODATION' 
											or UPPER(cd.anzsic) = 'PUBS, TAVERNS AND BARS' 
											or UPPER(cd.anzsic) = 'CLUBS (HOSPITALITY)' then cd.anzsic
										else 'Other'
									end
								else
									case when LEFT(ada.tariff, 1) = '1' and LEN(ada.tariff) = 7
											then 
												case when SUBSTRING(CAST(ada.tariff as CHAR(7)), 2, 6) = '571000'
													then 'Accommodation'
												when SUBSTRING(CAST(ada.tariff as CHAR(7)), 2, 6) = '572000'
													then 'Pubs, Taverns and Bars'
												when SUBSTRING(CAST(ada.tariff as CHAR(7)), 2, 6) = '574000'
													then 'Clubs'
												else 'Other'
											end
										else 
											case when ada.tariff = 571000 then 'Accommodation'
												when ada.tariff = 572000 then 'Pubs, Taverns and Bars'
												when ada.tariff = 574000 then 'Clubs'
												else 'Other'
											end
									end
							end
			,injdate
			,pr.rtw_paytype
			,pr.ppstart
			,pr.ppend
			,pr.payamt
			
			-- adjust hours worked per week to be a minimum of 1 and a maximum of 40;
			,hrs_per_week_adjusted = dbo.udf_MinValue(40
													  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0
																then cd.hrswrkwk 
															 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															 else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													  )
			,weeks_paid_adjusted = 1.0 
									* pr.hrs_total 
									/ nullif(dbo.udf_MinValue(40 
														 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
																when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1 
																else isnull(cd.hrswrkwk,pr.hrs_per_week) 
															end)
														),0)
			,pr.hrs_total
			,pr.DET_weekly
			
			-- calculate total incapacity days off work
			,days_for_TI = (case when rtw_paytype = 'TI'
										and datepart(dw,pr.ppstart) IN (1,7)
										and datepart(dw,pr.ppend) IN(1,7) 
										and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
									then DATEDIFF(day,pr.ppstart,pr.ppend) + 1					
								when pr.ppstart = pr.ppend 
									then 1 
								else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
							end)
							
			-- calculate days off work for pre-reform claims - Total incapacity payment
			,LT_TI = (CASE when	rtw_paytype = 'TI'
								and dbo.udf_MinValue(40 
												   ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
															 then cd.hrswrkwk 
														  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1
															 then 1 
														  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
													 end
													 )
													) >= 35 
								then 1.0 
									 * (pr.hrs_total* 5)
									 / nullif(dbo.udf_MinValue(40
													   ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													   ),0) 
									* dbo.udf_CheckPositiveOrNegative(pr.payamt)
						 when rtw_paytype = 'TI' 
							  and dbo.udf_MinValue(40 
												  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
															then cd.hrswrkwk
														when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
															then 1  
														else isnull(cd.hrswrkwk,pr.hrs_per_week) 
													end)
												 ) < 35 
							then 1.0 
								 * (pr.hrs_total * 5 / 37.5)
								 * dbo.udf_CheckPositiveOrNegative(pr.payamt)
						else 0 
					END)
					
			-- calculate days off work for pre-reform claims - Section 38 payment
			,LT_S38 = (CASE when rtw_paytype = 'S38'
								 and (case when pr.ppstart = pr.ppend 
												then 1 
										   else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									 end) = 0 
								then 0
							when rtw_paytype = 'S38' 
								 and dbo.udf_MinValue(40
													 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													 ) >= 35 
								then 1.0
									 *(case when  rtw_paytype = 'TI' 
													and datepart(dw,pr.ppstart) IN(1,7) 
													and datepart(dw,pr.ppend) IN(1,7) 
													and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
												 then DATEDIFF(day,pr.ppstart,pr.ppend) + 1					
											  when pr.ppstart = pr.ppend 
												then 1 
											  else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
										 end) 
									 * dbo.udf_CheckPositiveOrNegative(pr.payamt) 
							when rtw_paytype = 'S38' 
								 and dbo.udf_MinValue(40
													  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															 else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													  ) < 35  
								and dbo.udf_MinValue(40
													 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1 
															else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													) > 0 
								then 1.0
									 *(case	when rtw_paytype = 'TI' 
												 and datepart(dw,pr.ppstart) IN(1,7) 
												 and datepart(dw,pr.ppend) IN(1,7) 
												 and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
											  then DATEDIFF(day,pr.ppstart,pr.ppend) + 1
											when pr.ppstart = pr.ppend 
											  then 1 
											else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									  end)
									  * dbo.udf_CheckPositiveOrNegative(pr.payamt) 
									  * dbo.udf_MinValue(40
														 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
																when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1
																else isnull(cd.hrswrkwk,pr.hrs_per_week)
															end)
														 )
									  / 37.5
										
							else 0 
					END)
					
			-- calculate days off work for pre-reform claims - Section 40 payment
			,LT_S40 = (CASE when rtw_paytype = 'S40'
								and (case when pr.ppstart = pr.ppend 
												then 1 
										  else
												dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									end) = 0 
								then 0
							when rtw_paytype = 'S40'
								 and dbo.udf_MinValue(40
													  , (case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
															  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
												      ) >= 35 
								then 1.0
									 *(case when  rtw_paytype = 'TI' 
												 and datepart(dw,pr.ppstart) IN(1,7) 
												 and datepart(dw,pr.ppend) IN(1,7) 
												 and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
											 then DATEDIFF(day,pr.ppstart,pr.ppend) + 1
										   when pr.ppstart = pr.ppend 
											 then 1 
										   else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									 end)
									 * 0.75
									 * dbo.udf_CheckPositiveOrNegative(pr.payamt) 
							when rtw_paytype = 'S40' 
								 and dbo.udf_MinValue(40
													 , (case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															 else isnull(cd.hrswrkwk,pr.hrs_per_week) end)
														) < 35
								then 1.0
									 *(case when		rtw_paytype = 'TI' 
													and datepart(dw,pr.ppstart) IN(1,7) 
													and datepart(dw,pr.ppend) IN(1,7) 
													and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
												then DATEDIFF(day,pr.ppstart,pr.ppend) + 1					
											when pr.ppstart = pr.ppend 
												then 1 
											else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									   end)
									   * 0.75 
									   * dbo.udf_CheckPositiveOrNegative(pr.payamt) 
									   * dbo.udf_MinValue(40
														  , (case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
																  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1  
																  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
															 end)
															)
										/ 37.5
								else 0 
						END)
						
			-- calculate days off work for post reform claims - no current work capacity
			,LT_NWC = (CASE when rtw_paytype = 'NOWORKCAP' 
								and dbo.udf_MinValue(40
													 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1 
															else isnull(cd.hrswrkwk,pr.hrs_per_week) 
													  end)
													  ) >= 35 
								then 1.0 * (pr.payamt* 5) / nullif(pr.DET_weekly,0)
							when rtw_paytype = 'NOWORKCAP' 
								 and dbo.udf_MinValue(40 
													  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															 else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													  ) < 35 
								then 1.0 
									 * (pr.payamt / nullif(pr.DET_weekly,0) / 37.5)
									 * 5
									 * dbo.udf_MinValue(40
														,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																   then cd.hrswrkwk 
															   when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1  
															   else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														  end)
														  )
								else 0 
						END)
						
			-- calculate days off work for post reform claims - current work capacity
			,LT_WC = (CASE when rtw_paytype = 'WORKCAP'
								  and dbo.udf_MinValue(40
														,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																   then cd.hrswrkwk 
															   when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																   then 1 
															   else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														 end)
														) >= 35 
								 then 1.0 * (pr.payamt* 5) / nullif(pr.DET_weekly,0)
							  when rtw_paytype = 'WORKCAP' 
								  and dbo.udf_MinValue(40 
														,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																   then cd.hrswrkwk 
															   when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																   then 1  
															   else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													   ) < 35 
								 then 1.0 
									  * (pr.payamt / nullif(pr.DET_weekly,0) / 37.5)
									  *5
									  *dbo.udf_MinValue(40
														 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
																when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1  
																else isnull(cd.hrswrkwk,pr.hrs_per_week) 
															end)
														   )
							  else 0 
						END)
						
			/*  determine employer size: Small, Smal-Medium, Medium or Large */
			
			-- set default to Small when missing policy data;
			,EMPL_SIZE = (CASE WHEN pd.bastarif IS NULL OR pd.const_flag_final IS NULL OR pd.wages IS NULL then 'A - Small'
							  WHEN pd.wages <= 300000 then 'A - Small'
							  WHEN pd.wages > 300000 AND pd.wages <= 1000000 AND pd.const_flag_final = 1 then 'A - Small'
							  WHEN pd.wages > 300000 AND pd.wages <= 1000000 AND pd.const_flag_final <> 1 then 'B - Small-Medium'
							  WHEN pd.wages > 1000000 AND pd.wages <= 5000000 then 'C - Medium'
							  WHEN pd.wages > 5000000 AND pd.wages <= 15000000 AND pd.bastarif <= 100000 then 'C - Medium'
							  WHEN pd.wages > 15000000 then 'D - Large'
							  WHEN pd.wages > 5000000 AND pd.bastarif > 100000 then 'D - Large'
							  ELSE 'A - Small'
						  END)
			/*  determine employer size: Small, Smal-Medium, Medium or Large */
						 
			/* 13 weeks */
			
			-- caps applied to measure, compare with remuneration end as threshold
			,CAP_CUR_13 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate),
													dbo.udf_MinDay(DATEADD(dd, -1, _13WEEKS_), @remuneration_End, '2222/01/01')
													) + case when DATEPART(dw,injdate) not in (1,7) 
																then 1 
															else 0 
														end)
			
			-- caps applied to measure, compare with remuneration start as threshold
			,CAP_PRE_13 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate),
													dbo.udf_MinDay(DATEADD(dd, -1, _13WEEKS_), 
															DATEADD(dd, -1, @remuneration_Start), '2222/01/01')
													) +	case when DATEPART(dw,injdate) not in (1,7) 
																then 1 
															else 0 
														end)
			
			-- determine days off work between payment period start and end dates, compare with remuneration end as threshold
			,DAYS13_TRANS = case when ppstart <= @remuneration_end 
										and paydate < DATEADD(MM, @Transaction_lag, _13WEEKS_)
										and paydate <= @transaction_lag_remuneration_end 
									then case when dbo.udf_MinDay(@remuneration_End,
															DATEADD(dd, -1, _13WEEKS_), ppend) >= ppstart 
												then dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _13WEEKS_), ppend))
																		) +	case when DATEPART(dw,ppstart) not in (1,7) 
																					then 1
																				when rtw_paytype = 'TI' 
																					and DATEPART(dw,ppstart) in (1,7) 
																					and DATEPART(dw,ppend) in (1,7) 
																					and DATEDIFF(DD,ppstart, ppend) <= 1
																					then 1 + DATEDIFF(DD,ppstart, ppend) 
																				else 0 
																			end
										else dbo.udf_MaxValue(0, 
												dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
													dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _13WEEKS_), ppend))) 
									end
								else 0 
							end
			
			-- determine days off work between payment period start and end dates, compare with remuneration start as threshold
			,DAYS13_TRANS_PRIOR = case when ppstart < @remuneration_start
											and paydate < DATEADD(MM, @Transaction_lag, _13WEEKS_)
											and paydate <= @transaction_lag_remuneration_start
										then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
															DATEADD(dd, -1, _13WEEKS_), ppend) >= ppstart 
													then dbo.udf_MaxValue(0, 
																dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																		dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																				DATEADD(dd, -1, _13WEEKS_), ppend))
																			) + case when DATEPART(dw,ppstart) not in (1,7) 
																						then 1
																					when rtw_paytype = 'TI' 
																						and DATEPART(dw,ppstart) in (1,7) 
																						and DATEPART(dw,ppend) in (1,7) 
																						and DATEDIFF(DD,ppstart, ppend) <= 1
																					then 1 + DATEDIFF(DD,ppstart, ppend) 
																					else 0 
																				end
										else dbo.udf_MaxValue(0, 
													dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
															dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																	DATEADD(dd, -1, _13WEEKS_), ppend)
																					)
															) 
										end
									else 0 
								end
			,LT13_TRANS = 0
			,LT13_TRANS_PRIOR = 0
			,LT13 = 0
			
			/* 13 weeks */
			
			/* 26 weeks */
			
			-- caps applied to measure, compare with remuneration end as threshold
			,CAP_CUR_26 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _26WEEKS_), 
															@remuneration_End, '2222/01/01')
														) + case when DATEPART(dw,injdate) not in (1,7) 
																	then 1 
																else 0 
															end)		
			
			-- caps applied to measure, compare with remuneration start as threshold
			,CAP_PRE_26 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
														dbo.udf_MinDay(DATEADD(dd, -1, _26WEEKS_), 
																DATEADD(dd, -1, @remuneration_Start), '2222/01/01')
															) + case when DATEPART(dw,injdate) not in (1,7) 
																		then 1 
																	else 0 
																end)
			
			-- determine days off work between payment period start and end dates, compare with remuneration end as threshold
			,DAYS26_TRANS = case when ppstart <= @remuneration_end 
									and paydate < DATEADD(MM, @Transaction_lag, _26WEEKS_)
									and paydate <= @transaction_lag_remuneration_end
									then case when dbo.udf_MinDay(@remuneration_End, 
														DATEADD(dd, -1, _26WEEKS_), ppend) >= ppstart 
												then dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _26WEEKS_), ppend)
																				)
																		) + case when DATEPART(dw,ppstart) not in (1,7) 
																					then 1
																				when rtw_paytype = 'TI' 
																					and DATEPART(dw,ppstart) in (1,7) 
																					and DATEPART(dw,ppend) in (1,7) 
																					and DATEDIFF(DD,ppstart, ppend) <= 1
																					 then 1 + DATEDIFF(DD,ppstart, ppend) 
																				else 0 
																			end
										else dbo.udf_MaxValue(0, 
													dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
															dbo.udf_MinDay(@remuneration_End, 
																	DATEADD(dd, -1, _26WEEKS_), ppend))) 
										end
									else 0
								end
			
			-- determine days off work between payment period start and end dates, compare with remuneration start as threshold
			,DAYS26_TRANS_PRIOR = case when ppstart < @remuneration_start 
											and paydate < DATEADD(MM, @Transaction_lag, _26WEEKS_)
											and paydate <= @transaction_lag_remuneration_start
											then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																	DATEADD(dd, -1, _26WEEKS_), ppend) >= ppstart 
															then dbo.udf_MaxValue(0, 
																		dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																				dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																						DATEADD(dd, -1, _26WEEKS_), ppend)
																										)
																				) + case when DATEPART(dw,ppstart) not in (1,7) 
																							then 1
																						 when rtw_paytype = 'TI' 
																							and DATEPART(dw,ppstart) in (1,7) 
																							and DATEPART(dw,ppend) in (1,7) 
																							and DATEDIFF(DD,ppstart, ppend) <= 1
																							then 1 + DATEDIFF(DD,ppstart, ppend) 
																						else 0 
																					end
									
											else dbo.udf_MaxValue(0, 
													dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
															dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																	DATEADD(dd, -1, _26WEEKS_), ppend)
																					)
																)
										end
									else 0 
								end
			,LT26_TRANS = 0
			,LT26_TRANS_PRIOR = 0
			,LT26 = 0
			
			/* 26 weeks */
			
			/* 52 weeks */
			
			-- caps applied to measure, compare with remuneration end as threshold
			,CAP_CUR_52 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _52WEEKS_), 
															@remuneration_End, '2222/01/01')
																			) +	case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0
																				end)
			
			-- caps applied to measure, compare with remuneration start as threshold
			,CAP_PRE_52 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _52WEEKS_), 
															DATEADD(dd, -1, @remuneration_Start), '2222/01/01')
																			) +	case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0 
																				end)
			
			-- determine days off work between payment period start and end dates, compare with remuneration end as threshold
			,DAYS52_TRANS = case when ppstart <= @remuneration_end 
										and paydate < DATEADD(MM, @Transaction_lag, _52WEEKS_)
										and paydate <= @transaction_lag_remuneration_end
									then case when dbo.udf_MinDay(@remuneration_End, 
															DATEADD(dd, -1, _52WEEKS_), ppend) >= ppstart 
												then dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _52WEEKS_), ppend)
																							)
																	) +	case when DATEPART(dw,ppstart) not in (1,7) 
																				then 1
																			 when rtw_paytype = 'TI' 
																				and DATEPART(dw,ppstart) in (1,7) 
																				and DATEPART(dw,ppend) in (1,7) 
																				and DATEDIFF(DD,ppstart, ppend) <= 1
																				then 1 + DATEDIFF(DD,ppstart, ppend) 
																			else 0
												end
										else dbo.udf_MaxValue(0, 
													dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
															dbo.udf_MinDay(@remuneration_End, 
																	DATEADD(dd, -1, _52WEEKS_), ppend))) 
									end
								else 0 
							end
			
			-- determine days off work between payment period start and end dates, compare with remuneration start as threshold
			,DAYS52_TRANS_PRIOR = case when ppstart < @remuneration_start 
											and paydate < DATEADD(MM, @Transaction_lag, _52WEEKS_)
											and paydate <= @transaction_lag_remuneration_start
										then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
															DATEADD(dd, -1, _52WEEKS_), ppend) >= ppstart 
													then dbo.udf_MaxValue(0, 
																dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																		dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																				DATEADD(dd, -1, _52WEEKS_), ppend)
																								)
																		) + case when DATEPART(dw,ppstart) not in (1,7) 
																					then 1
																				 when rtw_paytype = 'TI' 
																					and DATEPART(dw,ppstart) in (1,7) 
																					and DATEPART(dw,ppend) in (1,7) 
																					and DATEDIFF(DD,ppstart, ppend) <= 1
																					then 1 + DATEDIFF(DD,ppstart, ppend) 
																				else 0
																			end
												else dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																			DATEADD(dd, -1, _52WEEKS_), ppend)
																							)
																	) 
											end
										else 0
									end
			,LT52_TRANS = 0	
			,LT52_TRANS_PRIOR = 0	
			,LT52 = 0
			
			/* 52 weeks */
			
			/* 78 weeks */
			
			-- caps applied to measure, compare with remuneration end as threshold
			,CAP_CUR_78 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _78WEEKS_), 
															@remuneration_End, '2222/01/01')
																			) + case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0 
																				end)
			
			-- caps applied to measure, compare with remuneration start as threshold
			,CAP_PRE_78 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _78WEEKS_), 
															DATEADD(dd, -1, @remuneration_Start), '2222/01/01')
																			) +	case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0
																				end)
			
			-- determine days off work between payment period start and end dates, compare with remuneration end as threshold
			,DAYS78_TRANS = case when ppstart <= @remuneration_end 
										and paydate < DATEADD(MM, @Transaction_lag, _78WEEKS_)
										and paydate <= @transaction_lag_remuneration_end
									then case when dbo.udf_MinDay(@remuneration_End, 
															DATEADD(dd, -1, _78WEEKS_), ppend) >= ppstart 
												then dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _78WEEKS_), ppend)
																							)
																	) +	case when DATEPART(dw,ppstart) not in (1,7) 
																				then 1
																			 when rtw_paytype = 'TI' 
																				and DATEPART(dw,ppstart) in (1,7) 
																				and DATEPART(dw,ppend) in (1,7) 
																				and DATEDIFF(DD,ppstart, ppend) <= 1
																				then 1 + DATEDIFF(DD,ppstart, ppend) 
																			else 0 
																		end
											else dbo.udf_MaxValue(0, 
														dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																dbo.udf_MinDay(@remuneration_End, 
																		DATEADD(dd, -1, _78WEEKS_), ppend))) 
											end
									else 0
								end
			
			-- determine days off work between payment period start and end dates, compare with remuneration start as threshold
			,DAYS78_TRANS_PRIOR = case when ppstart < @remuneration_start 
											and paydate < DATEADD(MM, @Transaction_lag, _78WEEKS_)
											and paydate <= @transaction_lag_remuneration_start								
											then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																	DATEADD(dd, -1, _78WEEKS_), ppend) >= ppstart 
														then dbo.udf_MaxValue(0, 
																	dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																			dbo.udf_MinDay(DATEADD(dd, -1, 
																					@remuneration_Start), 
																					DATEADD(dd, -1, _78WEEKS_), ppend)
																							)
																			) + case when DATEPART(dw,ppstart) not in (1,7) 
																						then 1
																					 when rtw_paytype = 'TI' 
																							and DATEPART(dw,ppstart) in (1,7) 
																							and DATEPART(dw,ppend) in (1,7) 
																							and DATEDIFF(DD,ppstart, ppend) <= 1
																						then 1 + DATEDIFF(DD,ppstart, ppend) 
																					else 0 
																				end
														else dbo.udf_MaxValue(0, 
																	dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																			dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																					DATEADD(dd, -1, _78WEEKS_), ppend)
																									)
																			) 
													end
											else 0 
									end
			,LT78_TRANS = 0	
			,LT78_TRANS_PRIOR = 0
			,LT78 = 0
			
			/* 78 weeks */
			
			/* 104 weeks */
			
			-- caps applied to measure, compare with remuneration end as threshold
			,CAP_CUR_104 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _104WEEKS_), 
															@remuneration_End, '2222/01/01')
																			) + case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0 
																				end)
			
			-- caps applied to measure, compare with remuneration start as threshold
			,CAP_PRE_104 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _104WEEKS_), 
															DATEADD(dd, -1, @remuneration_Start), '2222/01/01')
																			) + case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0 
																				end)
			
			-- determine days off work between payment period start and end dates, compare with remuneration end as threshold
			,DAYS104_TRANS = case when ppstart <= @remuneration_end 
										and paydate < DATEADD(MM, @Transaction_lag, _104WEEKS_)
										and paydate <= @transaction_lag_remuneration_end
									then case when dbo.udf_MinDay(@remuneration_End, 
															DATEADD(dd, -1, _104WEEKS_), ppend) >= ppstart 
												then dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _104WEEKS_), ppend)
																							)
																	) +	case when DATEPART(dw,ppstart) not in (1,7) 
																				then 1
																			 when rtw_paytype = 'TI' 
																				and DATEPART(dw,ppstart) in (1,7) 
																				and DATEPART(dw,ppend) in (1,7) 
																				and DATEDIFF(DD,ppstart, ppend) <= 1
																				then 1 + DATEDIFF(DD,ppstart, ppend) 
																			else 0
																		end
												else dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _104WEEKS_), ppend))) 
										end
									else 0
								end
			
			-- determine days off work between payment period start and end dates, compare with remuneration start as threshold
			,DAYS104_TRANS_PRIOR = case when ppstart < @remuneration_start 
											and paydate < DATEADD(MM, @Transaction_lag, _104WEEKS_)
											and paydate <= @transaction_lag_remuneration_start
											then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																	DATEADD(dd, -1, _104WEEKS_), ppend) >= ppstart 
														then dbo.udf_MaxValue(0, 
																	dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																			dbo.udf_MinDay(DATEADD(dd, -1, 
																					@remuneration_Start), 
																					DATEADD(dd, -1, _104WEEKS_), ppend)
																									)
																			) +	case when DATEPART(dw,ppstart) not in (1,7) 
																						then 1
																					 when rtw_paytype = 'TI' and DATEPART(dw,ppstart) in (1,7) 
																						and DATEPART(dw,ppend) in (1,7) 
																						and DATEDIFF(DD,ppstart, ppend) <= 1
																						then 1 + DATEDIFF(DD,ppstart, ppend) 
																					else 0
																				end
											else dbo.udf_MaxValue(0, 
														dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																dbo.udf_MinDay(DATEADD(dd, -1, 
																		@remuneration_Start), 
																		DATEADD(dd, -1, _104WEEKS_), ppend)
																					)
																)
											end
									else 0
								end
			,LT104_TRANS = 0
			,LT104_TRANS_PRIOR = 0
			,LT104 = 0
			
			/* 104 weeks */
			
			/* flags determine transaction's incapacity periods is lied within 13, 26, 52, 78, 104 weeks injury or not */
			,include_13 = (case when (injdate between @remuneration_Start and @remuneration_End) 
									or (_13WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (@remuneration_Start between  injdate and _13WEEKS_) 
									or (@remuneration_End between  injdate and _13WEEKS_) 
									then 1 
								else 0 
						  end)
			,include_26 = (case when (injdate between @remuneration_Start and @remuneration_End) 
									or (_26WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (@remuneration_Start between  injdate and _26WEEKS_) 
									or (@remuneration_End between  injdate and _26WEEKS_) 
									then 1 
								else 0 
						   end)
			,include_52 = (case when (_26WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (_52WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (@remuneration_Start between  _26WEEKS_ and _52WEEKS_) 
									or (@remuneration_End between  _26WEEKS_ and _52WEEKS_) 
									then 1 
								else 0 
						   end)
			,include_78 = (case when (_52WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (_78WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (@remuneration_Start between  _52WEEKS_ and _78WEEKS_) 
									or (@remuneration_End between  _52WEEKS_ and _78WEEKS_) 
									then 1 
								else 0 
						   end)
			,include_104 = (case when (_52WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (_104WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (@remuneration_Start between  _52WEEKS_ and _104WEEKS_) 
									or (@remuneration_End between  _52WEEKS_ and _104WEEKS_) 
									then 1 
								 else 0 
							end)
			
			/* flags determine transaction is included in the 13, 26, 52, 78, 104 week measures or not */
			,include_13_trans = (case when pr.paydate <  DATEADD(MM, @Transaction_lag, _13WEEKS_) 
											   and pr.paydate <= @transaction_lag_remuneration_end 	
											   then 1 
										  else 0 
									end)
			,include_26_trans = (case when pr.paydate <  DATEADD(MM, @Transaction_lag, _26WEEKS_) 
										   and pr.paydate <= @transaction_lag_remuneration_end	
										  then 1 
									  else 0 
								end)
			,include_52_trans = (case when  pr.paydate <  DATEADD(MM, @Transaction_lag, _52WEEKS_) 
											and pr.paydate <= @transaction_lag_remuneration_end 	
										  then 1 
									  else 0 
								end)
			,include_78_trans = (case when  pr.paydate <  DATEADD(MM, @Transaction_lag, _78WEEKS_) 
												and pr.paydate <= @transaction_lag_remuneration_end 	
											  then 1 
										   else 0 
									 end)
			,include_104_trans = (case when pr.paydate <  DATEADD(MM, @Transaction_lag, _104WEEKS_) 
											and pr.paydate <= @transaction_lag_remuneration_end 	
											then 1 
										else 0 
								  end)
			
			,Total_LT = 0
			,_13WEEKS_
			,_26WEEKS_
			,_52WEEKS_
			,_78WEEKS_
			,_104WEEKS_
			
			/* recalculate days off work between MAX(date of injury, remuneration start) 
				and MIN(13 weeks, remuneration end): exclude Saturday or Sunday at right threshold */
			,DAYS13_PRD_CALC = DAYS13_PRD 
											 
			/* recalculate days off work between MAX(date of injury, remuneration start) 
				and MIN(26 weeks, remuneration end): exclude Saturday or Sunday at right threshold */
			,DAYS26_PRD_CALC = DAYS26_PRD 
											 
			/* recalculate days off work between MAX(date of injury, remuneration start) 
				and MIN(52 weeks, remuneration end): exclude Saturday or Sunday at right threshold */
			,DAYS52_PRD_CALC = DAYS52_PRD 
											
			/* recalculate days off work between MAX(date of injury, remuneration start) 
				and MIN(78 weeks, remuneration end): exclude Saturday or Sunday at right threshold */
			,DAYS78_PRD_CALC = DAYS78_PRD 
											 
			/* recalculate days off work between MAX(date of injury, remuneration start) 
				and MIN(104 weeks, remuneration end): exclude Saturday or Sunday at right threshold */
			,DAYS104_PRD_CALC = DAYS104_PRD 
											  
			/* recalculate days off work between 13 weeks and date of injury: 
				exclude Saturday or Sunday at right threshold */
			,DAYS13_CALC = DAYS13 
									 
			/* recalculate days off work between 26 weeks and date of injury: 
				exclude Saturday or Sunday at right threshold */
			,DAYS26_CALC = DAYS26 
									 
			/* recalculate days off work between 52 weeks and date of injury: 
				exclude Saturday or Sunday at right threshold */
			,DAYS52_CALC = DAYS52 
									 
			/* recalculate days off work between 78 weeks and date of injury: 
				exclude Saturday or Sunday at right threshold */
			,DAYS78_CALC = DAYS78 
									 
			/* recalculate days off work between 104 weeks and date of injury: 
				exclude Saturday or Sunday at right threshold */
			,DAYS104_CALC = DAYS104
	FROM #claim cd INNER JOIN #rtw_raworig_2 pr ON cd.Claim = pr.Claim
				   LEFT JOIN  #policy pd ON pd.policyno = cd.policyno
											AND pd.renewal_no = cd.renewal_no
											AND PR.ppstart <= @remuneration_end
					LEFT JOIN #activity_detail_audit ada
							ON ada.policyno = cd.policyno AND ada.renewal_no = cd.renewal_no
	WHERE ada.wages_shifts = (SELECT MAX(ada2.wages_shifts) 
									FROM #activity_detail_audit ada2
									WHERE ada2.policyno = ada.policyno
										AND ada2.renewal_no = ada.renewal_no)

	/* update LT_TRANS and LT_TRANS_PRIOR */
	UPDATE #measures
		SET LT13_TRANS = (case when days_for_TI = 0 
									then 0 
								else 1.0
									 * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
									 * DAYS13_TRANS / nullif(days_for_TI,0)
					    end)
			,LT13_TRANS_PRIOR = (case when days_for_TI = 0 
										then 0 
									else 1.0 
										 * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
										 * DAYS13_TRANS_PRIOR / nullif(days_for_TI,0)
								end)
			,LT26_TRANS = (case when days_for_TI = 0 
									then 0 
								else 1.0 
									 * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
									 * DAYS26_TRANS / nullif(days_for_TI,0)
							end)
			,LT26_TRANS_PRIOR = (case when days_for_TI = 0 
										then 0 
									  else 1.0 
											* (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
											* DAYS26_TRANS_PRIOR / nullif(days_for_TI,0)
								end)
			,LT52_TRANS = (case when days_for_TI = 0 
									then 0 
								else 1.0
									 * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
									 * DAYS52_TRANS / nullif(days_for_TI,0)
						   end)
			,LT52_TRANS_PRIOR = (case when days_for_TI = 0 
										then 0 
									  else 1.0 
											* (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
											* DAYS52_TRANS_PRIOR / nullif(days_for_TI,0)
								end)
			,LT78_TRANS = (case when days_for_TI = 0 then 0 
								else 1.0 
									 * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC)
									 * DAYS78_TRANS / nullif(days_for_TI,0)
						   end)
			,LT78_TRANS_PRIOR = (case when days_for_TI = 0 
										then 0 
									  else 1.0 
											* (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
										    * DAYS78_TRANS_PRIOR / nullif(days_for_TI,0)
								end)
			,LT104_TRANS = (case when days_for_TI = 0 
									then 0 
								 else 1.0
									  * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
									  * DAYS104_TRANS / nullif(days_for_TI,0)
							end)
			,LT104_TRANS_PRIOR = (case when days_for_TI = 0 
											then 0 
									   else 1.0 
											* (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
											* DAYS104_TRANS_PRIOR / nullif(days_for_TI,0)
								 end)
			,Total_LT = (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC)
						* (case when ppend <= @remuneration_end or days_for_TI = 0 
									 then 1
								when ppstart > @remuneration_end 
									 then 0
								else 1.0 
									 * dbo.udf_NoOfDaysWithoutWeekend(ppstart, @remuneration_end) 
									 / nullif(days_for_TI,0)
						  end)

	/* end of updating LT_TRANS and LT_TRANS_PRIOR */
	
	/* delete small transactions */

	/* small transactions with $2 per day for S40 and WC payments */
	DELETE FROM #measures WHERE (CASE WHEN paytype in ('S40') AND days_for_TI <> 0 
											AND hrs_per_week_adjusted >= 35 
											AND (1.0 * payamt / nullif(days_for_TI,0)) < 2 
										THEN 1
									 WHEN paytype in ('S40') AND days_for_TI <> 0 
											AND hrs_per_week_adjusted < 35 
											AND (1.0 * payamt / ((days_for_TI*hrs_per_week_adjusted)/37.5)) < 2 
										THEN 1 
									 WHEN paytype in ('S40') AND days_for_TI = 0 
											AND LT_S40 <> 0 AND (1.0 * payamt / nullif(LT_S40,0)) < 2  
										THEN 1
									 WHEN paytype in ('WORKCAP') AND LT_WC <> 0 AND (1.0 * payamt / nullif(LT_WC,0)) < 2 
										THEN 1
									 ELSE 0
								  END = 1)

	/* other small transactions with payment amount < $20 per day */
	DELETE FROM #measures WHERE (CASE WHEN  paytype in ('S38','TI','NOWORKCAP') 
										    and (LT_TI + LT_S38 + LT_NWC) <> 0 
										    and (1.0 * payamt / nullif((LT_TI + LT_S38 + LT_NWC),0)) < 20
										  THEN 1
									  ELSE 0
								 END = 1)
	/* end delete small transactions */
	
	/* Extract claims 13 weeks from #measures table and some additional tables */
	--SELECT  'Remuneration_Start' = dateadd(mm, 1, @remuneration_start)
	--		,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0, @remuneration_end) 
	--			+ @Transaction_lag - 1, 0)) + '23:59'
	SELECT  'Remuneration_Start' = @remuneration_start
			,'Remuneration_End' = @remuneration_end
			,Measure_months = @measure_month_13
			
			-- retrieve group info like 'HEM*'
			,'Group' = CASE WHEN (rtrim(isnull(co.Grp,''))='') 
								OR NOT EXISTS (select distinct grp 
												from claims_officers 
												where active = 1 and len(rtrim(ltrim(grp))) > 0 
													  and grp like co.Grp+'%')	
								OR co.Grp NOT LIKE 'hosp%'
								THEN 'Miscellaneous'
							WHEN PATINDEX('HEM%', co.Grp) = 0 THEN Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1)
							ELSE SUBSTRING(Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1), 1, 
									CASE WHEN PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 4, LEN(rtrim(co.Grp)) - 3)) > 0 
										THEN (PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 4, LEN(rtrim(co.Grp)) - 3)) + 2) 
										ELSE LEN(rtrim(co.Grp)) 
									END)
							END
							
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' THEN 'Miscellaneous' ELSE RTRIM(UPPER(co.Grp)) END		
			,Case_manager = ISNULL(UPPER(coa1.First_Name + ' ' + coa1.Last_Name), 'Miscellaneous')			
			,Agency_id = ''
			,cd.Claim_no
			,cd.injdate
			,cd.policyno
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,AgencyName = ''
			,Sub_category = ''
			,Measure = 13
			,Cert_Type = case when mc.TYPE = 'P' then 'No Time Lost' 
						      when mc.TYPE = 'T' then 'Totally Unfit'
							  when mc.TYPE = 'S' then 'Suitable Duties'
							  when mc.TYPE = 'I' then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' then 'Permanently Modified Duties'
							  else 'Invalid type' end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,cno.CELL_NO as Cell_no
			,cd.portfolio
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
				
	FROM (
			SELECT rtrim(cla.claim) as Claim_no
					,cla.injdate
					,cla.policyno
					,cla.portfolio
					,round(dbo.udf_MinValue(sum(cla.LT13_TRANS), 
									avg(CAP_CUR_13)) - dbo.udf_MinValue(sum(cla.LT13_TRANS_PRIOR), 
																AVG(CAP_PRE_13)), 10) as LT					
					,round(dbo.udf_MinValue(1, 1.0 * DAYS13_PRD_CALC / nullif(DAYS13_CALC,0)), 10) as WGT
					,cla.EMPL_SIZE
					,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
					,_13WEEKS_
			FROM #measures cla 
			WHERE cla.include_13 = 1 and cla.include_13_trans = 1
			GROUP BY cla.claim,
					cla.policyno,
					cla.portfolio,
					cla.injdate,
					_13WEEKS_,
					DAYS13_PRD_CALC, 
					DAYS13_CALC, 
					cla.EMPL_SIZE
			HAVING round(SUM(total_LT),10) > 5 
					and round(sum(LT13_TRANS),10) > 5
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias 
		INNER JOIN ptd_audit ptda ON cd.policyno = ptda.Policy_No
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
				  left join Broker Br on PTD.Broker_No = Br.Broker_no 
				  left join UnderWriters U on  BR.emi_Contact = U.Alias 
					where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no
		
		-- for retrieving cell number info
		LEFT JOIN (SELECT CELL_NO, claim_number
					FROM CLAIM_DETAIL cld inner join POLICY_TERM_DETAIL ptd on cld.Policy_No = ptd.POLICY_NO) as cno
					on cno.Claim_Number = cd.Claim_no
		
	WHERE cada1.id = (SELECT MAX(cada2.id)
						FROM cad_audit cada2 
						WHERE cada2.claim_no = cada1.claim_no 
							and cada2.transaction_date <= dbo.udf_MinDay(cd._13WEEKS_,
						  @remuneration_end, cd._13WEEKS_))
		AND coa1.id = (SELECT MAX(coa2.id)
						  FROM CO_audit coa2
						  WHERE coa2.officer_id = coa1.officer_id 
						  and coa2.create_date < dbo.udf_MinDay(cd._13WEEKS_,
						  @remuneration_end, cd._13WEEKS_))
		AND ptda.id = (SELECT MAX(ptda2.id) 
						FROM ptd_audit ptda2
						WHERE ptda2.policy_no = ptda.policy_no 
							and ptda2.create_date <= @remuneration_end)
		
	UNION ALL
	
	/* Extract claims 26 weeks from #measures table and some additional tables */
	--select  'Remuneration_Start' = dateadd(mm, 1, @remuneration_start)
	--		,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0, @remuneration_end) 
	--			+ @Transaction_lag - 1, 0)) + '23:59'
	SELECT  'Remuneration_Start' = @remuneration_start
			,'Remuneration_End' = @remuneration_end
			,Measure_months = @Measure_month_26
			
			-- retrieve group info like 'HEM*'
			,'Group' = CASE WHEN (rtrim(isnull(co.Grp,''))='') 
								OR NOT EXISTS (select distinct grp 
												from claims_officers 
												where active = 1 and len(rtrim(ltrim(grp))) > 0 
													  and grp like co.Grp+'%')	
								OR co.Grp NOT LIKE 'hosp%'
								THEN 'Miscellaneous'
							WHEN PATINDEX('HEM%', co.Grp) = 0 THEN Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1)
							ELSE SUBSTRING(Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1), 1, 
									CASE WHEN PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 4, LEN(rtrim(co.Grp)) - 3)) > 0 
										THEN (PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 4, LEN(rtrim(co.Grp)) - 3)) + 2) 
										ELSE LEN(rtrim(co.Grp)) 
									END)
							END
							
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' THEN 'Miscellaneous' ELSE RTRIM(UPPER(co.Grp)) END		
			,Case_manager = ISNULL ( UPPER(coa1.First_Name+' '+ coa1.Last_Name), 'Miscellaneous')			
			,Agency_id = ''
			,cd.Claim_no
			,cd.injdate
			,cd.policyno
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,AgencyName = ''
			,Sub_category = ''
			,Measure = 26
			,Cert_Type = case when mc.TYPE = 'P' then 'No Time Lost' 
						      when mc.TYPE = 'T' then 'Totally Unfit'
							  when mc.TYPE = 'S' then 'Suitable Duties'
							  when mc.TYPE = 'I' then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' then 'Permanently Modified Duties'
							  else 'Invalid type' end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,cno.CELL_NO as Cell_no
			,cd.portfolio
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag

	FROM (
			SELECT rtrim(cla.claim) as Claim_no
				,cla.injdate
				,cla.policyno
				,cla.portfolio
				,round(dbo.udf_MinValue(sum(cla.LT26_TRANS), 
								avg(CAP_CUR_26)) - dbo.udf_MinValue(sum(cla.LT26_TRANS_PRIOR), 
															AVG(CAP_PRE_26)), 10) as LT				
				,round(dbo.udf_MinValue(1, 1.0 * DAYS26_PRD_CALC / nullif(DAYS26_CALC,0)), 10) as WGT
				,cla.EMPL_SIZE
				,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
				,_26WEEKS_
			FROM #measures cla 
			where cla.include_26 = 1 and cla.include_26_trans = 1
			GROUP BY cla.claim,
					cla.policyno,
					cla.portfolio,
					cla.injdate,
					_26WEEKS_,
					DAYS26_PRD_CALC,
					DAYS26_CALC, 
					cla.EMPL_SIZE
			HAVING round(SUM(total_LT),10) > 5 
						and round(sum(LT26_TRANS),10) > 5
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_no = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		INNER JOIN ptd_audit ptda ON cd.policyno = ptda.Policy_No
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
					left join Broker Br on PTD.Broker_No = Br.Broker_no 
					left join UnderWriters U on  BR.emi_Contact = U.Alias 
					where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no
		
		-- for retrieving cell number info
		LEFT JOIN (SELECT CELL_NO, claim_number
					FROM CLAIM_DETAIL cld inner join POLICY_TERM_DETAIL ptd on cld.Policy_No = ptd.POLICY_NO) as cno
					on cno.Claim_Number = cd.Claim_no
      			
	WHERE cada1.id = (SELECT MAX(cada2.id) 
						FROM cad_audit cada2
						WHERE cada2.claim_no = cada1.claim_no
							and cada2.transaction_date <= dbo.udf_MinDay(cd._26WEEKS_,
						  @remuneration_end, cd._26WEEKS_))
		AND coa1.id = (SELECT MAX(coa2.id)
						  FROM CO_audit coa2
						  WHERE coa2.officer_id = coa1.officer_id 
						  and coa2.create_date < dbo.udf_MinDay(cd._26WEEKS_,
						  @remuneration_end, cd._26WEEKS_))
		AND ptda.id = (SELECT MAX(ptda2.id)
						FROM ptd_audit ptda2
						WHERE ptda2.policy_no = ptda.policy_no
							and ptda2.create_date <= @remuneration_end)
		
	UNION ALL
	
	/* Extract claims 52 weeks from #measures table and some additional tables */
	--SELECT  'Remuneration_Start' = dateadd(mm, 1, @remuneration_start)
	--		,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0, @remuneration_end) 
	--			+ @Transaction_lag - 1, 0)) + '23:59'
	SELECT  'Remuneration_Start' = @remuneration_start
			,'Remuneration_End' = @remuneration_end
			,Measure_months = @Measure_month_52
			
			-- retrieve group info like 'HEM*'
			,'Group' = CASE WHEN (rtrim(isnull(co.Grp,''))='') 
								OR NOT EXISTS (select distinct grp 
												from claims_officers 
												where active = 1 and len(rtrim(ltrim(grp))) > 0 
													  and grp like co.Grp+'%')	
								OR co.Grp NOT LIKE 'hosp%'
								THEN 'Miscellaneous'
							WHEN PATINDEX('HEM%', co.Grp) = 0 THEN Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1)
							ELSE SUBSTRING(Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1), 1, 
									CASE WHEN PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 4, LEN(rtrim(co.Grp)) - 3)) > 0 
										THEN (PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 4, LEN(rtrim(co.Grp)) - 3)) + 2) 
										ELSE LEN(rtrim(co.Grp)) 
									END)
							END
							
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' THEN 'Miscellaneous' ELSE RTRIM(UPPER(co.Grp)) END		
			,Case_manager = ISNULL ( UPPER(coa1.First_Name + ' ' + coa1.Last_Name), 'Miscellaneous')			
			,Agency_id = ''
			,cd.Claim_no
			,cd.injdate
			,cd.policyno
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,AgencyName = ''
			,Sub_category = ''
			,Measure = 52
			,Cert_Type = case when mc.TYPE = 'P' then 'No Time Lost' 
						      when mc.TYPE = 'T' then 'Totally Unfit'
							  when mc.TYPE = 'S' then 'Suitable Duties'
							  when mc.TYPE = 'I' then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' then 'Permanently Modified Duties'
							  else 'Invalid type' end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,cno.CELL_NO as Cell_no
			,cd.portfolio
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
	FROM (
			SELECT	rtrim(cla.claim) as Claim_no	
					,cla.injdate	
					,cla.policyno
					,cla.portfolio
					,	(round(dbo.udf_MinValue(sum(cla.LT52_TRANS), 
										avg(CAP_CUR_52)) - dbo.udf_MinValue(sum(cla.LT52_TRANS_PRIOR), 
																AVG(CAP_PRE_52)), 10)
						- (round(dbo.udf_MinValue(sum(cla.LT26_TRANS), 
										avg(CAP_CUR_26)) - dbo.udf_MinValue(sum(cla.LT26_TRANS_PRIOR), 
																AVG(CAP_PRE_26)), 10))
					) as LT						
					,round(dbo.udf_MinValue(1, 1.0 * DAYS52_PRD_CALC / nullif(DAYS52_CALC,0)), 10) as WGT
					,cla.EMPL_SIZE
					,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
					,_52WEEKS_
			FROM #measures cla
			WHERE cla.include_52 = 1 and cla.include_52_trans = 1
			GROUP BY cla.claim,
					cla.policyno,
					cla.portfolio,
					cla.injdate,
					_52WEEKS_,
					DAYS52_PRD_CALC, 
					DAYS52_CALC, 
					cla.EMPL_SIZE
			HAVING round(SUM(total_LT),10) > 5 and round(sum(LT52_TRANS),10) > 5	
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		INNER JOIN ptd_audit ptda ON cd.policyno = ptda.Policy_No
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
					left join Broker Br on PTD.Broker_No = Br.Broker_no 
					left join UnderWriters U on  BR.emi_Contact = U.Alias 
					where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no
		
		-- for retrieving cell number info
		LEFT JOIN (SELECT CELL_NO, claim_number
					FROM CLAIM_DETAIL cld inner join POLICY_TERM_DETAIL ptd on cld.Policy_No = ptd.POLICY_NO) as cno
					on cno.Claim_Number = cd.Claim_no
		
	WHERE cada1.id = (SELECT MAX(cada2.id) 
						FROM cad_audit cada2 
						WHERE cada2.claim_no = cada1.claim_no 
							and cada2.transaction_date <= dbo.udf_MinDay(cd._52WEEKS_,
						  @remuneration_end, cd._52WEEKS_))
		AND coa1.id = (SELECT MAX(coa2.id)
						  FROM CO_audit coa2
						  WHERE coa2.officer_id = coa1.officer_id 
						  and coa2.create_date < dbo.udf_MinDay(cd._52WEEKS_,
						  @remuneration_end, cd._52WEEKS_))
		AND ptda.id = (SELECT MAX(ptda2.id) 
						FROM ptd_audit ptda2
						WHERE ptda2.policy_no = ptda.policy_no 
							and ptda2.create_date <= @remuneration_end)
		
	UNION ALL
	
	/* Extract claims 78 weeks from #measures table and some additional tables */
	--SELECT  'Remuneration_Start' = dateadd(mm, 1, @remuneration_start)
	--		,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0, @remuneration_end) 
	--			+ @Transaction_lag - 1, 0)) + '23:59'
	SELECT  'Remuneration_Start' = @remuneration_start
			,'Remuneration_End' = @remuneration_end
			,Measure_months = @Measure_month_78
			
			-- retrieve group info like 'HEM*'
			,'Group' = CASE WHEN (rtrim(isnull(co.Grp,''))='') 
								OR NOT EXISTS (select distinct grp 
												from claims_officers 
												where active = 1 and len(rtrim(ltrim(grp))) > 0 
													  and grp like co.Grp+'%')	
								OR co.Grp NOT LIKE 'hosp%'
								THEN 'Miscellaneous'
							WHEN PATINDEX('HEM%', co.Grp) = 0 THEN Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1)
							ELSE SUBSTRING(Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1), 1, 
									CASE WHEN PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 4, LEN(rtrim(co.Grp)) - 3)) > 0 
										THEN (PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 4, LEN(rtrim(co.Grp)) - 3)) + 2) 
										ELSE LEN(rtrim(co.Grp)) 
									END)
							END
							
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' THEN 'Miscellaneous' ELSE RTRIM(UPPER(co.Grp)) END
			,Case_manager = ISNULL ( UPPER(coa1.First_Name+' '+ coa1.Last_Name), 'Miscellaneous')			
			,Agency_id = ''
			,cd.Claim_no
			,cd.injdate
			,cd.policyno
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,AgencyName = ''
			,Sub_category = ''
			,Measure = 78
			,Cert_Type = case when mc.TYPE = 'P' then 'No Time Lost' 
						      when mc.TYPE = 'T' then 'Totally Unfit'
							  when mc.TYPE = 'S' then 'Suitable Duties'
							  when mc.TYPE = 'I' then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' then 'Permanently Modified Duties'
							  else 'Invalid type' end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,cno.CELL_NO as Cell_no
			,cd.portfolio
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
	FROM (
			SELECT	rtrim(cla.claim) as Claim_no
					,cla.injdate	
					,cla.policyno	
					,cla.portfolio
					,	(round(dbo.udf_MinValue(sum(cla.LT78_TRANS), 
													avg(CAP_CUR_78)) - dbo.udf_MinValue(sum(cla.LT78_TRANS_PRIOR), 
																							AVG(CAP_PRE_78)), 10)
						- (round(dbo.udf_MinValue(sum(cla.LT52_TRANS), 
													avg(CAP_CUR_52)) - dbo.udf_MinValue(sum(cla.LT52_TRANS_PRIOR), 
																							AVG(CAP_PRE_52)), 10))
					) as LT
					,round(dbo.udf_MinValue(1, 1.0 * DAYS78_PRD_CALC / nullif(DAYS78_CALC,0)), 10) as WGT
					,cla.EMPL_SIZE
					,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
					,_78WEEKS_
			FROM #measures cla
			WHERE cla.include_78 = 1 and cla.include_78_trans = 1
			GROUP BY cla.claim,
					cla.policyno,
					cla.portfolio,
					cla.injdate,
					_78WEEKS_, 
					DAYS78_PRD_CALC, 
					DAYS78_CALC, 
					cla.EMPL_SIZE
			HAVING round(SUM(total_LT),10) > 5 and round(sum(LT78_TRANS),10) > 5
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		INNER JOIN ptd_audit ptda ON cd.policyno = ptda.Policy_No
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
					left join Broker Br on PTD.Broker_No = Br.Broker_no 
					left join UnderWriters U on  BR.emi_Contact = U.Alias 
					where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no			
		
		-- for retrieving cell number info
		LEFT JOIN (SELECT CELL_NO, claim_number
					FROM CLAIM_DETAIL cld inner join POLICY_TERM_DETAIL ptd on cld.Policy_No = ptd.POLICY_NO) as cno
					on cno.Claim_Number = cd.Claim_no
	
	WHERE cada1.id = (SELECT MAX(cada2.id) 
						FROM cad_audit cada2 
						WHERE cada2.claim_no = cada1.claim_no 
							and cada2.transaction_date <= dbo.udf_MinDay(cd._78WEEKS_,
						  @remuneration_end, cd._78WEEKS_))
		AND coa1.id = (SELECT MAX(coa2.id)
						  FROM CO_audit coa2
						  WHERE coa2.officer_id = coa1.officer_id 
						  and coa2.create_date < dbo.udf_MinDay(cd._78WEEKS_,
						  @remuneration_end, cd._78WEEKS_))
		AND ptda.id = (SELECT MAX(ptda2.id)
						FROM ptd_audit ptda2
						WHERE ptda2.policy_no = ptda.policy_no 
							and ptda2.create_date <= @remuneration_end)
					
	UNION ALL
	
	/* Extract claims 104 weeks from #measures table and some additional tables */
	--SELECT  Remuneration_Start = dateadd(mm, 1, @remuneration_start)
	--		,Remuneration_End = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0, @remuneration_end) 
	--			+ @Transaction_lag - 1, 0)) + '23:59'
	SELECT  'Remuneration_Start' = @remuneration_start
			,'Remuneration_End' = @remuneration_end
			,Measure_months = @Measure_month_104
			
			-- retrieve group info like 'HEM*'
			,'Group' = CASE WHEN (rtrim(isnull(co.Grp,''))='') 
								OR NOT EXISTS (select distinct grp 
												from claims_officers 
												where active = 1 and len(rtrim(ltrim(grp))) > 0 
													  and grp like co.Grp+'%')
								OR co.Grp NOT LIKE 'hosp%'	
								THEN 'Miscellaneous'
							WHEN PATINDEX('HEM%', co.Grp) = 0 THEN Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1)
							ELSE SUBSTRING(Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1), 1, 
									CASE WHEN PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 4, LEN(rtrim(co.Grp)) - 3)) > 0 
										THEN (PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 4, LEN(rtrim(co.Grp)) - 3)) + 2) 
										ELSE LEN(rtrim(co.Grp)) 
									END)
							END
							
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' THEN 'Miscellaneous' ELSE RTRIM(UPPER(co.Grp)) END		
			,Case_manager = ISNULL(UPPER(coa1.First_Name + ' ' + coa1.Last_Name), 'Miscellaneous')			
			,Agency_id = ''
			,cd.Claim_no
			,cd.injdate
			,cd.policyno
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,AgencyName = ''
			,Sub_category = ''
			,Measure = 104
			,Cert_Type = case when mc.TYPE = 'P' then 'No Time Lost' 
						      when mc.TYPE = 'T' then 'Totally Unfit'
							  when mc.TYPE = 'S' then 'Suitable Duties'
							  when mc.TYPE = 'I' then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' then 'Permanently Modified Duties'
							  else 'Invalid type' end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To	
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,cno.CELL_NO as Cell_no
			,cd.portfolio
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
	FROM (
			SELECT	rtrim(cla.claim) as Claim_no
				,cla.injdate	
				,cla.policyno	
				,cla.portfolio
				,	(round(dbo.udf_MinValue(sum(cla.LT104_TRANS), 
									avg(CAP_CUR_104)) - dbo.udf_MinValue(sum(cla.LT104_TRANS_PRIOR), 
																AVG(CAP_PRE_104)), 10)
					- round(dbo.udf_MinValue(sum(cla.LT52_TRANS), 
									avg(CAP_CUR_52)) - dbo.udf_MinValue(sum(cla.LT52_TRANS_PRIOR), 
																AVG(CAP_PRE_52)), 10)
				) as LT					
				,round(dbo.udf_MinValue(1, 1.0 * DAYS104_PRD_CALC / nullif(DAYS104_CALC,0)), 10) as WGT
				,cla.EMPL_SIZE
				,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
				,_104WEEKS_
			FROM #measures cla 
			WHERE cla.include_104 = 1 and cla.include_104_trans = 1
			GROUP BY cla.claim,
					cla.policyno,
					cla.portfolio,
					cla.injdate,
					_104WEEKS_, 
					DAYS104_PRD_CALC, 
					DAYS104_CALC, 
					cla.EMPL_SIZE
			HAVING round(SUM(total_LT),10) > 5 and round(sum(LT104_TRANS),10) > 5		
		) as cd 
		
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		INNER JOIN ptd_audit ptda ON cd.policyno = ptda.Policy_No
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
					left join Broker Br on PTD.Broker_No = Br.Broker_no 
					left join UnderWriters U on  BR.emi_Contact = U.Alias 
					where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no		
		
		-- for retrieving cell number info
		LEFT JOIN (SELECT CELL_NO, claim_number
					FROM CLAIM_DETAIL cld inner join POLICY_TERM_DETAIL ptd on cld.Policy_No = ptd.POLICY_NO) as cno
					on cno.Claim_Number = cd.Claim_no
	
	WHERE cada1.id = (SELECT MAX(cada2.id) 
						FROM cad_audit cada2 
						WHERE cada2.claim_no = cada1.claim_no 
							and cada2.transaction_date <= dbo.udf_MinDay(cd._104WEEKS_,
						  @remuneration_end, cd._104WEEKS_))
		AND coa1.id = (SELECT MAX(coa2.id)
						  FROM CO_audit coa2
						  WHERE coa2.officer_id = coa1.officer_id 
						  and coa2.create_date < dbo.udf_MinDay(cd._104WEEKS_,
						  @remuneration_end, cd._104WEEKS_))
		AND ptda.id = (SELECT MAX(ptda2.id) 
						FROM ptd_audit ptda2
						WHERE ptda2.policy_no = ptda.policy_no 
							and ptda2.create_date <= @remuneration_end)
		
	/* drop all temp table */
	IF OBJECT_ID('tempdb..#measures') IS NOT NULL drop table #measures	
	/* end drop all temp table */
END--------------------------------  
-- END of D:\Projects\DbReleaseTool\tmpChange\StoredProcedure\usp_Dashboard_HEM_RTW.sql  
--------------------------------  
  
--------------------------------  
-- D:\Projects\DbReleaseTool\tmpChange\StoredProcedure\usp_Dashboard_HEM_RTW_AddTargetAndBase.sql  
--------------------------------  
SET ANSI_NULLS OFF

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_RTW] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_RTW] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_RTW] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_HEM_RTW.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_HEM_RTW_GenerateData.sql  
--------------------------------  
/****** Object:  StoredProcedure [dbo].[usp_Dashboard_HEM_RTW_GenerateData]    Script Date: 12/26/2013 14:40:33 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_HEM_RTW_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_HEM_RTW_GenerateData]
GO

-- For example
-- exec [usp_Dashboard_HEM_RTW_GenerateData] 2013, 6
CREATE PROCEDURE [dbo].[usp_Dashboard_HEM_RTW_GenerateData]
	@start_period_year int = 2010,
	@start_period_month int = 11	
AS
BEGIN
	SET NOCOUNT ON;
	declare @SQL varchar(500)
	
	declare @measure_month_13 int
	declare @measure_month_26 int
	declare @measure_month_52 int
	declare @measure_month_78 int
	declare @measure_month_104 int
	
	declare @AsAt datetime
	declare @remuneration_start datetime
	declare @remuneration_end datetime
	
	declare @transaction_lag_remuneration_end datetime
	
	declare @paystartdt datetime
	declare @transaction_lag int	
	
	set @measure_month_13 = 3	-- 13weeks = 3
	set @measure_month_26 = 6	-- 26weeks = 6
	set @measure_month_52 = 12  -- 52weeks = 12
	set @measure_month_78 = 18  -- 78weeks = 18
	set @measure_month_104 = 24 -- 104weeks = 24	
	
	set @transaction_lag = 3 -- for HEM
	
	---delete last transaction lag number months in dart db---	
	exec('DELETE FROM [DART].[dbo].[HEM_RTW] 
			WHERE remuneration_end in (select distinct top '+@transaction_lag+' remuneration_end 
			from [DART].[dbo].[HEM_RTW] order by remuneration_end desc)')
	---end delete--
	
	declare @start_period datetime = CAST(CAST(@start_period_year as varchar) + '/' 
										+ CAST(@start_period_month as varchar) + '/01' as datetime)
	declare @end_period datetime = DATEADD(MM, 0, getdate())
	
	declare @loop_time int = datediff(month, @start_period, @end_period)
	declare @i int = @loop_time
	declare @yy int
	declare @mm int
	declare @temp datetime
	
	-- Check temp table existing then drop
	IF OBJECT_ID('tempdb..#claim') IS NOT NULL drop table #claim
	IF OBJECT_ID('tempdb..#rtw_raworig_temp') IS NOT NULL DROP TABLE #rtw_raworig_temp
	IF OBJECT_ID('tempdb..#rtw_raworig') IS NOT NULL DROP TABLE #rtw_raworig
	IF OBJECT_ID('tempdb..#rtw_raworig_2') IS NOT NULL DROP TABLE #rtw_raworig_2
	IF OBJECT_ID('tempdb..#policy') IS NOT NULL drop table #policy
	IF OBJECT_ID('tempdb..#activity_detail_audit') IS NOT NULL DROP table #activity_detail_audit
	-- Check temp table existing then drop
	
	/* create #claim table to store claim detail info */
	CREATE TABLE #claim
	(
		claim CHAR(19)
		,policyno CHAR(19)
		,renewal_no INT
		,anzsic varchar(255)
		,hrswrkwk numeric(5,2)
		,injdate datetime
		,_13WEEKS_ DATETIME
		,_26WEEKS_ DATETIME
		,_52WEEKS_ DATETIME
		,_78WEEKS_ DATETIME
		,_104WEEKS_ DATETIME
		,DAYS13 int
		,DAYS26 int
		,DAYS52 int
		,DAYS78 int
		,DAYS104 int
		,DAYS13_PRD int
		,DAYS26_PRD int
		,DAYS52_PRD int
		,DAYS78_PRD int
		,DAYS104_PRD int
	)	

	/* create index for #claim table */
	SET @SQL = 'CREATE INDEX pk_claim_' + CONVERT(VARCHAR, @@SPID)
		+ ' ON #claim(claim, policyno, injdate)'
	EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	/* create #rtw_raworig temp table to store transaction data */
	CREATE TABLE #rtw_raworig_temp
	(
		 claim varchar(19)
		 ,paydate datetime
		 ,paytype varchar(15)
		 ,rtw_paytype varchar(9)
		 ,adjflag varchar(1)
		 ,payamt money
		 ,payment_no int
		 ,ppstart datetime
		 ,ppend datetime
		 ,hrs_per_week numeric(5,2)
		 ,hrs_total numeric(14,3)
		 ,DET_weekly money
	)

	/* create index for #rtw_raworig_temp table */
	SET @SQL = 'CREATE INDEX pk_rtw_raworig_temp_' + CONVERT(VARCHAR, @@SPID) 
		+ ' ON #rtw_raworig_temp(claim, payment_no)'
	EXEC(@SQL)
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	/* create #rtw_raworig table to store transaction data after summarizing step #1 */
	CREATE TABLE #rtw_raworig
	(
		 claim varchar(19)
		 ,paydate datetime
		 ,paytype varchar(15)
		 ,rtw_paytype varchar(9)
		 ,payamt money
		 ,ppstart datetime
		 ,ppend datetime
		 ,hrs_per_week numeric(5,2)
		 ,hrs_total numeric(14,3)
		 ,DET_weekly money
	)	
	
	/* create index for #rtw_raworig table */
	SET @SQL = 'CREATE INDEX pk_rtw_raworig_' + CONVERT(VARCHAR, @@SPID) 
		+ ' ON #rtw_raworig(claim, rtw_paytype, paydate)'
	EXEC(@SQL)
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	/* create #rtw_raworig_2 table to store transaction data after summarizing for step #2 */
	CREATE TABLE #rtw_raworig_2
	(
		 claim varchar(19)
		 ,paydate datetime
		 ,rtw_paytype varchar(9)
		 ,payamt money
		 ,ppstart datetime
		 ,ppend datetime
		 ,hrs_per_week numeric(5,2)
		 ,hrs_total numeric(14,3)
		 ,DET_weekly money
	)	
	
	/* create index for #rtw_raworig_2 table */
	SET @SQL = 'CREATE INDEX pk_rtw_raworig_2_' + CONVERT(VARCHAR, @@SPID)
		+ ' ON #rtw_raworig_2(claim, rtw_paytype, paydate)'
	EXEC(@SQL)
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	/* create #policy table to store policy info for claim */
	CREATE TABLE #policy
	(
		policyno CHAR(19)
		,renewal_no INT
		,bastarif MONEY
		,wages MONEY
		,const_flag_final int
	)
	
	/* create index for #policy table */
	SET @SQL = 'CREATE INDEX pk_policy_' + CONVERT(VARCHAR, @@SPID)
		+ ' ON #policy(policyno, renewal_no)'
	EXEC(@SQL)
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	/* create #activity_detail_audit table to store policy info for claim */
	CREATE TABLE #activity_detail_audit
	(
		policyno CHAR(19)
		,renewal_no INT
		,tariff INT
		,wages_shifts MONEY
	)
	
	/* create index for #activity_detail_audit table */
	SET @SQL = 'CREATE INDEX pk_activity_detail_audit_' + CONVERT(VARCHAR, @@SPID)
		+ ' ON #activity_detail_audit(policyno, renewal_no, tariff)'
	EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	WHILE (@i) >= 0
	BEGIN	
		set @temp = dateadd(mm, @i, @start_period)
		set @yy = year(@temp)
		set @mm = month(@temp)
		
		/* delete all data in the temp tables */
		delete from #claim
		delete from #rtw_raworig_temp
		delete from #rtw_raworig
		delete from #rtw_raworig_2
		delete from #policy
		delete from #activity_detail_audit
		IF OBJECT_ID('tempdb..#summary') IS NOT NULL DROP TABLE #summary
		
		set @remuneration_end = cast(CAST(@yy as varchar) + '/' +  CAST(@mm as varchar) + '/01' as datetime)
		set @remuneration_start = DATEADD(mm,-12, @remuneration_end) -- get max rolling month = 12
		--set @AsAt = DATEADD(dd, -1, DATEADD(mm, 1, @remuneration_end)) + '23:59'
		
		set @remuneration_end = DATEADD(dd, -1, @remuneration_end) + '23:59'		
		set @transaction_lag_remuneration_end = DATEADD(mm, @transaction_lag, @remuneration_end)
		
		-- use transaction flag = 3
		set @AsAt = @transaction_lag_remuneration_end
		
		set @paystartdt = DATEADD(mm, -@transaction_lag, DATEADD(YY, -2, @remuneration_Start))
		
		
		If NOT EXISTS(select 1 from [DART].[dbo].[HEM_RTW] 
							where YEAR(remuneration_end) = YEAR(@remuneration_end) and
							MONTH(remuneration_end) = MONTH(@remuneration_end))
			AND cast(CAST(year(@remuneration_end) as varchar) + '/' +  CAST(month(@remuneration_end) as varchar) + '/01' as datetime)
				< cast(CAST(year(getdate()) as varchar) + '/' +  CAST(month(getdate()) as varchar) + '/01' as datetime)
		BEGIN		
			print cast(YEAR(@remuneration_end) as varchar) + ' and ' + cast(MONTH(@remuneration_end) as varchar)
			print 'Start to delete data in HEM_RTW table first...'
			--delete from dbo.HEM_RTW
			--	   where year(Remuneration_End) = YEAR(@remuneration_end) 
			--			 and MONTH(Remuneration_End) = MONTH(@remuneration_end)
			
			/* retrieve claim detail info */
			INSERT INTO #claim
				SELECT	cd.Claim_Number
						, cda.Policy_No
						, Renewal_No
						, anz.DESCRIPTION
						, cd.Work_Hours
						, cd.Date_of_Injury
						
						-- calculate 13 weeks from date of injury
						, _13WEEKS_ = dateadd(mm, @measure_month_13, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
						
						-- calculate 26 weeks from date of injury
						, _26WEEKS_ = dateadd(mm, @measure_month_26, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
						
						-- calculate 52 weeks from date of injury
						, _52WEEKS_ = dateadd(mm, @measure_month_52, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
						
						-- calculate 78 weeks from date of injury
						, _78WEEKS_ = dateadd(mm, @measure_month_78, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
						
						-- calculate 104 weeks from date of injury
						, _104WEEKS_ = dateadd(mm, @measure_month_104, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
						
						, DAYS13 = 0
						, DAYS26 = 0
						, DAYS52 = 0
						, DAYS78 = 0
						, DAYS104 = 0
						
						,DAYS13_PRD = 0
						,DAYS26_PRD = 0
						,DAYS52_PRD = 0
						,DAYS78_PRD = 0
						,DAYS104_PRD = 0
				FROM dbo.CLAIM_DETAIL cd INNER JOIN cd_audit cda on cda.claim_no = cd.claim_number
					AND isnull(cd.Claim_Number,'') <> ''
					AND cd.Date_of_Injury >= @paystartdt
					AND cda.id = (select max(id) 
									from cd_audit cda1 
									where cda1.claim_no = cd.claim_number 
										and cda1.create_date < @remuneration_end)
					LEFT JOIN ANZSIC anz on cd.ANZSIC = anz.CODE
				/* exclude Serious Claims */
				WHERE cd.claim_number not in (select Claim_no from HEM_SIW)
					AND ISNULL(anz.ID, 1) = ISNULL((SELECT MAX(ID) FROM ANZSIC anz2 
														WHERE anz2.CODE = anz.CODE), 1)
			
			/* retrieve transactions data */
			INSERT INTO #rtw_raworig_temp
			SELECT  pr.Claim_No
					, CONVERT(varchar(10), pr.Transaction_date, 120)
					,pr.WC_Payment_Type
					,rtw_paytype=  (CASE WHEN wc_payment_type IN ('14', '15', 'WPT001', 'WPT002', 'WPT003', 'WPT004') 
											THEN 'TI'
										 WHEN wc_payment_type IN ('13', 'WPP001', 'WPP003') 
											THEN 'S38'
										 WHEN wc_payment_type IN ('16', 'WPP002', 'WPP004') 
											THEN 'S40'
										 WHEN wc_payment_type IN ('WPT005', 'WPT006', 'WPT007') 
											THEN 'NOWORKCAP'
										 WHEN wc_payment_type IN ('WPP005', 'WPP006', 'WPP007', 'WPP008') 
											THEN 'WORKCAP' 
									END)
					,Adjust_Trans_Flag
					,Trans_Amount
					,pr.Payment_no
					,Period_Start_Date
					,Period_End_Date
					,pr.hours_per_week
					,hrs_total = (isnull(WC_MINUTES, 0) / 60.0)
									 + isnull(WC_HOURS, 0)
									 + isnull(WC_WEEKS * HOURS_PER_WEEK, 0)
					,isnull(Rate, 0)
			FROM dbo.Payment_Recovery pr
					INNER JOIN dbo.CLAIM_PAYMENT_RUN
							   ON pr.Payment_no = dbo.CLAIM_PAYMENT_RUN.Payment_no
					INNER JOIN #claim cl on pr.Claim_No = cl.claim
			WHERE	Transaction_date >= @paystartdt
					AND Transaction_date <= @AsAt
					AND wc_Tape_Month IS NOT NULL 
					AND LEFT(wc_Tape_Month, 4) <= @yy
					AND wc_Tape_Month <= CONVERT(int, 
											CONVERT(varchar(8), @transaction_lag_remuneration_end,112))
					AND wc_payment_type IN ('WPT001', 'WPT003', 'WPT002'
											 ,'WPT004', 'WPP001', 'WPP003'
											 ,'WPP002', 'WPP004','WPT005'
											 ,'WPT006', 'WPT007', 'WPP005'
											 ,'WPP006', 'WPP007', 'WPP008'
											 ,'13', '14', '15', '16')
											 
			/* Adjust DET weekly field */
			SELECT distinct claim, ppstart, ppend, paytype, DET_weekly = max(DET_weekly) 
				INTO #summary
				FROM #rtw_raworig_temp
			GROUP BY claim,
					ppstart, 
					ppend, 
					paytype		

			UPDATE #rtw_raworig_temp 
				SET DET_weekly = su.DET_weekly
				FROM #summary su
				WHERE	#rtw_raworig_temp.claim = su.claim
						AND #rtw_raworig_temp.ppstart = su.ppstart
						AND #rtw_raworig_temp.ppend = su.ppend
						AND #rtw_raworig_temp.paytype = su.paytype		
			/* end of adjusting DET weekly field */
			
			/* summarised transactions by claim, paydate, paytype, ppstart, ppend */
			INSERT INTO #rtw_raworig
			SELECT  claim
					,paydate
					,paytype
					,rtw_paytype
					,payamt = (SELECT SUM(payamt)
									FROM #rtw_raworig_temp rtw1 
									WHERE	rtw1.claim = rtw.claim 
											and rtw1.paydate = rtw.paydate
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart 
											and rtw1.ppend = rtw.ppend)							
					,ppstart
					,ppend
					,hrs_per_week
					,hrs_total = (SELECT SUM(hrs_total)
									FROM #rtw_raworig_temp rtw1
									WHERE rtw1.claim = rtw.claim 
											and rtw1.paydate = rtw.paydate
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart
											and rtw1.ppend = rtw.ppend)
					,DET_weekly = (SELECT MAX(DET_weekly) 
									FROM #rtw_raworig_temp rtw1
									WHERE	rtw1.claim = rtw.claim 
											and rtw1.paydate = rtw.paydate
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart
											and rtw1.ppend = rtw.ppend)
			FROM #rtw_raworig_temp rtw
			GROUP BY claim,
					paydate,
					paytype,
					rtw_paytype,
					ppstart,
					ppend,
					hrs_per_week
					
			/*	
			Records with payment amount and hours paid for total incapacity are both zero are removed.
			*/
			DELETE FROM #rtw_raworig WHERE hrs_total = 0 and payamt = 0
			
			/*	
				Records with a negative payment amount, but positive hours paid for total incapacity
					have their hours paid changed to be negative.
			*/
			UPDATE #rtw_raworig SET hrs_total = -hrs_total 
				WHERE hrs_total > 0 AND payamt < 0
				
			/* summarised trasactions by claim, paytype, ppstart, ppend */
			INSERT INTO #rtw_raworig_2
			SELECT  claim
					,paydate = (SELECT MIN(paydate) 
									FROM #rtw_raworig rtw1
									WHERE	rtw1.claim = rtw.claim										
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart
											and rtw1.ppend = rtw.ppend)
					,rtw_paytype
					,payamt = (SELECT SUM(payamt)
									FROM #rtw_raworig rtw1 
									WHERE	rtw1.claim = rtw.claim 
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart 
											and rtw1.ppend = rtw.ppend)							
					,ppstart
					,ppend
					,hrs_per_week
					,hrs_total = (SELECT SUM(hrs_total)
									FROM #rtw_raworig rtw1
									WHERE rtw1.claim = rtw.claim 
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart
											and rtw1.ppend = rtw.ppend)
					,DET_weekly = (SELECT MAX(DET_weekly) 
									FROM #rtw_raworig rtw1
									WHERE	rtw1.claim = rtw.claim 
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart
											and rtw1.ppend = rtw.ppend)
			FROM #rtw_raworig rtw
			GROUP BY claim,
					paytype,
					rtw_paytype,
					ppstart,
					ppend,
					hrs_per_week
					
			/*	
			- Records with payment amount equal to zero are removed;
			- Records associated with payments of pre-reform benefits (s36, s37, s38, s40) with hours
			paid for partial incapacity and hours paid for total incapacity both equal to zero are
			removed;
			*/
			DELETE FROM #rtw_raworig_2 WHERE payamt = 0 or (hrs_total = 0 
				and rtw_paytype in ('TI', 'S38', 'S40'))
				
			/* retrieve claim policy info */
			INSERT INTO #policy
				SELECT	POLICY_NO
						, RENEWAL_NO
						, BTP					
						, WAGES0
						, Process_Flags					
					FROM dbo.PREMIUM_DETAIL pd
					WHERE EXISTS (SELECT 1 FROM #claim cd where cd.policyno = pd.POLICY_NO)
					ORDER BY POLICY_NO,RENEWAL_NO
				
			/* retrieve activity detail audit info */
			INSERT INTO #activity_detail_audit
				SELECT Policy_No, Renewal_No, Tariff, SUM(ISNULL(Wages_Shifts, 0))
					FROM ACTIVITY_DETAIL_AUDIT ada
					GROUP BY Policy_No, Renewal_No, Tariff
					HAVING EXISTS (SELECT 1 FROM #claim cd where cd.policyno = ada.Policy_No)
			
			print 'Start to insert data to HEM_RTW table...'
			
			--INSERT INTO dbo.HEM_RTW EXEC [dbo].[usp_Dashboard_HEM_RTW] @yy, @mm, 12, @AsAt
			--INSERT INTO dbo.HEM_RTW EXEC [dbo].[usp_Dashboard_HEM_RTW] @yy, @mm, 6, @AsAt
			--INSERT INTO dbo.HEM_RTW EXEC [dbo].[usp_Dashboard_HEM_RTW] @yy, @mm, 3, @AsAt
			--INSERT INTO dbo.HEM_RTW EXEC [dbo].[usp_Dashboard_HEM_RTW] @yy, @mm, 1, @AsAt
			
			INSERT INTO [Dart].[dbo].[HEM_RTW] EXEC [dbo].[usp_Dashboard_HEM_RTW] @yy, @mm, 12, @AsAt
			INSERT INTO [Dart].[dbo].[HEM_RTW] EXEC [dbo].[usp_Dashboard_HEM_RTW] @yy, @mm, 6, @AsAt
			INSERT INTO [Dart].[dbo].[HEM_RTW] EXEC [dbo].[usp_Dashboard_HEM_RTW] @yy, @mm, 3, @AsAt
			INSERT INTO [Dart].[dbo].[HEM_RTW] EXEC [dbo].[usp_Dashboard_HEM_RTW] @yy, @mm, 1, @AsAt			
			
		END
		SET @i = @i - 1
	END	
	
	-- drop all temp tables
	IF OBJECT_ID('tempdb..#claim') IS NOT NULL drop table #claim
	IF OBJECT_ID('tempdb..#rtw_raworig_temp') IS NOT NULL DROP TABLE #rtw_raworig_temp
	IF OBJECT_ID('tempdb..#summary') IS NOT NULL DROP TABLE #summary
	IF OBJECT_ID('tempdb..#rtw_raworig') IS NOT NULL DROP TABLE #rtw_raworig
	IF OBJECT_ID('tempdb..#rtw_raworig_2') IS NOT NULL DROP TABLE #rtw_raworig_2
	IF OBJECT_ID('tempdb..#policy') IS NOT NULL drop table #policy
	IF OBJECT_ID('tempdb..#activity_detail_audit') IS NOT NULL drop table #activity_detail_audit
	
END

SET ANSI_NULLS OFF

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_RTW_GenerateData] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_RTW_GenerateData] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_RTW_GenerateData] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_HEM_RTW_GenerateData.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_Portfolio.sql  
--------------------------------  
--exec usp_Dashboard_Portfolio_GenerateData 'EML','2014-03-31 23:59'
/****** Object:  StoredProcedure [dbo].[usp_Dashboard_Portfolio]    Script Date: 27/03/2014 14:31:45 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_Portfolio]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_Portfolio]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_Portfolio]
	@System varchar(20),
	@AsAt datetime,
	@Is_Last_Month bit
AS
BEGIN
	SET NOCOUNT ON
	
	/* Drop all temp tables first */
	IF OBJECT_ID('tempdb..#claim') IS NOT NULL DROP table #claim
	IF OBJECT_ID('tempdb..#WCA_EFFECTIVE') IS NOT NULL DROP table #WCA_EFFECTIVE
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT_ALL') IS NOT NULL DROP table #_WEEKLY_PAYMENT_ALL
	IF OBJECT_ID('tempdb..#_incap_date') IS NOT NULL DROP table #_incap_date
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT_ALL_2') IS NOT NULL DROP table #_WEEKLY_PAYMENT_ALL_2
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT') IS NOT NULL DROP table #_WEEKLY_PAYMENT
	IF OBJECT_ID('tempdb..#rtw_raworig_temp') IS NOT NULL DROP table #rtw_raworig_temp
	IF OBJECT_ID('tempdb..#summary') IS NOT NULL DROP table #summary
	IF OBJECT_ID('tempdb..#rtw_raworig') IS NOT NULL DROP table #rtw_raworig
	IF OBJECT_ID('tempdb..#rtw_raworig_2') IS NOT NULL DROP table #rtw_raworig_2
	IF OBJECT_ID('tempdb..#measures') IS NOT NULL DROP table #measures
	
	DECLARE @Reporting_Date datetime
	SET @Reporting_Date = convert(datetime, convert(char, @AsAt, 106)) + '23:59'
	
	SET @AsAt = convert(datetime, convert(char, @AsAt, 106)) + '23:59'
	
	-- determine if this is generating data process for last month or not
	IF @Is_Last_Month = 1
		SET @AsAt = DATEADD(m, DATEDIFF(m, 0, GETDATE()), -1)	-- get the end of last month as input parameter	
	
	-- previous 1 week from @AsAt
	DECLARE @AsAt_Prev_1_Week datetime
	SET @AsAt_Prev_1_Week = DATEADD(WEEK, -1, @AsAt)
	
	-- previous 2 weeks from @AsAt
	DECLARE @AsAt_Prev_2_Week datetime
	SET @AsAt_Prev_2_Week = DATEADD(WEEK, -2, @AsAt)
	
	-- previous 3 weeks from @AsAt
	DECLARE @AsAt_Prev_3_Week datetime
	SET @AsAt_Prev_3_Week = DATEADD(WEEK, -3, @AsAt)
	
	-- previous 4 weeks from @AsAt
	DECLARE @AsAt_Prev_4_Week datetime
	SET @AsAt_Prev_4_Week = DATEADD(WEEK, -4, @AsAt)
	
	-- next week from @AsAt
	DECLARE @AsAt_Next_Week datetime
	SET @AsAt_Next_Week = DATEADD(WEEK, 1, @AsAt)
	
	-- end day of next week from @AsAt
	DECLARE @AsAt_Next_Week_End datetime
	SET @AsAt_Next_Week_End = DATEADD(wk, 1, DATEADD(dd, 7-(DATEPART(dw, @AsAt)), @AsAt))	
	
	DECLARE @DataFrom datetime
	SET @DataFrom = CAST(YEAR(GETDATE())-1 as varchar(5)) + '-01-01'
	
	DECLARE @_curr_fiscal_yr datetime
	SET @_curr_fiscal_yr = case when MONTH(DATEADD(d,-1,DATEADD(WEEK, DATEDIFF(WEEK, 0, @AsAt), 0))) <= 6 
									then CAST(YEAR(DATEADD(d,-1,DATEADD(WEEK, DATEDIFF(WEEK, 0, @AsAt), 0))) AS varchar(5)) + '-06-30'
								else CAST(YEAR(DATEADD(d,-1,DATEADD(WEEK, DATEDIFF(WEEK, 0, @AsAt), 0))) +1 AS varchar(5)) + '-06-30'	  
							end	
	
	-- FOR EXTRACTING RTW_IMPACTING & CALCULATING ENTITLEMENT WEEKS
	DECLARE @SQL varchar(500)
	
	DECLARE @remuneration_start datetime
	DECLARE @remuneration_end datetime
	
	DECLARE @transaction_lag_remuneration_end datetime
	DECLARE @paystartdt datetime
	
	DECLARE @transaction_lag int
	SET @transaction_lag = 3
	
	DECLARE @RTW_start_date datetime
	SET @RTW_start_date = DATEADD(YY, -3, @AsAt)
	
	SET @remuneration_end = cast(CAST(YEAR(@AsAt) as varchar) + '/' +  CAST(MONTH(@AsAt) as varchar) + '/01' as datetime)
	SET @remuneration_start = DATEADD(mm,-3, @remuneration_end)
	SET @remuneration_end = DATEADD(dd, -1, @remuneration_end) + '23:59'
	
	SET @transaction_lag_remuneration_end = DATEADD(mm, @transaction_lag, @remuneration_end)
	
	SET @paystartdt = DATEADD(mm, -@transaction_lag, DATEADD(YY, -2, @remuneration_start))
	
	IF OBJECT_ID('tempdb..#claim') IS NULL
	BEGIN
		/* create #claim table to store claim detail info */
		CREATE TABLE #claim
		(
			claim CHAR(19)
			,hrswrkwk numeric(5,2)
			,Claim_Closed_Flag char(1)
			,Fund tinyint
			,Agency_id char(10)
			,is_exempt bit
			,date_of_injury datetime
			,date_claim_received datetime
			,date_claim_reopened datetime
		)	

		/* create index for #claim table */
		SET @SQL = 'CREATE INDEX pk_claim_' + CONVERT(VARCHAR, @@SPID) + ' ON #claim(claim)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

		INSERT INTO #claim
			SELECT	cd.Claim_Number
					,cd.Work_Hours
					,cada.Claim_Closed_Flag
					,cd.Fund
					,ptda.Agency_id
					,ade.is_exempt
					,cd.Date_of_Injury
					,date_claim_received = case when cada.date_claim_received is null 
													then cada.Date_Claim_Entered 
												else cada.date_claim_received
											end
					,cada.Date_Claim_reopened
			FROM dbo.CLAIM_DETAIL cd LEFT JOIN amendment_exemptions ade on cd.Claim_Number = ade.claim_no 
				LEFT JOIN ptd_audit ptda ON cd.Policy_No = ptda.Policy_No
				INNER JOIN cd_audit cda on cda.claim_no = cd.claim_number
				INNER JOIN CAD_AUDIT cada on cada.claim_no = cd.Claim_Number
				AND isnull(cd.Claim_Number,'') <> ''
				AND cd.is_Null = 0
				AND cd.Fund <> 98
				AND cda.id = (select max(id)
								from cd_audit cda1 
								where cda1.claim_no = cd.claim_number
									and cda1.create_date < @remuneration_end)
				AND cada.id = (select MAX(id)
									from CAD_AUDIT cada1
									where cada1.Claim_no = cada.Claim_no
										AND cada1.Transaction_Date <= @AsAt						
										)
				AND ptda.id = (SELECT MAX(ptda2.id) 
									FROM ptd_audit ptda2
									WHERE ptda2.policy_no = ptda.policy_no
										  AND ptda2.create_date <= @transaction_lag_remuneration_end
								)
END
	
	IF OBJECT_ID('tempdb..#WCA_EFFECTIVE') IS NULL
	BEGIN
		CREATE TABLE #WCA_EFFECTIVE
		(
			claim varchar(19)
			,hrswrkwk numeric(5,2)
			,date_claim_received datetime
			,effective_date datetime
			,Agency_id char(10)
			,is_exempt bit
		)
		
		/* create index for #WCA_EFFECTIVE table */
		SET @SQL = 'CREATE INDEX pk_WCA_EFFECTIVE_' + CONVERT(VARCHAR, @@SPID) + ' ON #WCA_EFFECTIVE(claim)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		/* Find transition date to new calculation */
		INSERT INTO #WCA_EFFECTIVE
			SELECT cd.claim
					,cd.hrswrkwk
					,date_claim_received
					/* First effective date for transition to new calculation for accruing entitlement weeks */
					,effective_date = (SELECT MIN(EFFECTIVE_DATE)
											FROM WORK_CAPACITY_ASSESSMENT
											WHERE CLAIM_NO = cd.claim
												AND EFFECTIVE_DATE is not null)
					,cd.Agency_id
					,cd.is_exempt
				FROM #claim cd
				WHERE cd.Claim_Closed_Flag = 'N'	/* open claims only */
					AND cd.Fund in (2, 4)			/* post 1987 claims only */
	END
	
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT_ALL') IS NULL
	BEGIN
		CREATE TABLE #_WEEKLY_PAYMENT_ALL
		(
			 claim varchar(19)
			 ,payment_no int
			 ,trans_date datetime
			 ,ppstart datetime
			 ,ppend datetime
			 ,payamt money
			 ,wc_Hours smallint
			 ,wc_Minutes smallint
			 ,hours_per_week numeric(4,2)
			 ,wc_payment_type varchar(15)
			 ,date_claim_received datetime
			 ,Agency_id char(10)
			 ,is_exempt bit
			 ,effective_date datetime
			 ,weeks_paid_old float
			 ,incap_week_start datetime
			 ,incap_week_end datetime
			 ,incap_week_start_new datetime
			 ,incap_week_end_new datetime
			 ,trans_amount_prop money
			 ,calc_method char(3)
			 ,latest_paydate datetime
			 ,latest_paydate_prev datetime
		)

		/* create index for #_WEEKLY_PAYMENT_ALL table */
		SET @SQL = 'CREATE INDEX pk_WEEKLY_PAYMENT_ALL_' + CONVERT(VARCHAR, @@SPID) 
			+ ' ON #_WEEKLY_PAYMENT_ALL(claim, payment_no)'
			EXEC(@SQL)
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		INSERT INTO #_WEEKLY_PAYMENT_ALL
		SELECT  pr.Claim_No
				,pr.Payment_no
				,Transaction_date
				,ppstart = case when wca_effect.effective_date > Period_Start_Date and effective_date <= Period_End_Date
									then wca_effect.effective_date
								else Period_Start_Date
							end
				,Period_End_Date
				,payamt = case when (Period_Start_Date is not null OR Period_End_Date is not null)
									AND wca_effect.effective_date > Period_Start_Date and effective_date <= Period_End_Date
									then (Trans_Amount * (DATEDIFF(DAY, wca_effect.effective_date, Period_End_Date) + 1) / (DATEDIFF(DAY, Period_Start_Date, Period_End_Date) + 1))
										+ (Trans_Amount * (DATEDIFF(DAY, Period_Start_Date, DATEADD(dd, -1, wca_effect.effective_date)) + 1) / (DATEDIFF(DAY, Period_Start_Date, Period_End_Date) + 1))
								else Trans_Amount
							end
				,wc_Hours = case when (Period_Start_Date is not null OR Period_End_Date is not null)
									AND wca_effect.effective_date > Period_Start_Date and effective_date <= Period_End_Date
									then (wc_Hours * (DATEDIFF(DAY, wca_effect.effective_date, Period_End_Date) + 1) / (DATEDIFF(DAY, Period_Start_Date, Period_End_Date) + 1))
										+ (wc_Hours * (DATEDIFF(DAY, Period_Start_Date, DATEADD(dd, -1, wca_effect.effective_date)) + 1) / (DATEDIFF(DAY, Period_Start_Date, Period_End_Date) + 1))
								else wc_Hours
							end
				,wc_Minutes = case when (Period_Start_Date is not null OR Period_End_Date is not null)
									AND wca_effect.effective_date > Period_Start_Date and effective_date <= Period_End_Date
									then (wc_Minutes * (DATEDIFF(DAY, wca_effect.effective_date, Period_End_Date) + 1) / (DATEDIFF(DAY, Period_Start_Date, Period_End_Date) + 1))
										+ (wc_Minutes * (DATEDIFF(DAY, Period_Start_Date, DATEADD(dd, -1, wca_effect.effective_date)) + 1) / (DATEDIFF(DAY, Period_Start_Date, Period_End_Date) + 1))
								else wc_Minutes
							end
				,hours_per_week = case when pr.hours_per_week < 1
											then wca_effect.hrswrkwk
										else pr.hours_per_week
									end
				,pr.WC_Payment_Type
				,wca_effect.date_claim_received
				,wca_effect.Agency_id
				,wca_effect.is_exempt
				,wca_effect.effective_date
				,weeks_paid_old = null
											
				/* NEW FORMULA */
				,incap_week_start = null
				,incap_week_end = null
				,incap_week_start_new = null
				,incap_week_end_new = null
				,trans_amount_prop = null
				,calc_method = null
				,latest_paydate = (SELECT MAX(Transaction_date)
										FROM dbo.Payment_Recovery pr1
										WHERE pr1.Claim_No = pr.Claim_No
											AND pr1.Transaction_date <= @AsAt
											AND wc_payment_type IN ('WPT001','WPT002','WPT003','WPT004','WPT005','WPT006','WPT007'
															,'WPP001','WPP002','WPP003', 'WPP004','WPP005','WPP006','WPP007','WPP008'
															,'13','14','15','16'))
				,latest_paydate_prev = null
		FROM dbo.Payment_Recovery pr
				INNER JOIN #WCA_EFFECTIVE wca_effect on pr.Claim_No = wca_effect.claim
		WHERE	Transaction_date <= @AsAt
				AND wc_payment_type IN ('WPT001','WPT002','WPT003','WPT004','WPT005','WPT006','WPT007'
								,'WPP001','WPP002','WPP003', 'WPP004','WPP005','WPP006','WPP007','WPP008'
								,'13','14','15','16')
				
				/* Data Cleansing 1: remove reversed claims */
				AND ABS(Trans_Amount) > 1
	END
	
	/* Drop unused temp table: #WCA_EFFECTIVE */
	IF OBJECT_ID('tempdb..#WCA_EFFECTIVE') IS NOT NULL DROP table #WCA_EFFECTIVE
	
	IF OBJECT_ID('tempdb..#_incap_date') IS NULL
	BEGIN
		CREATE TABLE #_incap_date
		(
			claim varchar(19),
			incapacity_date datetime
		)
		
		/* create index for #_incap_date table */
		SET @SQL = 'CREATE INDEX pk_incap_date_' + CONVERT(VARCHAR, @@SPID)
			+ ' ON #_incap_date(claim)'
			EXEC(@SQL)
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		/* Get incapacity date for new calculations */
		INSERT INTO #_incap_date
		SELECT	claim, incapacity_date = MIN(ppstart)
			FROM #_WEEKLY_PAYMENT_ALL
			WHERE date_claim_received >= '2012-10-01'
			GROUP BY claim
			
		/* Get incapacity date for old calculations */
		INSERT INTO #_incap_date
		SELECT	claim, incapacity_date = MIN(ppstart)
			FROM #_WEEKLY_PAYMENT_ALL
			WHERE wc_payment_type in ('WPT005','WPT006','WPT007','WPP005','WPP006','WPP007','WPP008')
				AND payamt > 0
				AND ppstart >= effective_date
				AND date_claim_received < '2012-10-01'
			GROUP BY claim
	END
	
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT_ALL_2') IS NULL
	BEGIN
		CREATE TABLE #_WEEKLY_PAYMENT_ALL_2
		(
			 claim varchar(19)
			 ,payment_no int
			 ,trans_date datetime
			 ,ppstart datetime
			 ,ppend datetime
			 ,payamt money
			 ,wc_Hours smallint
			 ,wc_Minutes smallint
			 ,hours_per_week numeric(4,2)
			 ,wc_payment_type varchar(15)
			 ,date_claim_received datetime
			 ,Agency_id char(10)
			 ,is_exempt bit
			 ,effective_date datetime
			 ,weeks_paid_old float
			 ,incap_week_start datetime
			 ,incap_week_end datetime
			 ,incap_week_start_new datetime
			 ,incap_week_end_new datetime
			 ,trans_amount_prop money
			 ,calc_method char(3)
			 ,latest_paydate datetime
			 ,latest_paydate_prev datetime
			 ,incapacity_date datetime
		)

		/* create index for #_WEEKLY_PAYMENT_ALL_2 table */
		SET @SQL = 'CREATE INDEX pk_WEEKLY_PAYMENT_ALL_2_' + CONVERT(VARCHAR, @@SPID) 
			+ ' ON #_WEEKLY_PAYMENT_ALL_2(claim, payment_no)'
			EXEC(@SQL)
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		/* For new calculations */
		INSERT INTO #_WEEKLY_PAYMENT_ALL_2
		SELECT	wpa.claim
				,payment_no
				,trans_date = (SELECT MAX(trans_date)
									FROM #_WEEKLY_PAYMENT_ALL wpa1
									WHERE	wpa1.claim = wpa.claim
											and wpa1.ppstart = wpa.ppstart
											and wpa1.ppend = wpa.ppend)
				,ppstart
				,ppend
				,payamt = (SELECT SUM(ISNULL(payamt,0))
								FROM #_WEEKLY_PAYMENT_ALL wpa1
								WHERE	wpa1.claim = wpa.claim
										and wpa1.ppstart = wpa.ppstart
										and wpa1.ppend = wpa.ppend)
				,wc_Hours = (SELECT SUM(ISNULL(wc_Hours,0))
								FROM #_WEEKLY_PAYMENT_ALL wpa1
								WHERE	wpa1.claim = wpa.claim
										and wpa1.ppstart = wpa.ppstart
										and wpa1.ppend = wpa.ppend)
				,wc_Minutes = (SELECT SUM(ISNULL(wc_Minutes,0))
									FROM #_WEEKLY_PAYMENT_ALL wpa1
									WHERE	wpa1.claim = wpa.claim
											and wpa1.ppstart = wpa.ppstart
											and wpa1.ppend = wpa.ppend)
				,hours_per_week
				,wc_payment_type = (SELECT TOP 1 wc_payment_type
										FROM #_WEEKLY_PAYMENT_ALL wpa1
										WHERE	wpa1.claim = wpa.claim
												and wpa1.ppstart = wpa.ppstart
												and wpa1.ppend = wpa.ppend)
				,date_claim_received
				,Agency_id
				,is_exempt
				,effective_date
				,weeks_paid_old
				,incap_week_start
				,incap_week_end
				,incap_week_start_new
				,incap_week_end_new
				,trans_amount_prop
				,calc_method
				,latest_paydate
				,latest_paydate_prev
				,incap.incapacity_date
			FROM #_WEEKLY_PAYMENT_ALL wpa LEFT JOIN #_incap_date incap ON incap.claim = wpa.claim
			WHERE date_claim_received >= '2012-10-01'
			GROUP BY wpa.claim
					,payment_no
					,ppstart 
					,ppend
					,hours_per_week
					,date_claim_received
					,Agency_id
					,is_exempt
					,effective_date
					,weeks_paid_old
					,incap_week_start
					,incap_week_end
					,incap_week_start_new
					,incap_week_end_new
					,trans_amount_prop
					,calc_method
					,latest_paydate
					,latest_paydate_prev
					,incap.incapacity_date
		
		/* Records belong to new calculations with payment amount or hours paid equal to zero are removed */
		DELETE FROM #_WEEKLY_PAYMENT_ALL_2 WHERE payamt = 0 or wc_Hours = 0
		
		/* For old calculations */
		INSERT INTO #_WEEKLY_PAYMENT_ALL_2
		SELECT wpa.*, incap.incapacity_date
			FROM #_WEEKLY_PAYMENT_ALL wpa LEFT JOIN #_incap_date incap ON incap.claim = wpa.claim
			WHERE date_claim_received < '2012-10-01'
			
		/* Drop unused temp tables: #_WEEKLY_PAYMENT_ALL, #_incap_date */
		IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT_ALL') IS NOT NULL DROP table #_WEEKLY_PAYMENT_ALL
		IF OBJECT_ID('tempdb..#_incap_date') IS NOT NULL DROP table #_incap_date
			
		UPDATE #_WEEKLY_PAYMENT_ALL_2
			SET calc_method =
					/* for exempted emergency services claims, old method is used */
					case when UPPER(@System) = 'TMF' and Agency_id in ('10250', '10255', '10355', '10405') and is_exempt = 1
							then 'OLD'
						/* for new claims, new method is applied from the first period start date of a correct positive new payment */
						when date_claim_received >= '2012-10-01'
							then
								case when ppstart >= incapacity_date
										then 'NEW'
									else 'OLD'
								end
						else 
							/* for existing recepients, new method is applied from the latter of effective date and first correct new code */
							case when effective_date is null
									then 'OLD'
								when ppstart >= incapacity_date
									then 'NEW'
								else 'OLD'
							end
					end
			
		/* OLD FORMULA */
		
		UPDATE #_WEEKLY_PAYMENT_ALL_2 SET weeks_paid_old = ISNULL((ISNULL(wc_Hours, 0) + ISNULL(wc_Minutes, 0)/60)
										/ (case when hours_per_week < 1
													then 37.5
												else hours_per_week
											end), 0)
			WHERE calc_method = 'OLD'
		
		/* NEW FORMULA */
		
		/* align payments into incapacity weeks */
		UPDATE #_WEEKLY_PAYMENT_ALL_2
			SET incap_week_start = case when ppstart is not null
											then
												case when datepart(dw,incapacity_date) > datepart(dw,ppstart)
													then dateadd(wk, -1, dateadd(dd, -(datepart(dw, ppstart)-1), ppstart))
															+ datepart(dw,incapacity_date) - 1
													else dateadd(dd, -(datepart(dw, ppstart)-1), ppstart)
															+ datepart(dw,incapacity_date) - 1
												end
										else null
									end
				,incap_week_end = case when ppend is not null
											then
												case when datepart(dw,incapacity_date) > datepart(dw,ppend)
														then dateadd(dd, -(datepart(dw, ppend)-1), ppend)
																+ datepart(dw,incapacity_date) - 2
													else dateadd(wk, 1, dateadd(dd, -(datepart(dw, ppend)-1), ppend)) 
															+ datepart(dw,incapacity_date) - 2
												end
										else null
									end
			WHERE calc_method = 'NEW'
				AND incapacity_date is not null
				AND wc_payment_type in ('WPT005','WPT006','WPT007','WPP005','WPP006','WPP007','WPP008')
		
		/* break down payments into incapacity weeks */
		UPDATE #_WEEKLY_PAYMENT_ALL_2
			SET incap_week_start_new = incap_week_start + 7 * dbo.udf_GetIncapWeekForEntitlement(incap_week_start, incap_week_end)
				,incap_week_end_new = incap_week_start + 7 * dbo.udf_GetIncapWeekForEntitlement(incap_week_start, incap_week_end) + 6
			WHERE calc_method = 'NEW'
				AND dbo.udf_GetIncapWeekForEntitlement(incap_week_start, incap_week_end) <> -1
			
		/* determine the payment date before the latest payment date */
		UPDATE #_WEEKLY_PAYMENT_ALL_2
			SET latest_paydate_prev = (SELECT MAX(Transaction_date)
											FROM dbo.Payment_Recovery pr1
											WHERE pr1.Claim_No = claim
												AND pr1.Transaction_date < latest_paydate
												AND wc_payment_type IN ('WPT001','WPT002','WPT003','WPT004','WPT005','WPT006','WPT007'
																,'WPP001','WPP002','WPP003', 'WPP004','WPP005','WPP006','WPP007','WPP008'
																,'13','14','15','16'))
				,trans_amount_prop = (DATEDIFF(DAY, dbo.udf_MaxDay(ppstart,incap_week_start_new,'1900/01/01'), 
					dbo.udf_MinDay(ppend, incap_week_end_new, '2222/01/01')) + 1)/((DATEDIFF(DAY, ppstart, ppend) + 1) * 1.0) * payamt
			WHERE calc_method = 'NEW'
	END
	
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT') IS NULL
	BEGIN
		CREATE TABLE #_WEEKLY_PAYMENT
		(
			 claim varchar(19)
			 ,payment_no int
			 ,incapacity_start datetime
			 ,incapacity_end datetime
			 ,weeks_paid_old float
			 ,weeks_paid_new float
		)

		/* create index for #_WEEKLY_PAYMENT table */
		SET @SQL = 'CREATE INDEX pk_WEEKLY_PAYMENT_' + CONVERT(VARCHAR, @@SPID) 
			+ ' ON #_WEEKLY_PAYMENT(claim, payment_no)'
			EXEC(@SQL)
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		INSERT INTO #_WEEKLY_PAYMENT
		SELECT  claim
				,payment_no
				,case when calc_method = 'OLD'
						then ppstart
					else incap_week_start_new
				end
				,case when calc_method = 'OLD'
						then ppend
					else incap_week_end_new
				end
				,case when calc_method = 'OLD'
						then weeks_paid_old
					else 0
				end
				,case when calc_method = 'NEW'
						then 1
					else 0
				end
		FROM #_WEEKLY_PAYMENT_ALL_2
		WHERE calc_method = 'OLD'
			
			/* Data Cleansing 2: remove negative adjustments */
			OR (calc_method = 'NEW' AND trans_amount_prop > 1)
	END
	
	IF OBJECT_ID('tempdb..#rtw_raworig_temp') IS NULL
	BEGIN
		/* create #rtw_raworig temp table to store transaction data */
		CREATE TABLE #rtw_raworig_temp
		(
			 claim varchar(19)
			 ,paydate datetime
			 ,paytype varchar(15)
			 ,rtw_paytype varchar(9)			 
			 ,payamt money
			 ,payment_no int
			 ,ppstart datetime
			 ,ppend datetime
			 ,hrs_per_week numeric(5,2)
			 ,hrs_total numeric(14,3)
			 ,DET_weekly money
		)

		/* create index for #rtw_raworig_temp table */
		SET @SQL = 'CREATE INDEX pk_rtw_raworig_temp_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig_temp(claim, payment_no)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		INSERT INTO #rtw_raworig_temp
		SELECT  pr.Claim_No
				, CONVERT(varchar(10), pr.Transaction_date, 120)
				,pr.WC_Payment_Type
				,rtw_paytype=  (CASE WHEN wc_payment_type IN ('14', '15', 'WPT001', 'WPT002', 'WPT003', 'WPT004') 
										THEN 'TI'
									 WHEN wc_payment_type IN ('13', 'WPP001', 'WPP003') 
										THEN 'S38'
									 WHEN wc_payment_type IN ('16', 'WPP002', 'WPP004') 
										THEN 'S40'
									 WHEN wc_payment_type IN ('WPT005', 'WPT006', 'WPT007') 
										THEN 'NOWORKCAP'
									 WHEN wc_payment_type IN ('WPP005', 'WPP006', 'WPP007', 'WPP008') 
										THEN 'WORKCAP' 
								END)
				,Trans_Amount
				,pr.Payment_no
				,Period_Start_Date
				,Period_End_Date
				,pr.hours_per_week
				,hrs_total = (isnull(WC_MINUTES, 0) / 60.0)
								 + isnull(WC_HOURS, 0)
								 + isnull(WC_WEEKS * HOURS_PER_WEEK, 0)
				,isnull(Rate, 0)
		FROM dbo.Payment_Recovery pr
				INNER JOIN dbo.CLAIM_PAYMENT_RUN
						   ON pr.Payment_no = dbo.CLAIM_PAYMENT_RUN.Payment_no
				INNER JOIN #claim cl on pr.Claim_No = cl.claim
		WHERE	Transaction_date >= @paystartdt
				AND cl.Date_of_Injury >= @paystartdt
				AND Transaction_date <= @AsAt
				AND Adjust_Trans_Flag = 'N'
				AND wc_Tape_Month IS NOT NULL
				AND LEFT(wc_Tape_Month, 4) <= YEAR(@AsAt)
				AND wc_Tape_Month <= CONVERT(int, CONVERT(varchar(8), @transaction_lag_remuneration_end,112))
				AND wc_payment_type IN ('WPT001','WPT002','WPT003','WPT004','WPT005','WPT006','WPT007'
										,'WPP001','WPP002','WPP003', 'WPP004','WPP005','WPP006','WPP007','WPP008'
										,'13','14','15','16')
										 
		/* Adjust DET weekly field */
	
		SELECT distinct claim, ppstart, ppend, paytype, DET_weekly = max(DET_weekly) 
			INTO #summary
			FROM #rtw_raworig_temp
		GROUP BY claim,
				ppstart,
				ppend,
				paytype

		UPDATE #rtw_raworig_temp 
			SET DET_weekly = su.DET_weekly
			FROM #summary su
			WHERE	#rtw_raworig_temp.claim = su.claim
					AND #rtw_raworig_temp.ppstart = su.ppstart
					AND #rtw_raworig_temp.ppend = su.ppend
					AND #rtw_raworig_temp.paytype = su.paytype
		
		/* end of adjusting DET weekly field */
		
		/* Drop unused temp table: #summary */
		IF OBJECT_ID('tempdb..#summary') IS NOT NULL DROP table #summary
	END
	
	IF OBJECT_ID('tempdb..#rtw_raworig') IS NULL
	BEGIN
		/* create #rtw_raworig table to store transaction data after summarizing step #1 */
		CREATE TABLE #rtw_raworig
		(
			 claim varchar(19)
			 ,paydate datetime
			 ,paytype varchar(15)
			 ,rtw_paytype varchar(9)
			 ,payamt money
			 ,ppstart datetime
			 ,ppend datetime
			 ,hrs_per_week numeric(5,2)
			 ,hrs_total numeric(14,3)
			 ,DET_weekly money
		)	
		
		/* create index for #rtw_raworig table */
		SET @SQL = 'CREATE INDEX pk_rtw_raworig_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig(claim, rtw_paytype, paydate)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END		
		
		/* summarised trasactions by claim, paydate, paytype, ppstart, ppend */
		INSERT INTO #rtw_raworig
		SELECT  claim
				,paydate
				,paytype
				,rtw_paytype
				,payamt = (SELECT SUM(ISNULL(payamt,0))
								FROM #rtw_raworig_temp rtw1 
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paydate = rtw.paydate
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart 
										and rtw1.ppend = rtw.ppend)							
				,ppstart
				,ppend
				,hrs_per_week
				,hrs_total = (SELECT SUM(ISNULL(hrs_total,0))
								FROM #rtw_raworig_temp rtw1
								WHERE rtw1.claim = rtw.claim 
										and rtw1.paydate = rtw.paydate
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
				,DET_weekly = (SELECT MAX(DET_weekly) 
								FROM #rtw_raworig_temp rtw1
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paydate = rtw.paydate
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
		FROM #rtw_raworig_temp rtw
		GROUP BY claim,
				paydate,
				paytype,
				rtw_paytype,
				ppstart,
				ppend,
				hrs_per_week
		
		/* Drop unused temp table: #rtw_raworig_temp */
		IF OBJECT_ID('tempdb..#rtw_raworig_temp') IS NOT NULL DROP table #rtw_raworig_temp
				
		/* Records with payment amount and hours paid for total incapacity are both zero are removed */
		DELETE FROM #rtw_raworig WHERE hrs_total = 0 and payamt = 0
		
		/* Records with a negative payment amount, but positive hours paid for total incapacity
				have their hours paid changed to be negative. */
		UPDATE #rtw_raworig SET hrs_total = -hrs_total
			WHERE hrs_total > 0 AND payamt < 0
	END
	
	IF OBJECT_ID('tempdb..#rtw_raworig_2') IS NULL
	BEGIN
		/* create #rtw_raworig_2 table to store transaction data after summarizing for step #2 */
		CREATE TABLE #rtw_raworig_2
		(
			 claim varchar(19)
			 ,paydate datetime
			 ,rtw_paytype varchar(9)
			 ,payamt money
			 ,ppstart datetime
			 ,ppend datetime
			 ,hrs_per_week numeric(5,2)
			 ,hrs_total numeric(14,3)
			 ,DET_weekly money
		)	
		
		/* create index for #rtw_raworig_2 table */
		SET @SQL = 'CREATE INDEX pk_rtw_raworig_2_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig_2(claim, rtw_paytype, paydate)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END		
		
		/* summarised transactions by claim, paytype, ppstart, ppend */
		INSERT INTO #rtw_raworig_2
		SELECT  claim
				,paydate = (SELECT MIN(paydate) 
								FROM #rtw_raworig rtw1
								WHERE	rtw1.claim = rtw.claim										
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
				,rtw_paytype
				,payamt = (SELECT SUM(ISNULL(payamt,0))
								FROM #rtw_raworig rtw1 
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart 
										and rtw1.ppend = rtw.ppend)							
				,ppstart
				,ppend
				,hrs_per_week
				,hrs_total = (SELECT SUM(ISNULL(hrs_total,0))
								FROM #rtw_raworig rtw1
								WHERE rtw1.claim = rtw.claim 
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
				,DET_weekly = (SELECT MAX(DET_weekly) 
								FROM #rtw_raworig rtw1
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
		FROM #rtw_raworig rtw
		GROUP BY claim,
				paytype,
				rtw_paytype,
				ppstart,
				ppend,
				hrs_per_week
			
		/* Drop unused temp table: #rtw_raworig */
		IF OBJECT_ID('tempdb..#rtw_raworig') IS NOT NULL DROP table #rtw_raworig
				
		/*
		- Records with payment amount equal to zero are removed;
		- Records associated with payments of pre-reform benefits (s36, s37, s38, s40) with hours
		paid for partial incapacity and hours paid for total incapacity both equal to zero are
		removed; */
		DELETE FROM #rtw_raworig_2 WHERE payamt = 0 or (hrs_total = 0 
			and rtw_paytype in ('TI', 'S38', 'S40'))
	END
	
	/* create #measures table that */
	CREATE TABLE #measures
	(
		claim CHAR(19)
		,paytype varchar(9)
		,payamt money
		,hrs_per_week_adjusted numeric(5,2)
		,days_for_TI int
		,LT_TI float
		,LT_S38 float
		,LT_S40 float
		,LT_NWC float
		,LT_WC float
	)
	
	INSERT INTO #measures
	SELECT DISTINCT 
			pr.Claim
			,pr.rtw_paytype
			,pr.payamt
			
			-- adjust hours worked per week to be a minimum of 1 and a maximum of 40;
			,hrs_per_week_adjusted = dbo.udf_MinValue(40
											  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0
														then cd.hrswrkwk 
													 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
														then 1  
													 else isnull(cd.hrswrkwk,pr.hrs_per_week) 
												end)
											  )
			
			-- calculate total incapacity days off work
			,days_for_TI = (case when rtw_paytype = 'TI'
										and datepart(dw,pr.ppstart) IN (1,7)
										and datepart(dw,pr.ppend) IN(1,7) 
										and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
									then DATEDIFF(day,pr.ppstart,pr.ppend) + 1					
								when pr.ppstart = pr.ppend 
									then 1 
								else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
							end)
						
			-- calculate days off work for pre-reform claims - Total incapacity payment
			,LT_TI = (CASE when	rtw_paytype = 'TI'
								and dbo.udf_MinValue(40 
												   ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
															 then cd.hrswrkwk 
														  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1
															 then 1 
														  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
													 end
													 )
													) >= 35 
								then 1.0 
									 * (pr.hrs_total* 5)
									 / nullif(dbo.udf_MinValue(40
													   ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													   ),0) 
									* dbo.udf_CheckPositiveOrNegative(pr.payamt)
						 when rtw_paytype = 'TI' 
							  and dbo.udf_MinValue(40 
												  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
															then cd.hrswrkwk
														when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
															then 1  
														else isnull(cd.hrswrkwk,pr.hrs_per_week) 
													end)
												 ) < 35 
							then 1.0 
								 * (pr.hrs_total * 5 /37.5)
								 * dbo.udf_CheckPositiveOrNegative(pr.payamt)
						else 0 
					END)
					
			-- calculate days off work for pre-reform claims - Section 38 payment
			,LT_S38 = (CASE when rtw_paytype = 'S38'
								 and (case when pr.ppstart = pr.ppend 
												then 1 
										   else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									 end) = 0 
								then 0
							when rtw_paytype = 'S38' 
								 and dbo.udf_MinValue(40
													 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													 ) >= 35 
								then 1.0 * (case when pr.ppstart = pr.ppend
													then 1
												else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
											end)
									 * dbo.udf_CheckPositiveOrNegative(pr.payamt)
							when rtw_paytype = 'S38'
								 and dbo.udf_MinValue(40
													  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															 else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													  ) < 35  
								and dbo.udf_MinValue(40
													 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1 
															else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													) > 0 
								then 1.0 * (case when pr.ppstart = pr.ppend
													then 1
												else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
											end)
									  * dbo.udf_CheckPositiveOrNegative(pr.payamt) 
									  * dbo.udf_MinValue(40
												 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
															then cd.hrswrkwk 
														when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
															then 1
														else isnull(cd.hrswrkwk,pr.hrs_per_week)
													end)
												 )
									  /37.5
										
							else 0
					END)
					
			-- calculate days off work for pre-reform claims - Section 40 payment
			,LT_S40 = (CASE when rtw_paytype = 'S40'
								and (case when pr.ppstart = pr.ppend 
												then 1 
										  else
												dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									end) = 0 
								then 0
							when rtw_paytype = 'S40'
								 and dbo.udf_MinValue(40
													  , (case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
															  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
												      ) >= 35 
								then 1.0 * (case when pr.ppstart = pr.ppend
													then 1
												else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
											end)
									 * 0.75
									 * dbo.udf_CheckPositiveOrNegative(pr.payamt)
							when rtw_paytype = 'S40' 
								 and dbo.udf_MinValue(40
											 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
														then cd.hrswrkwk 
													 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
														then 1  
													 else isnull(cd.hrswrkwk,pr.hrs_per_week) end)
												) < 35
								then 1.0 * (case when pr.ppstart = pr.ppend
													then 1
												else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
											end)
									   * 0.75 
									   * dbo.udf_CheckPositiveOrNegative(pr.payamt) 
									   * dbo.udf_MinValue(40
												  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
															then cd.hrswrkwk 
														  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
															then 1  
														  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
													 end)
													)
										/37.5
								else 0
						END)
						
			-- calculate days off work for post reform claims - no current work capacity
			,LT_NWC = (CASE when rtw_paytype = 'NOWORKCAP' 
								and dbo.udf_MinValue(40
													 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1 
															else isnull(cd.hrswrkwk,pr.hrs_per_week) 
													  end)
													  ) >= 35 
								then 1.0 * (pr.payamt* 5)/ nullif(pr.DET_weekly,0)
							when rtw_paytype = 'NOWORKCAP' 
								 and dbo.udf_MinValue(40 
													  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															 else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													  ) < 35 
								then 1.0 
									 * (pr.payamt / nullif(pr.DET_weekly,0) / 37.5)
									 * 5
									 *dbo.udf_MinValue(40
														,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																   then cd.hrswrkwk 
															   when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1  
															   else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														  end)
														  )
								else 0 
						END)
						
			-- calculate days off work for post reform claims - current work capacity
			,LT_WC = (CASE when rtw_paytype = 'WORKCAP'
								  and dbo.udf_MinValue(40
														,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																   then cd.hrswrkwk 
															   when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																   then 1 
															   else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														 end)
														) >= 35 
								 then 1.0 * (pr.payamt* 5) / nullif(pr.DET_weekly,0)
							  when rtw_paytype = 'WORKCAP' 
								  and dbo.udf_MinValue(40 
														,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																   then cd.hrswrkwk 
															   when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																   then 1  
															   else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													   ) < 35 
								 then 1.0 
									  * (pr.payamt / nullif(pr.DET_weekly,0) / 37.5)
									  * 5
									  *dbo.udf_MinValue(40
														 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
																when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1  
																else isnull(cd.hrswrkwk,pr.hrs_per_week) 
															end)
														   )
							  else 0 
						END)
	FROM #claim cd INNER JOIN #rtw_raworig_2 pr ON cd.Claim = pr.Claim
	WHERE cd.Date_of_Injury >= @paystartdt
	
	/* Drop unused temp tables: #claim, #rtw_raworig_2 */
	IF OBJECT_ID('tempdb..#claim') IS NOT NULL DROP table #claim
	IF OBJECT_ID('tempdb..#rtw_raworig_2') IS NOT NULL DROP table #rtw_raworig_2
	
	/* delete small transactions */

	/* small transactions with $2 per day for S40 and WC payments */
	DELETE FROM #measures WHERE (CASE WHEN paytype in ('S40') AND days_for_TI <> 0 
											AND hrs_per_week_adjusted >= 35 
											AND (1.0 * payamt / nullif(days_for_TI,0)) < 2 
										THEN 1
									 WHEN paytype in ('S40') AND days_for_TI <> 0 
											AND hrs_per_week_adjusted < 35 
											AND (1.0 * payamt / nullif(((days_for_TI*hrs_per_week_adjusted)/37.5),0)) < 2 
										THEN 1 
									 WHEN paytype in ('S40') AND days_for_TI = 0 
											AND LT_S40 <> 0 AND (1.0 * payamt / nullif(LT_S40,0)) < 2  
										THEN 1
									 WHEN paytype in ('WORKCAP') AND LT_WC <> 0 AND (1.0 * payamt / nullif(LT_WC,0)) < 2 
										THEN 1
									 ELSE 0
								  END = 1)

	/* other small transactions with payment amount < $20 per day */
	DELETE FROM #measures WHERE (CASE WHEN  paytype in ('S38','TI','NOWORKCAP') 
										    and (LT_TI + LT_S38 + LT_NWC) <> 0 
										    and (1.0 * payamt / nullif((LT_TI + LT_S38 + LT_NWC),0)) < 20 
										  THEN 1
									  ELSE 0
								 END = 1)
	/* end delete small transactions */
	
	SELECT	'Group' = CASE WHEN UPPER(@System) = 'TMF'
								THEN dbo.udf_TMF_GetGroupByTeam(co.Grp)
							WHEN UPPER(@System) = 'EML'
								THEN
									CASE WHEN (rtrim(isnull(co.Grp,''))='')
										OR NOT EXISTS (select distinct grp 
														from claims_officers 
														where active = 1 and len(rtrim(ltrim(grp))) > 0 
															  and grp like co.Grp+'%')										
										OR (co.Grp NOT LIKE 'wcnsw%' or PATINDEX('WCNSW', RTRIM(co.Grp))>0)
											THEN 'Miscellaneous'
										WHEN PATINDEX('WCNSW%', co.Grp) = 0
											THEN Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1)
										WHEN rtrim(co.Grp) = 'WCNSW' 
											THEN 'WCNSW(Group)'
										ELSE SUBSTRING(Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1), 1, 
											CASE WHEN PATINDEX('%[A-Z]%', 
														SUBSTRING(rtrim(co.Grp), 6, LEN(rtrim(co.Grp)) - 5)) > 0 
												THEN (PATINDEX('%[A-Z]%', 
														SUBSTRING(rtrim(co.Grp), 6, LEN(rtrim(co.Grp)) - 5)) + 4) 
												ELSE LEN(rtrim(co.Grp)) 
											END)
									END
							WHEN UPPER(@System) = 'HEM'
								THEN
									CASE WHEN (rtrim(isnull(co.Grp,'')) = '')
										OR NOT EXISTS (select distinct grp
															from claims_officers 
															where active = 1 and LEN(RTRIM(LTRIM(grp))) > 0 
																  and grp like co.Grp + '%')
										OR co.Grp NOT LIKE 'hosp%'
											THEN 'Miscellaneous'
										WHEN PATINDEX('HEM%', co.Grp) = 0 THEN RTRIM(co.Grp)
										ELSE SUBSTRING(rtrim(co.Grp), 1, 
												CASE WHEN PATINDEX('%[A-Z]%',
															SUBSTRING(RTRIM(co.Grp), 4, LEN(RTRIM(co.Grp)) - 3)) > 0 
													THEN (PATINDEX('%[A-Z]%', 
															SUBSTRING(RTRIM(co.Grp), 4, LEN(RTRIM(co.Grp)) - 3)) + 2) 
													ELSE LEN(rtrim(co.Grp))
												END)
									END
						END
			
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' THEN 'Miscellaneous' ELSE RTRIM(UPPER(co.Grp)) END			
			,Case_Manager = ISNULL(UPPER(co.First_Name + ' ' + co.Last_Name), 'Miscellaneous')
			,Agency_Name = dbo.udf_GetAgencyNameByPolicyNo(cd.Policy_no)
			,Agency_Id = UPPER(ptda.Agency_id)
			,Policy_No = cd.policy_no
			,Sub_Category = RTRIM(dbo.udf_GetSubCategoryByPolicyNo(cd.Policy_no))
			,EMPL_SIZE = (CASE WHEN pd.BTP IS NULL OR pd.Process_Flags IS NULL OR pd.WAGES0 IS NULL then 'A - Small'
							  WHEN pd.WAGES0 <= 300000 then 'A - Small'
							  WHEN pd.WAGES0 > 300000 AND pd.WAGES0 <= 1000000 AND pd.Process_Flags = 1 then 'A - Small'
							  WHEN pd.WAGES0 > 300000 AND pd.WAGES0 <= 1000000 AND pd.Process_Flags <> 1 then 'B - Small-Medium'
							  WHEN pd.WAGES0 > 1000000 AND pd.WAGES0 <= 5000000 then 'C - Medium'
							  WHEN pd.WAGES0 > 5000000 AND pd.WAGES0 <= 15000000 AND pd.BTP <= 100000 then 'C - Medium'
							  WHEN pd.WAGES0 > 15000000 then 'D - Large'
							  WHEN pd.WAGES0 > 5000000 AND pd.BTP > 100000 then 'D - Large'
							  ELSE 'A - Small'
						  END)
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			
			-- retrieve portfolio info
			,Portfolio = case when ISNULL(anz.DESCRIPTION,'')<>''
								then
									case when UPPER(anz.DESCRIPTION) = 'ACCOMMODATION' 
											or UPPER(anz.DESCRIPTION) = 'PUBS, TAVERNS AND BARS'
											or UPPER(anz.DESCRIPTION) = 'CLUBS (HOSPITALITY)' then anz.DESCRIPTION
										else 'Other'
									end
								else
									case when LEFT(ada.Tariff, 1) = '1' and LEN(ada.Tariff) = 7
											then 
												case when SUBSTRING(CAST(ada.Tariff as CHAR(7)), 2, 6) = '571000'
													then 'Accommodation'
												when SUBSTRING(CAST(ada.Tariff as CHAR(7)), 2, 6) = '572000'
													then 'Pubs, Taverns and Bars'
												when SUBSTRING(CAST(ada.Tariff as CHAR(7)), 2, 6) = '574000'
													then 'Clubs (Hospitality)'
												else 'Other'
											end
										else 
											case when ada.Tariff = 571000 then 'Accommodation'
												when ada.Tariff = 572000 then 'Pubs, Taverns and Bars'
												when ada.Tariff = 574000 then 'Clubs (Hospitality)'
												else 'Other'
											end
									end
							end
			,Reporting_Date = @Reporting_Date
			,Claim_No = cd.Claim_Number
			,WIC_Code = cd.Tariff_No
			,Company_Name = ISNULL((select LEGAL_NAME from POLICY_TERM_DETAIL ptd where ptd.POLICY_NO = pd.POLICY_NO),cd.policy_no)
			,Worker_Name = cd.Given_Names + ', ' + cd.Last_Names
			,Employee_Number = cd.Employee_no
			,Worker_Phone_Number = cd.Phone_no
			,Claims_Officer_Name = co.First_Name + ' ' + co.Last_Name
			,Date_of_Birth = cd.Date_of_Birth
			,Date_of_Injury = cd.Date_of_Injury
			,Date_Of_Notification = cd.Date_Notice_Given
			,Notification_Lag = case when cd.Date_of_Injury IS NULL then -1
									 else
										(case when ISNULL(DATEDIFF(day,cd.Date_of_Injury, cd.Date_Notice_Given), 0) < 0
												then 0
											else ISNULL(DATEDIFF(day,cd.Date_of_Injury, cd.Date_Notice_Given), 0)
										end)
								end
			,Entered_Lag = DATEDIFF(day,cada.date_claim_received, cada.date_claim_entered)
			,Claim_Liability_Indicator_Group = dbo.udf_GetLiabilityStatusById(cada.Claim_Liability_Indicator)
			,Investigation_Incurred = (select SUM(ed.Amount)
											from ESTIMATE_DETAILS ed 
											where ed.[Type] = '62' and ed.Claim_No = cada.Claim_no)
			,Total_Paid = (select ISNULL(SUM(pr.Trans_Amount),0) -
									ISNULL(SUM(pr.itc),0) -
									ISNULL(SUM(pr.dam),0) +
									ISNULL(SUM(pr.gst),0)
									from Payment_Recovery pr
									where pr.Claim_No = cada.Claim_no
										and Transaction_Date <= @AsAt)
			,Is_Time_Lost = cdba.is_Time_Lost
			,Claim_Closed_Flag = cada.Claim_Closed_Flag
			,Date_Claim_Entered = cada.Date_Claim_Entered
			,Date_Claim_Closed = cada.Date_Claim_Closed
			,Date_Claim_Received = cada.date_claim_received
			,Date_Claim_Reopened = cada.Date_Claim_reopened
			,Result_Of_Injury_Code = cdau.Result_of_Injury_Code
			,WPI = cada.WPI
			,Common_Law = case when (select SUM(ed1.Amount) 
										from ESTIMATE_DETAILS ed1 
										where cada.Claim_no = ed1.Claim_No and ed1.[Type] = '57') > 0 
									then 1
							   else 0
						  end
			,Total_Recoveries = (select ISNULL(SUM(pr.Trans_Amount),0) 
									from Payment_Recovery pr 
									where pr.Claim_No = cada.Claim_no and pr.Estimate_type = '76') +
										(select ISNULL(SUM(pr.Trans_Amount),0) 
											from Payment_Recovery pr 
											where pr.Claim_No = cada.Claim_no 
												and pr.Estimate_type in ('70','71','72','73','74','75','77'))			
			,Is_Working = 	case when cada.Work_Status_Code in (1,2,3,4,14) then 1
								 when cada.Work_Status_Code in (5,6,7,8,9) then 0
							end
			,Physio_Paid = (select SUM(Trans_amount) from Payment_Recovery pr
								where claim_no=CADA.Claim_no
									and (payment_type='05' or payment_type like 'pta%' or payment_type like 'ptx%')
									and estimate_type='55'
									and pr.Transaction_Date < @AsAt
							)
			,Chiro_Paid = (select SUM(Trans_amount) from Payment_Recovery pr
								where claim_no=CADA.Claim_no
									and (payment_type='06' or payment_type like 'cha%' or payment_type like 'chx%')
									and estimate_type='55'
									and pr.Transaction_Date < @AsAt
							)
			,Massage_Paid = (select SUM(Trans_amount) from Payment_Recovery pr
								where claim_no=CADA.Claim_no
									and (payment_type like 'rma%' or payment_type like 'rmx%')
									and estimate_type='55'
									and pr.Transaction_Date < @AsAt
								)	
			,Osteopathy_Paid = (select SUM(Trans_amount) from Payment_Recovery pr
									where claim_no=CADA.Claim_no
										and (payment_type like 'osa%' or payment_type like 'osx%')
										and estimate_type='55'
										and pr.Transaction_Date < @AsAt
								)
			,Acupuncture_Paid = (select SUM(Trans_amount) from Payment_Recovery pr
									where claim_no=CADA.Claim_no
										and (payment_type like 'ott001')
										and estimate_type='55'
										and pr.Transaction_Date < @AsAt
								)
			,Create_Date = getdate()
			,Is_Stress = case when cd.Mechanism_of_Injury in (81,82,84,85,86,87,88)
								OR cd.Nature_of_Injury in (910,702,703,704,705,706,707,718,719)
								then 1
							else 0
						  end
			,Is_Inactive_Claims = case when
									(select ISNULL(SUM(pr.Trans_Amount),0) -
										ISNULL(SUM(pr.itc),0) -
										ISNULL(SUM(pr.dam),0)
										from Payment_Recovery pr
										where pr.Claim_No = cada.Claim_no
											and Transaction_Date <= @AsAt
											and Transaction_Date >= DATEADD(MM, -3, @AsAt)) = 0
											then 1
										else 0
									end
			,Is_Medically_Discharged = case when cd.Employment_Terminated_Reason = 2 then 1
											else 0
									   end
			,Is_Exempt = ade.is_exempt
			,Is_Reactive = case when exists (select distinct claim
												from #_WEEKLY_PAYMENT_ALL_2 wp
												where wp.claim = cada.Claim_no
													and trans_date >= @paystartdt
													and latest_paydate_prev is not null
													and DATEDIFF(MONTH, latest_paydate_prev, latest_paydate) > 3)
									then 1
								else 0
							end
			,Is_Medical_Only = cd.Is_Medical_Only
			,Is_D_D = case when cd.Employment_Terminated_Reason = 2
									then 1
								else 0
							end
			,NCMM_Actions_This_Week = (case when cada.Claim_Closed_Flag = 'Y'
												then ''
											else
												(case when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 2
														then 'First Response Protocol- ensure RTW Plan has been developed'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 3
														then 'Complete 3 week Strategic Plan'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 4
														then 'Treatment Provider Engagement'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 6
														then 'Complete 6 week Strategic Review'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 10
														then 'Complete 10 Week First Response Review'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 16
														then 'Complete 16 Week Internal Panel Review'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 20
														then 'Complete 20 Week Tactical Strategy Review'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 26
														then 'Complete 26 week Employment Direction Pathyway Review (Internal Panel)'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 40
														then 'Complete 40 Week Tactical Strategy Review'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 52
														then 'Complete 52 week  Employment Direction Determination (Internal Panel)'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 65
														then 'Complete 65 Week Tactical Strategy Review'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 76
														then 'Complete 78 week Review in preparation for 78 week panel/handover ( Book Internal Panel)-panel in 2 weeks'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 78
														then 'Complete 78 week Internal Panel Review'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 90
														then 'Complete 90 Week Work Capacity Review (Internal Panel)'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 100
														then 'Complete 100 week Work Capacity Review'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 114
														then 'Complete 114 week Work Capacity Review'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 132
														then 'Complete 132 week Internal Panel'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 > 132
															and (DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 - 132) % 13 = 0
															and CEILING((DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 - 132) / 13) % 2 = 0
														then 'Recovering Independence Internal Panel Review'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 > 132
															and (DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 - 132) % 13 = 0
															and CEILING((DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 - 132) / 13) % 2 <> 0
														then 'Recovering Independence Quarterly Review'
													else ''
												end)
										end)
			,NCMM_Actions_Next_Week = (case when cada.Claim_Closed_Flag = 'Y'
												then ''
											else
												(case when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 2
														then 'Prepare for 3 week Strategic Plan- due next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 5
														then 'Prepare for 6 week Strategic Review (book Internal panel)- panel next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 9
														then 'Prepare for 10 week First Response Review- review due next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 14
														then 'Prepare for 16 Week Internal Panel Review ( book Internal Panel)- panel in 2 weeks'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 15
														then 'Prepare for 16 Week Internal Panel Review- panel next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 18
														then 'Prepare 20 Week Tactical Strategy Review -review due  in 2 weeks'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 19
														then 'Prepare 20 Week Tactical Strategy Review-  review due next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 24
														then 'Prepare 26 Week Employment Direction Pathway Review ( book internal panel)- panel in 2 weeks'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 25
														then 'Prepare 26 Week Employment Direction Pathway Review-panel next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 38
														then 'Prepare 40 Week Tactical Strategy Review-review due in 2 weeks'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 39
														then 'Prepare 40 Week Tactical Strategy Review- review due next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 50
														then 'Prepare Employment Direction Determination Review ( book Internal Panel)-panel  in 2 weeks'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 51
														then 'Prepare Employment Direction Determination Review-panel next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 63
														then 'Prepare 65 Week Tactical Strategy Review- review due in 2 weeks'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 64
														then 'Prepare 65 Week Tactical Strategy Review- review due next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 75
														then 'Start preparing  78 week  Work Capacity Review - review to be completed  in week 76 as preparation for handover'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 77
														then 'Prepare Review for 78 week panel- Panel next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 88
														then 'Prepare 90 Week Work Capacity Review (book internal panel)-panel  in 2 weeks'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 89
														then 'Prepare 90 Week Work Capacity Review -panel next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 98
														then 'Prepare 100 week Work Capacity Review- review due in 2 weeks'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 99
														then 'Prepare 100 week Work Capacity Review- review due next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 112
														then 'Prepare 114 week Work Capacity Review-review due in 2 weeks'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 113
														then 'Prepare 114 week Work Capacity Review- review due next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 130
														then 'Prepare 132 week Internal Panel (Book Internal panel)- panel in 2 weeks'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 131
														then 'Prepare 132 week Internal Panel- panel next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 > 132
															and (DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 - 132) % 13 = 11
															and CEILING((DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 - 132) / 13) % 2 = 0
														then 'Prepare review for  Internal Panel (Book Internal panel)- panel in 2 weeks'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 > 132
															and (DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 - 132) % 13 = 12
															and CEILING((DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 - 132) / 13) % 2 = 0
														then 'Prepare review  for Internal Panel- panel next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 > 132
															and (DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 - 132) % 13 = 11
															and CEILING((DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 - 132) / 13) % 2 <> 0
														then 'Prepare Recovering Independence Quarterly Review-review due in 2 weeks'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 > 132
															and (DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 - 132) % 13 = 12
															and CEILING((DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 - 132) / 13) % 2 <> 0
														then 'Prepare Recovering Independence Quarterly Review- review due next week'
													else ''
												end)
										end)
			,HoursPerWeek = ISNULL(tld.Deemed_HoursPerWeek, 0)
			,Is_Industrial_Deafness = case when cd.Nature_of_Injury in (152,250,312,389,771)
												then 1
											else 0
										end
			,Rehab_Paid = (select SUM(Trans_amount) from Payment_Recovery pr
									where claim_no=CADA.Claim_no
										and (payment_type like 'or%' or payment_type = '04')
										and Transaction_Date <= @AsAt
										and Transaction_Date >= DATEADD(MM, -3, @AsAt)
							)
			,Action_Required = case when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) in (2,3,4,5,6,9,10,14,15,16,18,19,20,
																					 24,25,26,38,39,40,50,51,52,63,64,65,
																					 75,77,76,78,88,89,90,98,99,100,112,113,
																					 114,130,131,132) 
									  OR (DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) -132) % 13 = 0
										  AND CEILING((DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) - 132) / 13) % 2 = 0)
									  OR (DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) -132) % 13 = 0
										  AND CEILING((DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) - 132) / 13) % 2 <> 0)
									  OR (DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) -132) % 13 = 11
										  AND CEILING((DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) - 132) / 13) % 2 = 0)
									  OR (DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) -132) % 13 = 12
										  AND CEILING((DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) - 132) / 13) % 2 = 0)
									  OR (DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) -132) % 13 = 11
										  AND CEILING((DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) - 132) / 13) % 2 <> 0)
									  OR (DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) -132) % 13 = 12
										  AND CEILING((DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) - 132) / 13) % 2 <> 0) then 'Y'
									else 'N'
							   end
			,RTW_Impacting = case when measure.LT > 5 and cd.Date_of_Injury between @RTW_start_date and @AsAt
									then 'Y'
								else 'N'
							end
			,Weeks_In = DATEDIFF(week,cd.Date_of_Injury,@AsAt_Next_Week_End)
			,Weeks_Band = case when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) between 0 and 12 then 'A.0-12 WK'
							   when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) between 13 and 18 then 'B.13-18 WK'
							   when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) between 19 and 22 then 'C.19-22 WK'
							   when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) between 23 and 26 then 'D.23-26 WK'
							   when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) between 27 and 34 then 'E.27-34 WK'
							   when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) between 35 and 48 then 'F.35-48 WK'
							   when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) between 48 and 52 then 'G.48-52 WK'
							   when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) between 53 and 60 then 'H.53-60 WK'
							   when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) between 61 and 76 then 'I.61-76 WK'
							   when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) between 77 and 90 then 'J.77-90 WK'
							   when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) between 91 and 100 then 'K.91-100 WK'
							   when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) between 101 and 117 then 'L.101-117 WK'
							   when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) between 118 and 130 then 'M.118-130 WK'
							   when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) > 130 then 'N.130+ WK'
						  end
			,Hindsight = case when cd.Date_of_Injury > DATEADD(day, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-36,@_curr_fiscal_yr)) + 1, 0))
								 and  cd.Date_of_Injury <= DATEADD(day, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-24,@_curr_fiscal_yr)) + 1, 0)) 
								 then '3 years'
							  when cd.Date_of_Injury > DATEADD(day, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-60,@_curr_fiscal_yr)) + 1, 0))
								 and  cd.Date_of_Injury <= DATEADD(day, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-48,@_curr_fiscal_yr)) + 1, 0)) 
								 then '5 years'
							  else ''
						 end
			,Active_Weekly = case when (Select ISNULL(SUM(pr.Trans_Amount),0) -
													ISNULL(SUM(pr.itc),0) -
													ISNULL(SUM(pr.dam),0)as amount
													from Payment_Recovery pr
													where pr.Claim_No = cada.Claim_no
														and Transaction_Date <= @AsAt
														and Transaction_Date >= DATEADD(MM, -3, @AsAt)
														and pr.Estimate_type = '50') <> 0 
										then 'Y'
								  else 'N'
							 end
			,Active_Medical = case when (Select ISNULL(SUM(pr.Trans_Amount),0) -
													ISNULL(SUM(pr.itc),0) -
													ISNULL(SUM(pr.dam),0)as amount
													from Payment_Recovery pr
													where pr.Claim_No = cada.Claim_no
														and Transaction_Date <= @AsAt
														and Transaction_Date >= DATEADD(MM, -3, @AsAt)
														and pr.Estimate_type = '55') <> 0 
										then 'Y'
								  else 'N'
							 end					  
			,Cost_Code = cd.Cost_Code
			,Cost_Code2 = cd.Cost_Code2
			,CC_Injury = (select top 1 Name from cost_code where policy_no =cd.Policy_No and short_name =cd.cost_code)
			,CC_Current = case when (select top 1 Name from cost_code where policy_no =cd.Policy_No and short_name =cd.cost_code2) is null 
									then (select top 1 Name from cost_code where policy_no =cd.Policy_No and short_name =cd.cost_code)
							   else (select top 1 Name from cost_code where policy_no =cd.Policy_No and short_name =cd.cost_code2)
						  end
			,Med_Cert_Status_This_Week = dbo.udf_ExtractMedCertStatus_Code(
									(select [Type] from Medical_Cert MC 
										where MC.ID = (select top 1 ID
															from Medical_Cert MC1
															where MC1.Claim_no = MC.Claim_no
																	and MC1.is_deleted <> 1
																	and MC1.create_date < @AsAt
															order by MC1.Date_From desc, MC1.create_date desc, MC1.ID desc
														)
											and MC.Claim_no = cada.Claim_no))
			,Med_Cert_Status_Next_Week = dbo.udf_ExtractMedCertStatus_Code(
									(select [Type] from Medical_Cert MC 
										where MC.ID = (select top 1 ID
															from Medical_Cert MC1
															where MC1.Claim_no = MC.Claim_no
																	and MC1.is_deleted <> 1
																	and MC1.create_date < @AsAt_Next_Week
															order by MC1.Date_From desc, MC1.create_date desc, MC1.ID desc
														)
											and MC.Claim_no = cada.Claim_no))
			,Capacity = (select case when temp.RTW_Goal = 2 then 'Partial Capacity'
									when temp.RTW_Goal = 3 then 'Full Capacity'
									else 'No Capacity'
							   end
						from (select RTW_Goal from TIME_LOST_DETAIL 
							  where ID = (select MAX(ID) from TIME_LOST_DETAIL 
									      where Claim_no = cd.Claim_Number)) as temp)
			,Entitlement_Weeks = (select SUM(weeks_paid_old + weeks_paid_new)
									from #_WEEKLY_PAYMENT
									where claim = cd.Claim_Number
									group by claim)
			,Med_Cert_Status_Prev_1_Week = dbo.udf_ExtractMedCertStatus_Code(
									(select [Type] from Medical_Cert MC 
										where MC.ID = (select top 1 ID
															from Medical_Cert MC1
															where MC1.Claim_no = MC.Claim_no
																	and MC1.is_deleted <> 1
																	and MC1.create_date < @AsAt_Prev_1_Week
															order by MC1.Date_From desc, MC1.create_date desc, MC1.ID desc
														)
											and MC.Claim_no = cada.Claim_no))
			,Med_Cert_Status_Prev_2_Week = dbo.udf_ExtractMedCertStatus_Code(
									(select [Type] from Medical_Cert MC 
										where MC.ID = (select top 1 ID
															from Medical_Cert MC1
															where MC1.Claim_no = MC.Claim_no
																	and MC1.is_deleted <> 1
																	and MC1.create_date < @AsAt_Prev_2_Week
															order by MC1.Date_From desc, MC1.create_date desc, MC1.ID desc
														)
											and MC.Claim_no = cada.Claim_no))
			,Med_Cert_Status_Prev_3_Week = dbo.udf_ExtractMedCertStatus_Code(
									(select [Type] from Medical_Cert MC 
										where MC.ID = (select top 1 ID
															from Medical_Cert MC1
															where MC1.Claim_no = MC.Claim_no
																	and MC1.is_deleted <> 1
																	and MC1.create_date < @AsAt_Prev_3_Week
															order by MC1.Date_From desc, MC1.create_date desc, MC1.ID desc
														)
											and MC.Claim_no = cada.Claim_no))
			,Med_Cert_Status_Prev_4_Week = dbo.udf_ExtractMedCertStatus_Code(
									(select [Type] from Medical_Cert MC 
										where MC.ID = (select top 1 ID
															from Medical_Cert MC1
															where MC1.Claim_no = MC.Claim_no
																	and MC1.is_deleted <> 1
																	and MC1.create_date < @AsAt_Prev_4_Week
															order by MC1.Date_From desc, MC1.create_date desc, MC1.ID desc
														)
											and MC.Claim_no = cada.Claim_no))
			,Is_Last_Month = @Is_Last_Month
	FROM	CAD_AUDIT cada
			INNER JOIN CLAIM_DETAIL cd on cada.claim_no = cd.Claim_Number
			LEFT JOIN (SELECT rtrim(claim) as Claim_no,
							round(SUM(LT_TI + LT_S38 + LT_S40 + LT_NWC + LT_WC),10) as LT
						FROM #measures
						GROUP BY claim
					) as measure on cd.Claim_Number = measure.Claim_no
			LEFT JOIN ANZSIC anz on cd.ANZSIC = anz.CODE
			LEFT JOIN amendment_exemptions ade on cd.Claim_Number = ade.claim_no
			
			-- for retrieving Agency_Id
			LEFT JOIN ptd_audit ptda ON cd.Policy_No = ptda.Policy_No
			
			INNER JOIN cd_bit_audit cdba on cdba.Claim_Number = cd.Claim_Number
			INNER JOIN cd_audit cdau on cdau.claim_no = cd.Claim_Number
			
			-- for retrieving Group, Team, Case_Manager
			LEFT JOIN CLAIMS_OFFICERS co ON cada.Claims_Officer = co.Alias
			
			-- for retrieving EMPL_SIZE
          	LEFT JOIN PREMIUM_DETAIL pd on pd.POLICY_NO = cd.policy_no and pd.RENEWAL_NO = cd.renewal_no 
          	LEFT JOIN ACTIVITY_DETAIL_AUDIT ada
				ON pd.POLICY_NO = ada.Policy_No and pd.RENEWAL_NO = ada.Renewal_No	
          	
          	-- for retrieving Account_Manager
          	LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number 
          					FROM CLAIM_DETAIL cld 
          						LEFT JOIN POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
								LEFT JOIN Broker Br on PTD.Broker_No = Br.Broker_no 
								LEFT JOIN UnderWriters U on BR.emi_Contact = U.Alias 
							WHERE U.is_Active = 1 AND U.is_EMLContact = 1 ) as acm 
				ON acm.claim_number = cd.Claim_Number
			
			-- for retrieving Deemed Hours Per Week
			LEFT JOIN TIME_LOST_DETAIL tld on cd.Claim_Number = tld.claim_no
			
	WHERE   CADA.ID = (SELECT MAX(ID) FROM CAD_AUDIT CADA1
							WHERE CADA1.CLAIM_NO = CADA.CLAIM_NO
								AND CADA1.Transaction_Date <= @AsAt
							)
			AND cdba.id = (SELECT MAX(cdba2.id)
							  FROM cd_bit_audit cdba2
							  WHERE cdba2.Claim_Number = cdba.Claim_Number
								AND cdba2.Create_date <= @AsAt
							)
			AND cdau.id = (SELECT MAX(cdau2.id)
							  FROM cd_audit cdau2
							  WHERE cdau2.claim_no = cdau.claim_no
								AND cdau2.Create_date <= @AsAt
							)
			AND ptda.id = (SELECT MAX(ptda2.id)
								FROM ptd_audit ptda2
								WHERE ptda2.policy_no = ptda.policy_no
									  AND ptda2.create_date <= @transaction_lag_remuneration_end
							)
			AND cada.Claim_Liability_Indicator <> '6'
			AND cdba.is_Null = 0
			AND cdau.fund not in (1, 3, 98, 99)
			AND cd.Policy_year >= 2000
			AND ISNULL(anz.ID, 1) = ISNULL((SELECT MAX(ID) FROM ANZSIC anz2 
												WHERE anz2.CODE = anz.CODE),1)
			AND ISNULL(ada.ID, 1) =
						ISNULL((SELECT TOP 1 ID
									FROM ACTIVITY_DETAIL_AUDIT ada2
									WHERE ada.Policy_No = ada2.Policy_No
										AND ada.Renewal_No = ada2.Renewal_No
									ORDER BY Policy_No, Renewal_No, CREATE_DATE desc, ID desc), 1)
			AND (cada.Date_Claim_Closed >=@DataFrom or cada.Date_Claim_Closed is null or cada.Date_Claim_Closed <= cada.Date_Claim_reopened)
			AND ISNULL(tld.id, 1) = ISNULL((SELECT MAX(tld2.id)
											  FROM TIME_LOST_DETAIL tld2
											  WHERE tld2.claim_no = tld.claim_no), 1)
											  
	/* Drop remaining temp tables */
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT_ALL_2') IS NOT NULL DROP table #_WEEKLY_PAYMENT_ALL_2
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT') IS NOT NULL DROP table #_WEEKLY_PAYMENT
	IF OBJECT_ID('tempdb..#measures') IS NOT NULL DROP table #measures
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_Portfolio] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_Portfolio] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_Portfolio] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_Portfolio.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_Portfolio_GenerateData.sql  
--------------------------------  
/****** Object:  StoredProcedure [dbo].[usp_Dashboard_Portfolio_GenerateData]    Script Date: 23/04/2014 14:31:45 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_Portfolio_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_Portfolio_GenerateData]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_Portfolio_GenerateData]
	@System varchar(20),
	@AsAt datetime = null
AS
BEGIN
	SET NOCOUNT ON
	if @AsAt is null
		SET @AsAt = GETDATE()
	
	IF UPPER(@System) = 'TMF'
	BEGIN		
		DELETE [Dart].[dbo].[TMF_Portfolio]	WHERE convert(datetime, convert(char, Reporting_Date, 106)) = convert(datetime, convert(char, @AsAt, 106))
		INSERT INTO [Dart].[dbo].[TMF_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @AsAt, 1
		INSERT INTO [Dart].[dbo].[TMF_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @AsAt, 0
	END
	ELSE IF UPPER(@System) = 'EML'
	BEGIN
		DELETE [Dart].[dbo].[EML_Portfolio]	WHERE convert(datetime, convert(char, Reporting_Date, 106)) = convert(datetime, convert(char, @AsAt, 106))
		INSERT INTO [Dart].[dbo].[EML_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @AsAt, 1		
		INSERT INTO [Dart].[dbo].[EML_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @AsAt, 0
	END
	ELSE IF UPPER(@System) = 'HEM'
	BEGIN
		DELETE [Dart].[dbo].[HEM_Portfolio]	WHERE convert(datetime, convert(char, Reporting_Date, 106)) = convert(datetime, convert(char, @AsAt, 106))
		INSERT INTO [Dart].[dbo].[HEM_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @AsAt, 1	
		INSERT INTO [Dart].[dbo].[HEM_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @AsAt, 0
	END
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_Portfolio_GenerateData] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_Portfolio_GenerateData] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_Portfolio_GenerateData] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_Portfolio_GenerateData.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_TMF_AWC.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
-- execute [usp_Dashboard_TMF_AWC] 2013, 1
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_TMF_AWC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_TMF_AWC]
GO

create PROCEDURE [dbo].[usp_Dashboard_TMF_AWC]
      @year int = 2013,
      @month int = 1
AS
BEGIN
	SET NOCOUNT ON
	IF OBJECT_ID('tempdb..#_Claim_list_adjusted') IS NOT NULL DROP TABLE #_Claim_list_adjusted
	IF OBJECT_ID('tempdb..#_Claim_Detail') IS NOT NULL DROP TABLE #_Claim_Detail
	IF OBJECT_ID('tempdb..#_Claim_List') IS NOT NULL DROP TABLE #_Claim_List		
	IF OBJECT_ID('tempdb..#AWC_list') IS NOT NULL DROP table #AWC_list
	
	declare @startdate datetime = cast(cast(@year as char(4)) + '/'  + cast(@month as char(2)) + '/01' as datetime)
	declare @enddate datetime  = dateadd(dd, -1, dateadd(mm, 1, @startdate)) + '23:59'
	
	declare @SQL varchar(500)

	--Check temp table existing then drop
	IF OBJECT_ID('tempdb..#_CLAIM_ESTIMATE_SUMMARY') IS NULL
	BEGIN
		create table #_CLAIM_ESTIMATE_SUMMARY
		(
			CLAIM_NO varCHAR(19)
			,TotalAmount MONEY
		) 
		
		SET @SQL = 'CREATE INDEX pk_CLAIM_ESTIMATE_SUMMARY'+CONVERT(VARCHAR, @@SPID)+' ON #_CLAIM_ESTIMATE_SUMMARY(CLAIM_NO, TotalAmount)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
			 
		INSERT INTO #_CLAIM_ESTIMATE_SUMMARY
		SELECT CLAIM_NO, SUM(ISNULL(Amount, 0))
		FROM ESTIMATE_DETAILS
		GROUP BY claim_no
	END
	
	CREATE TABLE #_Claim_Detail
	(
		policy_no char(19)
		,Claim_no varchar(19)
		,Claim_Closed_Flag CHAR(1)
		,Claim_Liability_Indicator TINYINT
		,renewal_no INT
	)
	
	SET @SQL = 'CREATE INDEX pk_Claim_Detail_'+CONVERT(VARCHAR, @@SPID)+' ON #_Claim_Detail(policy_no, Claim_no, Claim_Closed_Flag, Claim_Liability_Indicator)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	INSERT INTO #_Claim_Detail
		-- claim detail here
		SELECT  policy_no, 
				Claim_Number,
				Claim_Closed_Flag,
				Claim_Liability_Indicator, 
				Renewal_No
		FROM CLAIM_DETAIL cd INNER JOIN CLAIM_ACTIVITY_DETAIL cad 
			ON rtrim(cd.Claim_Number) =  rtrim(cad.Claim_no)
				AND Date_Created <= @enddate AND Claim_Number <> ''
				LEFT OUTER JOIN amendment_exemptions ae ON cd.Claim_Number = ae.claim_no

	CREATE TABLE #_Claim_List
	(
		Claim_no varchar(19)
		,EXCLUDE BIT
	)
	
	SET @SQL = 'CREATE INDEX pk_Claim_List'+CONVERT(VARCHAR, @@SPID)+' ON #_Claim_List(Claim_no, EXCLUDE)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	INSERT INTO #_Claim_List
		SELECT cd.Claim_no
			   ,EXCLUDE = (CASE WHEN (cd.Claim_Liability_Indicator IN (1,6,12)) 
									 OR (cd.Claim_Liability_Indicator IN (4) 
										AND ces.TotalAmount <= 0) 
									 OR (cd.Claim_Closed_Flag = 'Y' AND ces.TotalAmount = 0)  
								   THEN 1 
							   ELSE 0 
						   END)
		FROM #_Claim_Detail cd INNER JOIN #_CLAIM_ESTIMATE_SUMMARY ces 
										  ON cd.Claim_no = ces.CLAIM_NO

	CREATE TABLE #_Claim_list_adjusted
	(
		 Claim_no varchar(19)
		 ,submitted_trans_date datetime
		 ,Period_Start_Date datetime
		 ,Period_End_Date datetime
		 ,WC_Payment_Type varchar(8)
		 ,Payment_Type varchar(15)
		 ,Trans_Amount money
	)
	
	SET @SQL = 'CREATE NONCLUSTERED INDEX pk_Claim_List_submitted_trans_date_
				ON [dbo].[#_Claim_list_adjusted] (submitted_trans_date)
				INCLUDE ([Claim_no])'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	INSERT  INTO #_Claim_list_adjusted
	SELECT  u.claim_no
			, submitted_trans_date
			, Period_Start_Date
			, Period_End_Date
			, WC_Payment_Type
			, Payment_Type 
			, Trans_Amount = (SELECT SUM(ISNULL(u1.Trans_Amount, 0))
								FROM uv_submitted_Transaction_Payments u1 
								WHERE u1.Claim_No = u.claim_no 
								and u1.Period_Start_Date = u.Period_Start_Date
								and u1.Period_End_Date = u.Period_End_Date 
								and u1.WC_Payment_Type = u.WC_Payment_Type 
								and u1.Payment_Type = u.payment_type)
	FROM uv_submitted_Transaction_Payments u
	WHERE u.submitted_trans_date = (SELECT min(u1.submitted_trans_date) 
									FROM uv_submitted_Transaction_Payments u1 
									WHERE u1.Claim_No = u.claim_no 
										  and u1.Period_Start_Date = u.Period_Start_Date 
										  and u1.Period_End_Date = u.Period_End_Date 
										  and u1.WC_Payment_Type = u.WC_Payment_Type 
										  and u1.Payment_Type = u.payment_type)
		and u.submitted_trans_date between @startdate and @enddate
		and u.WeeklyPayment = 1
	GROUP BY u.claim_no, submitted_trans_date
			 ,Period_Start_Date, Period_End_Date
			 ,WC_Payment_Type, Payment_Type
	ORDER BY claim_no, payment_type, Period_Start_Date, Period_End_Date

	SET @SQL = 'CREATE NONCLUSTERED INDEX pk_Claim_List_submitted_trans_date_Trans_Amount
				ON [dbo].[#_Claim_list_adjusted] (Trans_Amount)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	DELETE FROM #_Claim_list_adjusted WHERE Trans_Amount = 0
	DELETE FROM #_Claim_list_adjusted 
		   WHERE CLAIM_NO in (SELECT cla1.claim_no 
							  FROM #_Claim_list_adjusted cla1 
									inner join #_Claim_List cl on cla1.Claim_no = cl.Claim_no 
												and cl.EXCLUDE = 1)

	CREATE TABLE #AWC_list 
	(
		claim_no varchar (19)
		,date_of_injury datetime
	)
	
	SET @SQL = 'CREATE INDEX pk_AWC_list'+CONVERT(VARCHAR, @@SPID)+' ON #AWC_list(Claim_no,date_of_injury)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	INSERT INTO #AWC_list
		SELECT DISTINCT rtrim(cla.claim_no),ca.Date_of_Injury 
		FROM #_Claim_list_adjusted cla 
			 INNER JOIN cd_audit ca ON cla.Claim_no = ca.claim_no 
									   AND cla.submitted_trans_date between @startdate and @enddate
									   AND ca.id = (SELECT MAX(id) 
													FROM cd_audit 
													WHERE ca.claim_no = claim_no 
													AND create_date < @enddate)
										AND ca.fund <> 98
	
	SELECT	Time_ID = @enddate
			,Claim_no = awc_list.Claim_no	
			,'Group' = dbo.udf_TMF_GetGroupByTeam(co.Grp)						
			,Team = CASE WHEN rtrim(isnull(co.Grp,''))='' THEN 'Miscellaneous' ELSE rtrim(UPPER(co.Grp)) END
			,Case_manager = ISNULL ( UPPER(co.First_Name+' '+ co.Last_Name), 'Miscellaneous')					
			,AgencyName =dbo.udf_GetAgencyNameByPolicyNo(cd.Policy_no)
			,awc_list.Date_of_Injury
			,create_date = getdate()	
			,cd.policy_no
			,Agency_id = UPPER(ptda.Agency_id)
			,Sub_category = rtrim(dbo.udf_GetSubCategoryByPolicyNo(cd.Policy_no))
			,Empl_Size = ''
			,Cert_Type = case when mc.TYPE = 'P' 
								then 'No Time Lost' 
						      when mc.TYPE = 'T' 
								then 'Totally Unfit'
							  when mc.TYPE = 'S' 
								then 'Suitable Duties'
							  when mc.TYPE = 'I' 
								then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' 
								then 'Permanently Modified Duties'
							  else 'Invalid type' 
						 end
			,Med_cert_From = mc.Med_cert_From
			,Med_cert_To = mc.Med_cert_To
			,Account_Manager = ''
			,Cell_no = NULL
			,Portfolio = ''
		
	FROM	#AWC_list awc_list
			INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = awc_list.claim_no
			INNER JOIN CLAIMS_OFFICERS CO on cad.Claims_Officer = co.Alias
			INNER JOIN #_Claim_Detail cd on awc_list.claim_no = cd.Claim_No		
			INNER JOIN cad_audit cada1 on cada1.Claim_No = awc_list.claim_no 
			INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
			INNER JOIN ptd_audit ptda ON cd.Policy_No = ptda.Policy_No
			LEFT JOIN (SELECT id, create_date, Claim_no, [Type],Med_cert_From=Date_From,Med_cert_To=Date_To 
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
			LEFT JOIN (SELECT item,value FROM [control] ctra1 WHERE type = 'GroupLevel') ctra1 
          			ON (CHARINDEX('*'+co.grp+'*',ctra1.value)) <> 0
          	
	WHERE   cada1.id = (SELECT MAX(cada2.id) 
					      FROM  cad_audit cada2 
					      WHERE cada2.claim_no = cada1.claim_no
							    AND cada2.transaction_date <= @enddate) 
			AND coa1.id = (SELECT   MAX(coa2.id) 
						     FROM   CO_audit coa2
						     WHERE  coa2.officer_id = coa1.officer_id
								    AND coa2.create_date <= @enddate)
			AND ptda.id = (SELECT MAX(ptda2.id) 
							FROM ptd_audit ptda2
							WHERE ptda2.policy_no = ptda.policy_no 
								  AND ptda2.create_date <= @enddate)
			
	--drop all temp table
	IF OBJECT_ID('tempdb..#_Claim_list_adjusted') IS NOT NULL DROP TABLE #_Claim_list_adjusted
	IF OBJECT_ID('tempdb..#_Claim_Detail') IS NOT NULL DROP TABLE #_Claim_Detail	
	IF OBJECT_ID('tempdb..#_Claim_List') IS NOT NULL DROP TABLE #_Claim_List
	IF OBJECT_ID('tempdb..#AWC_list') IS NOT NULL DROP TABLE #AWC_list
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_AWC] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_AWC] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_AWC] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_TMF_AWC.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_TMF_AWC_GenerateData.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_TMF_AWC_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_TMF_AWC_GenerateData]
Go
-- For example
-- exec [usp_Dashboard_TMF_AWC_GenerateData] 2011, 1
-- this will return all result with time id range from 2011-01-31 23:59 till now

CREATE PROCEDURE [dbo].[usp_Dashboard_TMF_AWC_GenerateData]
	@start_period_year int = 2012,
	@start_period_month int = 10
AS
BEGIN
	SET NOCOUNT ON;
	declare @start_period datetime = CAST(CAST(@start_period_year as varchar) 
											+ '/' + CAST(@start_period_month as varchar) 
											+ '/01' as datetime)	
	declare @end_period datetime = getdate()
	
	declare @loop_time int = DATEDIFF(month, @start_period, @end_period)
	declare @i int = @loop_time 
	declare @temp datetime
	declare @SQL varchar(500)

	---delete last transaction lag number months in dart db---	
	exec('DELETE FROM [DART].[dbo].[TMF_AWC] 
			WHERE Time_ID in (select distinct top 3 Time_ID 
			from [DART].[dbo].[TMF_AWC] order by Time_ID desc)')
	---end delete--	
	
	--Check temp table existing then drop	
	IF OBJECT_ID('tempdb..#_CLAIM_ESTIMATE_SUMMARY') IS NOT NULL DROP TABLE #_CLAIM_ESTIMATE_SUMMARY
		
	CREATE TABLE #_CLAIM_ESTIMATE_SUMMARY
	(
		CLAIM_NO varCHAR(19)
		,TotalAmount MONEY
	) 
	
	SET @SQL = 'CREATE INDEX pk_CLAIM_ESTIMATE_SUMMARY'+CONVERT(VARCHAR, @@SPID)+' ON #_CLAIM_ESTIMATE_SUMMARY(CLAIM_NO, TotalAmount)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		 
	INSERT INTO #_CLAIM_ESTIMATE_SUMMARY
	SELECT CLAIM_NO, SUM(ISNULL(Amount, 0)) FROM ESTIMATE_DETAILS GROUP BY claim_no	
	
	WHILE (@i >= 0)
	BEGIN
		set @temp = DATEADD(mm, @i, @start_period)
		declare @year int = YEAR(@temp)
		declare @month int = MONTH(@temp)
		
		If NOT EXISTS(select 1 from [DART].[dbo].[TMF_AWC] 
							where Year(Time_ID) = @year and
							Month(Time_ID ) = @month)
		   AND cast(CAST(@year as varchar) + '/' +  CAST(@month as varchar) + '/01' as datetime)
				< cast(CAST(year(getdate()) as varchar) + '/' +  CAST(month(getdate()) as varchar) + '/01' as datetime)
		BEGIN		
			print @temp
			--DELETE FROM dbo.TMF_AWC WHERE Time_ID = DATEADD(dd, -1, DATEADD(mm, 1, @temp)) + '23:59'
			--INSERT INTO dbo.TMF_AWC EXEC usp_Dashboard_TMF_AWC @year, @month
			INSERT INTO [DART].[dbo].[TMF_AWC] EXEC usp_Dashboard_TMF_AWC @year, @month
			
		END
		set @i = @i - 1
	END
	--drop temp table 	
	IF OBJECT_ID('tempdb..#_CLAIM_ESTIMATE_SUMMARY') IS NOT NULL drop table #_CLAIM_ESTIMATE_SUMMARY
	
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_AWC_GenerateData] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_AWC_GenerateData] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_AWC_GenerateData] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_TMF_AWC_GenerateData.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_TMF_RTW.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
--  exec [usp_Dashboard_TMF_RTW] 2013, 3, 12 -- 2011M12
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_TMF_RTW]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_TMF_RTW]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_TMF_RTW]
	@yy int,
	@mm int,
	@RollingMonth int -- 1, 3, 6, 12
AS
BEGIN
	SET NOCOUNT ON;	
	IF OBJECT_ID('tempdb..#Tem_ClaimDetail') IS NOT NULL DROP TABLE #Tem_ClaimDetail
	IF OBJECT_ID('tempdb..#TEMP_MEASURES') IS NOT NULL DROP TABLE #TEMP_MEASURES		
	IF OBJECT_ID('tempdb..#TEMP_PREMIUM_DETAIL') IS NOT NULL DROP table #TEMP_PREMIUM_DETAIL
	
	declare @Measure_month_13 int
	declare @Measure_month_26 int
	declare @Measure_month_52 int
	declare @Measure_month_78 int
	declare @Measure_month_104 int
	declare @transaction_Start datetime
	declare @date_of_injury_Start datetime
	declare @remuneration_Start datetime
	declare @remuneration_End datetime
	declare @Transaction_lag int
	declare @Transaction_lag_Remuneration_End datetime
	declare @Transaction_lag_Remuneration_Start datetime

	set @Measure_month_13 =3  -- 13weeks = 3, 26weeks = 6, 52weeks = 12, 78weeks = 18, 104weeks = 24
	set @Measure_month_26 =6  -- 13weeks = 3, 26weeks = 6, 52weeks = 12, 78weeks = 18, 104weeks = 24
	set @Measure_month_52 =12  -- 13weeks = 3, 26weeks = 6, 52weeks = 12, 78weeks = 18, 104weeks = 24
	set @Measure_month_78 =18  -- 13weeks = 3, 26weeks = 6, 52weeks = 12, 78weeks = 18, 104weeks = 24
	set @Measure_month_104 =24  -- 13weeks = 3, 26weeks = 6, 52weeks = 12, 78weeks = 18, 104weeks = 24
	set @Transaction_lag = 3 --for only TMF	

	set @remuneration_End = DATEADD(mm, -@Transaction_lag + 1, cast(CAST(@yy as varchar) + '/' +  CAST(@mm as varchar) + '/01' as datetime))
	set @remuneration_Start = DATEADD(mm,-@RollingMonth, @remuneration_End)
	set @remuneration_End = DATEADD(dd, -1, @remuneration_End) + '23:59'
	set @Transaction_lag_Remuneration_End = DATEADD(MM, @Transaction_lag, @remuneration_End)
	set @Transaction_lag_Remuneration_Start =DATEADD(MM, @Transaction_lag, @remuneration_Start)
	
	
	set @transaction_Start = DATEADD(YY, -3, @remuneration_Start) -- 2 years plus month lag is enough but 3 years for sure

	print 'remuneration Start = ' + cast(@remuneration_Start as varchar)
	print 'remuneration End = ' + cast(@remuneration_End as varchar)
	print 'Transaction_lag = ' + cast(@Transaction_lag as varchar)
	declare @SQL varchar(500)
	
	IF OBJECT_ID('tempdb..#uv_TMF_RTW_Payment_Recovery_Temp') IS NULL
	BEGIN
		CREATE TABLE #uv_TMF_RTW_Payment_Recovery_Temp
		(
		 Claim_no varchar(19)
		 ,submitted_trans_date datetime
		 ,Payment_Type varchar(15)
		 ,RTW_Payment_Type varchar(3)
		 ,Trans_Amount money
		 ,Payment_no int
		 ,Period_Start_Date datetime
		 ,Period_End_Date datetime
		 ,hours_per_week numeric(5,2)
		 ,HOURS_WC numeric(14,3)
		)

		SET @SQL = 'CREATE INDEX pk_uv_TMF_RTW_Payment_Recovery_Temp_'+CONVERT(VARCHAR, @@SPID)+' ON #uv_TMF_RTW_Payment_Recovery_Temp(Claim_No, Payment_no)'
			EXEC(@SQL)
		IF @@ERROR <>0
			BEGIN
				ROLLBACK TRAN
				RETURN
			END
				
		-- Insert into temptable filter S38, S40, TI
		insert into #uv_TMF_RTW_Payment_Recovery_Temp
		SELECT     dbo.Payment_Recovery.Claim_No, CASE WHEN dbo.CLAIM_PAYMENT_RUN.Authorised_dte IS NOT NULL 
							  THEN CASE WHEN dbo.CLAIM_PAYMENT_RUN.Authorised_dte <= CONVERT(datetime, CAST(dbo.Payment_Recovery.wc_Tape_Month AS varchar), 120) 
							  THEN dbo.CLAIM_PAYMENT_RUN.Authorised_dte ELSE dbo.Payment_Recovery.Transaction_date END ELSE CASE WHEN dbo.claim_payment_run.Paid_Date IS NOT NULL
							   THEN dbo.claim_payment_run.Paid_Date ELSE dbo.Payment_Recovery.Transaction_date END END AS submitted_trans_date, 
							  dbo.Payment_Recovery.Payment_Type, CASE WHEN payment_type IN ('14', '15', 'WPT001', 'WPT002', 'WPT003', 'WPT004', 'WPT005', 'WPT006', 'WPT007') 
							  THEN 'TI' WHEN payment_type IN ('16', 'WPP002', 'WPP004', 'WPP005', 'WPP006', 'WPP007', 'WPP008') THEN 'S40' WHEN payment_type IN ('13', 'WPP001', 
							  'WPP003') THEN 'S38' END AS RTW_Payment_Type, dbo.Payment_Recovery.Trans_Amount, dbo.Payment_Recovery.Payment_no, dbo.Payment_Recovery.Period_Start_Date, 
							  dbo.Payment_Recovery.Period_End_Date, ISNULL(dbo.Payment_Recovery.hours_per_week, 0) AS hours_per_week, 
							  CASE WHEN Trans_Amount < 0 AND ((isnull(WC_MINUTES, 0) / 60.0) + isnull(WC_HOURS, 0) 
							  + isnull(WC_WEEKS * HOURS_PER_WEEK, 0)) > 0 THEN - (((isnull(WC_MINUTES, 0) / 60.0) + isnull(WC_HOURS, 0) 
							  + isnull(WC_WEEKS * HOURS_PER_WEEK, 0))) ELSE ((isnull(WC_MINUTES, 0) / 60.0) + isnull(WC_HOURS, 0) + isnull(WC_WEEKS * HOURS_PER_WEEK, 
							  0)) END AS HOURS_WC
		FROM         dbo.Payment_Recovery INNER JOIN
							  dbo.CLAIM_PAYMENT_RUN ON dbo.Payment_Recovery.Payment_no = dbo.CLAIM_PAYMENT_RUN.Payment_no
							  and
			 (dbo.Payment_Recovery.wc_Tape_Month IS NOT NULL and LEFT(dbo.Payment_Recovery.wc_Tape_Month, 4) <= @yy) AND (dbo.Payment_Recovery.Transaction_date >= @transaction_Start) AND 
							  (dbo.Payment_Recovery.Payment_Type IN ('14', '15', 'WPT001', 'WPT002', 'WPT003', 'WPT004', 'WPT005', 'WPT006', 'WPT007', '16', 'WPP002', 'WPP004', 
							  'WPP005', 'WPP006', 'WPP007', 'WPP008', '13', 'WPP001', 'WPP003'))
		-- End Insert into temptable filter S38, S40, TI
	END
	
	IF OBJECT_ID('tempdb..#uv_TMF_RTW_Payment_Recovery') IS NULL
	BEGIN
		CREATE TABLE #uv_TMF_RTW_Payment_Recovery
		(
		 Claim_no varchar(19)
		 ,submitted_trans_date datetime
		 ,RTW_Payment_Type varchar(3)
		 ,Period_Start_Date datetime
		 ,Period_End_Date datetime
		 ,hours_per_week numeric(5,2)
		 ,HOURS_WC numeric(14,3)
		 ,Trans_Amount money 
		)

		SET @SQL = 'CREATE INDEX pk_uv_TMF_RTW_Payment_Recovery_'+CONVERT(VARCHAR, @@SPID)+' ON #uv_TMF_RTW_Payment_Recovery(Claim_no, RTW_Payment_Type, submitted_trans_date)'
			EXEC(@SQL)
		IF @@ERROR <>0
			BEGIN
				ROLLBACK TRAN
				RETURN
			END	
		--Insert into temp table after combine transaction--
		insert into #uv_TMF_RTW_Payment_Recovery
		select claim_no, submitted_trans_date, RTW_Payment_Type, Period_Start_Date, Period_End_Date, hours_per_week
				,HOURS_WC = (select SUM(hours_WC) from #uv_TMF_RTW_Payment_Recovery_Temp cla1 where cla1.Claim_No = cla.Claim_No and cla1.RTW_Payment_Type = cla.RTW_Payment_Type and cla1.Period_End_Date = cla.Period_End_Date and cla1.Period_Start_Date = cla.Period_Start_Date  and Period_Start_Date <= @remuneration_End)
				,trans_amount = (select SUM(trans_amount) from #uv_TMF_RTW_Payment_Recovery_Temp cla1 where cla1.Claim_No = cla.Claim_No and cla1.RTW_Payment_Type = cla.RTW_Payment_Type and cla1.Period_End_Date = cla.Period_End_Date and cla1.Period_Start_Date = cla.Period_Start_Date and Period_Start_Date <= @remuneration_End)
		from #uv_TMF_RTW_Payment_Recovery_Temp cla 
		where submitted_trans_date = (select min(cla1.submitted_trans_date) 
					from #uv_TMF_RTW_Payment_Recovery_Temp cla1 
					where cla1.Claim_No = cla.Claim_No 
					and cla1.RTW_Payment_Type = cla.RTW_Payment_Type 
					and cla1.Period_End_Date = cla.Period_End_Date 
					and cla1.Period_Start_Date = cla.Period_Start_Date 
					and Period_Start_Date <= @remuneration_End)
		group by claim_no, submitted_trans_date, RTW_Payment_Type, Period_Start_Date, Period_End_Date, hours_per_week
		--End Insert into temp table after combine transaction--
	END
	
	--Delete reversed transactions--
	delete from #uv_TMF_RTW_Payment_Recovery where (HOURS_WC = 0 and RTW_Payment_Type = 'TI') or Trans_amount = 0
	--End Delete reversed transactions--

	CREATE TABLE #Tem_ClaimDetail
	(
	   Claim_Number CHAR(19)
	   ,Policy_No CHAR(19)
	   ,Renewal_No INT
	   ,Date_of_Injury DATETIME
	   ,Work_Hours NUMERIC(5,2) 
	   ,_13WEEKS_ DATETIME
	   ,_26WEEKS_ DATETIME
	   ,_52WEEKS_ DATETIME
	   ,_78WEEKS_ DATETIME
	   ,_104WEEKS_ DATETIME
	   ,DAYS13 int
	   ,DAYS26 int
	   ,DAYS52 int
	   ,DAYS78 int
	   ,DAYS104 int
	   ,DAYS13_PRD int
	   ,DAYS26_PRD int
	   ,DAYS52_PRD int
	   ,DAYS78_PRD int
	   ,DAYS104_PRD int
	)	

	SET @SQL = 'CREATE INDEX pk_Tem_ClaimDetail_Temp_'+CONVERT(VARCHAR, @@SPID)+' ON #Tem_ClaimDetail(Claim_Number, Policy_No, Date_of_Injury)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		 
		INSERT INTO #Tem_ClaimDetail
		SELECT cd.Claim_Number,cda.Policy_No, Renewal_No,cd.Date_of_Injury,cd.Work_Hours		
				, _13WEEKS_ = dateadd(mm, @Measure_month_13, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))	
				, _26WEEKS_ = dateadd(mm, @Measure_month_26, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))			
				, _52WEEKS_ = dateadd(mm, @Measure_month_52, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))			
				, _78WEEKS_ = dateadd(mm, @Measure_month_78, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))			
				, _104WEEKS_ = dateadd(mm, @Measure_month_104, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))			
				, DAYS13 = 0
				, DAYS26 = 0
				, DAYS52 = 0
				, DAYS78 = 0
				, DAYS104 = 0
				,DAYS13_PRD = 0
				,DAYS26_PRD = 0
				,DAYS52_PRD = 0
				,DAYS78_PRD = 0
				,DAYS104_PRD = 0
			FROM dbo.CLAIM_DETAIL cd INNER JOIN cd_audit cda on cda.claim_no = cd.claim_number 
			AND cda.Fund <> 98
			AND isnull(cd.Claim_Number,'') <> ''
			AND cd.Date_of_Injury >= @transaction_Start
			AND cda.id = (select max(id) from cd_audit cda1 where cda1.claim_no = cd.claim_number and cda1.create_date < @Transaction_lag_Remuneration_End)
	update #Tem_ClaimDetail set DAYS13 = dbo.udf_NoOfDaysWithoutWeekend(Date_of_Injury, _13WEEKS_) + case when datepart(dw,Date_of_Injury) not IN(1,7) then 1 else 0 end
							,   DAYS26 = dbo.udf_NoOfDaysWithoutWeekend(Date_of_Injury, _26WEEKS_) + case when datepart(dw,Date_of_Injury) not IN(1,7) then 1 else 0 end
							,   DAYS52 = dbo.udf_NoOfDaysWithoutWeekend(_26WEEKS_, _52WEEKS_) + case when datepart(dw,_26WEEKS_) not IN(1,7) then 1 else 0 end
							,   DAYS78 = dbo.udf_NoOfDaysWithoutWeekend(_52WEEKS_, _78WEEKS_) + case when datepart(dw,_52WEEKS_) not IN(1,7) then 1 else 0 end
							,   DAYS104 = dbo.udf_NoOfDaysWithoutWeekend(_52WEEKS_, _104WEEKS_) + case when datepart(dw,_52WEEKS_) not IN(1,7) then 1 else 0 end
							,	DAYS13_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(Date_of_Injury, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _13WEEKS_), @remuneration_End,'2222/01/01'))
											+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(Date_of_Injury, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
							,	DAYS26_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(Date_of_Injury, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _26WEEKS_), @remuneration_End,'2222/01/01'))
											+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(Date_of_Injury, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
							,	DAYS52_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(_26WEEKS_, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _52WEEKS_), @remuneration_End,'2222/01/01'))
											+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(_26WEEKS_, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
							,	DAYS78_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _78WEEKS_), @remuneration_End,'2222/01/01'))
											+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
							,	DAYS104_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _104WEEKS_), @remuneration_End,'2222/01/01'))
											+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end

	CREATE TABLE #TEMP_PREMIUM_DETAIL
		(
		POLICY_NO CHAR(19),
		WAGES0 MONEY,
		BTP MONEY,
		RENEWAL_NO INT
		)
		
		
		SET @SQL = 'CREATE INDEX pk_TEMP_PREMIUM_DETAIL_Temp_'+CONVERT(VARCHAR, @@SPID)+' ON #TEMP_PREMIUM_DETAIL(POLICY_NO, RENEWAL_NO)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
	INSERT INTO #TEMP_PREMIUM_DETAIL
		SELECT POLICY_NO,WAGES0,BTP,RENEWAL_NO
				FROM PREMIUM_DETAIL pd
				WHERE EXISTS (SELECT 1 FROM #Tem_ClaimDetail cd where cd.policy_no = pd.POLICY_NO)
				ORDER BY POLICY_NO,RENEWAL_NO


	create table #TEMP_MEASURES
	 (
		Claim_No CHAR(19)	
		,Policy_No VARCHAR(19)	
		,Date_of_Injury DATETIME
		,Period_Start_Date DATETIME
		,Period_End_Date DATETIME
		,PaymentType varchar(3)
		,LT_S38 FLOAT
		,LT_S40 FLOAT
		,LT_TI FLOAT
		,Trans_Amount MONEY
		,hours_per_week_adjusted float	
		,Weeks_Paid_adjusted float	
		,CAP_CUR_13 float	
		,CAP_PRE_13 float	
		,DAYS13_TRANS float
		,DAYS13_TRANS_PRIOR float
		,LT13_TRANS FLOAT
		,LT13_TRANS_PRIOR FLOAT
		,LT13 FLOAT
		,CAP_CUR_26 float	
		,CAP_PRE_26 float	
		,DAYS26_TRANS float
		,DAYS26_TRANS_PRIOR float
		,LT26_TRANS FLOAT
		,LT26_TRANS_PRIOR FLOAT
		,LT26 FLOAT
		,CAP_CUR_52 float
		,CAP_PRE_52 float
		,DAYS52_TRANS float	
		,DAYS52_TRANS_PRIOR float	
		,LT52_TRANS FLOAT	
		,LT52_TRANS_PRIOR FLOAT	
		,LT52 FLOAT
		,CAP_CUR_78 float
		,CAP_PRE_78 float
		,DAYS78_TRANS float	
		,DAYS78_TRANS_PRIOR float	
		,LT78_TRANS FLOAT	
		,LT78_TRANS_PRIOR FLOAT	
		,LT78 FLOAT
		,CAP_CUR_104 float
		,CAP_PRE_104 float
		,DAYS104_TRANS float	
		,DAYS104_TRANS_PRIOR float	
		,LT104_TRANS FLOAT	
		,LT104_TRANS_PRIOR FLOAT	
		,LT104 FLOAT
		,include_13 bit
		,include_26 bit
		,include_52 bit
		,include_78 bit
		,include_104 bit
		,include_13_trans bit
		,include_26_trans bit
		,include_52_trans bit
		,include_78_trans bit
		,include_104_trans bit
		,Total_LT FLOAT	
		,[DAYS] int
		,_13WEEKS_ DATETIME
		,_26WEEKS_ DATETIME
		,_52WEEKS_ DATETIME
		,_78WEEKS_ DATETIME
		,_104WEEKS_ DATETIME
		,EMPL_SIZE varchar(256)
		,DAYS13_PRD_CALC int
		,DAYS26_PRD_CALC int
		,DAYS52_PRD_CALC int
		,DAYS78_PRD_CALC int
		,DAYS104_PRD_CALC int
		,DAYS13_CALC int
		,DAYS26_CALC int
		,DAYS52_CALC int
		,DAYS78_CALC int
		,DAYS104_CALC int
	 )
	 SET @SQL = 'CREATE INDEX pk_TEMP_MEASURES_'+CONVERT(VARCHAR, @@SPID)+' ON #TEMP_MEASURES(Claim_no,Policy_No, Date_of_Injury)'
		EXEC(@SQL)
	IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
			
	insert into #TEMP_MEASURES
	SELECT distinct pr.Claim_No, cd.Policy_No,Date_of_Injury
			,pr.Period_Start_Date
			,pr.Period_End_Date
			,RTW_Payment_Type
			,LT_S38 = case when RTW_Payment_Type = 'S38' and (case when period_start_date = period_end_date then 1 else 
									dbo.udf_NoOfDaysWithoutWeekend(period_start_date,period_end_date)
								end) = 0 then 0
								when RTW_Payment_Type = 'S38' and dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)) >= 35 
									then 1.0*case when RTW_Payment_Type = 'TI' and datepart(dw,period_start_date) IN(1,7) and datepart(dw,period_end_date) IN(1,7) and DATEDIFF(day,period_start_date,period_end_date) <=1
									then DATEDIFF(day,period_start_date,period_end_date) + 1					
								when period_start_date = period_end_date then 1 else 
									dbo.udf_NoOfDaysWithoutWeekend(period_start_date,period_end_date)
								end * dbo.udf_CheckPositiveOrNegative(Trans_Amount) 
								when RTW_Payment_Type = 'S38' and dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)) < 35  and dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)) > 0 
									then 1.0*case when RTW_Payment_Type = 'TI' and datepart(dw,period_start_date) IN(1,7) and datepart(dw,period_end_date) IN(1,7) and DATEDIFF(day,period_start_date,period_end_date) <=1
									then DATEDIFF(day,period_start_date,period_end_date) + 1					
								when period_start_date = period_end_date then 1 else 
									dbo.udf_NoOfDaysWithoutWeekend(period_start_date,period_end_date)
								end * dbo.udf_CheckPositiveOrNegative(Trans_Amount) * (dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end))/37.5)
								else 0 END
			,LT_S40 = case when RTW_Payment_Type = 'S40' and 
			
			(case when period_start_date = period_end_date then 1 else 
									dbo.udf_NoOfDaysWithoutWeekend(period_start_date,period_end_date)
									end) = 0 then 0
								when RTW_Payment_Type = 'S40' and dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)) >= 35 
									then 1.0*case when RTW_Payment_Type = 'TI' and datepart(dw,period_start_date) IN(1,7) and datepart(dw,period_end_date) IN(1,7) and DATEDIFF(day,period_start_date,period_end_date) <=1
									then DATEDIFF(day,period_start_date,period_end_date) + 1					
								when period_start_date = period_end_date then 1 else 
									dbo.udf_NoOfDaysWithoutWeekend(period_start_date,period_end_date)
								end * 0.75 * dbo.udf_CheckPositiveOrNegative(Trans_Amount) 
								when RTW_Payment_Type = 'S40' and dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)) < 35
									then 1.0*case when RTW_Payment_Type = 'TI' and datepart(dw,period_start_date) IN(1,7) and datepart(dw,period_end_date) IN(1,7) and DATEDIFF(day,period_start_date,period_end_date) <=1
									then DATEDIFF(day,period_start_date,period_end_date) + 1					
								when period_start_date = period_end_date then 1 else 
									dbo.udf_NoOfDaysWithoutWeekend(period_start_date,period_end_date)
								end* 0.75 * dbo.udf_CheckPositiveOrNegative(Trans_Amount) * (dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end))/37.5)
								else 0 END
			,LT_TI =  case when RTW_Payment_Type = 'TI' and dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)) >= 35 
									then 1.0 * (pr.HOURS_WC* 5 ) / nullif(dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)),0) * dbo.udf_CheckPositiveOrNegative(Trans_Amount)
								 when RTW_Payment_Type = 'TI' and dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)) < 35 
									then 1.0 * (pr.HOURS_WC * 5 / 37.5)* dbo.udf_CheckPositiveOrNegative(Trans_Amount)	
								else 0 END 
			,Trans_Amount
			,hours_per_week_adjusted = dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end))		
			,Weeks_Paid_adjusted = 1.0 * pr.HOURS_WC / nullif(dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)),0)
			------13 weeks-------
			,CAP_CUR_13 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _13WEEKS_), @remuneration_End, '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)		
			,CAP_PRE_13 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _13WEEKS_), DATEADD(dd, -1, @remuneration_Start), '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)
			
			,DAYS13_TRANS = case when submitted_trans_date <= @Transaction_lag_Remuneration_End and submitted_trans_date < DATEADD(MM, @Transaction_lag, _13WEEKS_ )
									then case when dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _13WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _13WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _13WEEKS_), Period_End_Date))) end
									
									else 0 end		
			,DAYS13_TRANS_PRIOR = case when submitted_trans_date < @Transaction_lag_Remuneration_Start and submitted_trans_date < DATEADD(MM, @Transaction_lag, _13WEEKS_ )								
									then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _13WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _13WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _13WEEKS_), Period_End_Date))) end
									
									else 0 end		
			,LT13_TRANS = 0
			,LT13_TRANS_PRIOR = 0
			,LT13 = 0
			------26 weeks-------
			,CAP_CUR_26 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _26WEEKS_), @remuneration_End, '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)		
			,CAP_PRE_26 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _26WEEKS_), DATEADD(dd, -1, @remuneration_Start), '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)
			
			,DAYS26_TRANS = case when submitted_trans_date <= @Transaction_lag_Remuneration_End and submitted_trans_date < DATEADD(MM, @Transaction_lag, _26WEEKS_ )
									then case when dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _26WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _26WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _26WEEKS_), Period_End_Date))) end
									
									else 0 end		
			,DAYS26_TRANS_PRIOR = case when submitted_trans_date < @Transaction_lag_Remuneration_Start and submitted_trans_date < DATEADD(MM, @Transaction_lag, _26WEEKS_ )								
									then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _26WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _26WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _26WEEKS_), Period_End_Date))) end
									
									else 0 end		
			,LT26_TRANS = 0
			,LT26_TRANS_PRIOR = 0
			,LT26 = 0
			------52 weeks-------
			,CAP_CUR_52 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _52WEEKS_), @remuneration_End, '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)
			,CAP_PRE_52 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _52WEEKS_), DATEADD(dd, -1, @remuneration_Start), '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)
			,DAYS52_TRANS = case when submitted_trans_date <= @Transaction_lag_Remuneration_End and submitted_trans_date < DATEADD(MM, @Transaction_lag, _52WEEKS_ )
									then case when dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _52WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _52WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _52WEEKS_), Period_End_Date))) end
									
									else 0 end
			,DAYS52_TRANS_PRIOR = case when submitted_trans_date < @Transaction_lag_Remuneration_Start and submitted_trans_date < DATEADD(MM, @Transaction_lag, _52WEEKS_ )								
									then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _52WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _52WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _52WEEKS_), Period_End_Date))) end
									
									else 0 end
			,LT52_TRANS = 0
			,LT52_TRANS_PRIOR = 0
			,LT52 = 0
			------ 78 weeks-------
			,CAP_CUR_78 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _78WEEKS_), @remuneration_End, '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)
			,CAP_PRE_78 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _78WEEKS_), DATEADD(dd, -1, @remuneration_Start), '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)
			,DAYS78_TRANS = case when submitted_trans_date <= @Transaction_lag_Remuneration_End and submitted_trans_date < DATEADD(MM, @Transaction_lag, _78WEEKS_ )
									then case when dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _78WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _78WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _78WEEKS_), Period_End_Date))) end
									
									else 0 end
			,DAYS78_TRANS_PRIOR = case when submitted_trans_date < @Transaction_lag_Remuneration_Start and submitted_trans_date < DATEADD(MM, @Transaction_lag, _78WEEKS_ )								
									then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _78WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _78WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _78WEEKS_), Period_End_Date))) end
									
									else 0 end
			,LT78_TRANS = 0
			,LT78_TRANS_PRIOR = 0
			,LT78 = 0
			------ 104 weeks-------
			,CAP_CUR_104 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _104WEEKS_), @remuneration_End, '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)
			,CAP_PRE_104 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _104WEEKS_), DATEADD(dd, -1, @remuneration_Start), '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)
			,DAYS104_TRANS = case when submitted_trans_date <= @Transaction_lag_Remuneration_End and submitted_trans_date < DATEADD(MM, @Transaction_lag, _104WEEKS_ )
									then case when dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _104WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _104WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _104WEEKS_), Period_End_Date))) end
									
									else 0 end
			,DAYS104_TRANS_PRIOR = case when submitted_trans_date < @Transaction_lag_Remuneration_Start and submitted_trans_date < DATEADD(MM, @Transaction_lag, _104WEEKS_ )								
									then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _104WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _104WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _104WEEKS_), Period_End_Date))) end
									
									else 0 end
			,LT104_TRANS = 0
			,LT104_TRANS_PRIOR = 0
			,LT104 = 0
			,include_13_trans = case when submitted_trans_date <  DATEADD(MM, @Transaction_lag, _13WEEKS_) and submitted_trans_date <= DATEADD(MM, @Transaction_lag, @remuneration_End) 	then 1 else 0 end
			,include_26_trans = case when submitted_trans_date <  DATEADD(MM, @Transaction_lag, _26WEEKS_) and submitted_trans_date <= DATEADD(MM, @Transaction_lag, @remuneration_End) 	then 1 else 0 end
			,include_52_trans = case when submitted_trans_date <  DATEADD(MM, @Transaction_lag, _52WEEKS_) and submitted_trans_date <= DATEADD(MM, @Transaction_lag, @remuneration_End) 	then 1 else 0 end
			,include_78_trans = case when submitted_trans_date <  DATEADD(MM, @Transaction_lag, _78WEEKS_) and submitted_trans_date <= DATEADD(MM, @Transaction_lag, @remuneration_End) 	then 1 else 0 end
			,include_104_trans = case when submitted_trans_date <  DATEADD(MM, @Transaction_lag, _104WEEKS_) and submitted_trans_date <= DATEADD(MM, @Transaction_lag, @remuneration_End) 	then 1 else 0 end
			,include_13 = case when (Date_of_Injury between @remuneration_Start and @remuneration_End) or (_13WEEKS_ between @remuneration_Start and @remuneration_End) or (@remuneration_Start between  Date_of_Injury and _13WEEKS_) or (@remuneration_End between  Date_of_Injury and _13WEEKS_) then 1 else 0 end
			,include_26 = case when (Date_of_Injury between @remuneration_Start and @remuneration_End) or (_26WEEKS_ between @remuneration_Start and @remuneration_End) or (@remuneration_Start between  Date_of_Injury and _26WEEKS_) or (@remuneration_End between  Date_of_Injury and _26WEEKS_) then 1 else 0 end
			,include_52 = case when (_26WEEKS_ between @remuneration_Start and @remuneration_End) or (_52WEEKS_ between @remuneration_Start and @remuneration_End) or (@remuneration_Start between  _26WEEKS_ and _52WEEKS_) or (@remuneration_End between  _26WEEKS_ and _52WEEKS_) then 1 else 0 end
			,include_78 = case when (_52WEEKS_ between @remuneration_Start and @remuneration_End) or (_78WEEKS_ between @remuneration_Start and @remuneration_End) or (@remuneration_Start between  _52WEEKS_ and _78WEEKS_) or (@remuneration_End between  _52WEEKS_ and _78WEEKS_) then 1 else 0 end
			,include_104 = case when (_52WEEKS_ between @remuneration_Start and @remuneration_End) or (_104WEEKS_ between @remuneration_Start and @remuneration_End) or (@remuneration_Start between  _52WEEKS_ and _104WEEKS_) or (@remuneration_End between  _52WEEKS_ and _104WEEKS_) then 1 else 0 end		
			,Total_LT = 0			
			,[DAYS] = case when RTW_Payment_Type = 'TI' and datepart(dw,period_start_date) IN(1,7) and datepart(dw,period_end_date) IN(1,7) and DATEDIFF(day,period_start_date,period_end_date) <=1
									then DATEDIFF(day,period_start_date,period_end_date) + 1					
								when period_start_date = period_end_date then 1 else 
									dbo.udf_NoOfDaysWithoutWeekend(period_start_date,period_end_date)
								end
			,_13WEEKS_
			,_26WEEKS_ 
			,_52WEEKS_ 
			,_78WEEKS_ 
			,_104WEEKS_
			,EMPL_SIZE = CASE WHEN pd.BTP > 500000 then 'L' 
							 WHEN pd.BTP < 10000 or pd.WAGES0 < 300000 THEN 'S' 
							 ELSE 'M' end 								 
			,DAYS13_PRD_CALC = DAYS13_PRD + case when  DATEPART(dw, dbo.udf_MinDay(_13WEEKS_, @remuneration_End,'2222/01/01')) not in (1, 7)  then -1 else 0 end
			,DAYS26_PRD_CALC = DAYS26_PRD + case when  DATEPART(dw, dbo.udf_MinDay(_26WEEKS_, @remuneration_End,'2222/01/01')) not in (1, 7)  then -1 else 0 end
			,DAYS52_PRD_CALC = DAYS52_PRD + case when  DATEPART(dw, dbo.udf_MinDay(_52WEEKS_, @remuneration_End,'2222/01/01')) not in (1, 7)  then -1 else 0 end
			,DAYS78_PRD_CALC = DAYS78_PRD + case when  DATEPART(dw, dbo.udf_MinDay(_78WEEKS_, @remuneration_End,'2222/01/01')) not in (1, 7)  then -1 else 0 end
			,DAYS104_PRD_CALC = DAYS104_PRD + case when  DATEPART(dw, dbo.udf_MinDay(_104WEEKS_, @remuneration_End,'2222/01/01')) not in (1, 7)  then -1 else 0 end
			,DAYS13_CALC = DAYS13 + case when  DATEPART(dw,_13WEEKS_) not in (1, 7)  then -1 else 0 end
			,DAYS26_CALC = DAYS26 + case when  DATEPART(dw,_26WEEKS_) not in (1, 7)  then -1 else 0 end
			,DAYS52_CALC = DAYS52 + case when  DATEPART(dw,_52WEEKS_) not in (1, 7)  then -1 else 0 end
			,DAYS78_CALC = DAYS78 + case when  DATEPART(dw,_78WEEKS_) not in (1, 7)  then -1 else 0 end
			,DAYS104_CALC = DAYS104 + case when  DATEPART(dw,_104WEEKS_) not in (1, 7)  then -1 else 0 end		

		  FROM #Tem_ClaimDetail cd INNER JOIN #uv_TMF_RTW_Payment_Recovery pr ON cd.Claim_Number = pr.Claim_No		
				LEFT JOIN #TEMP_PREMIUM_DETAIL pd ON pd.POLICY_NO = cd.Policy_No AND pd.RENEWAL_NO = cd.Renewal_No
			AND PR.Period_Start_Date <= @remuneration_End						

	-- Update LT_TRANS and LT_TRANS_PRIOR
	update #TEMP_MEASURES set LT13_TRANS = case when [DAYS] = 0 then 0 else					
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS13_TRANS / nullif([DAYS],0)
											end
							,LT13_TRANS_PRIOR = case when [DAYS] = 0 then 0 else
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS13_TRANS_PRIOR / nullif([DAYS],0)
											end 
							,LT26_TRANS = case when [DAYS] = 0 then 0 else					
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS26_TRANS / nullif([DAYS],0)
											end
							,LT26_TRANS_PRIOR = case when [DAYS] = 0 then 0 else
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS26_TRANS_PRIOR / nullif([DAYS],0)
											end
							,LT52_TRANS = case when [DAYS] = 0 then 0 else					
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS52_TRANS / nullif([DAYS],0)
											end
							,LT52_TRANS_PRIOR = case when [DAYS] = 0 then 0 else
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS52_TRANS_PRIOR / nullif([DAYS],0)
											end
							,LT78_TRANS = case when [DAYS] = 0 then 0 else					
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS78_TRANS / nullif([DAYS],0)
											end
							,LT78_TRANS_PRIOR = case when [DAYS] = 0 then 0 else
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS78_TRANS_PRIOR / nullif([DAYS],0)
											end
							,LT104_TRANS = case when [DAYS] = 0 then 0 else					
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS104_TRANS / nullif([DAYS],0)
											end
							,LT104_TRANS_PRIOR = case when [DAYS] = 0 then 0 else
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS104_TRANS_PRIOR / nullif([DAYS],0)
											end
							,Total_LT = (LT_S38 + LT_S40 + LT_TI) 
										* case when Period_End_Date <= @remuneration_End or [DAYS]=0 then 1 
												when Period_Start_Date > @remuneration_End then 0
											else 1.0 * dbo.udf_NoOfDaysWithoutWeekend(Period_Start_Date, @remuneration_End) / nullif([DAYS],0)
											end						

	-- End update LT_TRANS and LT_TRANS_PRIOR

	--Delete small transactions
	DELETE FROM #TEMP_MEASURES WHERE (
		CASE WHEN PaymentType in ('S40') and [DAYS] <> 0 AND hours_per_week_adjusted >=35 and (1.0 * Trans_Amount / nullif([DAYS],0)) < 2 then 1
			 WHEN PaymentType in ('S40') and [DAYS] <> 0 AND hours_per_week_adjusted < 35 and (1.0 * Trans_Amount / nullif((([DAYS]*hours_per_week_adjusted) / 37.5),0)) < 2   then 1 
			 WHEN PaymentType in ('S40') and [DAYS] = 0 AND LT_S40 <> 0 and (1.0 * Trans_Amount / nullif(LT_S40,0)) < 2 then 1
		ELSE 0
		END = 1)
		
	DELETE FROM #TEMP_MEASURES WHERE (
		CASE WHEN PaymentType in ('S38','TI') and (LT_TI + LT_S38) <> 0 and (1.0 * Trans_Amount / nullif((LT_TI + LT_S38),0)) < 20 then 1
		ELSE 0
		END = 1)
	--End Delete small transactions


	SET @SQL = 'CREATE NONCLUSTERED INDEX Pk_TEMP_MEASURES
				ON [dbo].[#TEMP_MEASURES] ([include_104],[include_104_trans])
				INCLUDE ([Claim_No],[Policy_No],[Date_of_Injury],[CAP_CUR_52],[CAP_PRE_52],[LT52_TRANS],[LT52_TRANS_PRIOR],[CAP_CUR_104],[CAP_PRE_104],[LT104_TRANS],[LT104_TRANS_PRIOR],[Total_LT],[_52WEEKS_],[_104WEEKS_],[EMPL_SIZE],[DAYS104_PRD_CALC],[DAYS104_CALC], [Weeks_Paid_adjusted])'
		EXEC(@SQL)
	IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
	
	-------List Claims 13 weeks----
	select  'Remuneration_Start' = @Transaction_lag_Remuneration_Start
			,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0,@remuneration_end) + @Transaction_lag + 1,0)) + '23:59'
			,Measure_months = @Measure_month_13
			,'Group' = dbo.udf_GetGroupByPolicyNo(cd.Policy_no)
			,Team = CASE WHEN rtrim(isnull(co.Grp,''))='' then 'Miscellaneous' else rtrim(UPPER(co.Grp)) end
			,Case_manager = ISNULL ( UPPER(co.First_Name+' '+ co.Last_Name), 'Miscellaneous')			
			,Agency_id = UPPER(ptda.Agency_id)
			,cd.Claim_no
			,cd.Date_of_Injury
			,cd.Policy_No
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,dbo.udf_GetAgencyNameByPolicyNo(cd.Policy_no) AS AgencyName
			,Sub_category = rtrim(dbo.udf_GetSubCategoryByPolicyNo(cd.Policy_no))
			,Measure = 13
			,Cert_Type = case when mc.TYPE = 'P' 
								then 'No Time Lost' 
						      when mc.TYPE = 'T' 
								then 'Totally Unfit'
							  when mc.TYPE = 'S' 
								then 'Suitable Duties'
							  when mc.TYPE = 'I' 
								then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' 
								then 'Permanently Modified Duties'
							  else 'Invalid type' 
						 end
			,Med_cert_From = mc.Med_cert_From
			,Med_cert_To = mc.Med_cert_To
			,Account_Manager = ''
			,Cell_no = NULL
			,Portfolio = ''
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
			
	from (
			SELECT rtrim(cla.claim_no) as Claim_no
					,cla.Date_of_Injury
					,cla.Policy_No	
					,round(dbo.udf_MinValue(sum(cla.LT13_TRANS), avg(CAP_CUR_13)) - dbo.udf_MinValue(sum(cla.LT13_TRANS_PRIOR), AVG(CAP_PRE_13)), 10) as LT										
					,round(dbo.udf_MinValue(1, 1.0 * DAYS13_PRD_CALC / nullif(DAYS13_CALC,0)), 10) as WGT
					,cla.EMPL_SIZE
					,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
					,_13WEEKS_
			FROM #TEMP_MEASURES cla where cla.include_13 = 1 and cla.include_13_trans = 1
			GROUP BY cla.claim_no,Policy_No,cla.Date_of_Injury,_13WEEKS_,DAYS13_PRD_CALC, DAYS13_CALC, cla.EMPL_SIZE
			HAVING round(SUM(total_LT),2) > 5 and round(sum(LT13_TRANS),2) > 5
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		INNER JOIN CLAIMS_OFFICERS CO on cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias 
		INNER JOIN ptd_audit ptda ON cd.POLICY_NO = ptda.Policy_No
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type],Med_cert_From=Date_From,Med_cert_To=Date_To 
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		
		
	WHERE cada1.id = (SELECT MAX(cada2.id) FROM cad_audit cada2 
				WHERE cada2.claim_no = cada1.claim_no 
				and cada2.transaction_date <= @Transaction_lag_Remuneration_End)
		AND coa1.id = (SELECT MAX(coa2.id) FROM CO_audit coa2
				WHERE coa2.officer_id = coa1.officer_id 
				and coa2.create_date < @Transaction_lag_Remuneration_End)
		AND ptda.id = (SELECT MAX(ptda2.id) FROM ptd_audit ptda2
				WHERE ptda2.policy_no = ptda.policy_no and ptda2.create_date <= @Transaction_lag_Remuneration_End)
					
	union all
	--List Claims 26 weeks--
	select  'Remuneration_Start' = @Transaction_lag_Remuneration_Start
			,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0,@remuneration_end) + @Transaction_lag + 1,0)) + '23:59'
			,Measure_months = @Measure_month_26
			,'Group' = dbo.udf_GetGroupByPolicyNo(cd.Policy_no)
			,Team = CASE WHEN rtrim(isnull(co.Grp,''))='' then 'Miscellaneous' else rtrim(UPPER(co.Grp)) end
			,Case_manager = ISNULL ( UPPER(co.First_Name+' '+ co.Last_Name), 'Miscellaneous')			
			,Agency_id = UPPER(ptda.Agency_id)
			,cd.Claim_no
			,cd.Date_of_Injury
			,cd.Policy_No
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,dbo.udf_GetAgencyNameByPolicyNo(cd.Policy_no) AS AgencyName
			,Sub_category = rtrim(dbo.udf_GetSubCategoryByPolicyNo(cd.Policy_no))
			,Measure = 26
			,Cert_Type = case when mc.TYPE = 'P' 
								then 'No Time Lost' 
						      when mc.TYPE = 'T' 
								then 'Totally Unfit'
							  when mc.TYPE = 'S' 
								then 'Suitable Duties'
							  when mc.TYPE = 'I' 
								then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' 
								then 'Permanently Modified Duties'
							  else 'Invalid type' 
						 end
			,Med_cert_From = mc.Med_cert_From
			,Med_cert_To = mc.Med_cert_To
			,Account_Manager = ''
			,Cell_no = NULL
			,Portfolio = ''
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
			
	from (
			SELECT rtrim(cla.claim_no) as Claim_no
				,cla.Date_of_Injury
				,cla.Policy_No
				,round(dbo.udf_MinValue(sum(cla.LT26_TRANS), avg(CAP_CUR_26)) - dbo.udf_MinValue(sum(cla.LT26_TRANS_PRIOR), AVG(CAP_PRE_26)), 10) as LT								
				,round(dbo.udf_MinValue(1, 1.0 * DAYS26_PRD_CALC / nullif(DAYS26_CALC,0)), 10) as WGT
				,cla.EMPL_SIZE
				,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
				,_26WEEKS_
			FROM #TEMP_MEASURES cla where cla.include_26 = 1 and cla.include_26_trans = 1
			GROUP BY cla.claim_no,Policy_No,cla.Date_of_Injury,_26WEEKS_,DAYS26_PRD_CALC, DAYS26_CALC, cla.EMPL_SIZE
			HAVING round(SUM(total_LT),2) > 5 and round(sum(LT26_TRANS),2) > 5
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		INNER JOIN CLAIMS_OFFICERS CO on cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		INNER JOIN ptd_audit ptda ON cd.POLICY_NO = ptda.Policy_No
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type],Med_cert_From=Date_From,Med_cert_To=Date_To 
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null ), '')		
		
	WHERE cada1.id = (SELECT MAX(cada2.id) FROM cad_audit cada2 
				WHERE cada2.claim_no = cada1.claim_no 
				and cada2.transaction_date <= @Transaction_lag_Remuneration_End)
		AND coa1.id = (SELECT MAX(coa2.id) FROM CO_audit coa2
				WHERE coa2.officer_id = coa1.officer_id 
				and coa2.create_date < @Transaction_lag_Remuneration_End)
		AND ptda.id = (SELECT MAX(ptda2.id) FROM ptd_audit ptda2
				WHERE ptda2.policy_no = ptda.policy_no and ptda2.create_date <= @Transaction_lag_Remuneration_End)
		
	union all
	---List Claims 52 weeks----
	select  'Remuneration_Start' = @Transaction_lag_Remuneration_Start
			,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0,@remuneration_end) + @Transaction_lag + 1,0)) + '23:59'
			,Measure_months = @Measure_month_52
			,'Group' = dbo.udf_GetGroupByPolicyNo(cd.Policy_no)
			,Team = CASE WHEN rtrim(isnull(co.Grp,''))='' then 'Miscellaneous' else rtrim(UPPER(co.Grp)) end
			,Case_manager = ISNULL ( UPPER(co.First_Name+' '+ co.Last_Name), 'Miscellaneous')			
			,Agency_id = UPPER(ptda.Agency_id)
			,cd.Claim_no
			,cd.Date_of_Injury
			,cd.Policy_No
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,dbo.udf_GetAgencyNameByPolicyNo(cd.Policy_no) AS AgencyName
			,Sub_category = rtrim(dbo.udf_GetSubCategoryByPolicyNo(cd.Policy_no))
			,Measure = 52
			,Cert_Type = case when mc.TYPE = 'P' 
								then 'No Time Lost' 
						      when mc.TYPE = 'T' 
								then 'Totally Unfit'
							  when mc.TYPE = 'S' 
								then 'Suitable Duties'
							  when mc.TYPE = 'I' 
								then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' 
								then 'Permanently Modified Duties'
							  else 'Invalid type' 
						 end
			,Med_cert_From = mc.Med_cert_From
			,Med_cert_To = mc.Med_cert_To
			,Account_Manager = ''
			,Cell_no = NULL
			,Portfolio = ''
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
			
	from (
			SELECT	rtrim(cla.claim_no) as Claim_no	
					,cla.Date_of_Injury	
					,cla.Policy_No	
					,	(round(dbo.udf_MinValue(sum(cla.LT52_TRANS), avg(CAP_CUR_52)) - dbo.udf_MinValue(sum(cla.LT52_TRANS_PRIOR), AVG(CAP_PRE_52)), 10)
						- (round(dbo.udf_MinValue(sum(cla.LT26_TRANS), avg(CAP_CUR_26)) - dbo.udf_MinValue(sum(cla.LT26_TRANS_PRIOR), AVG(CAP_PRE_26)), 10))
					) as LT											
					,round(dbo.udf_MinValue(1, 1.0 * DAYS52_PRD_CALC / nullif(DAYS52_CALC,0)), 10) as WGT
					,cla.EMPL_SIZE
					,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
					,_52WEEKS_
			FROM #TEMP_MEASURES cla 
			WHERE cla.include_52 = 1 and cla.include_52_trans = 1
			GROUP BY cla.claim_no,cla.Policy_No,cla.Date_of_Injury,_52WEEKS_,DAYS52_PRD_CALC, DAYS52_CALC, cla.EMPL_SIZE
			HAVING round(SUM(total_LT),2) > 5 and round(sum(LT52_TRANS),2) > 5	
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no		
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		INNER JOIN CLAIMS_OFFICERS CO on cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		INNER JOIN ptd_audit ptda ON cd.POLICY_NO = ptda.Policy_No
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type],Med_cert_From=Date_From,Med_cert_To=Date_To 
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')		
		
	WHERE cada1.id = (SELECT MAX(cada2.id) FROM cad_audit cada2 
				WHERE cada2.claim_no = cada1.claim_no 
				and cada2.transaction_date <= @Transaction_lag_Remuneration_End)
		AND coa1.id = (SELECT MAX(coa2.id) FROM CO_audit coa2
				WHERE coa2.officer_id = coa1.officer_id 
				and coa2.create_date < @Transaction_lag_Remuneration_End)
		AND ptda.id = (SELECT MAX(ptda2.id) FROM ptd_audit ptda2
				WHERE ptda2.policy_no = ptda.policy_no and ptda2.create_date <= @Transaction_lag_Remuneration_End)		

	union all
	---List Claims 78 weeks----
	select  'Remuneration_Start' = @Transaction_lag_Remuneration_Start
			,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0,@remuneration_end) + @Transaction_lag + 1,0)) + '23:59'
			,Measure_months = @Measure_month_78
			,'Group' = dbo.udf_GetGroupByPolicyNo(cd.Policy_no)
			,Team = CASE WHEN rtrim(isnull(co.Grp,''))='' then 'Miscellaneous' else rtrim(UPPER(co.Grp)) end
			,Case_manager = ISNULL ( UPPER(co.First_Name+' '+ co.Last_Name), 'Miscellaneous')			
			,Agency_id = UPPER(ptda.Agency_id)
			,cd.Claim_no
			,cd.Date_of_Injury
			,cd.Policy_No
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,dbo.udf_GetAgencyNameByPolicyNo(cd.Policy_no) AS AgencyName
			,Sub_category = rtrim(dbo.udf_GetSubCategoryByPolicyNo(cd.Policy_no))
			,Measure = 78
			,Cert_Type = case when mc.TYPE = 'P' 
								then 'No Time Lost' 
						      when mc.TYPE = 'T' 
								then 'Totally Unfit'
							  when mc.TYPE = 'S' 
								then 'Suitable Duties'
							  when mc.TYPE = 'I' 
								then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' 
								then 'Permanently Modified Duties'
							  else 'Invalid type' 
						 end
			,Med_cert_From = mc.Med_cert_From
			,Med_cert_To = mc.Med_cert_To
			,Account_Manager = ''
			,Cell_no = NULL
			,Portfolio = ''
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
			
	from (
			SELECT	rtrim(cla.claim_no) as Claim_no	
					,cla.Date_of_Injury	
					,cla.Policy_No	
					,	(round(dbo.udf_MinValue(sum(cla.LT78_TRANS), avg(CAP_CUR_78)) - dbo.udf_MinValue(sum(cla.LT78_TRANS_PRIOR), AVG(CAP_PRE_78)), 10)
						- (round(dbo.udf_MinValue(sum(cla.LT52_TRANS), avg(CAP_CUR_52)) - dbo.udf_MinValue(sum(cla.LT52_TRANS_PRIOR), AVG(CAP_PRE_52)), 10))
					) as LT												
					,round(dbo.udf_MinValue(1, 1.0 * DAYS78_PRD_CALC / nullif(DAYS78_CALC,0)), 10) as WGT
					,cla.EMPL_SIZE
					,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
					,_78WEEKS_
			FROM #TEMP_MEASURES cla 
			WHERE cla.include_78 = 1 and cla.include_78_trans = 1
			GROUP BY cla.claim_no,cla.Policy_No,cla.Date_of_Injury,_78WEEKS_, DAYS78_PRD_CALC, DAYS78_CALC, cla.EMPL_SIZE
			HAVING round(SUM(total_LT),2) > 5 and round(sum(LT78_TRANS),2) > 5	
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no		
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		INNER JOIN CLAIMS_OFFICERS CO on cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		INNER JOIN ptd_audit ptda ON cd.POLICY_NO = ptda.Policy_No
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type],Med_cert_From=Date_From,Med_cert_To=Date_To 
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')		
		
	WHERE cada1.id = (SELECT MAX(cada2.id) FROM cad_audit cada2 
				WHERE cada2.claim_no = cada1.claim_no 
				and cada2.transaction_date <= @Transaction_lag_Remuneration_End)
		AND coa1.id = (SELECT MAX(coa2.id) FROM CO_audit coa2
				WHERE coa2.officer_id = coa1.officer_id 
				and coa2.create_date < @Transaction_lag_Remuneration_End)
		AND ptda.id = (SELECT MAX(ptda2.id) FROM ptd_audit ptda2
				WHERE ptda2.policy_no = ptda.policy_no and ptda2.create_date <= @Transaction_lag_Remuneration_End)		
		
	union all
	---List Claims 104 weeks----
	select  Remuneration_Start = @Transaction_lag_Remuneration_Start
			,Remuneration_End = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0,@remuneration_end) + @Transaction_lag + 1,0)) + '23:59'
			,Measure_months = @Measure_month_104
			,'Group' = dbo.udf_GetGroupByPolicyNo(cd.Policy_no)
			,Team = CASE WHEN rtrim(isnull(co.Grp,''))='' then 'Miscellaneous' else rtrim(UPPER(co.Grp)) end
			,Case_manager = ISNULL ( UPPER(co.First_Name+' '+ co.Last_Name), 'Miscellaneous')			
			,Agency_id = UPPER(ptda.Agency_id)
			,cd.Claim_no
			,cd.Date_of_Injury
			,cd.Policy_No
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,dbo.udf_GetAgencyNameByPolicyNo(cd.Policy_no) AS AgencyName
			,Sub_category = rtrim(dbo.udf_GetSubCategoryByPolicyNo(cd.Policy_no))
			,Measure = 104
			,Cert_Type = case when mc.TYPE = 'P' 
								then 'No Time Lost' 
						      when mc.TYPE = 'T' 
								then 'Totally Unfit'
							  when mc.TYPE = 'S' 
								then 'Suitable Duties'
							  when mc.TYPE = 'I' 
								then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' 
								then 'Permanently Modified Duties'
							  else 'Invalid type' 
						 end
			,Med_cert_From = mc.Med_cert_From
			,Med_cert_To = mc.Med_cert_To
			,Account_Manager = ''
			,Cell_no = NULL
			,Portfolio = ''
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
					
	from (
			SELECT	rtrim(cla.claim_no) as Claim_no	
				,cla.Date_of_Injury	
				,cla.Policy_No	
				,	(round(dbo.udf_MinValue(sum(cla.LT104_TRANS), avg(CAP_CUR_104)) - dbo.udf_MinValue(sum(cla.LT104_TRANS_PRIOR), AVG(CAP_PRE_104)), 10)
					- round(dbo.udf_MinValue(sum(cla.LT52_TRANS), avg(CAP_CUR_52)) - dbo.udf_MinValue(sum(cla.LT52_TRANS_PRIOR), AVG(CAP_PRE_52)), 10)
				) as LT
				,round(dbo.udf_MinValue(1, 1.0 * DAYS104_PRD_CALC / nullif(DAYS104_CALC,0)), 10) as WGT
				,cla.EMPL_SIZE
				,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
				,_104WEEKS_
			FROM #TEMP_MEASURES cla 
			WHERE cla.include_104 = 1 and cla.include_104_trans = 1
			GROUP BY cla.claim_no,cla.Policy_No,cla.Date_of_Injury,_104WEEKS_, DAYS104_PRD_CALC, DAYS104_CALC, cla.EMPL_SIZE
			HAVING round(SUM(total_LT),2) > 5 and round(sum(LT104_TRANS),2) > 5		
		) as cd 
		
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no		
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		INNER JOIN CLAIMS_OFFICERS CO on cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		INNER JOIN ptd_audit ptda ON cd.POLICY_NO = ptda.Policy_No
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type],Med_cert_From=Date_From,Med_cert_To=Date_To 
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
	WHERE cada1.id = (SELECT MAX(cada2.id) FROM cad_audit cada2 
				WHERE cada2.claim_no = cada1.claim_no 
				and cada2.transaction_date <= @Transaction_lag_Remuneration_End)
		AND coa1.id = (SELECT MAX(coa2.id) FROM CO_audit coa2
				WHERE coa2.officer_id = coa1.officer_id 
				and coa2.create_date < @Transaction_lag_Remuneration_End)
		AND ptda.id = (SELECT MAX(ptda2.id) FROM ptd_audit ptda2
				WHERE ptda2.policy_no = ptda.policy_no and ptda2.create_date <= @Transaction_lag_Remuneration_End)		
		

	--Drop all temp table--
	/*
	drop table #uv_TMF_RTW_Payment_Recovery
	drop table #uv_TMF_RTW_Payment_Recovery_Temp
	*/
	IF OBJECT_ID('tempdb..#Tem_ClaimDetail') IS NOT NULL drop table #Tem_ClaimDetail
	IF OBJECT_ID('tempdb..#TEMP_PREMIUM_DETAIL') IS NOT NULL drop table #TEMP_PREMIUM_DETAIL
	IF OBJECT_ID('tempdb..#TEMP_MEASURES') IS NOT NULL drop table #TEMP_MEASURES	
	--End Drop all temp table--

END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_RTW] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_RTW] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_RTW] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_TMF_RTW.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_TMF_RTW_GenerateData.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
 
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_TMF_RTW_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_TMF_RTW_GenerateData]
GO
-- For example
-- exec [usp_Dashboard_TMF_RTW_GenerateData] 2012, 1
-- this will return all result from 2011/01/01 till now
CREATE PROCEDURE [dbo].[usp_Dashboard_TMF_RTW_GenerateData]
	@start_period_year int = 2010,
	@start_period_month int = 9
AS
BEGIN
	
	SET NOCOUNT ON;
	declare @transaction_Start datetime
	declare @remuneration_Start datetime
	declare @remuneration_End datetime
	declare @Transaction_lag int
	declare @SQL varchar(500)
	set @Transaction_lag = 3 --for only TMF	
	
	-----delete last transaction lag number months in dart db---	
	exec('DELETE FROM [DART].[dbo].[TMF_RTW] 
			WHERE remuneration_end in (select distinct top '+@transaction_lag+' remuneration_end 
			from [DART].[dbo].[TMF_RTW] order by remuneration_end desc)')
	-----end delete--	
	
	declare @start_period datetime = CAST(CAST(@start_period_year as varchar) 
											+ '/' + CAST(@start_period_month as varchar) 
											+ '/01' as datetime)
	
	declare @end_period datetime = getdate()
	declare @loop_time int = datediff(month, @start_period, @end_period)
	declare @i int = @loop_time
	declare @yy int
	declare @mm int
	declare @temp datetime
	
	--Check temp table existing then drop
	IF OBJECT_ID('tempdb..#uv_TMF_RTW_Payment_Recovery_Temp') IS NOT NULL DROP TABLE #uv_TMF_RTW_Payment_Recovery_Temp
	IF OBJECT_ID('tempdb..#uv_TMF_RTW_Payment_Recovery') IS NOT NULL DROP TABLE #uv_TMF_RTW_Payment_Recovery
	--Check temp table existing then drop
	
	--create temp table 
	CREATE TABLE #uv_TMF_RTW_Payment_Recovery_Temp
	(
		 Claim_no varchar(19)
		 ,submitted_trans_date datetime
		 ,Payment_Type varchar(15)
		 ,RTW_Payment_Type varchar(3)
		 ,Trans_Amount money
		 ,Payment_no int
		 ,Period_Start_Date datetime
		 ,Period_End_Date datetime
		 ,hours_per_week numeric(5,2)
		 ,HOURS_WC numeric(14,3)
	)
	SET @SQL = 'CREATE INDEX pk_uv_TMF_RTW_Payment_Recovery_Temp_'+CONVERT(VARCHAR, @@SPID)+' ON #uv_TMF_RTW_Payment_Recovery_Temp(Claim_No, Payment_no)'
			EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	CREATE TABLE #uv_TMF_RTW_Payment_Recovery
	(
		 Claim_no varchar(19)
		 ,submitted_trans_date datetime
		 ,RTW_Payment_Type varchar(3)
		 ,Period_Start_Date datetime
		 ,Period_End_Date datetime
		 ,hours_per_week numeric(5,2)
		 ,HOURS_WC numeric(14,3)
		 ,Trans_Amount money 
	)
	SET @SQL = 'CREATE INDEX pk_uv_TMF_RTW_Payment_Recovery_'+CONVERT(VARCHAR, @@SPID)+' ON #uv_TMF_RTW_Payment_Recovery(Claim_no, RTW_Payment_Type, submitted_trans_date)'
		EXEC(@SQL)
	IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END	
	--end create temp table 
		
	WHILE (@i) >= 0
	BEGIN	
		set @temp = dateadd(mm, @i, @start_period)
		set @yy = year(@temp)
		set @mm = MONTH(@temp)			
		
		If NOT EXISTS(select 1 from [DART].[dbo].[TMF_RTW] 
							where Year(remuneration_end) = @yy and
							Month(remuneration_end ) = @mm)
			
			AND cast(CAST(@yy as varchar) + '/' +  CAST(@mm as varchar) + '/01' as datetime)
				< cast(CAST(year(getdate()) as varchar) + '/' +  CAST(month(getdate()) as varchar) + '/01' as datetime)
		BEGIN	
			print cast(@yy as varchar) + ' and ' + cast(@mm as varchar)				
			print '--------------------delete first'
			
			--DELETE FROM  dbo.TMF_RTW 
			--	   WHERE Year(Remuneration_End) = @yy 
			--			 and Month(Remuneration_End) = @mm
			
			--delete data of temp table 		
			DELETE FROM #uv_TMF_RTW_Payment_Recovery_Temp
			DELETE FROM #uv_TMF_RTW_Payment_Recovery
			
			set @remuneration_End = DATEADD(mm
											, -@Transaction_lag + 1
											, CAST(CAST(@yy as varchar) 
														+ '/' 
														+  CAST(@mm as varchar) 
														+ '/01' as datetime))
			set @remuneration_Start = DATEADD(mm,-12, @remuneration_End)
			set @transaction_Start = DATEADD(YY, -3, @remuneration_Start) -- 2 years plus month lag is enough but 3 years for sure
						
			-- Insert into temptable filter S38, S40, TI
			INSERT	INTO #uv_TMF_RTW_Payment_Recovery_Temp
			SELECT  dbo.Payment_Recovery.Claim_No
					,submitted_trans_date=(CASE WHEN dbo.CLAIM_PAYMENT_RUN.Authorised_dte IS NOT NULL THEN						   
											   CASE WHEN dbo.CLAIM_PAYMENT_RUN.Authorised_dte <= CONVERT(datetime, CAST(dbo.Payment_Recovery.wc_Tape_Month AS varchar), 120) 
														THEN dbo.CLAIM_PAYMENT_RUN.Authorised_dte 
													 ELSE dbo.Payment_Recovery.Transaction_date 
												END 
										  ELSE 
												CASE WHEN dbo.claim_payment_run.Paid_Date IS NOT NULL
														 THEN dbo.claim_payment_run.Paid_Date 
													 ELSE dbo.Payment_Recovery.Transaction_date 
												END 
										  END)
					,dbo.Payment_Recovery.Payment_Type
					,RTW_Payment_Type = (CASE WHEN payment_type IN ('14', '15', 'WPT001', 'WPT002', 'WPT003'
															,'WPT004', 'WPT005', 'WPT006', 'WPT007') 
												  THEN 'TI' 
											  WHEN payment_type IN ('16', 'WPP002', 'WPP004', 'WPP005'
															,'WPP006', 'WPP007', 'WPP008') 
												  THEN 'S40' 
											  WHEN payment_type IN ('13', 'WPP001','WPP003') 
												  THEN 'S38' 
										 END)
				   , dbo.Payment_Recovery.Trans_Amount
				   , dbo.Payment_Recovery.Payment_no
				   , dbo.Payment_Recovery.Period_Start_Date
				   , dbo.Payment_Recovery.Period_End_Date
				   , hours_per_week = ISNULL(dbo.Payment_Recovery.hours_per_week, 0) 
				   ,HOURS_WC = (CASE  WHEN Trans_Amount < 0 AND ( (isnull(WC_MINUTES, 0) / 60.0) 
																 + isnull(WC_HOURS, 0) 
																 + isnull(WC_WEEKS * HOURS_PER_WEEK, 0)
																) > 0 
										 THEN - ((isnull(WC_MINUTES, 0) / 60.0) 
													+ isnull(WC_HOURS, 0) 
													+ isnull(WC_WEEKS * HOURS_PER_WEEK, 0)) 
									  ELSE  ((isnull(WC_MINUTES, 0) / 60.0) 
											 + isnull(WC_HOURS, 0) 
											 + isnull(WC_WEEKS * HOURS_PER_WEEK,0))
								END)
			FROM         dbo.Payment_Recovery 
							INNER JOIN  dbo.CLAIM_PAYMENT_RUN 
								ON dbo.Payment_Recovery.Payment_no = dbo.CLAIM_PAYMENT_RUN.Payment_no
								 AND (dbo.Payment_Recovery.wc_Tape_Month IS NOT NULL 
									  AND LEFT(dbo.Payment_Recovery.wc_Tape_Month, 4) <= @yy) 
								 AND (dbo.Payment_Recovery.Transaction_date >= @transaction_Start) 
								 AND (dbo.Payment_Recovery.Payment_Type IN ('14', '15', 'WPT001', 'WPT002'
																			,'WPT003', 'WPT004', 'WPT005'
																			, 'WPT006', 'WPT007', '16'
																			, 'WPP002', 'WPP004','WPP005'
																			, 'WPP006', 'WPP007', 'WPP008'
																			, '13', 'WPP001', 'WPP003'))
			-- End Insert into temptable filter S38, S40, TI
			
			--Insert into temp table after combine transaction--
			INSERT INTO #uv_TMF_RTW_Payment_Recovery
			SELECT  claim_no
					, submitted_trans_date
					, RTW_Payment_Type
					, Period_Start_Date
					, Period_End_Date
					, hours_per_week
					, HOURS_WC = (SELECT SUM(hours_WC) 
									FROM   #uv_TMF_RTW_Payment_Recovery_Temp cla1 
									WHERE  cla1.Claim_No = cla.Claim_No 
										   and cla1.RTW_Payment_Type = cla.RTW_Payment_Type 
										   and cla1.Period_End_Date = cla.Period_End_Date 
										   and cla1.Period_Start_Date = cla.Period_Start_Date  
										   and Period_Start_Date <= @remuneration_End)
					, trans_amount = (SELECT SUM(trans_amount) 
										FROM #uv_TMF_RTW_Payment_Recovery_Temp cla1 
										WHERE cla1.Claim_No = cla.Claim_No 
										and cla1.RTW_Payment_Type = cla.RTW_Payment_Type 
										and cla1.Period_End_Date = cla.Period_End_Date 
										and cla1.Period_Start_Date = cla.Period_Start_Date
										and Period_Start_Date <= @remuneration_End)
			FROM #uv_TMF_RTW_Payment_Recovery_Temp cla 
			WHERE submitted_trans_date = (SELECT   min(cla1.submitted_trans_date) 
											FROM   #uv_TMF_RTW_Payment_Recovery_Temp cla1 
											WHERE  cla1.Claim_No = cla.Claim_No 
												   and cla1.RTW_Payment_Type = cla.RTW_Payment_Type 
												   and cla1.Period_End_Date = cla.Period_End_Date 
												   and cla1.Period_Start_Date = cla.Period_Start_Date 
												   and Period_Start_Date <= @remuneration_End)
			GROUP BY claim_no, submitted_trans_date, RTW_Payment_Type, Period_Start_Date, Period_End_Date, hours_per_week
			--End Insert into temp table after combine transaction--		
			--
			
			print '--------------------then insert'
			
			--INSERT INTO [TMF_RTW]  EXEC [dbo].[usp_Dashboard_TMF_RTW] @yy, @mm, 12
			--INSERT INTO [TMF_RTW]  EXEC [dbo].[usp_Dashboard_TMF_RTW] @yy, @mm, 6
			--INSERT INTO [TMF_RTW]  EXEC [dbo].[usp_Dashboard_TMF_RTW] @yy, @mm, 3
			--INSERT INTO [TMF_RTW]  EXEC [dbo].[usp_Dashboard_TMF_RTW] @yy, @mm, 1	
			
			INSERT INTO [Dart].[dbo].[TMF_RTW]  EXEC [dbo].[usp_Dashboard_TMF_RTW] @yy, @mm, 12
			INSERT INTO [Dart].[dbo].[TMF_RTW]  EXEC [dbo].[usp_Dashboard_TMF_RTW] @yy, @mm, 6
			INSERT INTO [Dart].[dbo].[TMF_RTW]  EXEC [dbo].[usp_Dashboard_TMF_RTW] @yy, @mm, 3
			INSERT INTO [Dart].[dbo].[TMF_RTW]  EXEC [dbo].[usp_Dashboard_TMF_RTW] @yy, @mm, 1			
			
			END
			SET @i = @i - 1 	   
		END	
	
	--drop all temp table 
	IF OBJECT_ID('tempdb..#uv_TMF_RTW_Payment_Recovery') IS NOT NULL drop table #uv_TMF_RTW_Payment_Recovery
	IF OBJECT_ID('tempdb..#uv_TMF_RTW_Payment_Recovery_Temp') IS NOT NULL drop table #uv_TMF_RTW_Payment_Recovery_Temp
	
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_RTW_GenerateData] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_RTW_GenerateData] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_RTW_GenerateData] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_TMF_RTW_GenerateData.sql  
--------------------------------  
