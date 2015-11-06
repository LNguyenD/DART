namespace EM_Report.Domain
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;

    [DataContract(Name = "Report", Namespace = "http://www.yourcompany.com/types/")]
    public class Report : I_Status
    {
        [DataMember]
        public int ReportId { get; set; }

        [DataMember]
        public int CategoryId { get; set; }

        [DataMember]
        public string CategoryName { get; set; }

        [DataMember]
        [Required(ErrorMessage = "*")]
        [StringLength(256, ErrorMessage = "The report name must be under {1} characters.")]
        [DataType(DataType.Text)]
        public string Name { get; set; }

        [DataMember]
        [StringLength(50, ErrorMessage = "The report short name must be under {1} characters.")]
        public string ShortName { get; set; }

        [DataMember]
        [DataType(DataType.Url)]
        public string Url { get; set; }

        [DataMember]
        [StringLength(256, ErrorMessage = "The report description must be under {1} characters.")]
        [DataType(DataType.MultilineText)]
        public string Description { get; set; }

        [DataMember]
        public short Status { get; set; }

        [DataMember]
        public string StatusName { get; set; }

        [DataMember]
        [DataType(DataType.DateTime)]
        public DateTime? Create_Date { get; set; }

        [DataMember]
        public int Owner { get; set; }

        [DataMember]
        public string OwnerName { get; set; }

        [DataMember]
        public int? UpdatedBy { get; set; }

        [DataMember]
        public bool Is_Favorite { get; set; }

        [DataMember]
        public IList<object> ExcludeUserList { get; set; }

        [DataMember]
        public IList<object> IncludeUserList { get; set; }

        [DataMember]
        public bool ForSubscription { get; set; }

        public Report()
        {
            ExcludeUserList = new List<object>();
            IncludeUserList = new List<object>();
        }

        [DataMember]
        public List<Report_Organisation_Levels> Report_OrganisationRole_Levels { get; set; }
    }

    [DataContract(Name = "ReportPermission", Namespace = "http://www.yourcompany.com/types/")]
    public class ReportPermission
    {
        [DataMember]
        public int ReportId { get; set; }

        [DataMember]
        public IList<Report_External_Access> ReportExternalAccessList { get; set; }

        [DataMember]
        public IList<Report_Organisation_Levels> ReportOrganisationLevelList { get; set; }

        public ReportPermission()
        {
            this.ReportExternalAccessList = new List<Report_External_Access>();
            this.ReportOrganisationLevelList = new List<Report_Organisation_Levels>();
        }
    }
}