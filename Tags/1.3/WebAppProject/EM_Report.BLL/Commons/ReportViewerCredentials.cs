using System.Net;
using System.Security.Principal;
using Microsoft.Reporting.WebForms;
using System.Configuration;

namespace EM_Report
{
    public partial class ReportViewerCredentials : IReportServerCredentials
    {
        private string _userName;
        private string _password;
        private string _domain;

        public ReportViewerCredentials()
        {
            _userName = ConfigurationManager.AppSettings["MainSSRSAccount_UserName"];
            _password = ConfigurationManager.AppSettings["MainSSRSAccount_Password"];
            _domain = ConfigurationManager.AppSettings["MainSSRSAccount_Domain"];

        }

        public ReportViewerCredentials(string userName, string password, string domain)
        {
            _userName = userName;
            _password = password;
            _domain = domain;

        }

        public WindowsIdentity ImpersonationUser
        {
            get
            {
                //return null;
                return WindowsIdentity.GetCurrent();
            }
        }

        public ICredentials NetworkCredentials
        {
            get
            {

                return new NetworkCredential(_userName, _password, _domain);

            }             
        }

        public bool GetFormsCredentials(out Cookie authCookie,
                out string userName, out string password,
                out string authority)
        {
            authCookie = null;
            userName = _userName;
            password = _password;
            authority = _domain;

            // Not using form credentials   
            return false;
        }

    }      
}