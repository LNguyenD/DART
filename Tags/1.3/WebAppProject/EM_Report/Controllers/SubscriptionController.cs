using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Script.Serialization;
using EM_Report.BLL.Commons;
using EM_Report.BLL.Resources;
using EM_Report.BLL.Services;
using EM_Report.Helpers;
using EM_Report.Models;
using System.Net;
using System.Globalization;
using EM_Report.Models.RS2005;

namespace EM_Report.Controllers
{
    public class SubscriptionController : BaseController
    {
        I_RS_SubscriptionService _rs_subService = new RS_SubscriptionService(Base.LoginSession);       
        I_ScheduleService _scheduleService = new ScheduleService();
        I_ReportParameterService _reportParamService = new ReportParameterService();
        I_ReportService _reportService = new ReportService(Base.LoginSession);
        I_UserService _userService = new UserService(Base.LoginSession);
       
        SelectListItem[] _monthsOfYear = new SelectListItem[]{
                                                        new SelectListItem {Text = "Jan", Value = "Jan"},
                                                        new SelectListItem {Text = "Feb", Value = "Feb"},
                                                        new SelectListItem {Text = "Mar", Value = "Mar"},
                                                        new SelectListItem {Text = "Apr", Value = "Apr"},
                                                        new SelectListItem {Text = "May", Value = "May"},
                                                        new SelectListItem {Text = "Jun", Value = "Jun"},
                                                        new SelectListItem {Text = "Jil", Value = "Jil"},
                                                        new SelectListItem {Text = "Aug", Value = "Aug"},
                                                        new SelectListItem {Text = "Sep", Value = "Sep"},
                                                        new SelectListItem {Text = "Oct", Value = "Oct"},
                                                        new SelectListItem {Text = "Nov", Value = "Nov"},
                                                        new SelectListItem {Text = "Dec", Value = "Dec"}};
        SelectListItem[] _daySegment = new SelectListItem[]{
                                                        new SelectListItem {Text = "AM", Value = "true"},
                                                        new SelectListItem {Text = "PM", Value = "false"}};
        SelectListItem[] _monthType = new SelectListItem[]{
                                                        new SelectListItem {Text = "On week of month: ", Value = "0"},
                                                        new SelectListItem {Text = "On calendar day(s): ", Value = "1"}};


        public SubscriptionController()
            : base()
        {
            ViewBag.RenderFormats = ViewHelpers.LocalRenderFormats();            
            ViewBag.Pagesizes = new SelectList(Base.PageSizeOptions(), "10");
        }

        [HttpGet]
        public ActionResult Index(string reportid, string search_input, string hddSort)
        {
            var hddPaging = 1;
            hddSort = hddSort ?? "ModifiedDate|desc";
            var pagesize = ResourcesHelper.Report_PageSize;
            string reportPath = string.Empty;           
            var list = _rs_subService.GetQueryable(_rs_subService.GetAllByUserIDvsReport(reportPath, Base.LoginSession.intUserId), hddSort, "");

            var pagedList = UpdateViewBag<RS_SubscriptionModel>(search_input, hddSort, hddPaging, pagesize, list);
            ViewBag.ReportId = reportid;
            return View(pagedList);
        }

        [HttpPost]
        public ActionResult Index(string reportid, FormCollection collection, string hddAction, string search_input, string hddSort, int? hddPaging = 1)
        {
            var pagesize = int.Parse(Request.Form["cboDisplayEntry"]);
            hddSort = hddSort ?? string.Empty;

            string reportPath = string.Empty;
            
            var list = _rs_subService.GetQueryable(_rs_subService.GetAllByUserIDvsReport(reportPath, Base.LoginSession.intUserId), hddSort, search_input.Trim());

            var pagedList = UpdateViewBag<RS_SubscriptionModel>(search_input, hddSort, hddPaging, pagesize, list);
            return View(pagedList);
        }
        
