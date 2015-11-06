namespace EM_Report.Domain
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;
    using System.Web.Mvc;
    using System.Web;

    [DataContract(Name = "System_Role_Permissions", Namespace = "http://www.yourcompany.com/types/")]
    public class System_Role_Permissions : I_Status
    {
        [DataMember]
        [Required(ErrorMessage = "*")]
        public int System_RoleId { get; set; }

        [DataMember]
        [Required(ErrorMessage = "*")]
        public int PermissionId { get; set; }

        [DataMember]
        [Required(ErrorMessage = "*")]
        public int System_PermissionId { get; set; }

        [DataMember]
        public string Description { get; set; }

        [DataMember]
        public short Status { get; set; }

        [DataMember]
        public DateTime Create_Date { get; set; }

        [DataMember]
        public int Owner { get; set; }

        [DataMember]
        public string OwnerName { get; set; }

        [DataMember]
        public string StatusName { get; set; }

        [DataMember]
        public string System_RoleName { get; set; }

        [DataMember]
        public string PermissionName { get; set; }

        [DataMember]
        public string System_PermissionName { get; set; }

        [DataMember]
        public int? UpdatedBy { get; set; } 
    }   
}