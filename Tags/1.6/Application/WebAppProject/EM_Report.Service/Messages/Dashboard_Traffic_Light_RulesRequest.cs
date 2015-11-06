using System.Runtime.Serialization;
using EM_Report.Service.Criteria;
using EM_Report.Service.MessageBase;
using EM_Report.Domain;

namespace EM_Report.Service.Messages
{
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class Dashboard_Traffic_Light_RulesRequest : RequestBase
    {
        [DataMember]
        public int Id;

        [DataMember]
        public int SystemId;

        //[DataMember]
        //public string Unit;

        [DataMember]
        public string DashboardType;

        [DataMember]
        public string Type;

        [DataMember]
        public string Value { get; set; }

        [DataMember]
        public string Sub_Value { get; set; }

        [DataMember]
        public int? Measure { get; set; }

        //[DataMember]
        //public string Sub_DashboardType;

        [DataMember]
        public string Name;

        [DataMember]
        public string Description;

        [DataMember]
        public double? FromValue;

        [DataMember]
        public double? ToValue;

        [DataMember]
        public int UpdatedBy;

        [DataMember]
        public bool filteredFlag;

        [DataMember]
        public string parseString;

        [DataMember]
        public Dashboard_Traffic_Light_Rule Dashboard_Traffic_Light_Rules;
    }
}
