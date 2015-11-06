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
    public class ReportCategoryRequest : RequestBase
    {
        /// <summary>
        /// Unique category identifier.
        /// </summary>
        [DataMember]
        public int CategoryId { get; set; }

        [DataMember]
        public int UserId { get; set; }

        [DataMember]
        public Report_Categories ReportCategory;

    }
}
