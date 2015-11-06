using System.Linq;
using System.Web.Mvc;
using EM_Report.BLL.Services;
using EM_Report.Helpers;

namespace EM_Report.Controllers
{
    public class AuditTrailController : BaseController
    {       
        [HttpGet]
        public ActionResult Index()
        {
            ViewBag.AuditType = "Users";
            ViewBag.AuditPageSize = int.Parse(BLL.Resources.Control.Report_PageSize);
            ViewBag.AuditSearch = string.Empty;
            ViewBag.AuditSort = "Action_Date|desc";
            ViewBag.AuditPaging = 1;
            ViewBag.DisplayEntry = new SelectList(Base.PageSizeOptions(), BLL.Resources.Control.Report_PageSize);            
            return View();
        }

        [HttpPost]
        public ActionResult Index(FormCollection postForm,string hddAction,string cboAuditList, string search_input, string hddSort, int? hddPaging = 1)
        {            
            if (hddAction != null && hddAction != string.Empty)
            {                
                if (hddAction.Split('|').Count() > 0)
                {          
                    foreach (var item in hddAction.Split('|')[1].Split(','))
                    {                      
                        switch (cboAuditList)
                        {
                            case "Users":
                                I_Users_AuditService qServiceUser = new Users_AuditService(Base.LoginSession);
                                qServiceUser.Delete(item);
                                break;
                            case "Reports":
                                I_Reports_AuditService qServiceReport = new Reports_AuditService(Base.LoginSession);
                               qServiceReport.Delete(item);
                                break;
                            case "ReportCategories":
                                I_Report_Categories_AuditService qServiceCategory = new Report_Categories_AuditService(Base.LoginSession);
                                qServiceCategory.Delete(item);
                                break;
                            case "ExternalGroups":
                                I_External_Groups_AuditService qExternalGroupService = new External_Groups_AuditService(Base.LoginSession);
                                qExternalGroupService.Delete(item);
                                break;
                            case "OrganisationRoles":
                                I_Organisation_Roles_AuditService qOrganisationRoleService = new Organisation_Roles_AuditService(Base.LoginSession);
                                qOrganisationRoleService.Delete(item);
                                break;
                            case "OrganisationRoleLevels":
                                I_OrganisationRole_Levels_AuditService qOrganisationRoleLevelService = new OrganisationRole_Levels_AuditService(Base.LoginSession);
                                qOrganisationRoleLevelService.Delete(item);
                                break;
                            case "ReportExternalAccess":
                                I_Report_External_Access_AuditService qReportExternalEccessService = new Report_External_Access_AuditService(Base.LoginSession);
                                qReportExternalEccessService.Delete(item);
                                break;
                            case "ReportOrganisationRoles":
                                I_Report_Organisation_Roles_AuditService qReportOrganisationRoleService = new Report_Organisation_Roles_AuditService(Base.LoginSession);
                                qReportOrganisationRoleService.Delete(item);
                                break;
                            case "Subscriptions":
                                I_Subscriptions_AuditService qSubscriptionService = new Subscriptions_AuditService(Base.LoginSession);
                                qSubscriptionService.Delete(item);
                                break;
                            case "SystemRolePermissions":
                                I_System_Role_Permissions_AuditService qSystemRolePermissionService = new System_Role_Permissions_AuditService(Base.LoginSession);
                                qSystemRolePermissionService.Delete(item);
                                break;
                            case "Teams":
                                I_Teams_AuditService qTeamService = new Teams_AuditService(Base.LoginSession);
                                qTeamService.Delete(item);
                                break;                           
                        }                        
                    }
                }
            }
            
            hddSort = (hddSort == null || hddSort == string.Empty ? "Action_Date|desc" : hddSort);
            ViewBag.StartDate = Request.Form["txtStartDateAudit"];
            ViewBag.EndDate = Request.Form["txtEndDateAudit"];
            ViewBag.AuditType = cboAuditList;
            ViewBag.AuditPageSize = int.Parse(Request.Form["cboDisplayEntry"]);
            ViewBag.AuditSearch = search_input;
            ViewBag.AuditSort = hddSort;
            ViewBag.AuditPaging = hddPaging;
            ViewBag.DisplayEntry = new SelectList(Base.PageSizeOptions(), Request.Form["cboDisplayEntry"]);
            return View();
        }       
    }
}
