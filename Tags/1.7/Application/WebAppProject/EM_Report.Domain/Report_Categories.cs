namespace EM_Report.Domain
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;
    using System.Web.Mvc;
    using System.Web;

    [DataContract(Name = "Report_Categories", Namespace = "http://www.yourcompany.com/types/")]
    public class Report_Categories : I_Status
    {
        [DataMember]
        public int CategoryId { get; set; }

        [DataMember]
        [Required(ErrorMessage = "*")]
        [StringLength(256, ErrorMessage = "The category name must be under {1} characters long.")]
        [DataType(DataType.Text)]   
        public string Name { get; set; }

        [DataMember]
        [StringLength(256, ErrorMessage = "The category name must be under {1} characters long.")]
        [DataType(DataType.Text)]  
        public string Description { get; set; }

        [DataMember]
        public short Status { get; set; }

        [DataMember]
        public string StatusName { get; set; }

        [DataMember]
        [DataType(DataType.DateTime)]
        public DateTime? Create_Date { get; set; }

        [DataMember]
        public int Owner { get; set; }

        [DataMember]
        public string OwnerName { get; set; }

        [DataMember]
        public int? UpdatedBy { get; set; }

        [DataMember]
        public int TotalAccessItem { get; set; }
    }
}