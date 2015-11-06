namespace EM_Report.Domain
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;
    using System.Web.Mvc;
    using System.Web;

    [DataContract(Name = "Organisation_Levels", Namespace = "http://www.yourcompany.com/types/")]
    public class Organisation_Levels : I_Status
    {
        [DataMember]
        [Required(ErrorMessage = "*")]
        [StringLength(256, ErrorMessage = "The level name must be under {1} characters long.")]
        public string Name { get; set; }

        [DataMember]
        [Required(ErrorMessage = "*")]
        public int LevelId { get; set; }

        [DataMember]
        [Required(ErrorMessage = "*")]
        public int SystemId { get; set; }

        [DataMember]
        [Required(ErrorMessage = "*")]
        public int Sort { get; set; }

        [DataMember]
        [StringLength(256, ErrorMessage = "The level description must be under {1} characters long.")]
        public string Description { get; set; }

        [DataMember]
        public DateTime? Create_Date { get; set; }
        
        [DataMember]
        public short Status { get; set; }
        
        [DataMember]
        public int Owner { get; set; }
        
        [DataMember]
        public int? UpdatedBy { get; set; } 

        //Extra fields
        [DataMember]
        public string StatusName { get; set; }

        [DataMember]
        public string OwnerName { get; set; }

        [DataMember]
        public string ParentLevelName { get; set; }
    }
}