﻿using EM_Report.ActionServiceReference;
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
        public static void AddLoginCookie(long userid, string username, string password)
        {
            Base.AddUpdateCookie(Constants.STR_UserInfoSecurity, username + "|" + password + "|" + userid, 365 * 3);
        }

        public static void RemoveLoginCookie()
        {
            Base.RemoveCookie(Constants.STR_UserInfoSecurity);
        }

        public static void LoginAction(ActionServiceReference.LoginResponse response, bool isrememberme)
        {
            Base.LoginSession = new LoginSession(response, isrememberme, Base.LoginType);           
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

        public static LoginResponse Authenticate(LogIn model)
        {
            LoginResponse response = null;
            bool isLoginReportServerSuccesss = true;
            bool isWindowsAuthenticated = true;

            var ctx = HttpContext.Current;
            Parallel.Invoke(() =>
            {
                if (Base.LoginType == LoginType.Internal)
                {
                    var domain = Base.GetConfig("DomainName");
                    isWindowsAuthenticated = IsValidWindowsAccount(model.Username, model.Password, domain);
                }
            },
            () =>
            {
                // set current Http context for parallel process
                HttpContext.Current = ctx;
                var accountRepo = new AccountRepository();
                switch (Base.LoginType)
                {
                    case LoginType.Internal:
                        response = accountRepo.Login(model.Username, null, 0, Base.LoginType);
                        break;

                    case LoginType.External:
                        var encryptedPassword = EM_Report.Common.Utilities.EnCryption.IsEncrypt(model.Password) ?
                                                model.Password : EM_Report.Common.Utilities.EnCryption.Encrypt(model.Password);
                        response = accountRepo.Login(model.Email, encryptedPassword, 0, Base.LoginType);
                        break;
                }
            },
            () =>
            {
                // set current Http context for parallel process
                HttpContext.Current = ctx;
                try
                {
                    switch (Base.LoginType)
                    {
                        case LoginType.Internal:
                            LoginReportServer(model.Username, string.Empty);
                            break;

                        case LoginType.External:
                            LoginReportServer(model.Email, model.Password);
                            break;
                    }
                }
                catch (Exception ex)
                {
                    // authenticate report server fail
                    isLoginReportServerSuccesss = false;
                }
            });

            return isLoginReportServerSuccesss && isWindowsAuthenticated ? response :
                (response != null && response.Acknowledge == AcknowledgeType.Success ? null : response);
        }

        public static LoginResponse Authenticate(string[] userInfoValue)
        {
            LoginResponse response = null;
            var username = userInfoValue[0];
            var password = userInfoValue[1];
            var userId = int.Parse(userInfoValue[2]);
            bool isLoginReportServerSuccesss = true;
            bool isWindowsAuthenticated = true;

            var ctx = HttpContext.Current;
            Parallel.Invoke(() =>
            {
                if (Base.LoginType == LoginType.Internal)
                {
                    var domain = Base.GetConfig("DomainName");
                    isWindowsAuthenticated = IsValidWindowsAccount(username, password, domain);
                }
            },
            () =>
            {
                // set current Http context for parallel process
                HttpContext.Current = ctx;
                var accountRepo = new AccountRepository();
                switch (Base.LoginType)
                {
                    case LoginType.Internal:
                        response = accountRepo.AutoLogin(userId, username, null, 0, Base.LoginType);
                        break;

                    case LoginType.External:
                        response = accountRepo.AutoLogin(userId, username, password, 0, Base.LoginType);
                        break;
                }
            },
            () =>
            {
                // set current Http context for parallel process
                HttpContext.Current = ctx;
                try
                {
                    switch (Base.LoginType)
                    {
                        case LoginType.Internal:
                            LoginReportServer(username, string.Empty);
                            break;

                        case LoginType.External:
                            LoginReportServer(username, password);
                            break;
                    }
                }
                catch
                {
                    // authenticate report server fail
                    isLoginReportServerSuccesss = false;
                }
            });

            return isLoginReportServerSuccesss && isWindowsAuthenticated ? response :
                (response != null && response.Acknowledge == AcknowledgeType.Success ? null : response);
        }

        public static void LoginReportServer(string userName, string password)
        {           
            if (HttpContext.Current.Application["RS2010"] == null)
            {
                ReportServerProxy server = new ReportServerProxy();

                // Get the server URL from the report server using WMI
                server.Url = Base.GetConfig("ReportServerUrl") + Base.GetConfig("ReportServicePath2010");
                var encryptedPassword = EM_Report.Common.Utilities.EnCryption.IsEncrypt(password) || password == string.Empty ?
                                                password : EM_Report.Common.Utilities.EnCryption.Encrypt(password);
                server.LogonUser(userName, encryptedPassword, "false");
                server.Timeout = 3600000;
                server.AuthCookie.Expires.AddDays(365);
                HttpContext.Current.Application["RS2010"] = server;
            }
        }

        private static bool IsValidWindowsAccount(string userName, string password, string domain)
        {
            bool authenticated = false;
            try
            {
                var decryptedPassword = EM_Report.Common.Utilities.EnCryption.IsEncrypt(password) ?
                                                EM_Report.Common.Utilities.EnCryption.Decrypt(password) : password;
                DirectoryEntry entry = new DirectoryEntry("LDAP://" + domain,
                    userName, decryptedPassword);
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
    }
}