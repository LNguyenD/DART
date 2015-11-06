namespace EM_Report.Service.Messages
{
    using System.Runtime.Serialization;
    using EM_Report.Service.Criteria;
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
   public class Dashboard_LevelsRequest :RequestBase
    {
        [DataMember]
        public int DashboardLevelId { get; set; }

        [DataMember]
        public string Name { get; set; }

        [DataMember]
        public short Value { get; set; }

        /// <summary>
        /// Team object.
        /// </summary>
        [DataMember]
        public Dashboard_Levels DashboardLevels;
    }
}
