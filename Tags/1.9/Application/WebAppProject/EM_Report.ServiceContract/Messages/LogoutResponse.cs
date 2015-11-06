namespace EM_Report.Service.Messages
{
    using System.Runtime.Serialization;

    using EM_Report.Service.MessageBase;

    /// <summary>
    /// Represents a logout response message from web service to client.
    /// </summary>
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class LogoutResponse : ResponseBase
    {
        /// <summary>
        /// Default Constructor for LogoutResponse.
        /// </summary>
        public LogoutResponse() { }        
    }
}