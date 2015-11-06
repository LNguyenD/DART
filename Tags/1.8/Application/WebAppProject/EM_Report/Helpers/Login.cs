
using EM_Report.Common.Utilities;
using EM_Report.Domain;
using EM_Report.Domain.Enums;
using EM_Report.Domain.Resources;
using EM_Report.Repositories;
using Microsoft.Samples.ReportingServices.CustomSecurity;
using System;
using System.DirectoryServices;
using System.Linq;
using System.Net;
using System.Runtime.InteropServices;
using System.Threading.Tasks;
using System.Web;
using EM_Report.Service.Messages;
using EM_Report.Service.Criteria;
using EM_Report.Service.ServiceContracts;
using EM_Report.Service.MessageBase;

namespace EM_Report.Helpers
{
    public class Login
    {
        public static void DoLogout()
        {
            if (Base.LoginSession != null)
            {
                RemoveLoginCookie();

                // Remove Login Session
                Base.LoginSession = null;

                // Remove Access token
                HttpContext.Current.Session["AccessToken"] = null;

                // Remove cookie pass to report server custom authentication
                RemoveReportAuthentiCateCookie();
            }
        }

        public static void AuthorizeLogin()
        {
            if (Base.LoginSession == null) // Not login yet
            {
                if (Base.GetController.ToLower() != "welcome" || !"resetpassword,resetpasswordsuccess".Contains(Base.GetAction.ToLower()))
                {
                    Base.RedirectTo("~/account/login");
                }
                else
                {
                    return;
                }
            }
            else
            {
                if (Base.IsAjaxRequest())
                {
                    return;
                }
                else if (Base.GetController.ToLower() == "welcome" || Base.GetAction.ToLower() == "changepassword")
                {
                    return;
                }
                else if (!Base.LoginSession.isSystemUser && !Base.LoginSession.isExternal) // Internal report user
                {
                    if ((Base.GetController.ToLower() == "report" && "viewinfo,downloadactuarialreport".Contains(Base.GetAction.ToLower()))
                        || (Base.GetController.ToLower() == "dashboard" && Base.GetAction.ToLower().Contains("level")))
                    {
                        return;
                    }
                    else
                    {
                        Base.RedirectTo("~/welcome");
                    }
                }
                else if (Base.LoginSession.isSystemUser)
                {
                    int systemid = int.Parse(Control.System_Report);
                    int permissionid = int.Parse(Control.Permission_View);

                    string page = Base.RawUrl.ToLower().TrimStart('/');

                    if ("changepassword".Contains(Base.GetAction.ToLower()))
                    {
                        return;
                    }
                    else if (Base.GetAction.ToLower() == "details")
                    {
                        permissionid = int.Parse(Control.Permission_Update);
                        page = page.Substring(0, page.IndexOf("/details"));
                    }
                    else
                    {
                        if (Base.RawUrl.ToLower().IndexOf("/report") >= 0)
                        {
                            return;
                        }
                        else if (page.IndexOf("/") >= 0)
                        {
                            page = page.Substring(0, page.IndexOf("/"));
                        }
                    }

                    switch (page)
                    {
                        case "user":
                            systemid = int.Parse(Control.System_User);
                            break;

                        case "report":
                            systemid = int.Parse(Control.System_Report);
                            break;

                        case "systemrole":
                            systemid = int.Parse(Control.System_Role);
                            break;

                        case "dashboard":
                            permissionid = int.Parse(Control.Permission_View);
                            systemid = int.Parse(Control.System_Dashboard);
                            break;

                        default:
                            systemid = int.Parse(Control.System_Group);
                            break;
                    }
                    if (!AuthorizeSystemPermission(systemid, permissionid))
                    {
                        Base.RedirectTo("~/welcome");
                    }
                }
            }
        }

        public static bool AuthorizeSystemPermission(int systemid, int permissionid)
        {
            if (Base.LoginSession == null || !Base.LoginSession.isSystemUser)
            {
                return false;
            }
            else
            {
                return Base.LoginSession.objUserPermission.Where(l => l.System_PermissionId == systemid && l.PermissionId == permissionid).SingleOrDefault() != null ? true : false;
            }
        }

        /// <summary>
        /// Add login cookie
        /// </summary>
        /// <param name="userid"></param>
        /// <param name="username">Email for external users, Domain name for internal users</param>
        /// <param name="password"></param>
        public static void AddLoginCookie(long userid, string username, string password, string domain)
        {
            Base.AddUpdateCookie(Constants.STR_UserInfoSecurity, username + "|" + password + "|" + userid + "|" + domain, 365 * 3);
        }

        public static void RemoveLoginCookie()
        {
            Base.RemoveCookie(Constants.STR_UserInfoSecurity);
        }

        public static void LoginAction(LoginResponse response, string plainPassword, bool isrememberme, string domain)
        {
            Base.LoginSession = new LoginSession(response, plainPassword, isrememberme, domain, Base.LoginType);           
        }

