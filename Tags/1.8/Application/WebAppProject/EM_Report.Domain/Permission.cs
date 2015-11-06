namespace EM_Report.Domain
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;
    using System.Web.Mvc;
    using System.Web;

    [DataContract(Name = "Permission", Namespace = "http://www.yourcompany.com/types/")]
    public class Permission
    {
        [DataMember]
        public int PermissionId { get; set; }

        [DataMember]
        [Required(ErrorMessage = "*")]
        [DataType(DataType.Text)]   
        public string Name { get; set; }

        [DataMember]
        [DataType(DataType.Text)]  
        public string Description { get; set; }

        [DataMember]
        public short? Status { get; set; }
    }
}