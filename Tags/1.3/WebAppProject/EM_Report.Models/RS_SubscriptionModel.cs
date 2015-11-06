using System;
using System.Collections.Generic;
using EM_Report.Models.RS2005;
using System.Configuration;
using System.Web.Mvc;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;

namespace EM_Report.Models
{
    public class Credential
    {
        public string UserName { get; set; }
        public string Password { get; set; }
        public Credential() 
        {
            UserName = ConfigurationManager.AppSettings["MainSSRSAccount_UserName"];
            Password = ConfigurationManager.AppSettings["MainSSRSAccount_Password"];
        }
    }
    public class ReportParameterModel
    {
        public IEnumerable<ReportParameter> lstRSParameters { get; set; }
        public IEnumerable<ParameterValue> lstRSValues { get; set; }
    }
    public class RS_SubscriptionModel
    {
        private const string STR_EMAIL_PATTERN_VALIDATION = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}";
        #region general infos
        public string SubscriptionID {get; set;}
        public int ReportId { get; set; }
        public string ReportName { get; set; }
        public int Owner { get; set; }
        public string EventType { get; set; }
        // extentions
        public string DeliveryMethod { get; set; }
        public string FileName { get; set; }
        public string Format { get; set; }

        public string ReportPath { get; set; } // report path on ssrs server
        public string LastExcecute { get; set; }
        public string ModifiedDate {get;set;}
        public string DeliveryStatus { get; set; }
        public string Description { get; set; }
        public short Status { get; set; }
        public string StatusName { get; set; }

        // for local saving
        public string Path { get; set; }
        public Credential Credential { get; set; } // extentions

        // for email delivery
        //[RegularExpression(STR_EMAIL_PATTERN_VALIDATION, ErrorMessage = "Invalid Email")] -- no validation here, because of multiple email addresses
        [Required]
        //Regular Expression for multiple email separate by ; 
        [RegularExpression(@"^(([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})+([;.](([ a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})+)*$")]
        [DataType(DataType.EmailAddress)]
        public string ToEmail { get; set; }
        //[RegularExpression(STR_EMAIL_PATTERN_VALIDATION, ErrorMessage = "Invalid Email")]
        public string CC { get; set; }
        //[RegularExpression(STR_EMAIL_PATTERN_VALIDATION, ErrorMessage = "Invalid Email")]
        public string BCC { get; set; }
        //[RegularExpression(STR_EMAIL_PATTERN_VALIDATION, ErrorMessage = "Invalid Email")]
        public string ReplyTo { get; set; }
        public bool IncludeReport { get; set; }
        [Required]
        public string Subject { get; set; }
        [Required]
        public string Comment { get; set; }
        public bool IncludeLink { get; set; }
        public string Priority { get; set; }


        private const string STR_DATETIME_VALIDATION = @"/^(?:(?:(?:0?[13578]|1[02])(\/|-|\.)31)\1|(?:(?:0?[1,3-9]|1[0-2])(\/|-|\.)(?:29|30)\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:0?2(\/|-|\.)29\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:(?:0?[1-9])|(?:1[0-2]))(\/|-|\.)(?:0?[1-9]|1\d|2[0-8])\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$/igm";
       

        public string ScheduleDefType { get; set; }

        [Range(0, 24, ErrorMessage = "Hours: 0 to 24")]
        public short Hour { get; set; }

        [Range(0, 60, ErrorMessage = "Minutes: 0 to 60")]
        public short Minute { get; set; }

        public DaysOfWeekSelector wDaysOfWeek { get; set; }
        public DaysOfWeekSelector mDaysOfWeek { get; set; }

        [Range(0, 999, ErrorMessage = "0 to 999")]
        public int DaysInterval { get; set; }
        [Range(0, 999, ErrorMessage = "0 to 999")]
        public int WeeksInterval { get; set; }

        public MonthsOfYearSelector MonthsOfYear { get; set; }
        public short MonthlyType { get; set; }
        public short WeekOfMonth { get; set; }
        [RegularExpression(@"^(((0[1-9]|[1-9]|3[0-1]|([1-2][0-9])),( (0[1-9]|[1-9]|3[0-1]|([1-2][0-9]))-(0[1-9]|[1-9]|3[0-1]|([1-2][0-9]))))|((0[1-9]|[1-9]|3[0-1]|([1-2][0-9]))-(0[1-9]|[1-9]|3[0-1]|([1-2][0-9])))|(0[1-9]|[1-9]|3[0-1]|([1-2][0-9])))$")]
        public string MonthDays { get; set; }

        [Range(1, 12, ErrorMessage = "Start hour: 1 to 12")]
        public int StartHour { get; set; }

        [Range(0, 59, ErrorMessage = "Start minute: 0 to 59")]
        public int StartMinute { get; set; }

        public bool IsAM { get; set; }        
        public DateTime StartDate { get; set; }
        public bool HasEndDate { get; set; }        
        public DateTime EndDate { get; set; }
        #endregion

        #region details
        // schedule
        public string ScheduleId { get; set; }
        public string ScheduleName { get; set; }
        public short ScheduleType { get; set; }
        public string ScheduleDefJson { get; set; }
        public bool ScheduleChanged { get; set; }

        // parameters
        public ReportParameterModel rptParamterModel { get; set; }
        #endregion

        public RS_SubscriptionModel()
        {
            Subject = ConfigurationManager.AppSettings["DefaultEmailSubject"];
            IncludeReport = true;
            ScheduleDefType = "Once";

            Hour = 1;
            Minute = 0;
            wDaysOfWeek = new DaysOfWeekSelector();
            mDaysOfWeek = new DaysOfWeekSelector();
            DaysInterval = 1;
            WeeksInterval = 1;
            MonthsOfYear = new MonthsOfYearSelector();
            MonthDays = "1, 3-5";
            StartHour = 1;
            StartDate = DateTime.Now;
            EndDate = DateTime.Now.AddDays(1);
            MonthlyType = 0;
            IsAM = true;
            HasEndDate = false;
        }        
    }
}