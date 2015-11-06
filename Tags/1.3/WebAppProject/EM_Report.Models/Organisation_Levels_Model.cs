using System;
using System.ComponentModel.DataAnnotations;

namespace EM_Report.Models
{
    public class Organisation_Levels_Model : I_Status
    {     
        //DB fields
        [Required(ErrorMessage = "*")]
        [StringLength(256, ErrorMessage = "The level name must be under {1} characters long.")]
        public string Name { get; set; }      

        [Required(ErrorMessage = "*")]
        public int LevelId { get; set; }

        [Required(ErrorMessage = "*")]
        public int Sort { get; set; }
        
        [StringLength(256, ErrorMessage = "The level description must be under {1} characters long.")]
        public string Description { get; set; }

        public DateTime? Create_Date { get; set; }
        public short Status { get; set; }
        public int Owner { get; set; }
        public int? UpdatedBy { get; set; } 

        //Extra fields
        public string StatusName { get; set; }
        public string OwnerName { get; set; }
        public string ParentLevelName { get; set; }
    }
}