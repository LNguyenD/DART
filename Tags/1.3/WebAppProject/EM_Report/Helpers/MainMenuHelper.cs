using System.Text;
using System.Web;
using System.Configuration;
using EM_Report.BLL.Commons;
using EM_Report.BLL.Resources;

namespace EM_Report.Helpers
{
    public class MainMenuHelper
    {
        public MainMenuHelper()
        {
        }
        
        protected static string GetSubMenu()
        {
            StringBuilder strMenu = new StringBuilder();
            if (Base.LoginSession.isSystemUser)
            {
                strMenu.Append(string.Format("<a href='{0}' class='none' cat='report'>{1}</a>", VirtualPathUtility.ToAbsolute("~/report/category"), "Report Category"));
            }
            strMenu.Append(string.Format("<a href='{0}' class='none' cat='report'>{1}</a>", VirtualPathUtility.ToAbsolute("~/report"), "Report List"));
            strMenu.Append(string.Format("<a href='{0}' class='none' cat='report'>{1}</a>", VirtualPathUtility.ToAbsolute("~/subscription"), "Subscription List"));
            
            if (!Base.LoginSession.isExternal && Login.AuthorizeSystemPermission(int.Parse(Control.System_Report), ResourcesHelper.Permission_Add))
            {
                strMenu.Append(string.Format("<a href='{0}' class='none' cat='report'>{1}</a>", VirtualPathUtility.ToAbsolute("~/report/details"), "Add Report"));
            }
            if (!Base.LoginSession.isExternal && Login.AuthorizeSystemPermission(int.Parse(Control.System_Role), ResourcesHelper.Permission_View))
            {
                strMenu.Append(string.Format("<a href='{0}' class='none' cat='systemrole'>{1}</a>", VirtualPathUtility.ToAbsolute("~/systemrole"), "System Role List"));
            }
            if (!Base.LoginSession.isExternal && Login.AuthorizeSystemPermission(int.Parse(Control.System_Role), ResourcesHelper.Permission_Add))
            {
                strMenu.Append(string.Format("<a href='{0}' class='none' cat='systemrole'>{1}</a>", VirtualPathUtility.ToAbsolute("~/systemrole/create"), "Add System Role"));
            }

            if (!Base.LoginSession.isExternal && Login.AuthorizeSystemPermission(int.Parse(Control.System_Group), ResourcesHelper.Permission_View))
            {
                strMenu.Append(string.Format("<a href='{0}' class='none' cat='group'>{1}</a>", VirtualPathUtility.ToAbsolute("~/organisation_level"), "Organisation Level List"));                
                strMenu.Append(string.Format("<a href='{0}' class='none' cat='group'>{1}</a>", VirtualPathUtility.ToAbsolute("~/external"), "External Group List"));
                strMenu.Append(string.Format("<a href='{0}' class='none' cat='group'>{1}</a>", VirtualPathUtility.ToAbsolute("~/team"), "Team List"));
            }

            if (!Base.LoginSession.isExternal && Login.AuthorizeSystemPermission(int.Parse(Control.System_User), ResourcesHelper.Permission_View))
            {
                strMenu.Append(string.Format("<a href='{0}' class='none' cat='user'>{1}</a>", VirtualPathUtility.ToAbsolute("~/user"), "User List"));
            }
            if (!Base.LoginSession.isExternal && Login.AuthorizeSystemPermission(int.Parse(Control.System_User), ResourcesHelper.Permission_Add))
            {
                strMenu.Append(string.Format("<a href='{0}' class='none' cat='user'>{1}</a>", VirtualPathUtility.ToAbsolute("~/user/create"), "Add User"));
            }

            if (!Base.LoginSession.isExternal && Login.AuthorizeSystemPermission(int.Parse(Control.System_AuditTrail), ResourcesHelper.Permission_View))
            {
                strMenu.Append(string.Format("<a href='{0}' class='none' cat='audittrail'>{1}</a>", VirtualPathUtility.ToAbsolute("~/audittrail"), "Audit Trail List"));
            }

            strMenu.Append(string.Format("<a href='{0}' class='none' cat='address'>{1}</a>", VirtualPathUtility.ToAbsolute("~/addressbook"), "Address Book"));

            strMenu.Append("<a class='loginhistory' style='float:right'>" + Base.LoginSession.strLastLogin + "</a>");
            return strMenu.ToString();
        }

