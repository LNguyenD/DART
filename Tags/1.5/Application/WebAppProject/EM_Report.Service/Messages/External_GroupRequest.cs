namespace EM_Report.Service.Messages
{
    using System.Runtime.Serialization;
    using EM_Report.Service.Criteria;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class External_GroupRequest : RequestBase
    {
        /// <summary>
        /// Unique External_Group identifier.
        /// </summary>
        [DataMember]
        public int External_GroupId { get; set; }   

        /// <summary>
        /// External_Group object.
        /// </summary>
        [DataMember]
        public External_Group External_Group;
    }
}
