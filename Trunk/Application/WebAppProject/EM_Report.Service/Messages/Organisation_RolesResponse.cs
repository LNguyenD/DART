namespace EM_Report.Service.Messages
{
    using System.Collections.Generic;
    using System.Runtime.Serialization;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class Organisation_RolesResponse : ResponseBase
    {
        public Organisation_RolesResponse() {}
        public Organisation_RolesResponse(string correlationId) : base(correlationId) { }

        [DataMember]
        public bool IsTeamLeaderOrAbove;

        [DataMember]
        public Organisation_Roles Role;

        [DataMember]
        public IList<Organisation_Roles> Roles;
    }
}
