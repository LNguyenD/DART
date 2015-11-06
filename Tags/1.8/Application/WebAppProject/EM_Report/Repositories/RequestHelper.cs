using System;
using System.Web;
using System.Configuration;

using EM_Report.Helpers;
using EM_Report.Service.MessageBase;

namespace EM_Report.Repositories
{
    /// <summary>
    /// Static Request Helper class. 
    /// Provides common functionalities that apply to all Request types.
    /// </summary>
    public static class RequestHelper
    {
        /// <summary>
        /// Helper extension method that adds AccessToken to all request types.
        /// </summary>
        /// <typeparam name="T">The request type.</typeparam>
        /// <param name="request">The request</param>
        /// <returns>Fully prepared request, ready to use.</returns>
        public static T Prepare<T>(this T request) where T : RequestBase
        {
            request.AccessToken = Base.LoginSession.AccessToken;

            return request;
        }
    }
}