namespace EM_Report.Domain
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;
    using System.Web.Mvc;
    using System.Web;

    [DataContract(Name = "Dashboard_Target_Base", Namespace = "http://www.yourcompany.com/types/")]
    public class Dashboard_Target_Base
    {
        [DataMember]
        public int Id { get; set; }

        //[DataMember]
        //public int SystemId { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public string Type { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public string Value { get; set; }

        [DataMember]
        public string Sub_Value { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public int? Measure { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public double? Target { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public double? Base { get; set; }

        [DataMember]
        public short? Status { get; set; }

        [DataMember]
        public DateTime? Create_Date { get; set; }

        [DataMember]
        public int? UpdatedBy { get; set; }

        [DataMember]
        public string Remuneration { get; set; }

        public bool IsError { get; set; }

        public string[] ErrorFields { get; set; }
    }
}