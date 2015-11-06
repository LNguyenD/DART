using System.Collections.Generic;
using System.Runtime.Serialization;
using EM_Report.Service.MessageBase;
using EM_Report.Domain;

namespace EM_Report.Service.Messages
{
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class Dashboard_Graph_DescriptionResponse : ResponseBase
    {
        public Dashboard_Graph_DescriptionResponse() { }

        [DataMember]
        public IList<Dashboard_Graph_Description> Dashboard_Graph_Descriptions;

        [DataMember]
        public Dashboard_Graph_Description Dashboard_Graph_Description;
    }
}
