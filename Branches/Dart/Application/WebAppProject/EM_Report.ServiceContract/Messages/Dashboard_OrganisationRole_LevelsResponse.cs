namespace EM_Report.Service.Messages
{
    using System.Collections.Generic;
    using System.Runtime.Serialization;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class Dashboard_OrganisationRole_LevelsResponse : ResponseBase
    {
        /// <summary>
        /// Constructor for TeamResponse
        /// </summary>
        public Dashboard_OrganisationRole_LevelsResponse() { }

        /// <summary>
        /// List of users. 
        /// </summary>
        [DataMember]
        public IList<Dashboard_OrganisationRole_Levels> Dashboard_OrganisationRole_Levels;

        /// <summary>
        /// Single user
        /// </summary>
        [DataMember]
        public Dashboard_OrganisationRole_Levels Dashboard_OrganisationRole_Level;       
    }
}
