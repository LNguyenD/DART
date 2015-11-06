namespace EM_Report.Service.Messages
{
    using System.Runtime.Serialization;
    using EM_Report.Service.Criteria;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class ReportRequest : RequestBase
    {
        [DataMember]
        public int ReportId;
        [DataMember]
        public int CategoryId;
        [DataMember]
        public int UserId;
        [DataMember]
        public string Url;
        [DataMember]
        public bool IsSystemUser;
        [DataMember]
        public bool IsForSubscription;       
        [DataMember]
        public Report Report;
    }
}
