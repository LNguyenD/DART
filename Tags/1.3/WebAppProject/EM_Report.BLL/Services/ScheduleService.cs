using System.Configuration;
using System.IO;
using System.Xml;
using System.Xml.Serialization;
using EM_Report.BLL.Commons;
using EM_Report.Models;
using EM_Report.Models.RS2005;

namespace EM_Report.BLL.Services
{
    public interface I_ScheduleService
    {
        ScheduleModel MapToModel(Schedule scd);
        Schedule MapToDal(ScheduleModel scdModel);
        Schedule Get(string id);
        string CreateSchedule(string name, ScheduleDefinition definition, ref short scheduleType);
        void SetSchedule(string name, string id, ScheduleDefinition definition, ref short scheduleType);
        void PauseSchedule(string id);
        void ResumeSchedule(string id);
        void DeleteSchedule(string id);
    }
    public class ScheduleService : I_ScheduleService
    {
        ReportingService2005 _rs = new ReportingService2005();

        private string GetDaysOfWeekString(DaysOfWeekSelector dow)
        {
            string result = "";
            result += dow.Monday    ? "Mon," : "";
            result += dow.Tuesday   ? "Tue," : "";
            result += dow.Wednesday ? "Wed," : "";
            result += dow.Thursday  ? "Thu," : "";
            result += dow.Friday    ? "Fri," : "";
            result += dow.Saturday  ? "Sar," : "";
            result += dow.Sunday    ? "Sun," : "";
            if (!string.IsNullOrEmpty(result))
                result = result.Substring(0, result.Length - 1);
            return result;
        }

        private short GetWeekSelected(WeekNumberEnum w)
        {
            switch (w)
            {
                case WeekNumberEnum.FirstWeek:
                    return 1;
                case WeekNumberEnum.SecondWeek:
                    return 2;
                case WeekNumberEnum.ThirdWeek:
                    return 3;
                case WeekNumberEnum.FourthWeek:
                    return 4;
                case WeekNumberEnum.LastWeek:
                    return 5;
            }
            return 1;
        }

        public WeekNumberEnum GetWeekEnum(short w)
        {
            switch (w)
            {
                case 1:
                    return WeekNumberEnum.FirstWeek;
                case 2:
                    return WeekNumberEnum.SecondWeek;
                case 3:
                    return WeekNumberEnum.ThirdWeek;
                case 4:
                    return WeekNumberEnum.FourthWeek;
                case 5:
                    return WeekNumberEnum.LastWeek;
            }
            return WeekNumberEnum.FirstWeek;
        }

        public ScheduleService()
        {
            _rs.Url = ConfigurationManager.AppSettings[Constants.STR_REPORT_SERVER_URL] + ConfigurationManager.AppSettings["ReportServicePath"];
            _rs.Credentials = new ReportViewerCredentials().NetworkCredentials;
        }

        public ScheduleModel MapToModel(Schedule scd)
        {
            ScheduleModel scdModel = new ScheduleModel();
            scdModel.ScheduleId = scd.ScheduleID;
            scdModel.StartHour = (short)((scd.Definition.StartDateTime.Hour > 12 && scd.Definition.StartDateTime.Hour <= 23) ? scd.Definition.StartDateTime.Hour - 12 : scd.Definition.StartDateTime.Hour);
            scdModel.StartMinute = (short)scd.Definition.StartDateTime.Minute;
            scdModel.IsAM = scd.Definition.StartDateTime.ToString().IndexOf("AM") >= 0;
            scdModel.StartDate = scd.Definition.StartDateTime;
            scdModel.HasEndDate = scd.Definition.EndDateSpecified;
            scdModel.EndDate = scd.Definition.EndDate;
            if (scd.Definition.Item != null)
            {
                switch (scd.Definition.Item.GetType().Name)
                {
                    case "MinuteRecurrence":
                        scdModel.ScheduleDefType = "Hour";
                        MinuteRecurrence minuteRec = (MinuteRecurrence)scd.Definition.Item;
                            scdModel.Hour = (short)(minuteRec.MinutesInterval / 60);
                            scdModel.Minute = (short)(minuteRec.MinutesInterval % 60);
                        break;
                    case "DailyRecurrence":
                        scdModel.ScheduleDefType = "Day";
                        DailyRecurrence dailyRec = (DailyRecurrence)scd.Definition.Item;
                        scdModel.DaysInterval = dailyRec.DaysInterval;
                        break;
                    case "WeeklyRecurrence":
                        scdModel.ScheduleDefType = "Week";
                        WeeklyRecurrence weeklyRec = (WeeklyRecurrence)scd.Definition.Item;
                        scdModel.WeeksInterval = weeklyRec.WeeksInterval;
                        scdModel.wDaysOfWeek = weeklyRec.DaysOfWeek;
                        break;
                    case "MonthlyDOWRecurrence":
                        scdModel.ScheduleDefType = "Month";
                        MonthlyDOWRecurrence monthlyDOWRec = (MonthlyDOWRecurrence)scd.Definition.Item;
                        scdModel.MonthlyType = 0;
                        scdModel.WeeksOfMonth = GetWeekSelected(monthlyDOWRec.WhichWeek);
                        scdModel.mDaysOfWeek = monthlyDOWRec.DaysOfWeek;
                        scdModel.MonthsOfYear = monthlyDOWRec.MonthsOfYear;
                        break;
                    case "MonthlyRecurrence":
                        scdModel.ScheduleDefType = "Month";
                        MonthlyRecurrence monthlyRec = (MonthlyRecurrence)scd.Definition.Item;
                        scdModel.MonthlyType = 1;
                        scdModel.MonthDays = monthlyRec.Days;
                        scdModel.MonthsOfYear = monthlyRec.MonthsOfYear;
                        break;
                }
            }
            else
            {
                scdModel.ScheduleDefType = "Once";
            }
            return scdModel;
        }

