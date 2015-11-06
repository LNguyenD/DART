using System;

namespace EM_Report.Models
{
    public class Report_Organisation_LevelsModel
    {
        //DB fields
        public int ReportId { get; set; }
        public int LevelId { get; set; }
        public DateTime? Create_Date { get; set; }
        public int Owner { get; set; }
        public int? UpdatedBy { get; set; } 

        //Extra fields
        public string OwnerName { get; set; }
        public string ReportName { get; set; }
        public string LevelName { get; set; }
    }
}