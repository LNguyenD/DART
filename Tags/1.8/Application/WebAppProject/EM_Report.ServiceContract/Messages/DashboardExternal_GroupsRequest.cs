namespace EM_Report.Service.Messages
{
    using System.Collections.Generic;
    using System.Runtime.Serialization;
    using EM_Report.Domain;
    using EM_Report.Service.MessageBase;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class DashboardExternal_GroupsRequest : RequestBase
    {
        [DataMember]
        public int DashboardExternal_GroupId { get; set; }

        [DataMember]
        public int DashboardId { get; set; }

        [DataMember]
        public int External_GroupId { get; set; }

        [DataMember]
        public int DashboardLevelId { get; set; }

        [DataMember]
        public string Url { get; set; }

        /// <summary>
        /// The level id list for systems that user belongs to
        /// </summary>
        [DataMember]
        public List<int> GroupIdList { get; set; }

        [DataMember]
        public int GroupId { get; set; }        

        /// <summary>
        /// Team object.
        /// </summary>
        [DataMember]
        public DashboardExternal_Groups DashboardExternal_Group;

        [DataMember]
        public short Sort { get; set; }
    }
}
