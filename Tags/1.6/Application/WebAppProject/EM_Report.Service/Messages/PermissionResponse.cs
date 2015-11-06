namespace EM_Report.Service.Messages
{
    using System.Collections.Generic;
    using System.Runtime.Serialization;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class PermissionResponse : ResponseBase
    {
               /// <summary>
        /// Constructor for PermissionResponse
        /// </summary>
        public PermissionResponse() { }

        /// <summary>
        /// Overloaded Constructor for PermissionResponse. Sets CorrelationId.
        /// </summary>
        /// <param name="correlationId"></param>
        public PermissionResponse(string correlationId) : base(correlationId) { }

        /// <summary>
        /// List of permission. 
        /// </summary>
        [DataMember]
        public IList<Permission> Permissions;

        /// <summary>
        /// Single permission
        /// </summary>
        [DataMember]
        public Permission Permission;
    }
}
