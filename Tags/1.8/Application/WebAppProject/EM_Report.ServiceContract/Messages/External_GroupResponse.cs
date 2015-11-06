namespace EM_Report.Service.Messages
{
    using System.Collections.Generic;
    using System.Runtime.Serialization;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class External_GroupResponse : ResponseBase
    {
        /// <summary>
        /// Constructor for External_GroupResponse
        /// </summary>
        public External_GroupResponse() { }      

        /// <summary>
        /// List of users. 
        /// </summary>
        [DataMember]
        public IList<External_Group> External_Groups;

        /// <summary>
        /// Single user
        /// </summary>
        [DataMember]
        public External_Group External_Group;
    }
}
