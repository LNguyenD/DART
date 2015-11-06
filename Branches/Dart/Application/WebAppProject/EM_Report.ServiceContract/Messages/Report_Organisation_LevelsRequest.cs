namespace EM_Report.Service.Messages
{
    using EM_Report.Domain;
    using EM_Report.Service.MessageBase;
    using System.Runtime.Serialization;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class Report_Organisation_LevelsRequest : RequestBase
    {
        [DataMember]
        public int LevelId { get; set; }

        [DataMember]
        public string Url { get; set; }

        [DataMember]
        public Report_Organisation_Levels ReportOrganisationLevel;
    }
}