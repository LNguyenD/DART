using System;
using System.ComponentModel.DataAnnotations;


namespace EM_Report.Models
{
    public class External_GroupModel : I_Status
    {
        [Required(ErrorMessage = "*")]
        public int External_GroupId { get; set; }

        [Required(ErrorMessage = "*")]
        [StringLength(256, ErrorMessage = "The external group name must be under {1} characters long.")]
        public string Name { get; set; }
        
        [StringLength(256, ErrorMessage = "The external group description must be under {1} characters long.")]
        public string Description { get; set; }
        public string StatusName { get; set; }

        public short Status { get; set; }

        [DataType(DataType.DateTime)]
        public DateTime Create_Date { get; set; }

        public string OwnerName { get; set; }

        public int Owner { get; set; }
        public int? UpdatedBy { get; set; } 
    }   
}