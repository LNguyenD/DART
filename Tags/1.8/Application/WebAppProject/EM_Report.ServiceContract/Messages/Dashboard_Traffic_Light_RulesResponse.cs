using System.Collections.Generic;
using System.Runtime.Serialization;
using EM_Report.Service.MessageBase;
using EM_Report.Domain;

namespace EM_Report.Service.Messages
{
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class Dashboard_Traffic_Light_RulesResponse : ResponseBase
    {
        public Dashboard_Traffic_Light_RulesResponse() { }

        [DataMember]
        public IList<Dashboard_Traffic_Light_Rule> Dashboard_Traffic_Light_Rules;

        [DataMember]
        public Dashboard_Traffic_Light_Rule Dashboard_Traffic_Light_Rule;

        [DataMember]
        public string parseString;
    }
}
