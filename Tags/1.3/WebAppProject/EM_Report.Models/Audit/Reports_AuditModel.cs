using System;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace EM_Report.Models
{
    public class Reports_AuditModel : ReportModel  
    {
        public int Id { get; set; }
        public string Action_Type { get; set; }
        public DateTime? Action_Date { get; set; }
        public int? Action_Owner { get; set; }
    }   
}