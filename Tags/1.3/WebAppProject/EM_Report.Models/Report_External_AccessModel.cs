using System;
using System.ComponentModel.DataAnnotations;


namespace EM_Report.Models
{
    public class Report_External_AccessModel
    {
        public int ReportId { get; set; }
        public int External_GroupId { get; set; }
        public DateTime? Create_Date { get; set; }
        public int Owner { get; set; }
        public string OwnerName { get; set; }
        public string ReportName { get; set; }
        public string ExternalGroupName { get; set; }
        public int? UpdatedBy { get; set; } 
    }   
}