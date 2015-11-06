using System.Runtime.Serialization;
using EM_Report.Service.Criteria;
using EM_Report.Service.MessageBase;
using EM_Report.Domain;

namespace EM_Report.Service.Messages
{
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class Dashboard_ProjectionRequest : RequestBase
    {
        [DataMember]
        public int Id;

        [DataMember]
        public string Unit_Type;

        [DataMember]
        public string Unit_Name;

        [DataMember]
        public string Type;

        [DataMember]
        public string Time_Id;

        [DataMember]
        public Dashboard_Projection Dashboard_Projection;

        [DataMember]
        public string ProjectionDataPath;
    }
}
