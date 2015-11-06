using System.Collections.Generic;
using System.Runtime.Serialization;
using EM_Report.Service.MessageBase;
using EM_Report.Domain;

namespace EM_Report.Service.Messages
{
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class Dashboard_ProjectionResponse : ResponseBase
    {
        public Dashboard_ProjectionResponse() { }

        public Dashboard_ProjectionResponse(string correlationId) : base(correlationId) { }

        [DataMember]
        public IList<Dashboard_Projection> Dashboard_Projections;

        [DataMember]
        public Dashboard_Projection Dashboard_Projection;
    }
}
