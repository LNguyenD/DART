namespace EM_Report.Domain
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;
    using System.Web.Mvc;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;

    [DataContract(Name = "Dashboard_Favours", Namespace = "http://www.yourcompany.com/types/")]
    public class Dashboard_Favours
    {
        [Required(ErrorMessage="*")]
        [DataMember]
        public int FavourId { get; set; }

        [Required(ErrorMessage = "*")]
        [DataMember]
        public int UserId { get; set; }

        [Required(ErrorMessage = "*")]
        [StringLength(256,ErrorMessage="The Favourite name must be under {1} characters long.")]
        [DataMember]
        public string Name { get; set; }

        [DataMember]
        public short Status { get; set; }

        [DataMember]
        public DateTime? Create_Date { get; set; }

        [DataMember]
        public int Owner { get; set; }

        [DataMember]
        public string StatusName { get; set; }

        [DataMember]
        public string OwnerName { get; set; }

        [DataMember]
        public int? UpdateBy { get; set; }

        [Required(ErrorMessage = "*")]
        [StringLength(300, ErrorMessage = "The Favourite name must be under {1} characters long.")]
        [DataMember]
        public string Url { get; set; }

        [DataMember]
        public bool Is_Landing_Page { get; set; }
    }
}