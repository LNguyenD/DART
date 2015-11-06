using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.ServiceModel;
using EM_Report.ActionServiceReference;
namespace EM_Report.Repositories
{
    /// <summary>
    /// Base class for all Repositories. 
    /// Provides common repository functionality, including:
    ///   - Management of Service client.
    ///   - Offers common request-response correlation check.
    /// </summary>
    public abstract class RepositoryBase
    {       
        /// <summary>
        /// Lazy loads ActionServiceClient and stores it in Session object.
        /// </summary>
        protected ActionServiceClient Client
        {
            get
            {
                return Helpers.Base.SvcClient;
            }
        }

        /// <summary>
        /// Correlates requestid with returned response correlationId. 
        /// These must always match. If not, request and responses are not related.
        /// </summary>
        /// <param name="request"></param>
        /// <param name="response"></param>
        protected void Correlate(RequestBase request, ResponseBase response)
        {
            if (request.RequestId != response.CorrelationId)
                throw new ApplicationException("RequestId and CorrelationId do not match.");
        }       
    }
}