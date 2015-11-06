namespace EM_Report.Service.Messages
{
    using System.Runtime.Serialization;

    using EM_Report.Service.MessageBase;
using EM_Report.Domain.Enums;

    /// <summary>
    /// Represents a login request message from a client. Contains user credentials.
    /// </summary>
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class LoginRequest : RequestBase
    {
        /// <summary>
        /// Unique UserId credential.
        /// </summary>
        [DataMember]
        public int UserId;
        
        /// <summary>
        /// User name credential.
        /// </summary>
        [DataMember]
        public string UserName = "";

        /// <summary>
        /// Email credential.
        /// </summary>
        [DataMember]
        public string Email = "";

        /// <summary>
        /// Password credential.
        /// </summary>
        [DataMember]
        public string Password = "";       

        [DataMember]
        public bool Is_RememberMe;

        [DataMember]
        public int SystemId;

        [DataMember]
        public int NoLimitLoginAttempts;
		
		[DataMember]
        public int NoDaysBlockedAttempts;

        [DataMember]
        public LoginType LoginType;
    }
}