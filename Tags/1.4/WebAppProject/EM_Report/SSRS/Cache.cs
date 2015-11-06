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

namespace EM_Report.SSRS
{
    public class Cache : RepositoryBase
    {
        public static void Cache_Refresh_Snapshot(bool isRequireCache, bool isRequireRefresh, bool isRequireSnapshot)
        {
            try
            {
                var rs = Base.LoginSession.RS2010;               
                
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
                    DoSnapshotForLevel1(rs, recurrence);
                }                
            }
            catch (Exception ex) { }
        }        

        protected static void DoSnapshotForLevel1(ReportServerProxy rs, WeeklyRecurrence recurrence)
        {
            List<string> arrLevel1 = new List<string>();
            var rItems = rs.ListChildren("/EMReporting/reports", true);
            foreach (var item in rItems)
            {
                if (item.Name.ToLower().IndexOf("_level1") >= 0 || item.Name.ToLower().IndexOf("level0") >= 0)
                {
                    arrLevel1.Add(item.Path);
                }
            }
            if (arrLevel1.Count > 0)
            {
                var definitionSnapshot = new ScheduleDefinition();
                definitionSnapshot.StartDateTime = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, Base.GetIntConfig("Snapshot_At_Hour"), Base.GetIntConfig("Snapshot_At_Minute"), DateTime.Now.Second);
                definitionSnapshot.Item = recurrence;
                foreach (var level1 in arrLevel1)
                {          
                    rs.ListItemHistory(level1).ForEach(e =>
                    {
                        try
                        {                           
                            rs.DeleteItemHistorySnapshot(level1,e.HistoryID);
                        }
                        catch (Exception ex) { }
                    });                    
                    rs.SetExecutionOptions(level1, "Snapshot", definitionSnapshot);
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