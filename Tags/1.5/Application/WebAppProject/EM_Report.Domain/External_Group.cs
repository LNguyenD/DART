namespace EM_Report.Domain
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;

    [DataContract(Name = "External_Group", Namespace = "http://www.yourcompany.com/types/")]
    public class External_Group : I_Status
    {
        [DataMember]
        [Required(ErrorMessage = "*")]
        public int External_GroupId { get; set; }

        [DataMember]
        [Required(ErrorMessage = "*")]
        [StringLength(256, ErrorMessage = "The external group name must be under {1} characters long.")]
        public string Name { get; set; }

        [DataMember]
        [StringLength(256, ErrorMessage = "The external group description must be under {1} characters long.")]
        public string Description { get; set; }

        [DataMember]
        public string StatusName { get; set; }

        [DataMember]
        public short Status { get; set; }

        [DataMember]
        [DataType(DataType.DateTime)]
        public DateTime? Create_Date { get; set; }

        [DataMember]
        public string OwnerName { get; set; }

        [DataMember]
        public int Owner { get; set; }

        [DataMember]
        public int? UpdatedBy { get; set; } 
    }   
}