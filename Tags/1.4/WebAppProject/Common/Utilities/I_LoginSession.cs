using System.Collections.Generic;
using EM_Report.Domain;

namespace EM_Report.Common.Utilities
{
    public interface I_LoginSession
    {
        string strEmail { set; get; }
        string strUserName { set; get; }
        string strPassWord { set; get; }
        int intUserId { set; get; }
        bool isRememberme { set; get; }
        string strLastLogin { set; get; }
        string strLastLoginTime { set; get; }
        bool isSystemUser { set; get; }
        string defaultSystemName { set; get; }
        string landingPage_Url { set; get; }
        int? intSystem_RoleId { set; get; }
        int? intLevelId { set; get; }
        int intSystemId { set; get; } 
        bool isExternal { set; get; }
        int? intTeamId { set; get; }
        int? intOrganisation_RoleId { set; get; }
        int? intExternal_GroupId { set; get; }
        IList<Domain.Systems> lstSystems { set; get; }

        IList<System_Role_Permissions> objUserPermission { get; set; }       
        Config objConfig { get; set; }
    }
}