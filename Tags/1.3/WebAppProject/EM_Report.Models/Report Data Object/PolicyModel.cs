using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace EM_Report.Models.Report_Data_Object
{
    public class PolicyModel
    {
        public string PolicyNo { get; set; }
        public string LegalName { get; set; }
        public string TradingName { get; set; }
         [Range(double.MinValue, double.MaxValue, ErrorMessage = "The only value you can enter here is a number")]
        public double? ABN { get; set; }
         [Range(int.MinValue, int.MaxValue, ErrorMessage = "The only value you can enter here is a number")]
        public int? ACN { get; set; }
        public short StartYear { get; set; }
        public byte PolicyStatus { get; set; }
    }
}