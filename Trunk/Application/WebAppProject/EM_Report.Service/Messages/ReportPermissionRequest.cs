using System.Runtime.Serialization;
using EM_Report.Service.Criteria;
using EM_Report.Service.MessageBase;
using System.Collections.Generic;
using EM_Report.Domain;
namespace EM_Report.Service.Messages
{
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class ReportPermissionRequest : RequestBase
    {
        [DataMember]
        public int ReportId { get; set; }

        [DataMember]
        public Report_External_Access ReportExternalAccess { set; get; }
        
        [DataMember]
        public IEnumerable<Report_External_Access> ReportExternalAccesses { set; get; }
        
        [DataMember]
        public Report_Organisation_Levels ReportOrganisationLevel { set; get; }
        
        [DataMember]
        public ReportPermission ReportPermission;
    }
}
