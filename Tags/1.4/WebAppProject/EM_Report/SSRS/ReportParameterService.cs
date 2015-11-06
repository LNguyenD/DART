using System;
using System.Net;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using EM_Report.Common.Logger;
using EM_Report.Domain;
using System.IO;
using EM_Report.Common.Utilities;
using System.Xml.Linq;
using EM_Report.Helpers;
using System.Reflection;
using System.Web.Mvc;

namespace EM_Report.SSRS
{
    using System.ComponentModel.DataAnnotations;

    public class ItemParameter
    {
        public IEnumerable<Microsoft.SqlServer.ReportingServices2010.ItemParameter> lstRSParameters { get; set; }
        public IEnumerable<Microsoft.SqlServer.ReportingServices2010.ParameterValue> lstRSValues { get; set; }
    }
    
    public class RS_Subscription
    {        
        #region general infos
        public string SubscriptionID { get; set; }
        public int ReportId { get; set; }
        public string ReportName { get; set; }
        public int Owner { get; set; }
        public string EventType { get; set; }
        // extentions
        public string DeliveryMethod { get; set; }
        public string FileName { get; set; }
        public string Format { get; set; }

        public string ReportPath { get; set; } // report path on ssrs server
        public DateTime LastExcecute { get; set; }
        public DateTime ModifiedDate { get; set; }
        public string DeliveryStatus { get; set; }
        public string Description { get; set; }
        public short Status { get; set; }
        public string StatusName { get; set; }

        // for local saving
        public string Path { get; set; }       

        // for email delivery
        //[RegularExpression(STR_EMAIL_PATTERN_VALIDATION, ErrorMessage = "Invalid Email")] -- no validation here, because of multiple email addresses
        [Required(ErrorMessage = "*")]
        //Regular Expression for multiple email separate by ; 
        [RegularExpression(@"^(([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})+([;.](([ a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})+)*$", ErrorMessage = "Invalid the email address.")]
        [DataType(DataType.EmailAddress)]
        public string ToEmail { get; set; }
        //[RegularExpression(STR_EMAIL_PATTERN_VALIDATION, ErrorMessage = "Invalid Email")]
        public string CC { get; set; }
        //[RegularExpression(STR_EMAIL_PATTERN_VALIDATION, ErrorMessage = "Invalid Email")]
        public string BCC { get; set; }
        //[RegularExpression(STR_EMAIL_PATTERN_VALIDATION, ErrorMessage = "Invalid Email")]
        public string ReplyTo { get; set; }
        public bool IncludeReport { get; set; }
        [Required(ErrorMessage = "*")]
        public string Subject { get; set; }
        [Required(ErrorMessage = "*")]
        public string Comment { get; set; }
        public bool IncludeLink { get; set; }
        public string Priority { get; set; }

        public string ScheduleDefType { get; set; }

        [Range(0, 24, ErrorMessage = "Hours: 0 to 24")]
        public short Hour { get; set; }

        [Range(0, 60, ErrorMessage = "Minutes: 0 to 60")]
        public short Minute { get; set; }

        public Microsoft.SqlServer.ReportingServices2010.DaysOfWeekSelector wDaysOfWeek { get; set; }
        public Microsoft.SqlServer.ReportingServices2010.DaysOfWeekSelector mDaysOfWeek { get; set; }

        [Range(0, 999, ErrorMessage = "0 to 999")]
        public int DaysInterval { get; set; }
        [Range(0, 999, ErrorMessage = "0 to 999")]
        public int WeeksInterval { get; set; }

        public Microsoft.SqlServer.ReportingServices2010.MonthsOfYearSelector MonthsOfYear { get; set; }
        public short MonthlyType { get; set; }
        public short WeekOfMonth { get; set; }
        [RegularExpression(@"^(((0[1-9]|[1-9]|3[0-1]|([1-2][0-9])),( (0[1-9]|[1-9]|3[0-1]|([1-2][0-9]))-(0[1-9]|[1-9]|3[0-1]|([1-2][0-9]))))|((0[1-9]|[1-9]|3[0-1]|([1-2][0-9]))-(0[1-9]|[1-9]|3[0-1]|([1-2][0-9])))|(0[1-9]|[1-9]|3[0-1]|([1-2][0-9])))$", ErrorMessage="You must choose which days to use.")]
        public string MonthDays { get; set; }

        [Range(1, 12, ErrorMessage = "Start hour: 1 to 12")]
        public int StartHour { get; set; }

