using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Linq.Expressions;
using System.Web;
using EM_Report.BLL.Commons;
using EM_Report.Models;
using EM_Report.Models.RS2005;
using EM_Report.DAL;
using EM_Report.BLL.Logger;

namespace EM_Report.BLL.Services
{
    public interface I_RS_SubscriptionService
    {
        RS_SubscriptionModel MappingToModel(EM_Report.Models.RS2005.Subscription subscription);
        EM_Report.Models.RS2005.Subscription MappingToDAL(RS_SubscriptionModel model);
        IEnumerable<RS_SubscriptionModel> GetAll();
        IEnumerable<string> GetAllSubscriptionIdUserCanAccess();
        IEnumerable<RS_SubscriptionModel> GetAllByUserIDvsReport(string reportpath, int userID);
        RS_SubscriptionModel Get(string subID);
        RS_SubscriptionModel GetDetails(string subID);
        string Create(RS_SubscriptionModel subModel);
        bool Update(string subid, RS_SubscriptionModel subModel);
        bool IsExist(string subID);

        void SetStatus(string subID, short status);
        IQueryable<RS_SubscriptionModel> GetQueryable(IEnumerable<RS_SubscriptionModel> items, string sort, string keyword);
        IEnumerable<RS_SubscriptionModel> Sort(string sort, IEnumerable<RS_SubscriptionModel> items);
        IEnumerable<RS_SubscriptionModel> Filter(string keyword, IEnumerable<RS_SubscriptionModel> items);
    }

    public class RS_SubscriptionService : I_RS_SubscriptionService 
    {
        private ReportingService2005 _rs2005;
        private I_ReportService _reportService;
        private I_ScheduleService _scheduleService;
        private I_SubscriptionService _subService;
        private I_LoginSession _session;
        private I_Logger _logger;

        public I_ReportService ReportService
        {
            get { return _reportService; }
            set { _reportService = value; }
        }
        public I_ScheduleService ScdService
        {
            get { return _scheduleService; }
            set { _scheduleService = value; }
        }
        public ReportingService2005 MSReportingService
        {
            get { return _rs2005; }
            set { _rs2005 = value; }
        }
        public I_Logger Logger
        {
            get { return _logger; }
            set { _logger = value; }
        }

        public RS_SubscriptionService(I_LoginSession session)
        {
            _session = session;
            _reportService = new ReportService(session);
            _scheduleService = new ScheduleService();
            _rs2005 = new ReportingService2005();
            _rs2005.Url = ConfigurationManager.AppSettings[Constants.STR_REPORT_SERVER_URL] + ConfigurationManager.AppSettings["ReportServicePath"];
            _rs2005.Credentials = new ReportViewerCredentials().NetworkCredentials;
            _subService = new SubscriptionService(_session);
            _logger = new Log4Net();
        }

        public RS_SubscriptionModel MappingToModel(EM_Report.Models.RS2005.Subscription subscription)
        {
            ReportModel rptModel = ReportService.GetReportByReportPath(subscription.Path);
            RS_SubscriptionModel subModel = new RS_SubscriptionModel()
            {
                SubscriptionID = subscription.SubscriptionID,
                DeliveryMethod = subscription.DeliverySettings.Extension,
                ReportPath = subscription.Path,
                ReportId = rptModel.ReportId,
                ReportName = rptModel.Name,
                EventType = subscription.EventType,
                LastExcecute = subscription.LastExecuted.ToString(),
                ModifiedDate = subscription.ModifiedDate.ToString(),
                Description = subscription.Description,
                DeliveryStatus = subscription.Status
            };
            if (subModel.DeliveryMethod.IndexOf("Email") >= 0)
            {
                MappingSubscriptionEmail(subscription, subModel);
            }
            else
            {
                MappingWebSubscriptionData(subscription, subModel);
            }
            return subModel;
        }

        private static void MappingWebSubscriptionData(EM_Report.Models.RS2005.Subscription subscription, RS_SubscriptionModel subModel)
        {
            subModel.Format = GetParamValue("RENDER_FORMAT", subscription);
            subModel.FileName = GetParamValue("FILENAME", subscription);
            subModel.Path = GetParamValue("PATH", subscription);

            subModel.Credential = new Credential()
            {
                UserName = ConfigurationManager.AppSettings["MainSSRSAccount_UserName"],
                Password = ConfigurationManager.AppSettings["MainSSRSAccount_Password"]
            };
        }

