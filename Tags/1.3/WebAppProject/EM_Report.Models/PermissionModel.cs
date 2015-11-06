using System.ComponentModel.DataAnnotations;

namespace EM_Report.Models
{
    public class PermissionModel
    {
        public int PermissionId { get; set; }
        
        [Required(ErrorMessage = "*")]
        [DataType(DataType.Text)]   
        public string Name { get; set; }

        [DataType(DataType.Text)]  
        public string Description { get; set; }

        public int Status { get; set; }
    }
}