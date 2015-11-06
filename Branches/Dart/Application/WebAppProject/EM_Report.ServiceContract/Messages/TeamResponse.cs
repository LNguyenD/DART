namespace EM_Report.Service.Messages
{
    using System.Collections.Generic;
    using System.Runtime.Serialization;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class TeamResponse : ResponseBase
    {
        /// <summary>
        /// Constructor for TeamResponse
        /// </summary>
        public TeamResponse() { }

        /// <summary>
        /// List of users. 
        /// </summary>
        [DataMember]
        public IList<Team> Teams;

        /// <summary>
        /// Single user
        /// </summary>
        [DataMember]
        public Team Team;

        [DataMember]
        public bool IsRig;
    }
}
