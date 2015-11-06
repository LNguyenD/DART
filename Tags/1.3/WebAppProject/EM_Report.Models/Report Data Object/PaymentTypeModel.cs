using System;

namespace EM_Report.Models.Report_Data_Object
{
    public class PaymentTypeModel
    {
        public string Type { get; set; }
        public string Group { get; set; }
        public string Description { get; set; }
        public DateTime ActiveFromDate { get; set; }
        public DateTime? ActiveToDate { get; set; }
    }
}