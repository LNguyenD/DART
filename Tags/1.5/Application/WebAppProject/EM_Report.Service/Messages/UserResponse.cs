namespace EM_Report.Service.Messages
{
    using System.Collections.Generic;
    using System.Runtime.Serialization;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    /// <summary>
    /// Represents a login response message to the client.
    /// </summary>
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class UserResponse : ResponseBase
    {
        /// <summary>
        /// Default Constructor for LoginResponse.
        /// </summary>
        public UserResponse() { }

        /// <summary>
        /// Overloaded Constructor for LoginResponse. Sets CorrelationId.
        /// </summary>
        /// <param name="correlationId"></param>
        public UserResponse(string correlationId) : base(correlationId) { }

        /// <summary>
        /// List of users. 
        /// </summary>
        [DataMember]
        public IList<User> Users;

        /// <summary>
        /// Single user
        /// </summary>
        [DataMember]
        public User User;

        /// <summary>
        /// List Systems
        /// </summary>
        [DataMember]
        public IList<Systems> Systems;
    }
}
