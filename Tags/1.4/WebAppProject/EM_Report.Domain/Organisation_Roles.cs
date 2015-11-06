namespace EM_Report.Domain
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;
    using System.Web.Mvc;
    using System.Web;

    [DataContract(Name = "Organisation_Roles", Namespace = "http://www.yourcompany.com/types/")]
    public class Organisation_Roles : I_Status
    {
        [DataMember]
        [Required(ErrorMessage = "*")]
        public int Organisation_RoleId { get; set; }

        [DataMember]
        [Required(ErrorMessage = "*")]
        public int LevelId { get; set; }

        [DataMember]
        [Required(ErrorMessage = "*")]
        [StringLength(256, ErrorMessage = "The organisation name must be under {1} characters long.")]
        public string Name { get; set; }

        [DataMember]
        [StringLength(256, ErrorMessage = "The organisation description must be under {1} characters long.")]
        public string Description { get; set; }

        [DataMember]
        public short Status { get; set; }

        [DataMember]
        public DateTime Create_Date { get; set; }

        [DataMember]
        public int Owner { get; set; }

        [DataMember]
        public int? UpdatedBy { get; set; }
        
        //Extra fields
        [DataMember]
        public string LevelName { get; set; }

        [DataMember]
        public string OwnerName { get; set; }

        [DataMember]
        public string StatusName { get; set; }

        [DataMember]
        public int SystemId { get; set; }  
    }   
}