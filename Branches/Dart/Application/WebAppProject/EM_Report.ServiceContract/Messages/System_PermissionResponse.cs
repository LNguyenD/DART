namespace EM_Report.Service.Messages
{
    using System.Collections.Generic;
    using System.Runtime.Serialization;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class System_PermissionResponse : ResponseBase
    {
        public System_PermissionResponse() {}        
        [DataMember]
        public System_Permission SystemPermission;
        [DataMember]
        public IList<System_Permission> SystemPermissions;
    }
}
