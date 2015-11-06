namespace EM_Report.Domain
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;
    using System.Web.Mvc;
    using System.Web;

    [DataContract(Name = "Status", Namespace = "http://www.yourcompany.com/types/")]
    public class Status
    {
        [DataMember]
        [Required(ErrorMessage = "*")]
        public short StatusId { get; set; }

        [DataMember]
        public string Name { get; set; }

        [DataMember]
        public string Description { get; set; }
    }
}