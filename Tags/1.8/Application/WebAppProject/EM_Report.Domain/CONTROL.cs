namespace EM_Report.Domain
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;
    using System.Web.Mvc;
    using System.Web;
    using System.Collections.Generic;
    public class CONTROL
    {
        public string Type { get; set; }
        public string Item { get; set; }
        public string Value { get; set; }
        public string Text_Value { get; set; }        

    }
}