        private static void MappingSubscriptionEmail(EM_Report.Models.RS2005.Subscription subscription, RS_SubscriptionModel subModel)
        {
            // email delivery
            subModel.ToEmail = GetParamValue("TO", subscription);
            subModel.CC = GetParamValue("CC", subscription);
            subModel.BCC = GetParamValue("BCC", subscription);
            subModel.ReplyTo = GetParamValue("ReplyTo", subscription);
            subModel.IncludeReport = bool.Parse(GetParamValue("IncludeReport", subscription));
            subModel.Subject = GetParamValue("Subject", subscription);
            subModel.Comment = GetParamValue("Comment", subscription);
            subModel.IncludeLink = bool.Parse(GetParamValue("IncludeLink", subscription));
            subModel.Priority = GetParamValue("Priority", subscription);
            subModel.Format = GetParamValue("RenderFormat", subscription);
            subModel.FileName = subscription.Report;
        }

        private static string GetParamValue(string name, EM_Report.Models.RS2005.Subscription subscription)
        {
            var param = ((ParameterValue)subscription.DeliverySettings.ParameterValues.Where(v => ((ParameterValue)v).Name == name).FirstOrDefault());
            return param != null ? param.Value : string.Empty;
        }

        public  EM_Report.Models.RS2005.Subscription MappingToDAL(RS_SubscriptionModel model)
        {
            List<ParameterValue> prmValues = new List<ParameterValue>();
            
            if (model.DeliveryMethod.IndexOf("Email") >= 0)
            {
                prmValues.Add(new ParameterValue() { Name = "RenderFormat", Value = model.Format });
                prmValues.Add(new ParameterValue() { Name = "TO", Value = model.ToEmail });
                prmValues.Add(new ParameterValue() { Name = "CC", Value = model.CC });
                prmValues.Add(new ParameterValue() { Name = "BCC", Value = model.BCC });
                prmValues.Add(new ParameterValue() { Name = "ReplyTo", Value = model.ReplyTo });
                prmValues.Add(new ParameterValue() { Name = "IncludeReport", Value = model.IncludeReport.ToString() });
                prmValues.Add(new ParameterValue() { Name = "Subject", Value = model.Subject });
                prmValues.Add(new ParameterValue() { Name = "Comment", Value = model.Comment });
                prmValues.Add(new ParameterValue() { Name = "IncludeLink", Value = model.IncludeLink.ToString() });
                prmValues.Add(new ParameterValue() { Name = "Priority", Value = "NORMAL" });
            }
            else
            {
                prmValues.Add(new ParameterValue() { Name = "RENDER_FORMAT", Value = model.Format });
                prmValues.Add(new ParameterValue() { Name = "FILENAME", Value = model.FileName });
                prmValues.Add(new ParameterValue() { Name = "PATH", Value = model.Path });
                prmValues.Add(new ParameterValue() { Name = "USERNAME", Value = model.Credential.UserName });
                prmValues.Add(new ParameterValue() { Name = "PASSWORD", Value = model.Credential.Password });
            }
            return new EM_Report.Models.RS2005.Subscription()
            {
                SubscriptionID = model.SubscriptionID,
                DeliverySettings = new ExtensionSettings() {  Extension = model.DeliveryMethod, ParameterValues = prmValues.ToArray()}
            };
        }

        #region RS Service
        private IEnumerable<EM_Report.Models.RS2005.Subscription> GetAll_RS_Subscriptions()
        {
            try
            {
                return _rs2005.ListSubscriptions(null, null);
            }
            catch (Exception ex)
            {
                Logger.Error("GetAll_RS_Subscriptions ERROR", ex);
            }
            return Enumerable.Empty<EM_Report.Models.RS2005.Subscription>();
        }
        #endregion

        #region EMReport Service
        public IEnumerable<RS_SubscriptionModel> GetAll()
        {
            try
            {
                return GetAll_RS_Subscriptions().Select(s => MappingToModel(s));
            }
            catch (Exception ex)
            {
                Logger.Error(ex.Message, ex);
            }
            return Enumerable.Empty<RS_SubscriptionModel>();
        }

