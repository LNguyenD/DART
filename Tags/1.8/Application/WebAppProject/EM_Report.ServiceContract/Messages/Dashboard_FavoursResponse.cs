namespace EM_Report.Service.Messages
{
    using System.Collections.Generic;
    using System.Runtime.Serialization;
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class Dashboard_FavoursResponse : ResponseBase
    {
        public Dashboard_FavoursResponse() { }       

        [DataMember]
        public IList<Dashboard_Favours> Dashboard_Favours;

        [DataMember]
        public Dashboard_Favours Dashboard_Favour;

        [DataMember]
        public bool IsSaveSuccess;
    }
}
