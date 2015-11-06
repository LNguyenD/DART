using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using EM_Report.Repositories;
using EM_Report.Common.Utilities;
using EM_Report.Domain;
using System.Net;
using System.Web;

using Microsoft.Samples.ReportingServices.CustomSecurity;
using System.ServiceModel;
using EM_Report.Domain.Enums;
using EM_Report.Service.Messages;
using EM_Report.Service.Criteria;
using EM_Report.Service.ServiceContracts;
using EM_Report.Service.MessageBase;

namespace EM_Report.Helpers
{
    public interface I_LoginSessionExtend : I_LoginSession
    {       
        ReportServerProxy RS2010 { get; set; }
        IList<int> Organisation_LevelList { get; set; }
        IList<int> Organisation_GroupList { get; set; }     
    }

    public class LoginSession : I_LoginSessionExtend
    {
        public string strEmail { set; get; }
        public string strDomain { set; get; }
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
        public string External_GroupName { set; get; }

        public int intSystemId { set; get; }
        public IList<Domain.Systems> lstSystems { set; get; }

        public IList<Domain.System_Role_Permissions> objUserPermission { get; set; }

        public IList<int> Organisation_LevelList { get; set; }

        public IList<int> Organisation_GroupList { get; set; }

        public ReportServerProxy RS2010 { get; set; }

        public string AccessToken { get; set; }

        public LoginSession(){}

        public LoginSession(LoginResponse response, string password, bool isrememberme, string domain, LoginType loginType)
        {
            var user = response.UserExt;
            if (user != null)
            {
                AccessToken = response.AccessToken;
                strEmail = user.Email;
                strDomain = domain;
                strUserName = user.UserName;
                strPassWord = password;
                intUserId = user.UserId;
                isRememberme = isrememberme;
                strLastLogin = Commons.GetLoginSequence(user.Last_Online_Login_Date);
                strLastLoginTime = Commons.GetLoginSequenceTime(user.Last_Online_Login_Date);
                isSystemUser = user.Is_System_User;
                defaultSystemName = user.Default_System_Name == null ?
                    Base.RetrieveCookie(Constants.STR_SystemName_ + strUserName) : user.Default_System_Name;
                landingPage_Url = user.LandingPage_Url;
                
                isExternal = user.Is_External_User;
                
                lstSystems = user.SystemList;                            

                intSystemId = user.Default_System_Id??2;
                
                
                if (isSystemUser)
                {
                    intSystem_RoleId = user.System_RoleId;
                    objUserPermission = user.System_Role_PermissionList;
                    External_GroupName = "";
                }
                else
                {
                    if (isExternal)
                    {
                        var objDefaultExternal_Group = user.SystemList.SingleOrDefault(l => l.SystemId == user.Default_System_Id);
                        if (objDefaultExternal_Group != null)
                        {
                            intExternal_GroupId = objDefaultExternal_Group.External_GroupId;
                            if (objDefaultExternal_Group.External_GroupName == "WOW External")
                                External_GroupName = objDefaultExternal_Group.External_GroupName;
                            else
                                External_GroupName = "";
                        }

                        Organisation_GroupList = user.External_GroupIdList;
                    }
                    else
                    {
                        var objOranisationRoleLevel = user.SystemList.SingleOrDefault(l => l.SystemId == user.Default_System_Id);
                        if (objOranisationRoleLevel != null)
                        {
                            intLevelId = objOranisationRoleLevel.LevelId;
                            External_GroupName = "";
                        }
                        Organisation_LevelList = user.Organisation_LevelIdList; 
                    }
                    objUserPermission = new List<Domain.System_Role_Permissions>();
                }

                if (isrememberme && Base.LoginType == LoginType.External)
                {                    
                    Login.AddLoginCookie(response.UserExt.UserId, response.UserExt.Email, response.UserExt.Password, domain);
                }
                else if (isrememberme && Base.LoginType == LoginType.Internal)
                {
                    Login.AddLoginCookie(response.UserExt.UserId, response.UserExt.UserName, password, domain);
                }
                else if (!isrememberme)
                {
                    Login.RemoveLoginCookie();
                }

                if (HttpContext.Current.Application["RS2010"] == null)
                {
                    Login.LoginReportServer(strUserName, strPassWord);                    
                }
                
                RS2010 = ((ReportServerProxy)(HttpContext.Current.Application["RS2010"]));
            }
        }
    }
}