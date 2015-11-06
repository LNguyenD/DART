namespace EM_Report.Service.Messages
{
    using System.Collections.Generic;
    using System.Runtime.Serialization;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class DashboardExternal_GroupsResponse : ResponseBase
    {
        public DashboardExternal_GroupsResponse() { }

        /// <summary>
        /// List of users. 
        /// </summary>
        [DataMember]
        public IList<DashboardExternal_Groups> DashboardExternal_Groups;

        /// <summary>
        /// Single user
        /// </summary>
        [DataMember]
        public DashboardExternal_Groups DashboardExternal_Group;       
    }
}
