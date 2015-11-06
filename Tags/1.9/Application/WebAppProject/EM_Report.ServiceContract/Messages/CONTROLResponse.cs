using System.Collections.Generic;
using System.Runtime.Serialization;
using EM_Report.Service.MessageBase;
using EM_Report.Domain;


namespace EM_Report.Service.Messages
{
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class CONTROLResponse : ResponseBase
    {
        [DataMember]
        public IList<CONTROL> Controls;

        [DataMember]
        public CONTROL Control;

        
    }
}
