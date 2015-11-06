namespace EM_Report.Service.Messages
{
    using System.Runtime.Serialization;
    using EM_Report.Service.Criteria;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    /// <summary>
    /// Respresents a report category requests message from client to web service.
    /// </summary>
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
   public class StatusRequest :RequestBase
    {
        /// <summary>
        /// Unique team identifier.
        /// </summary>
        [DataMember]
        public short StatusId { get; set; }
        /// <summary>
        /// Selection criteria and sort status
        /// </summary>
        [DataMember]
        public Criteria Criteria;

        [DataMember]
        public Status Status;
    }
}
