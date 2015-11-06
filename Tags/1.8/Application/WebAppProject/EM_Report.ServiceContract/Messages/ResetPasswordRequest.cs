namespace EM_Report.Service.Messages
{
    using System.Runtime.Serialization;

    using EM_Report.Service.MessageBase;

    /// <summary>
    /// Represents a login request message from a client. Contains user credentials.
    /// </summary>
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class ResetPasswordRequest : RequestBase
    {
        /// <summary>
        /// Current UserId.
        /// </summary>
        [DataMember]
        public string  Email = "";        
        
        /// <summary>
        /// Reset Password.
        /// </summary>
        [DataMember]
        public string OldPassword = "";

        [DataMember]
        public string NewPassword = "";

        [DataMember]
        public string ResetPassword_Activation_Url = "";
    }
}
