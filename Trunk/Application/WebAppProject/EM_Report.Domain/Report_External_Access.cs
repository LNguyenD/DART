namespace EM_Report.Domain
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;
    using System.Web.Mvc;
    using System.Web;

    [DataContract(Name = "Report_External_Access", Namespace = "http://www.yourcompany.com/types/")]
    public class Report_External_Access
    {
        [DataMember]
        public int ReportId { get; set; }

        [DataMember]
        public int External_GroupId { get; set; }

        [DataMember]
        public DateTime? Create_Date { get; set; }

        [DataMember]
        public int Owner { get; set; }

        [DataMember]
        public string OwnerName { get; set; }

        [DataMember]
        public string ReportName { get; set; }

        [DataMember]
        public string ExternalGroupName { get; set; }

        [DataMember]
        public int? UpdatedBy { get; set; } 
    }   
}