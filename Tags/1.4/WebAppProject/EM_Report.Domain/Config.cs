namespace EM_Report.Domain
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;
    using System.Web.Mvc;
    using System.Web;

    [DataContract(Name = "Config", Namespace = "http://www.yourcompany.com/types/")]
    public class Config
    {
        [DataMember]
        public string ReportServerUrl { get; set; }

        [DataMember]
        public string ReportServicePath { get; set; }

        [DataMember]
        public string ReportServicePath2010 { get; set; }

        [DataMember]
        public string ReportServerDomain { get; set; }       

        [DataMember]
        public string EM_ReportConnectionString { get; set; }

        [DataMember]
        public string ReportPathPrefix { get; set; }
        
        public Config(){ }        
    }
}