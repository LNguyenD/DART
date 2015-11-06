using System;
using System.Configuration;
using System.Data.Linq;
using System.Linq;
using System.Runtime.Caching;
using System.Web;
using EM_Report.BLL.Commons;
using EM_Report.BLL.Resources;
using EM_Report.BLL.Services;
using EM_Report.Models;

namespace EM_Report.Helpers
{    
    public class Login
    {
        private const string STR_UserBlocked_ = "UserBlocked_";
        private const string STR_UserInfoSecurity = "UserInfoSecurity";

        private static I_AccountService _qAccountService = new AccountService(null);
        private static I_UserService _qUserService = new UserService(null);        

        public static void InitLogin()
        {            
            if (HttpContext.Current.Request["logout"]!=null && HttpContext.Current.Request["logout"].ToLower() == "true")
            {
                DoLogout();
            }
            else
            {
                if (DoLogin())
                {
                    if (Login.AuthorizeSystemPermission(int.Parse(EM_Report.BLL.Resources.Control.System_User), int.Parse(EM_Report.BLL.Resources.Control.Permission_View)))
                    {
                        HttpContext.Current.Response.Redirect(VirtualPathUtility.ToAbsolute("~/user"));
                    }
                    else
                    {
                        HttpContext.Current.Response.Redirect(VirtualPathUtility.ToAbsolute("~/report"));
                    }
                }
            }
        }

        private static void DoLogout()
        {
            if (Base.LoginSession != null)
            {
                Base.LoginSession = null;
                HttpContext.Current.Session["MenuSession"] = null;
                HttpContext.Current.Session["LeftNavigationReportSession"] = null;
            }
            RemoveLoginCookie();            
        }        
        
        private static bool DoLogin()
        {
            bool returnValue = false;
            if (Base.LoginSession != null)
            {
                int login = _qAccountService.AutoLogin(Base.LoginSession.intUserId, CryptMD5.EncryptMD5WithSalt(Base.LoginSession.strUserName, ConfigurationManager.AppSettings["PassWordSalt"]), Base.LoginSession.strPassWord);
                if (login > 0)
                {
                    Login.LoginAction(login, Base.LoginSession.isRememberme);
                    returnValue = true;         
                }
            }
            else
            {
                HttpCookie userInfo = HttpContext.Current.Request.Cookies[STR_UserInfoSecurity];
                if (userInfo == null)
                    return false;

                string[] values = userInfo.Value.Split('|');
                if (values.Length != 3)
                    return false;

                int login = _qAccountService.AutoLogin(int.Parse(values[2]), values[0], values[1]);                
                if (login <=0)
                    return false;

                Login.LoginAction(login, true);
                returnValue = true;
            }
            return returnValue;
        }

        public static void AuthorizeLogin()
        {            
            if (Base.LoginSession == null && (Base.RawUrl.ToLower().IndexOf("/accessdenied") < 0 && Base.RawUrl.ToLower().IndexOf("/resetpassword") < 0 && Base.RawUrl.ToLower().IndexOf("/resetpasswordsuccess") < 0))
            {
                HttpContext.Current.Response.Redirect(VirtualPathUtility.ToAbsolute("~/account/login"));
            }
            if (Base.LoginSession != null && Base.RawUrl.ToLower().IndexOf("/accessdenied") < 0)
            {
                int systemid = int.Parse(Control.System_Report);
                int permissionid = int.Parse(Control.Permission_View);

                string page = Base.RawUrl.ToLower().Replace(ConfigurationManager.AppSettings["SiteAlias"].ToLower(), "").TrimStart('/');

                if (Base.RawUrl.ToLower().IndexOf("/subscription") >= 0 || Base.RawUrl.ToLower().IndexOf("/changepassword") >= 0)
                {
                    return;
                }
                else if (page.IndexOf("/edit") >= 0)
                {
                    permissionid = int.Parse(Control.Permission_Update);
                    page = page.Substring(0, page.IndexOf("/edit"));
                }
                else if (page.IndexOf("/create") >= 0)
                {
                    permissionid = int.Parse(Control.Permission_Add);
                    page = page.Substring(0, page.IndexOf("/create"));
                }
                else
                {
                    if (Base.RawUrl.ToLower().IndexOf("/report") >= 0 || Base.RawUrl.ToLower().IndexOf("/addressbook") >= 0)
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
                    case "audittrail":
                        systemid = int.Parse(Control.System_AuditTrail);
                        break;
                    case "subscription":
                        permissionid = int.Parse(Control.Permission_View);
                        systemid = int.Parse(Control.System_Report);
                        break;
                    case "addressbook":
                        permissionid = int.Parse(Control.Permission_View);
                        systemid = int.Parse(Control.System_Report);
                        break;
                    default:
                        systemid = int.Parse(Control.System_Group);
                        break;
                }                

                if (!AuthorizeSystemPermission(systemid, permissionid))
                {
                    HttpContext.Current.Response.Redirect(VirtualPathUtility.ToAbsolute("~/account/accessdenied"));
                }
            }
        }        

