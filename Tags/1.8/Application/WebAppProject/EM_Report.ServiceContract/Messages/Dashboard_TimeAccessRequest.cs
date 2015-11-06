namespace EM_Report.Service.Messages
{
    using System.Runtime.Serialization;
    using EM_Report.Service.Criteria;
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;
    using System;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class Dashboard_TimeAccessRequest : RequestBase
    {
        /// <summary>
        /// Unique team identifier.
        /// </summary>
        [DataMember]
        public int Id { get; set; }

        //[DataMember]
        //public int DashboardId { get; set; }

        //[DataMember]
        //public int DashboardLevelId { get; set; }

        //[DataMember]
        //public int UserId { get; set; }

        //[DataMember]
        //public DateTime StartTime { get; set; }

        //[DataMember]
        //public DateTime EndTime { get; set; }

        //[DataMember]
        //public short Status { get; set; }

        //[DataMember]
        //public DateTime? Create_Date { get; set; }

        //[DataMember]
        //public int Owner { get; set; }

        //[DataMember]
        //public int? UpdateBy { get; set; }


        /// <summary>
        /// Dashboard_TimeAccess object.
        /// </summary>
        [DataMember]
        public Dashboard_TimeAccess Dashboard_TimeAccess;
    }
}