        // GET: /Subscription/Details/
        public ActionResult Details(string reportid, string subid)
        {
            ViewBag.ScheduleTypes = ViewHelpers.ScheduleTypes();           
            ViewBag.DaySegment = _daySegment;            
            ViewBag.ScheduleTypes = ViewHelpers.ScheduleTypes();
            ViewBag.DaysOfWeek = ViewHelpers.DaysOfWeek();
            ViewBag.WeeksOfMonth = ViewHelpers.WeekOfMonth();            
            ViewBag.MonthsOfYear = _monthsOfYear;
            ViewBag.MonthType = _monthType;
            
            //edit existing subscription
            if (!string.IsNullOrEmpty(subid))
            {
                if (!_rs_subService.GetAllSubscriptionIdUserCanAccess().Contains(subid))
                    return ReturnAccessDenied();

                RS_SubscriptionModel sub = _rs_subService.GetDetails(subid);
                ViewBag.StatusList = Base.StatusList();
                ViewBag.Action = "Edit";
                // used in Edit Post
                Session["RS_SubscriptionModel"] = sub;
                return View(sub);
            }

            //create new subscription
            RS_SubscriptionModel subModel = new RS_SubscriptionModel();
            IEnumerable<ReportModel> reports = _reportService.GetAllReportUserCanAccess(Base.LoginSession.intUserId);
            if (string.IsNullOrEmpty(reportid))
            {
                if (reports.IsNullOrEmpty())
                {
                    return ReturnAccessDenied();
                }
                reportid = reports.ElementAt(0).ReportId.ToString();
            }
            if (!reports.Select(r => r.ReportId).Contains(int.Parse(reportid)))
            {
                return ReturnAccessDenied();
            }
            ReportModel rptModel = _reportService.GetById(reportid);
            ScheduleDefinition defaultSchDef = (ScheduleDefinition)HttpContext.Application["DefaultSchedule"];
            defaultSchDef.StartDateTime = DateTime.Now.Date;           

            subModel = new RS_SubscriptionModel()
            {
                rptParamterModel = new ReportParameterModel()
                {
                    lstRSParameters = _reportParamService.GetVisibleParametersInfo(rptModel.UrlFullPath)
                },
                ReportPath = rptModel.UrlFullPath,
                ReportId = rptModel.ReportId,
                DeliveryMethod = Constants.DeliveryMethodNames[DeliveryMethod.EMAIL],
                ScheduleDefJson = HttpUtility.UrlEncode(ScheduleService.SerializeSchedule(defaultSchDef).InnerXml),
                Status = ResourcesHelper.StatusActive                 
            };

            ViewBag.ReportList = reports;            
            ViewBag.ReportName = rptModel.Name;
            ViewBag.Action = "Create";
            ViewBag.StatusList = Base.StatusList();
            Session["RS_SubscriptionModel"] = subModel;

            return View(subModel);
        }

        private bool IsValidMonth()
        {
            if (Request.Form["MonthsOfYear.January"] == "true" || Request.Form["MonthsOfYear.February"] == "true" ||
                Request.Form["MonthsOfYear.March"] == "true" || Request.Form["MonthsOfYear.April"] == "true" ||
                Request.Form["MonthsOfYear.May"] == "true" || Request.Form["MonthsOfYear.June"] == "true" ||
                Request.Form["MonthsOfYear.July"] == "true" || Request.Form["MonthsOfYear.August"] == "true" ||
                Request.Form["MonthsOfYear.September"] == "true" || Request.Form["MonthsOfYear.October"] == "true" ||
                Request.Form["MonthsOfYear.November"] == "true" || Request.Form["MonthsOfYear.December"] == "true")
            {
                return true;
            }
            return false;            
        }

        private bool IsValidWeek()
        {
            if (Request.Form["wDaysOfWeek.Sunday"] == "true" || Request.Form["wDaysOfWeek.Monday"] == "true" ||
                Request.Form["wDaysOfWeek.Tuesday"] == "true" || Request.Form["wDaysOfWeek.Wednesday"] == "true" ||
                Request.Form["wDaysOfWeek.Thursday"] == "true" || Request.Form["wDaysOfWeek.Friday"] == "true" ||
                Request.Form["wDaysOfWeek.Saturday"] == "true")
            {
                return true;
            }
            return false;            
        }

        [HttpPost]
        public ActionResult Details(string subid, RS_SubscriptionModel sub, FormCollection collection, string reportParameterNames, string Schedule, string hdClientUTC)
        {
            if (!ModelState.IsValid || (sub.ScheduleDefType == "Month" && !IsValidMonth()) || (sub.ScheduleDefType == "Week" && !IsValidWeek()))
            {
                ShowError(Resource.msgInvalidInput);
                GetViewBagProperties();                                
            }
            else
            {                
                //edit existing subscription
                if (!string.IsNullOrEmpty(subid))
                {
                    return UpdateSubscription(sub, collection, reportParameterNames, Schedule, hdClientUTC);
                }
                //create new subscription
                try
                {
                    return CreateSubscription(sub, collection, reportParameterNames, Schedule, hdClientUTC);
                }
                catch (Exception)
                {
                    GetViewBagProperties();
                    ShowError(Resource.msgInvalidInput);
                }
                ViewBag.StatusList = Base.StatusList();           
            }
            return View(sub);
        }

        private void GetViewBagProperties() {
            IEnumerable<ReportModel> reports = _reportService.GetAllReportUserCanAccess(Base.LoginSession.intUserId);
            ViewBag.ReportList = reports;
            ViewBag.ScheduleTypes = ViewHelpers.ScheduleTypes();
            ViewBag.DaySegment = _daySegment;
            ViewBag.DaysOfWeek = ViewHelpers.DaysOfWeek();
            ViewBag.WeeksOfMonth = ViewHelpers.WeekOfMonth();
            ViewBag.MonthsOfYear = _monthsOfYear;
            ViewBag.MonthType = _monthType;
        }