        public static bool AuthorizeSystemPermission(int systemid, int permissionid)
        {
            if (Base.LoginSession == null || Base.LoginSession.isExternal)
            {
                return false;
            }
            else if (Base.LoginSession.isExternal 
                && permissionid.ToString() == Control.Permission_View 
                && systemid.ToString() == Control.System_Report
                && (Base.RawUrl.ToLower().IndexOf("/report") >= 0 || Base.RawUrl.ToLower().IndexOf("/subscription") >= 0 || Base.RawUrl.ToLower().IndexOf("/addressbook") >= 0))
            {
                return true;
            }
            else
            {
                return Base.LoginSession.objUserPermission.Where(l => l.System_PermissionId == systemid && l.PermissionId == permissionid).SingleOrDefault() != null ? true : false;
            }
        }        

        public static void AddLoginCookie(long userid, string username, string password)
        {
            //Response.Cookies.Add(mycookie);
            HttpCookie userInfo = new HttpCookie(STR_UserInfoSecurity);
            //Setting values inside it
            userInfo.Value = username + "|" + password + "|" + userid;

            //Adding Expire Time of cookies
            userInfo.Expires = DateTime.Now.AddYears(3);

            //Adding cookies to current web response
            HttpContext.Current.Response.Cookies.Add(userInfo);
        }

        public static void RemoveLoginCookie()
        {
            if (HttpContext.Current.Request.Cookies[STR_UserInfoSecurity] != null)
            {
                HttpCookie aCookie = HttpContext.Current.Request.Cookies[STR_UserInfoSecurity];
                aCookie.Expires = DateTime.Now.AddYears(-3);
                HttpContext.Current.Response.Cookies.Add(aCookie);
            }
        }

        public static void UpdateLoginTrack(UserModel user)
        {
            try
            {
                user.Last_Online_Login_Date = DateTime.Now;
                user.Online_No_Of_Login_Attempts = ++user.Online_No_Of_Login_Attempts ?? 1;
                _qUserService.Update(user, user.UserId);
            }
            catch (ChangeConflictException)
            {
                throw;
            }
        }
        
        public static void LoginAction(int userid,bool isrememberme)
        {
            Base.LoginSession = new LoginSession(userid, isrememberme);                
        }       

        public static void CacheBlockLogin(string username)
        {
            username = username.ToLower();
            object FailedLoginCounter = MemoryCache.Default.Get(STR_UserBlocked_ + username);
            if (FailedLoginCounter == null)
            {
                FailedLoginCounter = 0;
                MemoryCache.Default.Add(STR_UserBlocked_ + username, FailedLoginCounter, new CacheItemPolicy());
            }
            MemoryCache.Default[STR_UserBlocked_ + username] = (int)FailedLoginCounter + 1;

            if ((int)MemoryCache.Default[STR_UserBlocked_ + username] == int.Parse(ConfigurationManager.AppSettings["No_Limit_Login_Attempts"]))
            {
                UserModel user = _qUserService.GetUserByUserName(username);
                if (user != null)
                {
                    user.Status = short.Parse(Control.Status_InActive);
                    user.Online_Locked_Until_Datetime = DateTime.Now.AddDays(int.Parse(ConfigurationManager.AppSettings["No_Days_Blocked_Attempts"]));
                    _qUserService.Update(user, user.UserId);

                    ReCacheBlockLogin(username);
                }
            }
        }

        public static void ReCacheBlockLogin(string username)
        {
            username = username.ToLower();
            if (MemoryCache.Default.Contains(STR_UserBlocked_ + username))
            {
                MemoryCache.Default.Remove(STR_UserBlocked_ + username);
            }
        }
    }
}