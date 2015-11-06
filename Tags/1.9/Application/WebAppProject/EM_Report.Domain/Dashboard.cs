namespace EM_Report.Domain
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;
    using System.Web.Mvc;
    using System.Web;
    using System.Collections.Generic;

    [DataContract(Name = "Dashboard", Namespace = "http://www.yourcompany.com/types/")]
    public class Dashboard
    {
        [DataMember]
        public int DashboardId { get; set; }

        [DataMember]
        public int SystemId { get; set; }

        [Required(ErrorMessage = "*")]
        [StringLength(256, ErrorMessage = "The report name must be under {1} characters.")]
        [DataType(DataType.Text)]  
        [DataMember]
        public string Name { get; set; }

        [DataMember]
        public string Url { get; set; }

        [StringLength(256, ErrorMessage = "The report description must be under {1} characters.")]
        [DataType(DataType.MultilineText)] 
        [DataMember]
        public string Description { get; set; }

        [DataMember]
        public int? Owner { get; set; }

        [DataMember]
        public string StatusName { get; set; }

        [DataMember]
        public string OwnerName { get; set; }

        [DataMember]
        public int? UpdatedBy { get; set; }

        [DataMember]
        [DataType(DataType.DateTime)]
        public DateTime? Create_Date { get; set; }

        [DataMember]
        public short? Status { get; set; }

        [DataMember]
        public string  Dashboard_OrganisationRole_Levels {get;set;}

        [DataMember]
        public string DashboardExternal_Groups { get; set; }
    }
}