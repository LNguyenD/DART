namespace EM_Report.Domain
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;
    using System.Web.Mvc;
    using System.Web;

    [DataContract(Name = "System_Roles", Namespace = "http://www.yourcompany.com/types/")]
    public class System_Roles
    {
        [DataMember]
        [Required(ErrorMessage = "*")]
        public int System_RoleId { get; set; }

        [DataMember]
        [Required(ErrorMessage = "*")]
        [StringLength(256, ErrorMessage = "The system role name must be under {1} characters long.")]       
        public string Name { get; set; }

        [DataMember]
        [Required(ErrorMessage = "*")]
        [StringLength(256, ErrorMessage = "The system role description must be under {1} characters long.")]        
        public string Description { get; set; }        
    }   
}