namespace EM_Report.Service.Messages
{
    using System.Runtime.Serialization;
    using EM_Report.Service.Criteria;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class System_PermissionRequest : RequestBase
    {
        [DataMember]
        public int System_PermissionId;
        [DataMember]
        public System_Permission SystemPermission;
    }
}
