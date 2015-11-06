using System.Collections.Generic;
using System.Runtime.Serialization;
using EM_Report.Service.MessageBase;
using EM_Report.Domain;

namespace EM_Report.Service.Messages
{
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class Dashboard_FavoursResponse : ResponseBase
    {
        public Dashboard_FavoursResponse() { }

        public Dashboard_FavoursResponse(string correlationId) : base(correlationId) { }

        [DataMember]
        public IList<Dashboard_Favours> Dashboard_Favours;

        [DataMember]
        public Dashboard_Favours Dashboard_Favour;

        [DataMember]
        public bool IsSaveSuccess;
    }
}
