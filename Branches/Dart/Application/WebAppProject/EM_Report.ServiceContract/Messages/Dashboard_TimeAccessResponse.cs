namespace EM_Report.Service.Messages
{
    using System.Collections.Generic;
    using System.Runtime.Serialization;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class Dashboard_TimeAccessResponse : ResponseBase
    {
        /// <summary>
        /// Constructor for TeamResponse
        /// </summary>
        public Dashboard_TimeAccessResponse() { }       

        /// <summary>
        /// List of Time Access
        /// </summary>
        [DataMember]
        public IList<Dashboard_TimeAccess> Dashboard_TimeAccesss;

        /// <summary>
        /// Single Time Access
        /// </summary>
        [DataMember]
        public Dashboard_TimeAccess Dashboard_TimeAccess;

        [DataMember]
        public bool IsRig;
    }
}
