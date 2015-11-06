using System;
using System.ComponentModel.DataAnnotations;

namespace EM_Report.Models
{
    public class TeamModel : I_Status
    {
        [Required(ErrorMessage = "*")]
        public int TeamId { get; set; }

        [Required(ErrorMessage = "*")]
        [StringLength(256, ErrorMessage = "The team name must be under {1} characters long.")]
        public string Name { get; set; }
      
        [StringLength(256, ErrorMessage = "The team description must be under {1} characters long.")]
        public string Description { get; set; }

        public short Status { get; set; }
        public DateTime Create_Date { get; set; }
        public int Owner { get; set; }
        public string StatusName { get; set; }
        public string OwnerName { get; set; }
        public int? UpdatedBy { get; set; } 
    }   
}