using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Xml.Linq;
using System.Configuration;

namespace EM_Report.Helpers
{
    public static class ViewHelpers
    {
        public static string RowCss(bool isOdd)
        {
            return isOdd ? "odd" : "even";
        }
        
        public static IList<SelectListItem> LocalRenderFormats()
        {
            IList<SelectListItem> result = new List<SelectListItem>();
            try
            {
                XDocument document = XDocument.Load(ConfigurationManager.AppSettings["ReportParamTemplate"]);
                foreach (var item in document.Elements("ReportParam").Elements("LocalRenderFormats").Elements("Format"))
                {
                    result.Add(new SelectListItem() { Text = item.Element("Name").Value, Value = item.Element("Value").Value });
                }
                return result;
            }
            catch
            {
                return new SelectListItem[] { 
                    new SelectListItem { Text = "XML file with report data", Value = "XML"},
                    new SelectListItem { Text = "CSV (comma delimiter)", Value = "CSV"},
                    new SelectListItem { Text = "Data Feed", Value = "Atom"},
                    new SelectListItem { Text = "PDF", Value = "PDF"},
                    new SelectListItem { Text = "HTML 4.0", Value = "HTML 4.0"},
                    new SelectListItem { Text = "MHTML (web archive)", Value = "MHTML"},
                    new SelectListItem { Text = "Excel", Value = "Excel"},
                    new SelectListItem { Text = "RPL Render", Value = "RPL"},
                    new SelectListItem { Text = "TIFF file", Value = "TIFF"},
                    new SelectListItem { Text = "Word", Value = "Word"}};
            }
        }

        public static IList<SelectListItem> EmailRenderFormats()
        {
            IList<SelectListItem> result = new List<SelectListItem>();
            try
            {
                XDocument document = XDocument.Load(ConfigurationManager.AppSettings["ReportParamTemplate"]);
                foreach (var item in document.Elements("ReportParam").Elements("EmailRenderFormats").Elements("Format"))
                {
                    result.Add(new SelectListItem() { Text = item.Element("Name").Value, Value = item.Element("Value").Value });
                }
                return result;
            }
            catch
            {
                return new SelectListItem[] { 
                    new SelectListItem { Text = "XML file with report data", Value = "XML"},
                    new SelectListItem { Text = "CSV (comma delimiter)", Value = "CSV"},
                    new SelectListItem { Text = "PDF", Value = "PDF"},
                    new SelectListItem { Text = "MHTML (web archive)", Value = "MHTML"},
                    new SelectListItem { Text = "Excel", Value = "Excel"},
                    new SelectListItem { Text = "TIFF file", Value = "TIFF"},
                    new SelectListItem { Text = "Word", Value = "Word"}};
            }
        }

        public static IList<SelectListItem> ScheduleTypes()
        {
            IList<SelectListItem> result = new List<SelectListItem>();
            try
            {
                XDocument document = XDocument.Load(ConfigurationManager.AppSettings["ReportParamTemplate"]);
                foreach (var item in document.Elements("ReportParam").Elements("ScheduleTypes").Elements("Schedule"))
                {
                    result.Add(new SelectListItem() { Text = item.Element("Name").Value, Value = item.Element("Value").Value });
                }
                return result;
            }
            catch
            {
                return new SelectListItem[] { 
                    new SelectListItem {Text = "Hour", Value = "Hour"},
                    new SelectListItem {Text = "Day", Value = "Day"},
                    new SelectListItem {Text = "Week", Value = "Week"},
                    new SelectListItem {Text = "Month", Value = "Month"},
                    new SelectListItem {Text = "Once", Value = "Once"}};
            }
        }

        public static IList<SelectListItem> DaysOfWeek()
        {
            IList<SelectListItem> result = new List<SelectListItem>();
            try
            {
                XDocument document = XDocument.Load(ConfigurationManager.AppSettings["ReportParamTemplate"]);
                foreach (var item in document.Elements("ReportParam").Elements("DayOfWeeks").Elements("Day"))
                {
                    result.Add(new SelectListItem() { Text = item.Element("Name").Value, Value = item.Element("Value").Value });
                }
                return result;
            }
            catch
            {
                return new SelectListItem[] { 
                    new SelectListItem {Text = "Sun", Value = "Sun"},
                    new SelectListItem {Text = "Mon", Value = "Mon"},
                    new SelectListItem {Text = "Tue", Value = "Tue"},
                    new SelectListItem {Text = "Wed", Value = "Wed"},
                    new SelectListItem {Text = "Thu", Value = "Thu"},
                    new SelectListItem {Text = "Fri", Value = "Fri"},
                    new SelectListItem {Text = "Sat", Value = "Sat"}};
            }
        }

        public static SelectListItem[] WeekOfMonth()
        {
            //SelectListItem[] result = new SelectListItem[]{};
            //try
            //{
            //    XDocument document = XDocument.Load(ConfigurationManager.AppSettings["ReportParamTemplate"]);
            //    foreach (var item in document.Elements("ReportParam").Elements("WeekOfMonths").Elements("Week"))
            //    {
            //        var iItem = new SelectListItem { Text = item.Element("Name").Value, Value = item.Element("Value").Value };
            //        item.Add(result);                    
            //    }
            //    return result;
            //}
            //catch
            //{
                return new SelectListItem[] { 
                    new SelectListItem {Text = "1st", Value = "1"},
                    new SelectListItem {Text = "2nd", Value = "2"},
                    new SelectListItem {Text = "3rd", Value = "3"},
                    new SelectListItem {Text = "4th", Value = "4"},
                    new SelectListItem {Text = "Last", Value = "5"}};
            //}
        }
    }
}