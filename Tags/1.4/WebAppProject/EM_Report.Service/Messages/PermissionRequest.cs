namespace EM_Report.Service.Messages
{
    using System.Runtime.Serialization;
    using EM_Report.Service.Criteria;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
   public class PermissionRequest : RequestBase
    {
        /// <summary>
        /// Unique team identifier.
        /// </summary>
        [DataMember]
        public int PermissionId { get; set; }
        [DataMember]
        public Permission Permission;
    }
}
