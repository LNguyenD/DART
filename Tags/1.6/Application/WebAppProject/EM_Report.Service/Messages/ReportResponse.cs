namespace EM_Report.Service.Messages
{
    using System.Collections.Generic;
    using System.Runtime.Serialization;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class ReportResponse : ResponseBase
    {
                       /// <summary>
        /// Constructor for ReportResponse
        /// </summary>
        public ReportResponse() { }

        /// <summary>
        /// Overloaded Constructor for ReportResponse. Sets CorrelationId.
        /// </summary>
        /// <param name="correlationId"></param>
        public ReportResponse(string correlationId) : base(correlationId) { }

        /// <summary>
        /// List of Report. 
        /// </summary>
        [DataMember]
        public IList<Report> Reports;

        /// <summary>
        /// Single report
        /// </summary>
        [DataMember]
        public Report Report;
    }
}
