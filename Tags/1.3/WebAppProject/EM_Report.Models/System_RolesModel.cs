using System.ComponentModel.DataAnnotations;


namespace EM_Report.Models
{
    public class System_RolesModel
    {
        [Required(ErrorMessage = "*")]
        public int System_RoleId { get; set; }

        [Required(ErrorMessage = "*")]
        [StringLength(256, ErrorMessage = "The system role name must be under {1} characters long.")]
        public string Name { get; set; }
        [StringLength(256, ErrorMessage = "The system role description must be under {1} characters long.")]
        public string Description { get; set; }        
    }   
}