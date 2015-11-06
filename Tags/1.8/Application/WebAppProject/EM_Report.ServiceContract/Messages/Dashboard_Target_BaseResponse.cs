using System.Collections.Generic;
using System.Runtime.Serialization;
using EM_Report.Service.MessageBase;
using EM_Report.Domain;

namespace EM_Report.Service.Messages
{
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class Dashboard_Target_BaseResponse : ResponseBase
    {
        public Dashboard_Target_BaseResponse() { }
        
        [DataMember]
        public IList<Dashboard_Target_Base> Dashboard_Target_Bases;

        [DataMember]
        public Dashboard_Target_Base Dashboard_Target_Base;

        [DataMember]
        public string parseString;
    }
}
