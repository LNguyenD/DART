using EM_Report.Common.Utilities;
using EM_Report.Helpers;
using System.IO;
using System.Web.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Samples.ReportingServices.CustomSecurity;
using System.Text;
using Microsoft.SqlServer.ReportingServices2010;
using EM_Report.Domain;
using EM_Report.Domain.Resources;
using System.Collections;
using System.Data;

namespace EM_Report.Controllers
{
    public class SSRSDeployController : BaseController
    {
        [HttpGet]
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Index(List<SSRSCacheSetting> model)
        {
            try
            {
                var havePermission = Base.LoginSession.isSystemUser;
                if (!havePermission)
                    return RedirectToAction("index", "welcome");
                else
                {
                    Cache_Refresh_Snapshot(true, true, true, model);
                }

                return new HttpStatusCodeResult(200);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }   
        }

        private void Cache_Refresh_Snapshot(bool isRequireCache, bool isRequireRefresh, bool isRequireSnapshot, List<SSRSCacheSetting> settings)
        {
            try
            {
                ReportServerProxy server = new ReportServerProxy();
                // Get the server URL from the report server using WMI
                server.Url = Base.GetConfig("ReportServerUrl") + Base.GetConfig("ReportServicePath2010");

                server.LogonUser(Base.LoginSession.strUserName, Base.LoginSession.strPassWord, "false");
                server.Timeout = 3600000;

                var rs = server;
                var datasets = rs.ListChildren("/EMReporting/dataset", true);
                var reports = rs.ListChildren("/EMReporting/reports", true);
                foreach (var setting in settings)
                {
                    var definition = new ScheduleDefinition();
                    var scheduleID = "";
                    var schRef = new ScheduleReference();
                    var SchExp = new ScheduleExpiration();

                    var scheName = "Daily cache for report dataset at " + setting.SSRSCacheAtHour + " : " + setting.SSRSCacheAtMinute;
                    string descRefresh = "Daily refresh of the report cache at " + setting.RefreshSSRSCacheAtHour + " : " + setting.RefreshSSRSCacheAtMinute;


                    definition.StartDateTime = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, setting.SSRSCacheAtHour, setting.SSRSCacheAtMinute, DateTime.Now.Second);
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
                    refreshDefinition.StartDateTime = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, setting.RefreshSSRSCacheAtHour, setting.RefreshSSRSCacheAtMinute, DateTime.Now.Second);
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

                    CatalogItem[] targetDatasets = null;
                    CatalogItem[] targetReports = null;
                    if (setting.DashboardType.Equals("Others", StringComparison.InvariantCultureIgnoreCase))
                    {
                        targetDatasets = datasets.Where(d => !(d.Name.Contains("AWC") || d.Name.Contains("RTW") || d.Name.Contains("CPR"))).ToArray();
                        targetReports = reports.Where(r => !(r.Name.Contains("AWC") || r.Name.Contains("RTW") || r.Name.Contains("CPR"))).ToArray();
                    }
                    else
                    {
                        targetDatasets = datasets.Where(d => d.Name.Contains(setting.DashboardType)).ToArray();
                        targetReports = reports.Where(r => r.Name.Contains(setting.DashboardType)).ToArray();
                    }
                    
                    if (isRequireCache)
                    {
                        Cache_Share_Dataset(setting.DashboardType, rs, targetDatasets, schRef, SchExp, isRequireCache, scheduleID);
                    }
                    if (isRequireRefresh)
                    {
                        Refresh_Share_Dataset(setting.DashboardType, rs, targetDatasets, descRefresh, eventType, defString, isRequireRefresh);
                    }

                    if (isRequireSnapshot)
                    {
                        Take_Snapshot_Report(setting.DashboardType, rs, targetReports, setting.SSRSSnapshotAtHour, setting.SSRSSnapshotAtMinute);
                    }
                }
            }
            catch (Exception ex)
            {
            }
        }

        private void Take_Snapshot_Report(string System, ReportServerProxy rs, CatalogItem[] items, int ssrsSnapshotAtH, int ssrsSnapshotAtM)
        {
            var reports = new List<string> { "level0", "level1", "level2" };

            List<string> snapshotReports = new List<string>();
            foreach (var item in items)
            {
                if (reports.Any(r => item.Name.ToLower().Contains(r.ToLower())))
                {
                    snapshotReports.Add(item.Path);
                }
            }

            if (snapshotReports.Count > 0)
            {
                var definitionSnapshot = new ScheduleDefinition();
                definitionSnapshot.StartDateTime = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, ssrsSnapshotAtH, ssrsSnapshotAtM, DateTime.Now.Second);
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
                }
            }
        }

        private void Cache_Share_Dataset(string System, ReportServerProxy rs, CatalogItem[] items, ScheduleReference schRef, ScheduleExpiration SchExp, bool isRequireCache, string scheduleID)
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

        private void Refresh_Share_Dataset(string System, ReportServerProxy rs, CatalogItem[] items, string descRefresh, string eventType, string defString, bool isRequireRefresh)
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