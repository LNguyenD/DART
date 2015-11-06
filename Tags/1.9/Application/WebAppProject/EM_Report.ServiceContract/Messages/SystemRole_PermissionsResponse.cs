namespace EM_Report.Service.Messages
{
    using System.Collections.Generic;
    using System.Runtime.Serialization;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
  public  class SystemRole_PermissionsResponse :ResponseBase
    {
              /// <summary>
        /// Constructor for SystemRole_PermissionsResponse
        /// </summary>
        public SystemRole_PermissionsResponse() { }        

        /// <summary>
        /// List of System Role Permissions. 
        /// </summary>
        [DataMember]
        public IList<System_Role_Permissions> SystemRolePermissions;

        /// <summary>
        /// Single System Role Permission
        /// </summary>
        [DataMember]
        public System_Role_Permissions SystemRolePermission;

    }
}
