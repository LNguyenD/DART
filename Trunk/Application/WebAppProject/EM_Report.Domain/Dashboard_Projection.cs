namespace EM_Report.Domain
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;
    using System.Runtime.Serialization;
    using System.ComponentModel.DataAnnotations;

    [DataContract(Name = "Dashboard_Projection", Namespace = "http://www.yourcompany.com/types/")]
    public class Dashboard_Projection
    {
        [DataMember]
        public int Id { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public string Unit_Type { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public string Unit_Name { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public string Type { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public DateTime Time_Id { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public double Projection { get; set; }
        
        public bool IsError { get; set; }

        public string[] ErrorFields { get; set; }
    }
}