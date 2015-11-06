using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace EM_Report.Models.Report_Data_Object
{
    public class CreditorModel
    {
        public int ID { get; set; }
        public string CreditorNo { get; set; }
        public string Name { get; set; }
        public string AKA { get; set; }
            [Range(double.MinValue, double.MaxValue, ErrorMessage = "The only value you can enter here is a number")]
        public double? ABN { get; set; }
        public string WCProviderCode { get; set; }
        public string HCNumber { get; set; }
        public bool IsDeleted { get; set; }
        public bool Inactive { get; set; }
    }
}