        [Range(0, 59, ErrorMessage = "Start minute: 0 to 59")]
        public int StartMinute { get; set; }

        public bool IsAM { get; set; }
        public DateTime StartDate { get; set; }
        public bool HasEndDate { get; set; }
        [EndDate(HasEndDate = "HasEndDate", StartDate = "StartDate")]
        public System.Nullable<DateTime> EndDate { get; set; }
        #endregion

        #region details
        // schedule
        public string ScheduleId { get; set; }
        public string ScheduleName { get; set; }
        public short ScheduleType { get; set; }
        public string ScheduleDefJson { get; set; }
        public bool ScheduleChanged { get; set; }

        // parameters
        public ItemParameter rptParamterModel { get; set; }
        #endregion

        public RS_Subscription()
        {
            Subject = "";
            IncludeReport = true;
            ScheduleDefType = "Once";

            Hour = 1;
            Minute = 0;
            wDaysOfWeek = new Microsoft.SqlServer.ReportingServices2010.DaysOfWeekSelector();
            mDaysOfWeek = new Microsoft.SqlServer.ReportingServices2010.DaysOfWeekSelector();
            DaysInterval = 1;
            WeeksInterval = 1;
            MonthsOfYear = new Microsoft.SqlServer.ReportingServices2010.MonthsOfYearSelector();
            MonthDays = "1, 3-5";
            StartHour = 1;
            StartDate = DateTime.Now;
            EndDate = DateTime.Now.AddDays(1);
            MonthlyType = 0;
            IsAM = true;
            HasEndDate = false;
        }
    }

    public interface I_ReportParameterService
    {
        IEnumerable<Microsoft.SqlServer.ReportingServices2010.ItemParameter> GetVisibleParametersInfo(string systemname, string reportPath);        
        Microsoft.SqlServer.ReportingServices2010.ParameterValue[] GetParameterValues(string subid);
        IList<FilterItem> GetFields(string UrlReportPath);
        IEnumerable<Microsoft.SqlServer.ReportingServices2010.ItemParameter> GetVisibleParametersInfo(string systemname, string reportPath, IEnumerable<Microsoft.SqlServer.ReportingServices2010.ParameterValue> prmValues);        
        IEnumerable<Microsoft.SqlServer.ReportingServices2010.ItemParameter> GetDashboard_VisibleParametersInfo(string reportPath, IEnumerable<Microsoft.SqlServer.ReportingServices2010.ParameterValue> prmValues);
    }
    public class ReportParameterService : I_ReportParameterService
    {        
        private I_Logger _logger;       

        public I_Logger Logger
        {
            get { return _logger; }
            set { _logger = value; }
        }

        public ReportParameterService()
        {
            _logger = new Log4Net();
        }
        public  IList<FilterItem> GetFields(string UrlReportPath)
        {
            try
            {
                byte[] bytes = Base.LoginSession.RS2010.GetItemDefinition(UrlReportPath);

                MemoryStream stream = new MemoryStream(bytes);
                XDocument xdoc = new XDocument();
                xdoc = XDocument.Load(stream);
                XNamespace ns = xdoc.Root.GetDefaultNamespace();
                XNamespace nsRd = xdoc.Root.GetNamespaceOfPrefix("rd");

                IEnumerable<XElement> bookElements = from r in xdoc.Descendants(ns + "DataSet")
                                                     where (string)r.Attribute("Name") == "DataSet"
                                                     select r;

                var bookField = from f in bookElements.Descendants(ns + "Field") select f;

                var elements = from f in bookField
                               select
                                   new
                                       {
                                           DataFields = f.FirstAttribute.Value,
                                           DataType = Commons.ConvertDataTypeToString(f.Value.Replace(f.FirstAttribute.Value, ""))
                                       };
                var result = from p in elements
                             select new FilterItem()
                             {
                                 FieldName = p.DataFields,
                                 DataType = p.DataType
                             };
                return result.ToList();
            }
            catch (Exception ex) { return new List<FilterItem>(); }                             
        }

        public IEnumerable<Microsoft.SqlServer.ReportingServices2010.ItemParameter> GetVisibleParametersInfo(string systemname, string reportPath)
        {
            return GetVisibleParametersInfo(systemname, reportPath, null);
        }       

