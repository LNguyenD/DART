using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace EM_Report.Models
{
    public class ReportModel : I_Status
    {
        public int ReportId { get; set; }

        public int CategoryId { get; set; }
        
        public string CategoryName { get; set; }

        [Required(ErrorMessage = "*")]
        [StringLength(256, ErrorMessage = "The report name must be under {1} characters.")]
        [DataType(DataType.Text)]   
        public string Name { get; set; }
        
        [StringLength(50, ErrorMessage = "The report short name must be under {1} characters.")]
        public string ShortName { get; set; }

        [Required(ErrorMessage = "*")]
        [StringLength(300, ErrorMessage = "The report url must be under {1} characters.")]
        [DataType(DataType.Url)]
        public string Url { get; set; }

        public string UrlFullPath { get; set; }

        [StringLength(256, ErrorMessage = "The report description must be under {1} characters.")]
        [DataType(DataType.MultilineText)]   
        public string Description { get; set; }

        public short Status { get; set; }

        public string StatusName { get; set; } 

        [DataType(DataType.DateTime)]   
        public DateTime? Create_Date { get; set; }

        public int Owner { get; set; }

        public string OwnerName { get; set; }
        public int? UpdatedBy { get; set; }
        public bool Is_Favorite { get; set; }

        public IList<object> ExcludeUserList { get; set; }
        public IList<object> IncludeUserList { get; set; }

        public ReportModel()
        {
            ExcludeUserList = new List<object>();
            IncludeUserList = new List<object>();
        }
    }

    public class ReportPermissionModel
    {
        public int ReportId { get; set; }
        public IList<Report_External_AccessModel> ReportExternalAccessList { get; set; }

        public IList<Report_Organisation_LevelsModel> ReportOrganisationLevelList { get; set; }

        public ReportPermissionModel()
        {
            this.ReportExternalAccessList = new List<Report_External_AccessModel>();
            this.ReportOrganisationLevelList = new List<Report_Organisation_LevelsModel>();
        }
    }
}