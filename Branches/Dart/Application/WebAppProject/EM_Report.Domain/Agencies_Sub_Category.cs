namespace EM_Report.Domain
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;
    using System.Web.Mvc;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;

    [DataContract(Name="Agencies_Sub_Category", Namespace = "http://www.yourcompany.com/types/")]
    public class Agencies_Sub_Category
    {
        [Required(ErrorMessage="*")]
        [DataMember]
        public int Id { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public string AgencyId { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public string AgencyName { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public string Sub_Category { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public string POLICY_NO { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public string Group { get; set; }
    }
}