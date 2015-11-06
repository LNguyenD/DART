namespace EM_Report.Service.Messages
{
    using System.Collections.Generic;
    using System.Runtime.Serialization;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class System_RolesResponse : ResponseBase
    {
        public System_RolesResponse() {}        
        [DataMember]
        public System_Roles SystemRole;
        [DataMember]
        public IList<System_Roles> SystemRoles;
        [DataMember]
        public bool IsSaveSuccess;
    }
}
