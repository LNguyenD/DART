
namespace EM_Report.Service.Messages
{
    using System.Collections.Generic;
    using System.Runtime.Serialization;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

   [DataContract(Namespace = "http://www.yourcompany.com/types/")]
   public class DashboardResponse : ResponseBase
    {

               /// <summary>
        /// Default Constructor for DashboardResponse.
        /// </summary>
        public DashboardResponse() { }

        /// <summary>
        /// Overloaded Constructor for DashboardResponse. Sets CorrelationId.
        /// </summary>
        /// <param name="correlationId"></param>
        public DashboardResponse(string correlationId) : base(correlationId) { }

        /// <summary>
        /// List of dashboard. 
        /// </summary>
        [DataMember]
        public IList<Dashboard> Dashboards;

        /// <summary>
        /// List of dashboard. 
        /// </summary>
        [DataMember]
        public IList<Dashboard_Traffic_Light_Rule> Dashboard_Traffic_Light_Rules;

        /// <summary>
        /// Single dashboard
        /// </summary>
        [DataMember]
        public Dashboard Dashboard;


    }
}
