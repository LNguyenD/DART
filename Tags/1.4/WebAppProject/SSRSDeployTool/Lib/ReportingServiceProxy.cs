using Microsoft.SqlServer.ReportingServices2010;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Text;

namespace Lib
{
    class ReportingServiceProxy : ReportingService2010
    {
        protected override WebRequest GetWebRequest(Uri uri)
        {
            HttpWebRequest request;
            request = (HttpWebRequest)HttpWebRequest.Create(uri);
            // Create a cookie jar to hold the request cookie
            CookieContainer cookieJar = new CookieContainer();
            request.CookieContainer = cookieJar;
            Cookie authCookie = AuthCookie;
            // if the client already has an auth cookie
            // place it in the request's cookie container            
            if (authCookie != null) request.CookieContainer.Add(authCookie);
            request.Timeout = -1;
            request.Headers.Add("Accept-Language", CultureInfo.CurrentCulture.Name);
            return request;
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2201:DoNotRaiseReservedExceptionTypes")]
        protected override WebResponse GetWebResponse(WebRequest request)
        {
            WebResponse response = base.GetWebResponse(request);
            string cookieName = response.Headers["RSAuthenticationHeader"];
            // If the response contains an auth header, store the cookie
            if (cookieName != null)
            {
                Utilities.CustomAuthCookieName = cookieName;
                HttpWebResponse webResponse = (HttpWebResponse)response;
                Cookie authCookie = webResponse.Cookies[cookieName];
                // If the auth cookie is null, throw an exception
                if (authCookie == null)
                {
                    throw new Exception("Authorization ticket not received by LogonUser");
                }
                // otherwise save it for this request

                AuthCookie = authCookie;
            }
            return response;
        }

        public Cookie AuthCookie
        {
            get
            {
                return m_Authcookie;
            }
            set
            {
                m_Authcookie = value;
            }
        }

        private Cookie m_Authcookie = null;
    }

    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance",
        "CA1812:AvoidUninstantiatedInternalClasses")]
    internal sealed class Utilities
    {
        internal static string CustomAuthCookieName
        {
            get
            {
                lock (m_cookieNamelockRoot)
                {
                    return m_cookieName;
                }
            }
            set
            {
                lock (m_cookieNamelockRoot)
                {
                    m_cookieName = value;
                }
            }
        }

        private static string m_cookieName;

        private static object m_cookieNamelockRoot = new object();
    }
}
