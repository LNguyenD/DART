namespace EM_Report.Service.Messages
{
    using System.Runtime.Serialization;

    using EM_Report.Service.MessageBase;

    /// <summary>
    /// Represents a login request message from a client. Contains user credentials.
    /// </summary>
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class ChangePasswordRequest : RequestBase
    {
        /// <summary>
        /// Current UserId.
        /// </summary>
        [DataMember]
        public int UserId;        
        
        /// <summary>
        /// Old Password.
        /// </summary>
        [DataMember]
        public string OldPassword = "";

        /// <summary>
        /// New Password.
        /// </summary>
        [DataMember]
        public string NewPassword = "";

        /// <summary>
        /// Confirm Password credential.
        /// </summary>       
        [DataMember]
        public string ConfirmPassword = "";        
    }
}
