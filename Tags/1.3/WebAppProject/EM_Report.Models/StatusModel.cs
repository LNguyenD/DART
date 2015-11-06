using System.ComponentModel.DataAnnotations;

namespace EM_Report.Models
{
    public class StatusModel
    {
        [Required(ErrorMessage = "*")]
        public short StatusId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
    }
}