namespace EM_Report.Domain
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;
    using System.Web.Mvc;
    using System.Web;

    [DataContract(Name = "Dashboard_Traffic_Light_Rule", Namespace = "http://www.yourcompany.com/types/")]
    public class Dashboard_Traffic_Light_Rule
    {
        [DataMember]
        public int Id { get; set; }

        [DataMember]
        public int SystemId { get; set; }

        //[Required(ErrorMessage = "*")]
        //[DataMember]
        //public string Unit { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public string DashboardType { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public string Type { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public string Value { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public string Sub_Value { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public int? Measure { get; set; }
       
        //[DataMember]
        //public string Sub_DashboardType { get; set; }

        [Required(ErrorMessage = "*")]            
        [DataMember]        
        public string Name { get; set; }
        
        [DataMember]
        public string Description { get; set; }
        
        [DataMember]
        public string Color { get; set; }
        
        [DataMember]
        public string ImageUrl { get; set; }

        [Required(ErrorMessage = "*")]  
        [DataMember]
        public double? FromValue { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public double? ToValue { get; set; }

        [DataMember]
        public short? Status { get; set; }

        [DataMember]
        public DateTime? Create_Date { get; set; }

        [DataMember]
        public int? Owner { get; set; }

        [DataMember]
        public int? UpdatedBy { get; set; }

        public bool IsError { get; set; }

        public string[] ErrorFields { get; set; }

        public string SystemName { get; set; }
    }
}