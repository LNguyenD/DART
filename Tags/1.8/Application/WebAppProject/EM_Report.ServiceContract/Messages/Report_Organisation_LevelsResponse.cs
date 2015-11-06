namespace EM_Report.Service.Messages
{
    using EM_Report.Domain;
    using EM_Report.Service.MessageBase;
    using System.Collections.Generic;
    using System.Runtime.Serialization;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class Report_Organisation_LevelsResponse : ResponseBase
    {
        public Report_Organisation_LevelsResponse() { }

        [DataMember]
        public IList<Report_Organisation_Levels> Report_Organisation_Levels;

        [DataMember]
        public Report_Organisation_Levels Report_Organisation_Level;
    }
}