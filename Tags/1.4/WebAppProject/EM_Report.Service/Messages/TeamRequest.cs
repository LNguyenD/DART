namespace EM_Report.Service.Messages
{
    using System.Runtime.Serialization;
    using EM_Report.Service.Criteria;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class TeamRequest : RequestBase
    {
        /// <summary>
        /// Unique team identifier.
        /// </summary>
        [DataMember]
        public int TeamId { get; set; }

        [DataMember]
        public string UserName { get; set; }

        [DataMember]
        public string Site { get; set; }


        /// <summary>
        /// Team object.
        /// </summary>
        [DataMember]
        public Team Team;
    }
}
