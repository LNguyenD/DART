namespace EM_Report.Service.Messages
{
    using System.Runtime.Serialization;
    using EM_Report.Service.Criteria;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class Organisation_RolesRequest : RequestBase
    {
        [DataMember]
        public int RoleId;
        [DataMember]
        public int LevelId;
        [DataMember]
        public int UserId;
        [DataMember]
        public Organisation_Roles Roles;
    }
}
