
namespace EM_Report.Models
{
    public class SubscriptionModel
    {
        public string SubscriptionID { get; set; }
        public int ReportId { get; set; }
        public int? Owner { get; set; }
        public short? Status { get; set; }
        public string ScheduleID { get; set; }
        public short? ScheduleType { get; set; }
        public string OwnerName { get; set; }
        public int? UpdatedBy { get; set; }
        public string ReportName { get; set; }
        public string StatusName { get; set; } 
    }
}