        private static void RemoveReportAuthentiCateCookie()
        {
            if (HttpContext.Current.Request.Cookies["sqlAuthCookie"] != null)
            {
                HttpCookie myCookie = new HttpCookie("sqlAuthCookie");
                myCookie.Expires = DateTime.Now.AddDays(-1d);
                HttpContext.Current.Response.Cookies.Add(myCookie);
            }
        }

        public static string GetLandingPageUrl()
        {
            string landingPageUrl = "/dashboard/level0?reportpath=/emreporting/reports/level0";

            if (!string.IsNullOrEmpty(Base.LoginSession.landingPage_Url))
            {
                landingPageUrl = Base.LoginSession.landingPage_Url;
            }

            return "~" + landingPageUrl;
        }

        public static string GetInvalidLoginErrorMessage(LoginType _loginType)
        {
            var msg = "";
            switch (_loginType)
            {
                case LoginType.External:
                    msg = Resource.msgInvalidUserNameOrPassLogin;
                    break;

                case LoginType.Internal:
                    msg = Resource.msgInvalidDomainAccount;
                    break;
            }
            return msg;
        }

        public static LoginResponse Authenticate(int userid, LogIn model, string domain)
        {
            LoginResponse response = null;
            bool isLoginReportServerSuccesss = true;
            bool isWindowsAuthenticated = true;
            string encryptedpassword = "";
            var accountRepo = new AccountRepository();

            try
            {
                response = accountRepo.Login(userid, Base.LoginType == LoginType.Internal ? model.Username : model.Email, model.Password, Base.LoginType);
                if (response.UserExt!=null && response.UserExt.UserId > 0 && response.UserExt.Status == 1)
                { 
                    if(Base.LoginType==LoginType.Internal)
                    {
                        isWindowsAuthenticated = IsValidWindowsAccount(model.Username, model.Password, domain);
                    }
                    if (Base.LoginType == LoginType.External)
                    {
                        encryptedpassword = response.UserExt.Password;
                    }
                    LoginReportServer(Base.LoginType == LoginType.Internal ? model.Username : model.Email, encryptedpassword);
                }        
            }
            catch (Exception)
            {
                isLoginReportServerSuccesss = false;
            }                      

            return isLoginReportServerSuccesss && isWindowsAuthenticated ? response : null;
        }

        public static void LoginReportServer(string userName, string encryptedPassword)
        {
            ReportServerProxy server = new ReportServerProxy();
            // Get the server URL from the report server using WMI
            server.Url = Base.GetConfig("ReportServerUrl") + Base.GetConfig("ReportServicePath2010");
            server.LogonUser(userName, encryptedPassword, "false");
            server.Timeout = 3600000;
            server.AuthCookie.Expires.AddDays(365);
            HttpContext.Current.Application["RS2010"] = server;
        }

        private static bool IsValidWindowsAccount(string userName, string password, string domain)
        {
            bool authenticated = false;
            try
            {                
                DirectoryEntry entry = new DirectoryEntry("LDAP://" + domain,
                    userName, password);
                object nativeObject = entry.NativeObject;
                authenticated = true;
            }
            catch (COMException ex)
            {
                return false;
            }
            catch (Exception ex)
            {
                return false;
            }

            return authenticated;
        }

        public static bool AutoLoginSession()
        {
            bool returnValue = false;

            if (Base.LoginSession != null && Base.LoginSession.strUserName != null)
            {
                var model = new LogIn
                {
                    Username = Base.LoginSession.strUserName,
                    Email = Base.LoginSession.strEmail,
                    Password = Base.LoginSession.strPassWord,
                };

                var response = Login.Authenticate(0, model, Base.LoginSession.strDomain);
                if (response != null)
                {
                    Login.LoginAction(response,Base.LoginSession.strPassWord, Base.LoginSession.isRememberme, Base.LoginSession.strDomain);
                    returnValue = true;
                }
            }
            return returnValue;
        }

        public static bool AutoLoginCookie()
        {
            bool returnValue = false;
            HttpCookie userInfo = HttpContext.Current.Request.Cookies[Constants.STR_UserInfoSecurity];
            if (userInfo == null)
                returnValue = false;
            else
            {
                string[] values = userInfo.Value.Split('|');
                if (values.Length != 4)
                {
                    returnValue = false;
                }
                else
                {
                    var model = new LogIn
                    {
                        Username = values[0],
                        Email = values[0],
                        Password = Base.LoginType == LoginType.Internal ? Common.Utilities.EnCryption.Decrypt(values[1]) : values[1]
                                
                    };

                    var response = Login.Authenticate(int.Parse(values[2]),model, values[3]);                     
                    if (response == null)
                    {
                        returnValue = false;
                    }
                    else
                    {
                        Login.LoginAction(response, (Base.LoginType == LoginType.Internal ? Common.Utilities.EnCryption.Decrypt(values[1]) : values[1]), true, values[3]);
                        returnValue = true;
                    }
                }
            }
            return returnValue;
        }
    }
}