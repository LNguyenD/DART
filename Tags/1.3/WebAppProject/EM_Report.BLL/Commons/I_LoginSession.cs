using System.Collections.Generic;
using EM_Report.Models;

namespace EM_Report.BLL.Commons
{
    public interface I_LoginSession
    {
        string strUserName { set; get; }
        string strPassWord { set; get; }
        int intUserId { set; get; }
        bool isRememberme { set; get; }
        string strLastLogin { set; get; }
        string strLastLoginTime { set; get; }
        bool isSystemUser { set; get; }
        int? intSystem_RoleId { set; get; }
        bool isExternal { set; get; }
        int? intTeamId { set; get; }
        int? intOrganisation_RoleId { set; get; }
        int? intExternal_GroupId { set; get; }        
       
        IEnumerable<System_Role_PermissionsModel> objUserPermission { get; set; }
        IEnumerable<Report_CategoriesModel> objCategories { get; set; }
        IEnumerable<ReportModel> objRecentlyReports { get; set; }
        IEnumerable<ReportModel> objFavoriteReports { get; set; }        
    }
}
