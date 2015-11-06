namespace EM_Report.Service.Messages
{
    using System.Collections.Generic;
    using System.Runtime.Serialization;
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class Dashboard_LevelsResponse:ResponseBase
    {
                /// <summary>
        /// Constructor for DashboardLevelResponse
        /// </summary>
        public Dashboard_LevelsResponse() { }        

        /// <summary>
        /// List of DashboardLevels. 
        /// </summary>
        [DataMember]
        public IList<Dashboard_Levels> DashboardLevelses;

        /// <summary>
        /// Single DashboardLevel
        /// </summary>
        [DataMember]
        public Dashboard_Levels DashboardLevels; 
    }
}
