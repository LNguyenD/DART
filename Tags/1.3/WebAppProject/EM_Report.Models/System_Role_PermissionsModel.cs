using System;
using System.ComponentModel.DataAnnotations;

namespace EM_Report.Models
{
    public class System_Role_PermissionsModel : I_Status
    {
        [Required(ErrorMessage = "*")]
        public int System_RoleId { get; set; }
        
        [Required(ErrorMessage = "*")]
        public int PermissionId { get; set; }
        
        [Required(ErrorMessage = "*")]
        public int System_PermissionId { get; set; }       

        public string Description { get; set; }
        public short Status { get; set; }
        public DateTime Create_Date { get; set; }
        public int Owner { get; set; }
        public string OwnerName { get; set; }
        public string StatusName { get; set; }
        public string System_RoleName { get; set; }
        public string PermissionName { get; set; }
        public string System_PermissionName { get; set; }
        public int? UpdatedBy { get; set; } 
    }   
}