        [HttpPost]
        public string UpdateFormatList(string deliveryMethod)
        {
            RS_SubscriptionModel subModel = Session["RS_SubscriptionModel"] != null ? (RS_SubscriptionModel)Session["RS_SubscriptionModel"] : null;

            string htmlString = null;
            if (deliveryMethod.IndexOf("Email") >= 0)
            {
                htmlString = "<option value='XML'>XML file with report data</option>" +
                        "<option value='CSV'>CSV (comma delimiter)</option>" +
                        "<option value='PDF'>PDF</option>" +
                        "<option value='MHTML'>MHTML (web archive)</option>" +
                        "<option value='Excel'>Excel</option>" +
                        "<option value='TIFF'>TIFF file</option>" +
                        "<option value='Word'>Word</option>";
            }
            else
            {
                htmlString = "<option value='XML'>XML file with report data</option>" +
                        "<option value='CSV'>CSV (comma delimiter)</option>" +
                        "<option value='Atom'>Data Feed</option>" +
                        "<option value='PDF'>PDF</option>" +
                        "<option value='HTML 4.0'>HTML 4.0</option>" +
                        "<option value='MHTML'>MHTML (web archive)</option>" +
                        "<option value='Excel'>Excel</option>" +
                        "<option value='RPL'>RPL Render</option>" +
                        "<option value='TIFF'>TIFF file</option>" +
                        "<option value='Word'>Word</option>";
            }
            if (subModel != null && subModel.DeliveryMethod.IndexOf(deliveryMethod) >= 0)
            {
                htmlString = htmlString.Replace("value='" + subModel.Format + "'", "value='" + subModel.Format + "'" + " selected='true'");
            }
            return htmlString;
        }

        [HttpPost]
        public ActionResult ReportParameter(string ReportId, string ReportParameterValue)
        {
            List<ParameterValue> prmValues = new List<ParameterValue>();
            if (!string.IsNullOrEmpty(ReportParameterValue))
            {
                prmValues = new List<ParameterValue>();
                foreach (var param in ReportParameterValue.Split(';'))
                {
                    string[] text = param.Split('|');
                    string name = text[0];
                    string[] values = text.Length > 1 ? text[1].Split(',') : new string[] { };
                    foreach (string s in values)
                    {
                        if (!string.IsNullOrEmpty(name))
                        {
                            prmValues.Add(new ParameterValue() { Name = name, Value = s });
                        }
                    }
                }
            }
            ReportParameterModel parameters = new ReportParameterModel() { lstRSParameters = _reportParamService.GetVisibleParametersInfo(_reportService.GetById(ReportId).UrlFullPath, prmValues.AsEnumerable()) };
            return View("ReportParameter", parameters);
        }       
        
        public string SearchReport(string reportname)
        {
            IEnumerable<ReportModel> reports = new List<ReportModel>();
            reports = _reportService.GetAllReportUserCanAccess(Base.LoginSession.intUserId);
            var list = from r in reports
                       select new DropDownItemModel() { Id = r.ReportId, Value = r.Name };
            return new JavaScriptSerializer().Serialize(list);
        }        

        protected string GetSchedule(RS_SubscriptionModel sub,string hdClientUTC)
        {
            ScheduleDefinition scdDef = new ScheduleDefinition();            
            int hour = sub.IsAM ? sub.StartHour : sub.StartHour + 12;           

            scdDef.StartDateTime = Base.ConvertToServerDatetime(new System.DateTime(sub.StartDate.Year, sub.StartDate.Month, sub.StartDate.Day, hour, sub.StartMinute, 0),hdClientUTC);
            scdDef.EndDate = sub.EndDate;
            scdDef.EndDateSpecified = sub.HasEndDate;
            
            switch (sub.ScheduleDefType)
            {
                case "Hour":
                    scdDef.Item = new MinuteRecurrence() { MinutesInterval = sub.Hour * 60 + sub.Minute };
                    break;
                case "Day":
                    scdDef.Item = new DailyRecurrence() { DaysInterval = sub.DaysInterval };
                    break;
                case "Week":
                    scdDef.Item = new WeeklyRecurrence() { WeeksInterval = sub.WeeksInterval, WeeksIntervalSpecified = true, DaysOfWeek = sub.wDaysOfWeek };
                    break;
                case "Month":
                    if (sub.MonthlyType==0)
                        scdDef.Item = new MonthlyDOWRecurrence()
                        {
                            MonthsOfYear = sub.MonthsOfYear,
                            DaysOfWeek = sub.mDaysOfWeek,
                            WhichWeek = (new ScheduleService()).GetWeekEnum(sub.WeekOfMonth),
                            WhichWeekSpecified = true
                        };
                    else
                        scdDef.Item = new MonthlyRecurrence() { MonthsOfYear = sub.MonthsOfYear, Days = sub.MonthDays };
                    break;
                case "Once":
                    scdDef.Item = null;
                    break;
            }
            Schedule scd = new Models.RS2005.Schedule() { Definition = scdDef };            
            sub.ScheduleDefJson = HttpUtility.UrlEncode(ScheduleService.SerializeSchedule(scd.Definition).InnerXml);
            sub.ScheduleChanged = true;            
            return sub.ScheduleDefJson;
        }

