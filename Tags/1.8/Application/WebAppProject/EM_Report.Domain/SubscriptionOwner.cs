namespace EM_Report.Domain
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;
    using System.Web.Mvc;
    using System.Web;

    [DataContract(Name = "Subscription", Namespace = "http://www.yourcompany.com/types/")]
    public class Subscription
    {
        [DataMember]
        public string SubscriptionID { get; set; }

        [DataMember]
        public int ReportId { get; set; }

        [DataMember]
        public int? Owner { get; set; }

        [DataMember]
        public short? Status { get; set; }

        [DataMember]
        public string ScheduleID { get; set; }

        [DataMember]
        public short? ScheduleType { get; set; }

        [DataMember]
        public string OwnerName { get; set; }

        [DataMember]
        public int? UpdatedBy { get; set; }

        [DataMember]
        public string ReportName { get; set; }

        [DataMember]
        public string StatusName { get; set; } 
    }
}