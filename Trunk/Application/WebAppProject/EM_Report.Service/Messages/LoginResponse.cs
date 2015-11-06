namespace EM_Report.Service.Messages
{
    using System.Runtime.Serialization;
    using System.Collections.Generic;    
    using EM_Report.Service.MessageBase;
    using EM_Report.Domain;

    /// <summary>
    /// Represents a login response message to the client.
    /// </summary>
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class LoginResponse : ResponseBase
    {
        /// <summary>
        /// Default Constructor for LoginResponse.
        /// </summary>
        public LoginResponse() { }

        /// <summary>
        /// Overloaded Constructor for LoginResponse. Sets CorrelationId.
        /// </summary>
        /// <param name="correlationId"></param>
        public LoginResponse(string correlationId) : base(correlationId) { }

        /// <summary>
        /// Uri to which client should redirect following successful login. 
        /// This would be necessary if authentication is handled centrally 
        /// and other services are distributed accross multiple servers. 
        /// Not used in this sample application. 
        /// SalesForce.com uses this in their API.
        /// </summary>
        [DataMember]
        public string Uri = "";

        /// <summary>
        /// Session identifier. Useful when sessions are maintained using 
        /// SOAP headers (rather than cookies). Not used in this sample application.
        /// SalesForce.com uses this in their SOAP header model.
        /// </summary>
        [DataMember]
        public string SessionId = "";

        /// <summary>
        /// Single user.
        /// </summary>
        [DataMember]
        public User User;        

        /// <summary>
        /// List system role permission of current user.
        /// </summary>
        [DataMember]
        public IList<System_Role_Permissions> System_Role_Permissions;        

        /// <summary>
        /// Return store procedure value.
        /// </summary>
        [DataMember]
        public int returnValue;

        [DataMember]
        public string defaultSystemName;
    }
}
