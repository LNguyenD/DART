namespace EM_Report.Service.Messages
{
    using System.Collections.Generic;
    using System.Runtime.Serialization;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    /// <summary>
    /// Respresents a response message with a list of category report for a given customer.
    /// </summary>
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class ReportCategoryResponse : ResponseBase
    {
         /// <summary>
        /// Default Constructor for ReportCategoryResponse.
        /// </summary>
        public ReportCategoryResponse() { }

        /// <summary>
        /// Overloaded Constructor for ReportCategoryResponse. Sets CorrelationId.
        /// </summary>
        /// <param name="correlationId"></param>
        public ReportCategoryResponse(string correlationId) : base(correlationId) { }

        /// <summary>
        /// List of report category for a given customer.
        /// </summary>
        [DataMember]
        public List<Report_Categories> ReportCategories;

        /// <summary>
        /// Single report category.
        /// </summary>
        [DataMember]
        public Report_Categories ReportCategory;



    }
}
