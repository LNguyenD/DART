using System.Collections.Generic;
using System.Runtime.Serialization;
using EM_Report.Service.MessageBase;
using EM_Report.Domain;

namespace EM_Report.Service.Messages
{   
    /// <summary>
    /// Represents a login response message to the client.
    /// </summary>
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class ChangePasswordResponse : ResponseBase
    {
        /// <summary>
        /// Default Constructor for LoginResponse.
        /// </summary>
        public ChangePasswordResponse() { }          

        /// <summary>
        /// Return value after change password.
        /// </summary>
        [DataMember]
        public bool returnValue;
    }
}
