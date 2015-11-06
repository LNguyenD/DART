namespace EM_Report.Service.Messages
{
    using System.Runtime.Serialization;
    using EM_Report.Service.Criteria;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class System_RolesRequest : RequestBase
    {
        [DataMember]
        public long System_RoleId;
        [DataMember]
        public string SystemRoles;
        [DataMember]
        public int UpdatedBy;
        [DataMember]
        public System_Roles SystemRole;
    }
}
