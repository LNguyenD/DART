namespace EM_Report.Service.Messages
{
    using System.Collections.Generic;
    using System.Runtime.Serialization;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class Organisation_LevelsResponse : ResponseBase
    {
        public Organisation_LevelsResponse() {}       
        
        [DataMember]
        public Organisation_Levels Level;

        [DataMember]
        public IList<Organisation_Levels> Levels;
    }
}
