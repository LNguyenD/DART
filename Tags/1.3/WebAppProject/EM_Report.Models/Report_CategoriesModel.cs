using System;
using System.ComponentModel.DataAnnotations;

namespace EM_Report.Models
{
    public class Report_CategoriesModel : I_Status
    {
        public int CategoryId { get; set; }

        [Required(ErrorMessage = "*")]
        [StringLength(256, ErrorMessage = "The category name must be under {1} characters long.")]
        [DataType(DataType.Text)]   
        public string Name { get; set; }

        [StringLength(256, ErrorMessage = "The category name must be under {1} characters long.")]
        [DataType(DataType.Text)]  
        public string Description { get; set; }

        public short Status { get; set; }

        public string StatusName { get; set; }

        [DataType(DataType.DateTime)]
        public DateTime? Create_Date { get; set; }

        public int Owner { get; set; }

        public string OwnerName { get; set; }
        public int? UpdatedBy { get; set; } 
    }
}