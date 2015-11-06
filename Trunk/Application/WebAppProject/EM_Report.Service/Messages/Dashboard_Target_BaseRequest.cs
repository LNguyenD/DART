using System.Runtime.Serialization;
using EM_Report.Service.Criteria;
using EM_Report.Service.MessageBase;
using EM_Report.Domain;

namespace EM_Report.Service.Messages
{
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class Dashboard_Target_BaseRequest : RequestBase
    {
        [DataMember]
        public int Id { get; set; }

        //[DataMember]
        //public int SystemId { get; set; }

        [DataMember]
        public string Type { get; set; }

        [DataMember]
        public string Value { get; set; }

        [DataMember]
        public string Sub_Value { get; set; }

        [DataMember]
        public int? Measure { get; set; }

        [DataMember]
        public double? Target { get; set; }

        [DataMember]
        public double? Base { get; set; }

        [DataMember]
        public int UpdatedBy;

        [DataMember]
        public bool filteredFlag;

        [DataMember]
        public string parseString;

        [DataMember]
        public string Remuneration;

        [DataMember]
        public Dashboard_Target_Base Dashboard_Target_Base;
    }
}
