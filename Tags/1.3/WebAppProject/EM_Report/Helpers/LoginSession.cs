using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using EM_Report.BLL.Commons;
using EM_Report.BLL.Services;
using EM_Report.Models;

namespace EM_Report.Helpers
{
    
    public class LoginSession : EM_Report.BLL.Commons.I_LoginSession
    {
        public string strUserName { set; get; }
        public string strPassWord { set; get; }
        public int intUserId { set; get; }
        public bool isRememberme { set; get; }
        public string strLastLogin { set; get; }
        public string strLastLoginTime { set; get; }
        public bool isSystemUser { set; get; }

        public int? intSystem_RoleId { set; get; }
        public bool isExternal { set; get; }
        public int? intTeamId { set; get; }
        public int? intOrganisation_RoleId { set; get; }        
        public int? intExternal_GroupId { set; get; }

        public IEnumerable<System_Role_PermissionsModel> objUserPermission { get; set; }
        public IEnumerable<Report_CategoriesModel> objCategories { get; set; }
        public IEnumerable<ReportModel> objRecentlyReports { get; set; }
        public IEnumerable<ReportModel> objFavoriteReports { get; set; } 
        
        public LoginSession(int userid, bool isrememberme)
        {
            I_UserService qUserService = new UserService(null);
            I_ReportService qReportService = new ReportService(null);
            I_System_Role_PermissionsService qSystemRolePermissionService = new System_Role_PermissionsService(null);
            I_ReportCategoriesService qCategoryService = new ReportCategoriesService(null);
       
            var user = qUserService.GetUserById(userid);
            if (user != null)
            {
                strUserName = user.UserName;
                strPassWord = user.Password;
                intUserId = userid;
                isRememberme = isrememberme;
                strLastLogin = Commons.GetLoginSequence(user.Last_Online_Login_Date);
                strLastLoginTime = Commons.GetLoginSequenceTime(user.Last_Online_Login_Date);
                isSystemUser = user.Is_System_User;

                intSystem_RoleId = user.System_RoleId;
                isExternal = user.Is_External_User;
                intTeamId = user.TeamId;
                intOrganisation_RoleId = user.Organisation_RoleId;
                intExternal_GroupId = user.External_GroupId;
                if (isSystemUser)
                {
                    objUserPermission = qSystemRolePermissionService.GetAll().Where(l => l.System_RoleId == intSystem_RoleId);
                }
                else
                {
                    objUserPermission = new List<System_Role_PermissionsModel>();
                }
                
                objCategories = qCategoryService.GetCategoriesUserCanAccess(userid);
                objFavoriteReports = qReportService.GetFavoriteReport(userid);                
                objRecentlyReports = qReportService.GetRecentlyReport(userid);                           
                
                Login.UpdateLoginTrack(user);

                if (isrememberme)
                {
                    Login.AddLoginCookie(userid, CryptMD5.EncryptMD5WithSalt(user.UserName, ConfigurationManager.AppSettings["PassWordSalt"]), user.Password);
                }
                else
                {
                    Login.RemoveLoginCookie();
                }
                Login.ReCacheBlockLogin(user.UserName);
            }
        }
    }
}