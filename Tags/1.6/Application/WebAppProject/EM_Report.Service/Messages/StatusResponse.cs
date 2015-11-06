namespace EM_Report.Service.Messages
{
    using System.Collections.Generic;
    using System.Runtime.Serialization;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    /// <summary>
    /// Respresents a response message with a list of status for a given customer.
    /// </summary>
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
  public class StatusResponse : ResponseBase
    {

                 /// <summary>
        /// Default Constructor for StatusResponse.
        /// </summary>
        public StatusResponse() { }

        /// <summary>
        /// Overloaded Constructor for StatusResponse. Sets CorrelationId.
        /// </summary>
        /// <param name="correlationId"></param>
        public StatusResponse(string correlationId) : base(correlationId) { }

        /// <summary>
        /// List of Status for a given customer.
        /// </summary>
        [DataMember]
        public IEnumerable<Status> Statuses;

        /// <summary>
        /// Single status.
        /// </summary>
        [DataMember]
        public Status Status;

    }
}