        public Microsoft.SqlServer.ReportingServices2010.ParameterValue[] GetParameterValues(string subid)
        {
            Microsoft.SqlServer.ReportingServices2010.ExtensionSettings ext = null;
            string desc = null;
            Microsoft.SqlServer.ReportingServices2010.ActiveState activeState = null;
            string status = null;
            string eventType = null;
            string matchDate = null;
            Microsoft.SqlServer.ReportingServices2010.ParameterValue[] pvs = null;
            try
            {
                Base.LoginSession.RS2010.GetSubscriptionProperties(subid, out ext , out desc, out activeState, out status, out eventType, out matchDate, out pvs);                
            }
            catch (Exception ex)
            {
                Logger.Error("Cann't retrieve Report Information, Report doesn't exists!", ex);
            }
            return pvs;
        }

        public static List<Microsoft.Reporting.WebForms.ReportParameter> GetInvisibleParameter(string systemname, string userName, IList<string> exception)
        {
            List<Microsoft.Reporting.WebForms.ReportParameter> reportParams = new List<Microsoft.Reporting.WebForms.ReportParameter>();
            
            if (exception == null || !exception.Contains(Constants.STR_USERNAME_PARAM))
            {
                reportParams.Add(new Microsoft.Reporting.WebForms.ReportParameter(Constants.STR_USERNAME_PARAM, userName, false));
            }
            return reportParams;
        }

        public static IList<Microsoft.SqlServer.ReportingServices2010.ParameterValue> GetInvisibleParameterValue(string systemname , string userName, IList<string> exception)
        {
            List<Microsoft.SqlServer.ReportingServices2010.ParameterValue> reportParams = new List<Microsoft.SqlServer.ReportingServices2010.ParameterValue>();
            
            if (exception == null || !exception.Contains(Constants.STR_USERNAME_PARAM))
            {
                reportParams.Add(new Microsoft.SqlServer.ReportingServices2010.ParameterValue() { Name = Constants.STR_USERNAME_PARAM, Value = userName });
            }
            return reportParams;
        }

        public IEnumerable<Microsoft.SqlServer.ReportingServices2010.ItemParameter> GetVisibleParametersInfo(string systemname,string reportPath, IEnumerable<Microsoft.SqlServer.ReportingServices2010.ParameterValue> prmValues)
        {
            //must assign the DataParam first before get the parameters
            if (prmValues == null)
            {
                prmValues = Enumerable.Empty<Microsoft.SqlServer.ReportingServices2010.ParameterValue>();
            }            

            try
            {                
                return Base.LoginSession.RS2010.GetItemParameters(reportPath, null, true, prmValues.ToArray(), null);
            }
            catch (Exception ex)
            {
                Logger.Error("Can't retrieve Report Information, Report doesn't exists!", ex);
                throw;
            }
        }
        
        public IEnumerable<Microsoft.SqlServer.ReportingServices2010.ItemParameter> GetDashboard_VisibleParametersInfo(string reportPath, IEnumerable<Microsoft.SqlServer.ReportingServices2010.ParameterValue> prmValues)
        {
            //must assign the DataParam first before get the parameters
            if (prmValues == null)
            {
                prmValues = Enumerable.Empty<Microsoft.SqlServer.ReportingServices2010.ParameterValue>();
            }          

            try
            {
                return Base.LoginSession.RS2010.GetItemParameters(reportPath, null, true, prmValues.ToArray(), null);
            }
            catch (Exception ex)
            {
                Logger.Error("Can't retrieve Report Information, Report doesn't exists!", ex);
                throw;
            }
        }
    }

    public class EndDateAttribute : ValidationAttribute
    {
        public string HasEndDate { get; set; }
        public string StartDate { get; set; }

        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            PropertyInfo _HasEndDate = validationContext.ObjectInstance.GetType().GetProperty(HasEndDate);
            PropertyInfo _StartDate = validationContext.ObjectInstance.GetType().GetProperty(StartDate);

            var _HasEndDateValue = _HasEndDate.GetValue(validationContext.ObjectInstance, null);
            var _StartDateValue = _StartDate.GetValue(validationContext.ObjectInstance, null);

            if (value == null && _HasEndDateValue.ToString().ToLower() == "true")
            {
                return new ValidationResult(Domain.Resources.Resource.Sub_Validate_StartDate);
            }
            else if (_HasEndDateValue.ToString().ToLower() == "true" && value != null && DateTime.Parse(value.ToString()) <= DateTime.Parse(_StartDateValue.ToString()))
            {
                return new ValidationResult(Domain.Resources.Resource.Sub_Validate_EndDate_After_StartDate);
            }
            return ValidationResult.Success;
        }
    }    
}