using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using EM_Report.Repositories;
using EM_Report.Common.Utilities;
using EM_Report.Domain;
using System.Net;
using System.Web;
using EM_Report.ActionServiceReference;
using Microsoft.Samples.ReportingServices.CustomSecurity;
using System.ServiceModel;
using EM_Report.Domain.Enums;

namespace EM_Report.Helpers
{
    public interface I_LoginSessionExtend : I_LoginSession
    {
        ReportServerProxy RS2010 { get; set; }
        ActionServiceClient svcClient { get; set; }
    }

    public class LoginSession : RepositoryBase, I_LoginSessionExtend
    {
        public string strEmail { set; get; }
        public string strUserName { set; get; }
        public string strPassWord { set; get; }
        public int intUserId { set; get; }
        public bool isRememberme { set; get; }
        public string strLastLogin { set; get; }
        public string strLastLoginTime { set; get; }
        public bool isSystemUser { set; get; }
        public string defaultSystemName { set; get; }
        public string landingPage_Url { set; get; }

        public int? intSystem_RoleId { set; get; }
        public bool isExternal { set; get; }
        public int? intTeamId { set; get; }
        public int? intOrganisation_RoleId { set; get; }
        public int? intLevelId { set; get; }
        public int? intExternal_GroupId { set; get; }
        public int intSystemId { set; get; }
        public IList<Domain.Systems> lstSystems { set; get; }

        public IList<Domain.System_Role_Permissions> objUserPermission { get; set; }        
        public Domain.Config objConfig { get; set; }
        public ReportServerProxy RS2010 { get; set; }
        public ActionServiceClient svcClient { get; set; }

        public LoginSession(){}

        public LoginSession(LoginResponse response, bool isrememberme, LoginType loginType)
        {
            var user = response.User;
            if (user != null)
            {
                strEmail = user.Email;
                strUserName = user.UserName;
                strPassWord = user.Password;
                intUserId = user.UserId;
                isRememberme = isrememberme;
                strLastLogin = Commons.GetLoginSequence(user.Last_Online_Login_Date);
                strLastLoginTime = Commons.GetLoginSequenceTime(user.Last_Online_Login_Date);
                isSystemUser = user.Is_System_User;
                defaultSystemName = response.defaultSystemName == null ? 
                    Base.RetrieveCookie(Constants.STR_SystemName_ + strUserName) : response.defaultSystemName;
                landingPage_Url = user.LandingPage_Url;

                intSystem_RoleId = user.System_RoleId;
                isExternal = user.Is_External_User;
                intLevelId = user.LevelId;
                intExternal_GroupId = user.External_GroupId;
                lstSystems = user.Systems;

                // update organisation level id for each system
                if (user.Organisation_LevelIdList != null && user.Systems != null)
                {
                    foreach (KeyValuePair<string, int> item in user.Organisation_LevelIdList)
                    {
                        var system = user.Systems.SingleOrDefault(s => s.Name.ToLower() == item.Key.ToLower());
                        if (system != null)
                            system.LevelId = item.Value;
                    }
                }

                intSystemId = user.SystemId;

                if (isSystemUser)
                {
                    objUserPermission = response.System_Role_Permissions;
                }
                else
                {
                    objUserPermission = new List<Domain.System_Role_Permissions>();
                }                

                // just add cookie for external user here, because we do not store domain account password of internal user
                if (isrememberme && loginType == LoginType.External)
                {
                    Login.AddLoginCookie(user.UserId, user.Email, user.Password);
                }
                else if(!isrememberme)
                {
                    Login.RemoveLoginCookie();
                }
                Login.ReCacheBlockLogin(user.UserName);

                objConfig = response.Configs;

                if (HttpContext.Current.Application["RS2010"] == null)
                {
                    ReportServerProxy server = new ReportServerProxy();
                    // Get the server URL from the report server using WMI
                    server.Url = response.Configs.ReportServerUrl + response.Configs.ReportServicePath2010;
                    server.LogonUser(strUserName, strPassWord, response.Configs.EM_ReportConnectionString);
                    server.Timeout = 3600000;
                    HttpContext.Current.Application["RS2010"] = server;
                }

                Cookie myAuthCookie = ((ReportServerProxy)(HttpContext.Current.Application["RS2010"])).AuthCookie;
                if (myAuthCookie != null)
                {
                    HttpCookie cookie = new HttpCookie(myAuthCookie.Name, myAuthCookie.Value);
                    HttpContext.Current.Response.Cookies.Add(cookie);
                }
                RS2010 = ((ReportServerProxy)(HttpContext.Current.Application["RS2010"]));
                svcClient = Base.SvcClient;
            }
            else
            {
                // Check if not initialized yet
                var svc = new ActionServiceClient();

                Helpers.Base.ByPassCertificate();

                // If current client is 'faulted' (due to some error), create a new instance.
                svcClient = svc;

                if (svcClient.State == CommunicationState.Faulted)
                {
                    try { svcClient.Abort(); }
                    catch { /* no action */ }

                    svcClient = new ActionServiceClient();
                }
            }
        }
    }
}