        public Schedule MapToDal(ScheduleModel scdModel)
        {
            ScheduleDefinition scdDef = new ScheduleDefinition();
            int hour = scdModel.IsAM ? scdModel.StartHour : scdModel.StartHour + 12;
            scdDef.StartDateTime = new System.DateTime(scdModel.StartDate.Year, scdModel.StartDate.Month, scdModel.StartDate.Day, hour, scdModel.StartMinute, 0);
            scdDef.EndDate = scdModel.EndDate;
            scdDef.EndDateSpecified = scdModel.HasEndDate;

            switch (scdModel.ScheduleDefType)
            {
                case "Hour":
                    scdDef.Item = new MinuteRecurrence(){ MinutesInterval = scdModel.Hour * 60 + scdModel.Minute};
                    break;
                case "Day":
                    scdDef.Item = new DailyRecurrence() { DaysInterval = scdModel.DaysInterval };
                    break;
                case "Week":
                    scdDef.Item = new WeeklyRecurrence() { WeeksInterval = scdModel.WeeksInterval, WeeksIntervalSpecified = true, DaysOfWeek = scdModel.wDaysOfWeek };
                    break;
                case "Month":
                    if (scdModel.MonthlyType == 0)
                        scdDef.Item = new MonthlyDOWRecurrence()
                        {
                            MonthsOfYear = scdModel.MonthsOfYear,
                            DaysOfWeek = scdModel.mDaysOfWeek,
                            WhichWeek = GetWeekEnum(scdModel.WeeksOfMonth),
                            WhichWeekSpecified = true
                        };
                    else
                        scdDef.Item = new MonthlyRecurrence() { MonthsOfYear = scdModel.MonthsOfYear, Days = scdModel.MonthDays };
                    break;
                case "Once":
                    scdDef.Item = null;
                    break;
            }
            return new Schedule() { Definition = scdDef };
        }

        public static XmlDocument SerializeSchedule(ScheduleDefinition schedule)
        {
            MemoryStream buffer = new MemoryStream();
            XmlSerializer xmlSerializer = new XmlSerializer(typeof(ScheduleDefinition));
            xmlSerializer.Serialize(buffer, schedule);
            buffer.Seek(0, SeekOrigin.Begin);

            XmlDocument doc = new XmlDocument();
            doc.Load(buffer);
            // patch up WhichWeek
            XmlNamespaceManager ns = new XmlNamespaceManager(doc.NameTable);
            ns.AddNamespace("rs",
                    "http://schemas.microsoft.com/sqlserver/2003/12/reporting/reportingservices");

            XmlNode node =
                doc.SelectSingleNode(
                     "/ScheduleDefinition/rs:MonthlyDOWRecurrence/rs:WhichWeek", ns
                );
            if (node != null)
            {
                switch (node.InnerXml)
                {
                    case "FirstWeek":
                        node.InnerXml = "FIRST_WEEK"; break;
                    case "SecondWeek":
                        node.InnerXml = "SECOND_WEEK"; break;
                    case "ThirdWeek":
                        node.InnerXml = "THIRD_WEEK"; break;
                    case "FourthWeek":
                        node.InnerXml = "FOURTH_WEEK"; break;
                    case "LastWeek":
                        node.InnerXml = "LAST_WEEK"; break;
                }
            }

            return doc;
        }

        public static ScheduleDefinition DeserializeSchedule(string xml)
        {
            XmlSerializer xmlSerializer = new XmlSerializer(typeof(ScheduleDefinition));
            StringReader sr = new StringReader(xml);
            ScheduleDefinition scdDef = (ScheduleDefinition)xmlSerializer.Deserialize(sr);
            return scdDef;
        }

        public Schedule Get(string id)
        {
            return _rs.GetScheduleProperties(id);
        }

        public string CreateSchedule(string name, ScheduleDefinition definition, ref short scheduleType)
        {
            scheduleType = (short)(definition.Item == null ? 1 : 2);
            return _rs.CreateSchedule(name, definition);
        }
        public void SetSchedule(string name, string id, ScheduleDefinition definition, ref short scheduleType)
        {
            scheduleType = (short)(definition.Item == null ? 1 : 2);
            _rs.SetScheduleProperties(name, id, definition);
        }
        public void PauseSchedule(string id)
        {
            _rs.PauseSchedule(id);
        }
        public void ResumeSchedule(string id)
        {
            _rs.ResumeSchedule(id);
        }
        public void DeleteSchedule(string id)
        {
            _rs.DeleteSchedule(id);
        }
    }
}