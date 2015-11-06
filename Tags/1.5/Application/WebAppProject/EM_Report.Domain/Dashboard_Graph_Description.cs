namespace EM_Report.Domain
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;
    using System.Web.Mvc;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;

    [DataContract(Name = "Dashboard_Graph_Description", Namespace = "http://www.yourcompany.com/types/")]
    public class Dashboard_Graph_Description
    {
        [Required(ErrorMessage = "*")]
        [DataMember]
        public int DescriptionId { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public int SystemId { get; set; }

        [Required(ErrorMessage = "*")]
        [StringLength(20, ErrorMessage = "The graph description type must be under {1} characters long.")]
        [DataMember]
        public string Type { get; set; }

        [Required(ErrorMessage = "*")]
        [StringLength(500, ErrorMessage = "The graph description must be under {1} characters long.")]
        [DataMember]
        public string Description { get; set; }

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
    }
}