        private ActionResult CreateSubscription(RS_SubscriptionModel sub, FormCollection collection, string reportParameterNames, string Schedule, string hdClientUTC)
        {
            // schedule
            sub.ScheduleName = sub.ReportPath + " - " + DateTime.Now.ToString();
            Schedule = GetSchedule(sub, hdClientUTC);             
            sub.EventType = "TimedSubscription";
            sub.Owner = Base.LoginSession.intUserId;
            sub.rptParamterModel = ((RS_SubscriptionModel)Session["RS_SubscriptionModel"]).rptParamterModel;
            sub.rptParamterModel.lstRSValues = GetReportParameterValues(collection, reportParameterNames);            
            _rs_subService.Create(sub);          
            return RedirectToAction("index");
        }

        private ActionResult UpdateSubscription(RS_SubscriptionModel sub, FormCollection collection, string reportParameterNames, string Schedule, string hdClientUTC)
        {
            RS_SubscriptionModel subModel = null;
            subModel = Session["RS_SubscriptionModel"] != null ? (RS_SubscriptionModel)Session["RS_SubscriptionModel"] : _rs_subService.Get(sub.SubscriptionID);
            subModel.Subject = sub.Subject;
            subModel.ToEmail = sub.ToEmail;
            subModel.IncludeLink = sub.IncludeLink;
            subModel.IncludeReport = sub.IncludeReport;
            subModel.Format = sub.Format;
            subModel.Comment = sub.Comment;
            subModel.rptParamterModel.lstRSValues = GetReportParameterValues(collection, reportParameterNames);

            try
            {
                // schedule
                Schedule = GetSchedule(sub, hdClientUTC);
                subModel.ScheduleDefJson = Schedule;
                _rs_subService.Update(sub.SubscriptionID, subModel);                
                return RedirectToAction("index");
            }
            catch {
                return View(subModel);   
            }            
        }

        public static List<ParameterValue> GetReportParameterValues(FormCollection collection, string reportParameterNames)
        {
            List<ParameterValue> prmValues = new List<ParameterValue>();
            if (collection.Get("ReportParameterValues") != null)
            {
                var parameters = collection.Get("ReportParameterValues").Split('>');
                var mutipleNames = collection.Get("MultiSelects").Split(',');
                if (parameters.Length > 0)
                {
                    foreach (string param in parameters)
                    {
                        if (param.Contains("prm"))
                        {
                            var items = param.Split('|');
                            if (items.Length > 0 && items[0].StartsWith("prm"))
                            {
                                var name = items[0].Substring(3);
                                if (mutipleNames.Contains(items[0]))
                                {
                                    string[] values = items[1].Split(',');
                                    foreach (string s in values)
                                    {
                                        prmValues.Add(new ParameterValue() { Name = name, Value = s });
                                    }
                                }
                                else
                                {
                                    prmValues.Add(new ParameterValue() { Name = name, Value = items[1] });
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                foreach (string name in reportParameterNames.Split(','))
                {
                    if (collection.AllKeys.Any(k => k.Equals("multiselect_prm" + name)))
                    {
                        string[] values = collection.Get("multiselect_prm" + name).Split(',');
                        foreach (string s in values)
                        {
                            prmValues.Add(new ParameterValue() { Name = name, Value = s });
                        }
                    }
                    else
                    {
                        prmValues.Add(new ParameterValue() { Name = name, Value = collection.Get("prm" + name) });
                    }
                }  
            }
            prmValues.AddRange(ReportParameterService.GetInvisibleParameterValue(Base.LoginSession.strUserName, null));
            return prmValues;
        }
        
        private ActionResult ReturnAccessDenied()
        {
            return RedirectToAction("AccessDenied", "Account");
        }

        [HttpPost]
        public DateTime ConvertServerTimeToClientTime(DateTime dtServer,string strSourceTimeZoneIdClient)
        {
            return  Base.ConvertToClientDatetime(dtServer, strSourceTimeZoneIdClient);
        }       
    }
}
