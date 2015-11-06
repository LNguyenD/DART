namespace EM_Report.Service.Messages
{
    using System.Collections.Generic;
    using System.Runtime.Serialization;
    using EM_Report.Domain;
    using EM_Report.Service.MessageBase;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class Dashboard_OrganisationRole_LevelsRequest : RequestBase
    {
        /// <summary>
        /// Unique team identifier.
        /// </summary>
        ///
        [DataMember]
        public int DashboardOrganisationlevelId { get; set; }

        [DataMember]
        public int DashboardId { get; set; }

        [DataMember]
        public int LevelId { get; set; }

        [DataMember]
        public int DashboardLevelId { get; set; }

        [DataMember]
        public string Url { get; set; }

        /// <summary>
        /// The level id list for systems that user belongs to
        /// </summary>
        [DataMember]
        public List<int> LevelIdList { get; set; }        

        /// <summary>
        /// Team object.
        /// </summary>
        [DataMember]
        public Dashboard_OrganisationRole_Levels Dashboard_OrganisationRole_Level;

        [DataMember]
        public short Sort { get; set; }
    }
}