using System.Runtime.Serialization;
using EM_Report.Service.Criteria;
using EM_Report.Service.MessageBase;
using EM_Report.Domain;

namespace EM_Report.Service.Messages
{    
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class CONTROLRequest : RequestBase
    {
        [DataMember]
        public string Type { get; set; }

        [DataMember]
        public string Item { get; set; }

        [DataMember]
        public string Value { get; set; }

        [DataMember]
        public string Text_Value { get; set; }

        [DataMember]
        public CONTROL Control { get; set; }
        
    }
}
