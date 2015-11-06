using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using EM_Report.Common.Utilities;
using EM_Report.Repositories;
using EM_Report.Helpers;
using Microsoft.Reporting.WebForms;
using System.Security.Principal;

namespace EM_Report.SSRS
{    
    public class MyReportServerCredentials : IReportServerCredentials
    {
        private Cookie m_authCookie;

        public MyReportServerCredentials(Cookie authCookie)
        {
            m_authCookie = authCookie;
        }

        public WindowsIdentity ImpersonationUser
        {
            get
            {
                return null;  // Use default identity.
            }
        }

        public ICredentials NetworkCredentials
        {
            get
            {
                return null;  // Not using NetworkCredentials to authenticate.
            }
        }

        public bool GetFormsCredentials(out Cookie authCookie, out string user,
                                        out string password, out string authority)
        {
            authCookie = m_authCookie;
            user = password = authority = null;
            return true;  // Use forms credentials to authenticate.
        }
    }
}