        protected static string GetMainMenuLogin()
        {
            StringBuilder strMenuItem = new StringBuilder();
            strMenuItem.Append("<div class='login_information'>");
            strMenuItem.Append(string.Format("<a href='{0}' class='button black fr'><span class='icon_text logout'></span>{1}</a>", VirtualPathUtility.ToAbsolute("~/account/login?logout=true"), "logout"));
            strMenuItem.Append("<a class='button white fr'><span class='icon_text admin'></span>" + Base.LoginSession.strUserName + "</a>");
            strMenuItem.Append("<p class='fr'><span>Logged as</span></p>");
            strMenuItem.Append("<div class='clear'></div>");
            strMenuItem.Append(string.Format("<a href='{0}' class='fr'><span>{1}</span></a>", VirtualPathUtility.ToAbsolute("~/account/changepassword"), "Change Password"));
            strMenuItem.Append("</div>");
            return strMenuItem.ToString();
        }

        protected static string GetMainMenuItem(string virtualpath,string key, string itemText, string subItemText, string imgName)
        {
            StringBuilder strMenuItem = new StringBuilder();
            strMenuItem.Append("<li onclick=window.location='" + virtualpath + "' id='" + key + "'>");
            strMenuItem.Append(string.Format("<img src='{0}'/>", VirtualPathUtility.ToAbsolute("~/images/" + UrlHelperExtension.Site() + "/" + imgName)));
            strMenuItem.Append("<h3>" + itemText + "</h3>");
            strMenuItem.Append("<span>" + subItemText + "</span>");
            strMenuItem.Append("<div class='sel'></div>");
            switch(key)
            {
                case "report":
                    strMenuItem.Append("<ul>");
                    if (Base.LoginSession.isSystemUser)
                    {
                        strMenuItem.Append(string.Format("<li><a href='{0}'>{1}</a></li>", VirtualPathUtility.ToAbsolute("~/report/category"), "Report Category List"));
                    }
                    strMenuItem.Append(string.Format("<li><a href='{0}'>{1}</a></li>", VirtualPathUtility.ToAbsolute("~/report"), "Report List"));
                    strMenuItem.Append(string.Format("<li><a href='{0}'>{1}</a></li>", VirtualPathUtility.ToAbsolute("~/subscription"), "Subscription List"));
            
                    if (!Base.LoginSession.isExternal && Login.AuthorizeSystemPermission(int.Parse(Control.System_Report), ResourcesHelper.Permission_Add))
                    {
                        strMenuItem.Append(string.Format("<li><a href='{0}'>{1}</a></li>", VirtualPathUtility.ToAbsolute("~/report/details"), "Add Report"));
                    }
                    strMenuItem.Append("</ul>");
                    break;
                case "user":
                    strMenuItem.Append("<ul>");
                    if (!Base.LoginSession.isExternal && Login.AuthorizeSystemPermission(int.Parse(Control.System_User), ResourcesHelper.Permission_View))
                    {
                        strMenuItem.Append(string.Format("<li><a href='{0}'>{1}</a></li>", VirtualPathUtility.ToAbsolute("~/user"), "User List"));
                    }
                    if (!Base.LoginSession.isExternal && Login.AuthorizeSystemPermission(int.Parse(Control.System_User), ResourcesHelper.Permission_Add))
                    {
                        strMenuItem.Append(string.Format("<li><a href='{0}'>{1}</a></li>", VirtualPathUtility.ToAbsolute("~/user/details"), "Add User"));
                    }                    
                    strMenuItem.Append("</ul>");
                    break;
                case "systemrole":
                    strMenuItem.Append("<ul>");
                    if (!Base.LoginSession.isExternal && Login.AuthorizeSystemPermission(int.Parse(Control.System_Role), ResourcesHelper.Permission_View))
                    {
                        strMenuItem.Append(string.Format("<li><a href='{0}'>{1}</a></li>", VirtualPathUtility.ToAbsolute("~/systemrole"), "System Role List"));
                    }
                    if (!Base.LoginSession.isExternal && Login.AuthorizeSystemPermission(int.Parse(Control.System_Role), ResourcesHelper.Permission_Add))
                    {
                        strMenuItem.Append(string.Format("<li><a href='{0}'>{1}</a></li>", VirtualPathUtility.ToAbsolute("~/systemrole/details"), "Add System Role"));
                    }
                    strMenuItem.Append("</ul>");
                    break;
                case "group":
                    strMenuItem.Append("<ul>");
                    if (!Base.LoginSession.isExternal && Login.AuthorizeSystemPermission(int.Parse(Control.System_Group), ResourcesHelper.Permission_View))
                    {
                        strMenuItem.Append(string.Format("<li><a href='{0}'>{1}</a></li>", VirtualPathUtility.ToAbsolute("~/organisation_level"), "Organisation Level List"));                        
                        strMenuItem.Append(string.Format("<li><a href='{0}'>{1}</a></li>", VirtualPathUtility.ToAbsolute("~/external"), "External Group List"));
                        strMenuItem.Append(string.Format("<li><a href='{0}'>{1}</a></li>", VirtualPathUtility.ToAbsolute("~/team"), "Team List"));
                    }
                    strMenuItem.Append("</ul>");
                    break;                
                default:
                    break;
            }
            strMenuItem.Append("</li>");
            return strMenuItem.ToString();
        }        

