namespace EM_Report.Service.Messages
{
    using System.Runtime.Serialization;
    using EM_Report.Service.Criteria;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class DashboardRequest:RequestBase
    {
        [DataMember]
        public int DashboardId;
        [DataMember]
        public int SystemsId;
        [DataMember]
        public int UserId;
        [DataMember]
        public bool IsSystemUser;
        [DataMember]
        public string Url;

        /// <summary>
        /// Team object.
        /// </summary>
        [DataMember]
        public Dashboard Dashboard;
    }
}
