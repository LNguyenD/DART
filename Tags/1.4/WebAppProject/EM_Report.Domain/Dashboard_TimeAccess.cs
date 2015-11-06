namespace EM_Report.Domain
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;
    using System.Web.Mvc;
    using System.Web;

    //[DataContract(Name = "Dashboard_TimeAccess", Namespace = "http://www.yourcompany.com/types/")]
    public class Dashboard_TimeAccess //: I_Status
    {
        [DataMember]
        public int Id { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public int DashboardId { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public int DashboardLevelId { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public int UserId { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public DateTime? StartTime { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public DateTime? EndTime { get; set; }


        [DataMember]
        public short Status { get; set; }

        public string StatusName { get; set; }

        [DataMember]
        public DateTime? Create_Date { get; set; }

        [DataMember]
        public int Owner { get; set; }

        [DataMember]
        public int? UpdatedBy { get; set; }

    }
}