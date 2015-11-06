using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Linq;
using System.Runtime.Caching;
using System.Web;
using EM_Report.Common.Utilities;
using EM_Report.Domain;
using EM_Report.ActionServiceReference;
using EM_Report.Repositories;
using Microsoft.Reporting.WebForms;
using System.Net;
using System.Xml;
using System.Data;
using System.Globalization;
using System.Security.Cryptography.X509Certificates;
using Microsoft.Samples.ReportingServices.CustomSecurity;
using System.ServiceModel;
using System.IO;
using System.Text;
using Microsoft.SqlServer.ReportingServices2010;
using System.Xml.Linq;
using EM_Report.Helpers;
using EM_Report.Domain.Enums;

namespace EM_Report.SSRS
{
    public class Cache : RepositoryBase
    {
        public static void Cache_Refresh_Snapshot(bool isRequireCache, bool isRequireRefresh, bool isRequireSnapshot)
        {
            try
            {
                ReportServerProxy server = new ReportServerProxy();
                // Get the server URL from the report server using WMI
                server.Url = Base.GetConfig("ReportServerUrl") + Base.GetConfig("ReportServicePath2010");
               
                server.LogonUser(Base.LoginSession.strUserName, Base.LoginSession.strPassWord, "false");
                server.Timeout = 3600000;

                var rs = server;               
                
                var definition = new ScheduleDefinition();
                var scheduleID = "";
                var schRef = new ScheduleReference();
                var SchExp = new ScheduleExpiration();

                var scheName = "Daily cache for report dataset at " + Base.GetConfig("Cache_Dataset_At_Hour") + " : " + Base.GetConfig("Cache_Dataset_At_Minute");
                string descRefresh = "Daily refresh of the report cache at " + Base.GetConfig("Refresh_Cache_Dataset_At_Hour") + " : " + Base.GetConfig("Refresh_Cache_Dataset_At_Minute");
                var items = rs.ListChildren("/EMReporting/dataset", true);

                definition.StartDateTime = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, Base.GetIntConfig("Cache_Dataset_At_Hour"), Base.GetIntConfig("Cache_Dataset_At_Minute"), DateTime.Now.Second);
                var recurrence = new WeeklyRecurrence();
                var days = new DaysOfWeekSelector();
                days.Monday = true;
                days.Tuesday = true;
                days.Wednesday = true;
                days.Thursday = true;
                days.Friday = true;
                days.Saturday = true;
                days.Sunday = true;
                recurrence.DaysOfWeek = days;
                recurrence.WeeksInterval = 1;
                recurrence.WeeksIntervalSpecified = true;
                definition.Item = recurrence;

                string eventType = "RefreshCache";
                var refreshDefinition = new ScheduleDefinition();

                // Create the schedule definition.
                refreshDefinition.StartDateTime = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, Base.GetIntConfig("Refresh_Cache_Dataset_At_Hour"),Base.GetIntConfig("Refresh_Cache_Dataset_At_Minute"), DateTime.Now.Second);
                refreshDefinition.Item = recurrence;

                // Serialize schedule definition
                System.Xml.Serialization.XmlSerializer serializer =
                    new System.Xml.Serialization.XmlSerializer(
                        typeof(ScheduleDefinition));

                MemoryStream stream = new MemoryStream();
                serializer.Serialize(stream, refreshDefinition);
                UTF8Encoding encoding = new UTF8Encoding();
                string defString = encoding.GetString(stream.ToArray());

                foreach (var sch in rs.ListSchedules(null))
                {
                    if (scheName.Equals(sch.Name))
                    {
                        scheduleID = sch.ScheduleID;
                        break;
                    }
                }

                if (scheduleID == "")
                {
                    scheduleID = rs.CreateSchedule(scheName, definition, null);
                }               
               
                if (isRequireCache)
                {
                    Cache_Share_Dataset(rs, items, schRef, SchExp, isRequireCache, scheduleID);
                }
                if (isRequireRefresh)
                {
                    Refresh_Share_Dataset(rs, items, descRefresh, eventType, defString, isRequireRefresh);
                }

                if (isRequireSnapshot)
                {
                    Take_Snapshot_Report(rs, recurrence);
                }                
            }
            catch (Exception ex) { }
        }

        protected static void Take_Snapshot_Report(ReportServerProxy rs, WeeklyRecurrence recurrence)
        {
            var reports = new List<string> { "level0", "level1", "level2" };

            List<string> snapshotReports = new List<string>();
            var rItems = rs.ListChildren("/EMReporting/reports", true);
            foreach (var item in rItems)
            {
                if (reports.Any(r => item.Name.ToLower().Contains(r.ToLower())))
                {
                    snapshotReports.Add(item.Path);
                }
            }

            if (snapshotReports.Count > 0)
            {
                var definitionSnapshot = new ScheduleDefinition();
                definitionSnapshot.StartDateTime = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, Base.GetIntConfig("Snapshot_At_Hour"), Base.GetIntConfig("Snapshot_At_Minute"), DateTime.Now.Second);
                definitionSnapshot.Item = recurrence;
                foreach (var report in snapshotReports)
                {
                    rs.ListItemHistory(report).ForEach(e =>
                    {
                        try
                        {
                            rs.DeleteItemHistorySnapshot(report, e.HistoryID);
                        }
                        catch (Exception ex) { }
                    });
                    rs.SetExecutionOptions(report, "Snapshot", definitionSnapshot);
                    rs.SetItemHistoryOptions(report, true, true, definitionSnapshot);
                    rs.UpdateItemExecutionSnapshot(report);
                    Microsoft.SqlServer.ReportingServices2010.Warning[] warnings;
                    rs.CreateItemHistorySnapshot(report, out warnings);
                }
            }
        }        

        protected static void Cache_Share_Dataset(ReportServerProxy rs, CatalogItem[] items, ScheduleReference schRef, ScheduleExpiration SchExp, bool isRequireCache, string scheduleID)
        {
            foreach (var item in items)
            {
                schRef.ScheduleID = scheduleID;
                SchExp.Item = schRef;
                if (isRequireCache)
                {
                    rs.SetCacheOptions(item.Path, true, SchExp);
                }                
            }
        }

        protected static void Refresh_Share_Dataset(ReportServerProxy rs, CatalogItem[] items, string descRefresh, string eventType, string defString, bool isRequireRefresh)
        {           
            foreach (var item in items)
            {
                rs.ListCacheRefreshPlans(item.Path).ForEach(e =>
                {
                    try
                    {
                        rs.DeleteCacheRefreshPlan(e.CacheRefreshPlanID);
                    }
                    catch (Exception ex) { }
                });
                string CacheRefreshPlanID = rs.CreateCacheRefreshPlan(item.Path, descRefresh, eventType, defString, null);                 
            }
        }        
    }
}