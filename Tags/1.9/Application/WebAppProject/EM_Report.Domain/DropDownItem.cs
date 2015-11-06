namespace EM_Report.Domain
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;
    using System.Web.Mvc;
    using System.Web;

    [DataContract(Name = "DropDownItem", Namespace = "http://www.yourcompany.com/types/")]
    public class DropDownItem
    {
        [DataMember]
        public object Id { get; set; }

        [DataMember]
        public object Value { get; set; }

        [DataMember]
        public object Label { get; set; }
    }
}