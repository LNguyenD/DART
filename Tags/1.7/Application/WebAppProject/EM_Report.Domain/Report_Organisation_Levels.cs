namespace EM_Report.Domain
{
    using System;
    using System.Runtime.Serialization;

    [DataContract(Name = "Report_Organisation_Levels", Namespace = "http://www.yourcompany.com/types/")]
    public class Report_Organisation_Levels
    {
        [DataMember]
        public int ReportId { get; set; }

        [DataMember]
        public int LevelId { get; set; }

        [DataMember]
        public DateTime? Create_Date { get; set; }

        [DataMember]
        public int? Owner { get; set; }

        [DataMember]
        public int? UpdatedBy { get; set; }

        //Extra fields
        [DataMember]
        public string OwnerName { get; set; }

        [DataMember]
        public string ReportName { get; set; }

        [DataMember]
        public string LevelName { get; set; }
    }
}