        protected static string GetMenuWithSelectedCss(string menu)
        {
            string strMenu = menu;
            string page = Base.RawUrl.ToLower().Replace(ConfigurationManager.AppSettings["SiteAlias"].ToLower(), "").TrimStart('/');            
            if (page.IndexOf("/edit") >= 0)
            {                
                page = page.Substring(0, page.IndexOf("/edit"));
            }
            else if (Base.RawUrl.ToLower().IndexOf("/create") >= 0)
            {
                page = page.Substring(0, page.IndexOf("/create"));
            }
            else if (page.IndexOf("/")>=0)
            {
                page = page.Substring(0, page.IndexOf("/"));
            }   
            
            if (Base.RawUrl.ToLower().IndexOf("account/changepassword") < 0)
            {
                strMenu = strMenu.Replace("href='" + Base.RawUrl.ToLower() + "'", "href='" + Base.RawUrl.ToLower() + "' class='selected'");
            }
            return strMenu;
        }        

        public static string GetMainMenu()
        {
            StringBuilder strMenu = new StringBuilder();
            if (HttpContext.Current.Session["MenuSession"] == null)
            {
                strMenu.Append("<div class='nav-wrapper-left'>");
                strMenu.Append("<div class='nav-wrapper-right'>");
                strMenu.Append("<div class='logo'><span>&nbsp;</span></div>");
                strMenu.Append("<div class='nav_wrapper'>");
                strMenu.Append("<ul class='nav'>");                
                if (Base.LoginSession != null)
                {
                    strMenu.Append(GetMainMenuItem(VirtualPathUtility.ToAbsolute("~/report"), "report", "Report", "management", "report-icon.png"));
                    if (!Base.LoginSession.isExternal && Login.AuthorizeSystemPermission(int.Parse(Control.System_User), ResourcesHelper.Permission_View))
                    {
                        strMenu.Append(GetMainMenuItem(VirtualPathUtility.ToAbsolute("~/user"),"user", "User", "management", "user-icon.png"));
                    }

                    if (!Base.LoginSession.isExternal && Login.AuthorizeSystemPermission(int.Parse(Control.System_Role), ResourcesHelper.Permission_View))
                    {
                        strMenu.Append(GetMainMenuItem(VirtualPathUtility.ToAbsolute("~/systemrole"),"systemrole", "System Role", "management", "permission-icon.png"));                        
                    }

                    if (!Base.LoginSession.isExternal && Login.AuthorizeSystemPermission(int.Parse(Control.System_Group), ResourcesHelper.Permission_View))
                    {
                        strMenu.Append(GetMainMenuItem(VirtualPathUtility.ToAbsolute("~/organisation_level"),"group", "Group", "management", "group-icon.png"));                        
                    }
                    if (!Base.LoginSession.isExternal && Login.AuthorizeSystemPermission(int.Parse(Control.System_AuditTrail), ResourcesHelper.Permission_View))
                    {
                        strMenu.Append(GetMainMenuItem(VirtualPathUtility.ToAbsolute("~/audittrail"),"audittrail", "Audit Trail", "management", "audit-icon.png"));
                    }
                    strMenu.Append(GetMainMenuItem(VirtualPathUtility.ToAbsolute("~/addressbook"), "addressbook", "Address Book", "management", "address-book-icon.png"));                
                }
                strMenu.Append("</ul>");
                strMenu.Append("</div>");
                if (Base.LoginSession != null)
                {
                    strMenu.Append(GetMainMenuLogin());
                }
                strMenu.Append("</div>");
                strMenu.Append("</div>");
                strMenu.Append("<div id='notice-wrapper-left'>");
                strMenu.Append("<div id='notice-wrapper-right'>");
                strMenu.Append("<div id='notice'>");
                if (Base.LoginSession != null)
                {                    
                    strMenu.Append("<a class='login_history'>" + Base.LoginSession.strLastLogin + "</a>");
                }
                else
                {
                    strMenu.Append(string.Format("<a class='login_right' href='{0}'>{1}</a>", VirtualPathUtility.ToAbsolute("~/account/login"), "Login"));
                }
                strMenu.Append("</div>");
                strMenu.Append("</div>");
                strMenu.Append("</div>");
                if (Base.LoginSession != null)
                {
                    HttpContext.Current.Session["MenuSession"] = strMenu.ToString();
                }
            }
            if (Base.LoginSession != null)
            {
                return GetMenuWithSelectedCss(HttpContext.Current.Session["MenuSession"].ToString());
            }
            else
            {
                return strMenu.ToString();
            }
        }
    }
}