        public IEnumerable<string> GetAllSubscriptionIdUserCanAccess()
        {
            try
            {
                return GetAllSubscriptionUserCanAccess().Select(s => s.SubscriptionID);
            }
            catch (Exception ex)
            {
                Logger.Error(ex.Message, ex);
            }
            return Enumerable.Empty<string>();
        }

        public IEnumerable<SubscriptionModel> GetAllSubscriptionUserCanAccess()
        {
            try
            {
                return _subService.GetAllQueryable(string.Empty, string.Empty);
            }
            catch (Exception ex)
            {
                Logger.Error(ex.Message, ex);
            }
            return Enumerable.Empty<SubscriptionModel>();
        }

        public IEnumerable<RS_SubscriptionModel> GetAllByUserIDvsReport(string reportpath, int userID)
        {
            var subList = GetAllSubscriptionUserCanAccess( );
            var subIds = subList.Select(s => s.SubscriptionID);
            
            var rsSubscriptionList = GetAll_RS_Subscriptions().Where(s => subIds.Contains(s.SubscriptionID));
            if (!string.IsNullOrEmpty(reportpath))
                rsSubscriptionList = rsSubscriptionList.Where(s => s.Path.ToLower() == reportpath.ToLower());

            var rsSubscriptionModelList = rsSubscriptionList.Select(s => MappingToModel(s));
            
            IList<RS_SubscriptionModel> subsModelListResult = new List<RS_SubscriptionModel>();

            foreach (var item in rsSubscriptionModelList)
            {
                var subModel = subList.First(s => s.SubscriptionID == item.SubscriptionID);
                item.Status = subModel.Status.Value;
                item.ScheduleType = (short)(subModel.ScheduleType != null ? subModel.ScheduleType.Value : 1);
                item.ReportName = subModel.ReportName;

                // delete at runtime subscriptions that expired
                if (item.ScheduleType == 1 && _rs2005.GetScheduleProperties(subModel.ScheduleID).State == ScheduleStateEnum.Expired)
                {
                    DeleteExpiredRS_Subscription(subModel);
                }
                else
                {
                    subsModelListResult.Add(item);
                }
            }
            return subsModelListResult;
        }

        public SubscriptionModel GetSubscriptionModel(string subscriptionId)
        {
            var subList = GetAllSubscriptionUserCanAccess();
            return subList.First(s => s.SubscriptionID == subscriptionId);
        }

