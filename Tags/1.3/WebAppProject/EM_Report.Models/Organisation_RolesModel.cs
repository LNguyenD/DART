using System;
using System.ComponentModel.DataAnnotations;

namespace EM_Report.Models
{
    public class Organisation_RolesModel : I_Status
    {
        //DB fields
        [Required(ErrorMessage = "*")]
        public int Organisation_RoleId { get; set; }

        [Required(ErrorMessage = "*")]
        public int LevelId { get; set; }

        [Required(ErrorMessage = "*")]
        [StringLength(256, ErrorMessage = "The organisation name must be under {1} characters long.")]
        public string Name { get; set; }
      
        [StringLength(256, ErrorMessage = "The organisation description must be under {1} characters long.")]
        public string Description { get; set; }

        public short Status { get; set; }
        public DateTime Create_Date { get; set; }
        public int Owner { get; set; }
        public int? UpdatedBy { get; set; }
        
        //Extra fields
        public string LevelName { get; set; }
        public string OwnerName { get; set; }
        public string StatusName { get; set; }  
    }   
}