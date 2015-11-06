	
/* Update graph description */
update dbo.Dashboard_Graph_Description
set [Description] = 'WOW - Claims portfolio movement past 12 months'
where [Type] = 'WOW_CPR'

update dbo.Dashboard_Graph_Description
set [Description] = 'HEM - Claims portfolio movement past 12 months'
where [Type] = 'HEM_CPR'

update dbo.Dashboard_Graph_Description
set [Description] = 'TMF - Claims portfolio movement past 12 months'
where [Type] = 'TMF_CPR'

update dbo.Dashboard_Graph_Description
set [Description] = 'EML - Claims portfolio movement past 12 months'
where [Type] = 'EML_CPR'	