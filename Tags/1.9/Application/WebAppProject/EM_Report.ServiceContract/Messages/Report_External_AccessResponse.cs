namespace EM_Report.Service.Messages
{
    using System.Collections.Generic;
    using System.Runtime.Serialization;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class Report_External_AccessResponse : ResponseBase
    {
        public Report_External_AccessResponse() { }

        [DataMember]
        public IList<Report_External_Access> Report_External_AccessDCs;

        [DataMember]
        public Report_External_Access Report_External_AccessDC;
    }
}