        public void DeleteExpiredRS_Subscription(SubscriptionModel subModel)
        {
            // delete schedule
            I_ScheduleService scdService = new ScheduleService();
            scdService.DeleteSchedule(subModel.ScheduleID);
            // delete sub ssrs
            _rs2005.DeleteSubscription(subModel.SubscriptionID);
            // delete sub
            _subService.Delete(subModel.SubscriptionID);
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

        public RS_SubscriptionModel Get(string subID)
        {
            try
            {
                return MappingToModel(GetAll_RS_Subscriptions().SingleOrDefault(sub => sub.SubscriptionID == subID));
            }
            catch (Exception ex)
            {
                Logger.Error(ex.Message, ex);
            }
            return null;
        }

        public RS_SubscriptionModel GetDetails(string subID)
        {
            RS_SubscriptionModel subscription = Get(subID);
            GetReportParameter(subscription);
            GetSchedule(subID, subscription);
            return subscription;
        }

        private void GetSchedule(string subID, RS_SubscriptionModel subscription)
        {            
            var s = _subService.GetById(subID);
            subscription.Status = s.Status.Value;
            subscription.Owner = s.Owner.Value;
            subscription.ScheduleType = (short)(s.ScheduleType != null ? s.ScheduleType.Value : 1);
            subscription.ReportId = s.ReportId;            

            I_ScheduleService scdService = new ScheduleService();
            Schedule scd = scdService.Get(s.ScheduleID);
            subscription.ScheduleDefJson = HttpUtility.UrlEncode(ScheduleService.SerializeSchedule(scd.Definition).InnerXml);
            subscription.ScheduleId = scd.ScheduleID;
            subscription.ScheduleName = scd.Name;
            subscription.Description = scd.Description;

            subscription.HasEndDate = scd.Definition.EndDateSpecified;
            subscription.EndDate = scd.Definition.EndDate;
            subscription.StartDate = scd.Definition.StartDateTime;            

            subscription.IsAM = scd.Definition.StartDateTime.TimeOfDay.Hours > 12 || (scd.Definition.StartDateTime.TimeOfDay.Hours == 12 && scd.Definition.StartDateTime.TimeOfDay.Minutes > 0) ? false : true;
            subscription.StartHour = subscription.IsAM ? scd.Definition.StartDateTime.TimeOfDay.Hours : scd.Definition.StartDateTime.TimeOfDay.Hours - 12;
            subscription.StartMinute = scd.Definition.StartDateTime.TimeOfDay.Minutes;
            if (scd.Definition.Item != null)
            {
                switch (scd.Definition.Item.GetType().Name)
                {
                    case "MinuteRecurrence":
                        subscription.ScheduleDefType = "Hour";
                        MinuteRecurrence minuteRec = (MinuteRecurrence)scd.Definition.Item;
                        subscription.Hour = (short)(minuteRec.MinutesInterval / 60);
                        subscription.Minute = (short)(minuteRec.MinutesInterval % 60);
                        break;
                    case "DailyRecurrence":
                        subscription.ScheduleDefType = "Day";
                        DailyRecurrence dailyRec = (DailyRecurrence)scd.Definition.Item;
                        subscription.DaysInterval = dailyRec.DaysInterval;
                        break;
                    case "WeeklyRecurrence":
                        subscription.ScheduleDefType = "Week";
                        WeeklyRecurrence weeklyRec = (WeeklyRecurrence)scd.Definition.Item;
                        subscription.WeeksInterval = weeklyRec.WeeksInterval;
                        subscription.wDaysOfWeek = weeklyRec.DaysOfWeek;
                        break;
                    case "MonthlyDOWRecurrence":
                        subscription.ScheduleDefType = "Month";
                        MonthlyDOWRecurrence monthlyDOWRec = (MonthlyDOWRecurrence)scd.Definition.Item;
                        subscription.MonthlyType = 0;
                        subscription.WeekOfMonth = GetWeekSelected(monthlyDOWRec.WhichWeek);
                        subscription.mDaysOfWeek = monthlyDOWRec.DaysOfWeek;
                        subscription.MonthsOfYear = monthlyDOWRec.MonthsOfYear;
                        break;
                    case "MonthlyRecurrence":
                        subscription.ScheduleDefType = "Month";
                        MonthlyRecurrence monthlyRec = (MonthlyRecurrence)scd.Definition.Item;
                        subscription.MonthlyType = 1;
                        subscription.MonthDays = monthlyRec.Days;
                        subscription.MonthsOfYear = monthlyRec.MonthsOfYear;
                        break;
                }
            }
        }

        private static void GetReportParameter(RS_SubscriptionModel subscription)
        {
            ReportParameterService prmService = new ReportParameterService();
            subscription.rptParamterModel = new ReportParameterModel()
            {
                lstRSParameters = prmService.GetVisibleParametersInfo(subscription.ReportPath, null),
                lstRSValues = prmService.GetParameterValues(subscription.SubscriptionID)
            };
        }

        public string Create(RS_SubscriptionModel subModel)
        {
            string newSubID = null;
            try 
	        {
                ScheduleDefinition scdDef = ScheduleService.DeserializeSchedule(HttpUtility.UrlDecode(subModel.ScheduleDefJson));
                short stype = 0;
                subModel.ScheduleId = ScdService.CreateSchedule(subModel.ScheduleName, scdDef, ref stype);
                subModel.ScheduleType = stype;
                EM_Report.Models.RS2005.Subscription rsSubscription = MappingToDAL(subModel);
                newSubID = _rs2005.CreateSubscription(
                                            ReportService.GetById(subModel.ReportId).UrlFullPath, 
                                            rsSubscription.DeliverySettings,
                                            subModel.Description,
                                            subModel.EventType,
                                            subModel.ScheduleId,
                                            subModel.rptParamterModel.lstRSValues.ToArray());
	        }
	        catch (Exception ex)
	        {
                // rollback create schedule if create subscription unsuccessfully
                _rs2005.DeleteSchedule(subModel.ScheduleId);
                Logger.Error(ex.Message, ex);
                throw ex;
	        }
            
            // update subscription owner if create subscription successfully
            _subService.Create(new SubscriptionModel()
            {
                Owner = subModel.Owner,
                SubscriptionID = newSubID,
                ScheduleID = subModel.ScheduleId,
                Status = subModel.Status,
                ScheduleType = subModel.ScheduleType,
                ReportId = subModel.ReportId
            });
            return newSubID;
        }

        public bool Update(string subid, RS_SubscriptionModel subModel)
        {
            ScheduleDefinition scdDef = ScheduleService.DeserializeSchedule(HttpUtility.UrlDecode(subModel.ScheduleDefJson));
            short stype = 0;
            ScdService.SetSchedule(subModel.ScheduleName, subModel.ScheduleId, scdDef, ref stype);
            subModel.ScheduleType = stype;
            ReportParameterService prmService = new ReportParameterService();
            EM_Report.Models.RS2005.Subscription subscription = MappingToDAL(subModel);
            _rs2005.SetSubscriptionProperties(
                subid, 
                subscription.DeliverySettings, 
                subModel.Description,
                subModel.EventType,
                subModel.ScheduleId,
                subModel.rptParamterModel.lstRSValues.ToArray());
          
            // subOwnerService.SetStatus(subid, subModel.Status);
            _subService.SetScheduleType(subid, subModel.ScheduleType);
            return true;
        }
        #endregion

        public bool IsExist(string subID)
        {
            return GetAll_RS_Subscriptions().Any(s => s.SubscriptionID == subID);
        }

        public void SetStatus(string subID, short status)
        {
            string scheduleID = _subService.SetStatus(subID, status).ScheduleID;

            ScheduleService scdService = new ScheduleService();
            switch (status)
            {
                case 1: 
                    scdService.ResumeSchedule(scheduleID); 
                    break;
                case 2: 
                    scdService.PauseSchedule(scheduleID); 
                    break;
                default: 
                    scdService.PauseSchedule(scheduleID);
                    break;
            }
        }

        public IQueryable<RS_SubscriptionModel> GetQueryable(IEnumerable<RS_SubscriptionModel> items, string sort, string keyword)
        {
            items = Filter(keyword, items);

            items = Sort(sort, items);

            return items.AsQueryable();
        }

        public IEnumerable<RS_SubscriptionModel> Sort(string sort, IEnumerable<RS_SubscriptionModel> items)
        {
            if (string.IsNullOrEmpty(sort))
                return items;

            var param = Expression.Parameter(typeof(RS_SubscriptionModel), "item");

            var sortExpression = Expression.Lambda<Func<RS_SubscriptionModel, object>>
                (Expression.Convert(Expression.Property(param, sort.Split('|')[0].ToString()), typeof(object)), param);
            if (sort.Split('|')[1] != null && sort.Split('|')[1].ToLower().IndexOf(Constants.G_ORDER_DESC) >= 0)
            {
                items = items.AsQueryable<RS_SubscriptionModel>().OrderByDescending<RS_SubscriptionModel, object>(sortExpression);
            }
            else
            {
                items = items.AsQueryable<RS_SubscriptionModel>().OrderBy<RS_SubscriptionModel, object>(sortExpression);
            }
            return items;
        }

        public  IEnumerable<RS_SubscriptionModel> Filter(string keyword, IEnumerable<RS_SubscriptionModel> items)
        {
            var predicate = PredicateBuilder.False<RS_SubscriptionModel>();
            if (!string.IsNullOrEmpty(keyword))
            {
                keyword = keyword.ToLower();
                items = from p in items
                        where p.FileName.Contains(keyword)
                            || (p.Format == null ? string.Empty : p.Format.ToLower()).Contains(keyword)
                            || (p.ReportPath == null ? string.Empty : p.ReportPath.ToLower()).Contains(keyword)
                            || (p.DeliveryMethod == null ? string.Empty : p.DeliveryMethod.ToLower()).Contains(keyword)
                            || (p.Path == null ? string.Empty : p.Path.ToLower()).Contains(keyword)
                            || (p.DeliveryStatus == null ? string.Empty : p.DeliveryStatus.ToLower()).Contains(keyword)
                        select p;
            }
            return items;
        }
    }
}