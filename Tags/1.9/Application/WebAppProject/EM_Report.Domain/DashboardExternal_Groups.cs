namespace EM_Report.Domain
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;
    using System.Web.Mvc;
    using System.Web;

    [DataContract(Name = "DashboardExternal_Groups", Namespace = "http://www.yourcompany.com/types/")]
    public class DashboardExternal_Groups
    {
        [DataMember]
        public int DashboardExternal_GroupId { get; set; }

        [DataMember]
        public int DashboardId { get; set; }

        [DataMember]
        public int DashboardLevelId { get; set; }

        [DataMember]
        public int External_GroupId { get; set; }

        [DataMember]
        public DateTime? Create_Date { get; set; }

        [DataMember]
        public int? Owner { get; set; }

        [DataMember]
        public int? UpdatedBy { get; set; }

        [DataMember]
        public int? Sort { get; set; }

        [DataMember]
        public string Url { get; set; }
    }
}