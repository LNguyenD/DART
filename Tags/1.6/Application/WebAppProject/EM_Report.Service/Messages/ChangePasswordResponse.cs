namespace EM_Report.Service.Messages
{
    using System.Runtime.Serialization;

    using EM_Report.Service.MessageBase;

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
        /// Overloaded Constructor for LoginResponse. Sets CorrelationId.
        /// </summary>
        /// <param name="correlationId"></param>
        public ChangePasswordResponse(string correlationId) : base(correlationId) { }        

        /// <summary>
        /// Return value after change password.
        /// </summary>
        [DataMember]
        public bool returnValue;
    }
}
