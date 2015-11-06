namespace EM_Report.Domain
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;
    using System.Web.Mvc;
    using System.Web;

    [DataContract(Name = "FilterItem", Namespace = "http://www.yourcompany.com/types/")]
    public class FilterItem
    {
        [DataMember]
        public object FieldName { get; set; }

        [DataMember]
        public object DataType { get; set; }
    }
}