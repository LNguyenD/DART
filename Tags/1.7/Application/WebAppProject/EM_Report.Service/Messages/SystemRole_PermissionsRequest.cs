namespace EM_Report.Service.Messages
{
    using System.Runtime.Serialization;
    using EM_Report.Service.Criteria;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
   public class SystemRole_PermissionsRequest : RequestBase
    {
        [DataMember]
        public int System_RoleId { get; set; }

        [DataMember]
        public int PermissionId { get; set; }

        [DataMember]
        public int System_PermissionId { get; set; }

        /// <summary>
        /// User object.
        /// </summary>
        [DataMember]
        public System_Role_Permissions SysRolePermission;
    }
}
