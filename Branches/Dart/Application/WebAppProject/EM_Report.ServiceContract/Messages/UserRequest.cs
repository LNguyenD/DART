namespace EM_Report.Service.Messages
{
    using System.Runtime.Serialization;
    using EM_Report.Service.Criteria;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    /// <summary>
    /// Represents a login request message from a client. Contains user credentials.
    /// </summary>
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class UserRequest : RequestBase
    {
        /// <summary>
        /// Unique user identifier.
        /// </summary>
        [DataMember]
        public int UserId { get; set; }

        /// <summary>
        /// Unique username identifier
        /// </summary>
        [DataMember]
        public string UserName { get; set; }

        /// <summary>
        /// Unique email identifier
        /// </summary>
        [DataMember]
        public string Email { get; set; }        

        /// <summary>
        /// User object.
        /// </summary>
        [DataMember]
        public User User;

        /// <summary>
        /// Unique user type identifier
        /// </summary>
        [DataMember]
        public string UserType { get; set; }    
    }
}
