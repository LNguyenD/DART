namespace EM_Report.Service.Messages
{
    using System.Runtime.Serialization;
    using EM_Report.Service.Criteria;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class Report_External_AccessRequest: RequestBase
    {
        [DataMember]
        public int ReportId { get; set; }
        [DataMember]
        public int External_GroupId { get; set; }

        [DataMember]
        public Report_External_Access ReportExternalAccess;
    }
}
