namespace EM_Report.Service.Messages
{
    using System.Runtime.Serialization;

    using EM_Report.Service.MessageBase;

    /// <summary>
    /// Respresents a logout request message from client to web service.
    /// </summary>
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class LogoutRequest : RequestBase
    {
        // This derived class intentionally left blank
        // Base class has the required parameters.
    }
}
