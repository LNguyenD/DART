using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using EM_Report.Common.Pager;
using EM_Report.Helpers;
using EM_Report.Repositories;

namespace EM_Report.Controllers
{
    public class BaseController : Controller
    {
        #region private properties

        private IUserRepository _userRepository;
        private IReportRepository _reportRepository;
        private ITeamRepository _teamRepository;
        private IExternal_GroupRepository _extgroupRepository;
        private IAccountRepository _accountRepository;
        private IReportCategoryRepository _reportCategoryRepository;
        private IOrganisationLevelsRepository _organisationLevelRepository;
        private IOrganisationRolesRepository _organisationRoleRepository;
        private ISystemRoleRepository _systemRoleRepository;
        private IPermissionRepository _permissionRepository;
        private ISystemPermissionRepository _sysPermissionRepository;
        private ISystemRole_PermissionRepository _sysRolePermissionRepository;
        private IStatusRepository _statusRepository;
        private IReportPermissionRepository _reportPermissionRepository;
        private IDashboard_OrganisationRole_LevelsRepository _dashboard_OrganisationRole_LevelsRepository;
        private IDashboardExternal_GroupsRepository _dashboardExternal_GroupsRepository;
        private IDashboardRepository _dashboardRepository;
        private IDashboardLevelRepository _dashboardLevelRepository;
        private IDashboard_FavoursRepository _dashboard_FavourRepository;
        private IDashboard_Graph_DescriptionRepository _dashboard_Graph_DescriptionRepository;
        private IDashboard_Traffic_Light_RulesRepository _dashboard_Traffic_Light_RulesRepository;
        private IDashboard_ProjectionRepository _Dashboard_ProjectionRepository;
        private IDashboard_TimeAccessRepository _dashboard_DashboardTimeAccessRepository;
        private IDashboard_Target_BaseRepository _dashboard_Target_BaseRepository;

        #endregion private properties

        #region public properties

        public IAccountRepository AccountRepository
        {
            get
            {
                if (_accountRepository == null)
                {
                    _accountRepository = new AccountRepository();
                }
                return _accountRepository;
            }
            set
            {
                _accountRepository = value;
            }
        }

        public IDashboardRepository DashboardRepository
        {
            get
            {
                if (_dashboardRepository == null)
                {
                    _dashboardRepository = new DashboardRepository();
                }
                return _dashboardRepository;
            }
            set
            {
                _dashboardRepository = value;
            }
        }

        public IDashboardLevelRepository DashboardLevelRepository
        {
            get
            {
                if (_dashboardLevelRepository == null)
                {
                    _dashboardLevelRepository = new DashboardLevelRepository();
                }
                return _dashboardLevelRepository;
            }
            set
            {
                _dashboardLevelRepository = value;
            }
        }

        public IUserRepository UserRepository
        {
            get
            {
                if (_userRepository == null)
                {
                    _userRepository = new UserRepository();
                }
                return _userRepository;
            }
            set
            {
                _userRepository = value;
            }
        }

        public IReportRepository ReportRepository
        {
            get
            {
                if (_reportRepository == null)
                {
                    _reportRepository = new ReportRepository();
                }
                return _reportRepository;
            }
            set
            {
                _reportRepository = value;
            }
        }

        public IReportCategoryRepository ReportCategoryRepository
        {
            get
            {
                if (_reportCategoryRepository == null)
                {
                    _reportCategoryRepository = new ReportCategoryRepository();
                }
                return _reportCategoryRepository;
            }
            set
            {
                _reportCategoryRepository = value;
            }
        }

        public ISystemRoleRepository SystemRoleRepository
        {
            get
            {
                if (_systemRoleRepository == null)
                {
                    _systemRoleRepository = new SystemRoleRepository();
                }
                return _systemRoleRepository;
            }
            set
            {
                _systemRoleRepository = value;
            }
        }

        public ITeamRepository TeamRepository
        {
            get
            {
                if (_teamRepository == null)
                {
                    _teamRepository = new TeamRepository();
                }
                return _teamRepository;
            }
            set
            {
                _teamRepository = value;
            }
        }

        public IExternal_GroupRepository External_GroupRepository
        {
            get
            {
                if (_extgroupRepository == null)
                {
                    _extgroupRepository = new External_GroupRepository();
                }
                return _extgroupRepository;
            }
            set
            {
                _extgroupRepository = value;
            }
        }

        public IOrganisationLevelsRepository OrganisationLevelRepository
        {
            get
            {
                if (_organisationLevelRepository == null)
                {
                    _organisationLevelRepository = new OrganisationLevelsRepository();
                }
                return _organisationLevelRepository;
            }
            set
            {
                _organisationLevelRepository = value;
            }
        }

        public IOrganisationRolesRepository OrganisationRoleRepository
        {
            get
            {
                if (_organisationRoleRepository == null)
                {
                    _organisationRoleRepository = new OrganisationRolesRepository();
                }
                return _organisationRoleRepository;
            }
            set
            {
                _organisationRoleRepository = value;
            }
        }

        public IStatusRepository StatusRepository
        {
            get
            {
                if (_statusRepository == null)
                {
                    _statusRepository = new StatusRepository();
                }
                return _statusRepository;
            }
            set
            {
                _statusRepository = value;
            }
        }

        public IReportPermissionRepository ReportPermissionRepository
        {
            get
            {
                if (_reportPermissionRepository == null)
                {
                    _reportPermissionRepository = new ReportPermissionRepository();
                }
                return _reportPermissionRepository;
            }
            set
            {
                _reportPermissionRepository = value;
            }
        }

        public ISystemRole_PermissionRepository SysRolePermissionRepository
        {
            get
            {
                if (_sysRolePermissionRepository == null)
                {
                    _sysRolePermissionRepository = new SystemRole_PermissionRepository();
                }
                return _sysRolePermissionRepository;
            }
            set
            {
                _sysRolePermissionRepository = value;
            }
        }

        public IPermissionRepository PermissionRepository
        {
            get
            {
                if (_permissionRepository == null)
                {
                    _permissionRepository = new PermissionRepository();
                }
                return _permissionRepository;
            }
            set
            {
                _permissionRepository = value;
            }
        }

        public ISystemPermissionRepository SystemPermissionRepository
        {
            get
            {
                if (_sysPermissionRepository == null)
                {
                    _sysPermissionRepository = new SystemPermissionRepository();
                }
                return _sysPermissionRepository;
            }
            set
            {
                _sysPermissionRepository = value;
            }
        }

        public IDashboard_OrganisationRole_LevelsRepository Dashboard_OrganisationRole_LevelsRepository
        {
            get
            {
                if (_dashboard_OrganisationRole_LevelsRepository == null)
                {
                    _dashboard_OrganisationRole_LevelsRepository = new Dashboard_OrganisationRole_LevelsRepository();
                }
                return _dashboard_OrganisationRole_LevelsRepository;
            }
            set
            {
                _dashboard_OrganisationRole_LevelsRepository = value;
            }
        }

        public IDashboardExternal_GroupsRepository DashboardExternal_GroupsRepository
        {
            get
            {
                if (_dashboardExternal_GroupsRepository == null)
                {
                    DashboardExternal_GroupsRepository = new DashboardExternal_GroupsRepository();
                }
                return _dashboardExternal_GroupsRepository;
            }
            set
            {
                _dashboardExternal_GroupsRepository = value;
            }
        }

        public IDashboard_FavoursRepository Dashboard_FavourRepository
        {
            get
            {
                if (_dashboard_FavourRepository == null)
                {
                    _dashboard_FavourRepository = new Dashboard_FavoursRepository();
                }
                return _dashboard_FavourRepository;
            }
            set
            {
                _dashboard_FavourRepository = value;
            }
        }

        public IDashboard_Graph_DescriptionRepository Dashboard_Graph_DescriptionRepository
        {
            get
            {
                if (_dashboard_Graph_DescriptionRepository == null)
                {
                    _dashboard_Graph_DescriptionRepository = new Dashboard_Graph_DescriptionRepository();
                }
                return _dashboard_Graph_DescriptionRepository;
            }
            set
            {
                _dashboard_Graph_DescriptionRepository = value;
            }
        }

        public IDashboard_Traffic_Light_RulesRepository Dashboard_Traffic_Light_RulesRepository
        {
            get
            {
                if (_dashboard_Traffic_Light_RulesRepository == null)
                {
                    _dashboard_Traffic_Light_RulesRepository = new Dashboard_Traffic_Light_RulesRepository();
                }
                return _dashboard_Traffic_Light_RulesRepository;
            }
            set
            {
                _dashboard_Traffic_Light_RulesRepository = value;
            }
        }

        public IDashboard_TimeAccessRepository Dashboard_TimeAccessRepository
        {
            get
            {
                if (_dashboard_DashboardTimeAccessRepository == null)
                {
                    _dashboard_DashboardTimeAccessRepository = new Dashboard_TimeAccessRepository();
                }
                return _dashboard_DashboardTimeAccessRepository;
            }
            set
            {
                _dashboard_DashboardTimeAccessRepository = value;
            }
        }

        public IDashboard_ProjectionRepository Dashboard_ProjectionRepository
        {
            get
            {
                if (_Dashboard_ProjectionRepository == null)
                {
                    _Dashboard_ProjectionRepository = new Dashboard_ProjectionRepository();
                }
                return _Dashboard_ProjectionRepository;
            }
            set
            {
                _Dashboard_ProjectionRepository = value;
            }
        }

        public IDashboard_Target_BaseRepository Dashboard_Target_BaseRepository
        {
            get
            {
                if (_dashboard_Target_BaseRepository == null)
                {
                    _dashboard_Target_BaseRepository = new Dashboard_Target_BaseRepository();
                }
                return _dashboard_Target_BaseRepository;
            }
            set
            {
                _dashboard_Target_BaseRepository = value;
            }
        }

        #endregion public properties

        protected override void Initialize(RequestContext context)
        {
            ClearMessage();
            base.Initialize(context);
            if (Base.GetController.ToLower() != "account")
            {
                Login.AuthorizeLogin();
            }
        }

        //
        // GET: /Base/
        public BaseController()
            : base()
        {
        }

        protected PagedList<T> UpdateViewBag<T>(string search_input, string hddSort, int? hddPaging, int pagesize, IQueryable<T> list)
        {
            var currentSystemId = Base.LoginSession.intSystemId;
            if (Request["systemid"] != null && !string.IsNullOrEmpty(Request["systemid"].ToString()))
            {
                currentSystemId = int.Parse(Request["systemid"]);
            }
            else if (Request.Form["cboSystem"] != null)
            {
                currentSystemId = int.Parse(Request.Form["cboSystem"]);
                Base.AddUpdateCookie(Common.Utilities.Constants.STR_SystemId_ + Base.LoginSession.strUserName, Request.Form["cboSystem"], 365);
            }

            var cookieSort = Request.Url.ToString().ToLower() + "_" + Base.LoginSession.strUserName.ToLower() + "_sort";
            cookieSort = cookieSort.Replace("\\", "_").Replace("/", "_").Replace(":", "_").Replace("?", "_").Replace("&", "_").Replace("=", "_");

            if (Request.Cookies[cookieSort] != null && !string.IsNullOrEmpty(Request.Cookies[cookieSort].Value))
            {
                hddSort = HttpUtility.UrlDecode(Request.Cookies[cookieSort].Value, System.Text.Encoding.Default);
            }

            var cookiePaging = Request.Url.ToString().ToLower() + "_" + Base.LoginSession.strUserName.ToLower() + "_pagesize";
            cookiePaging = cookiePaging.Replace("\\", "_").Replace("/", "_").Replace(":", "_").Replace("?", "_").Replace("&", "_").Replace("=", "_");
            if (Request.Cookies[cookiePaging] != null && !string.IsNullOrEmpty(Request.Cookies[cookiePaging].Value))
            {
                pagesize = int.Parse(Request.Cookies[cookiePaging].Value);
            }

            ViewBag.PageSize = pagesize;
            ViewBag.TotalItemCount = Base.TotalItemCount;
            ViewBag.CurrentPage = hddPaging;
            var pagedList = list.ToPagedList<T>(hddPaging.Value, pagesize);
            ViewBag.Pager = pagedList;
            ViewBag.DisplayEntry = new SelectList(Base.PageSizeOptions(), pagesize.ToString());
            ViewBag.SearchValue = search_input;
            ViewBag.SortValue = hddSort;
            ViewBag.PagingValue = hddPaging;
            ViewBag.cboSystemType = new SelectList(Base.LoginSession.lstSystems, "SystemId", "Name", currentSystemId);
            ViewBag.currentSystemId = currentSystemId;
            return pagedList;
        }

        protected List<T> UpdateViewBag<T>(string search_input, string hddSort, int? hddPaging, int pagesize, List<T> list)
        {
            var currentSystemId = Base.LoginSession.intSystemId;
            if (Request["systemid"] != null && !string.IsNullOrEmpty(Request["systemid"].ToString()))
            {
                currentSystemId = int.Parse(Request["systemid"]);
            }
            else if (Request.Form["cboSystem"] != null)
            {
                currentSystemId = int.Parse(Request.Form["cboSystem"]);
                Base.AddUpdateCookie(Common.Utilities.Constants.STR_SystemId_ + Base.LoginSession.strUserName, Request.Form["cboSystem"], 365);
            }

            var cookieSort = Request.Url.ToString().ToLower() + "_" + Base.LoginSession.strUserName.ToLower() + "_sort";
            cookieSort = cookieSort.Replace("\\", "_").Replace("/", "_").Replace(":", "_").Replace("?", "_").Replace("&", "_").Replace("=", "_");

            if (Request.Cookies[cookieSort] != null && !string.IsNullOrEmpty(Request.Cookies[cookieSort].Value))
            {
                hddSort = HttpUtility.UrlDecode(Request.Cookies[cookieSort].Value, System.Text.Encoding.Default);
            }

            var cookiePaging = Request.Url.ToString().ToLower() + "_" + Base.LoginSession.strUserName.ToLower() + "_pagesize";
            cookiePaging = cookiePaging.Replace("\\", "_").Replace("/", "_").Replace(":", "_").Replace("?", "_").Replace("&", "_").Replace("=", "_");
            if (Request.Cookies[cookiePaging] != null && !string.IsNullOrEmpty(Request.Cookies[cookiePaging].Value))
            {
                pagesize = int.Parse(Request.Cookies[cookiePaging].Value);
            }

            ViewBag.PageSize = pagesize;
            ViewBag.TotalItemCount = Base.TotalItemCount;
            ViewBag.CurrentPage = hddPaging;
            ViewBag.Pager = list;
            ViewBag.DisplayEntry = new SelectList(Base.PageSizeOptions(), pagesize.ToString());
            ViewBag.SearchValue = search_input;
            ViewBag.SortValue = hddSort;
            ViewBag.PagingValue = hddPaging;
            ViewBag.cboSystemType = new SelectList(Base.LoginSession.lstSystems, "SystemId", "Name", currentSystemId);
            ViewBag.currentSystemId = currentSystemId;
            return list;
        }

        protected void ShowMessage(string message)
        {
            ClearMessage();
            TempData.Add("message", message);
        }

        protected void ShowSuccess(string message)
        {
            ModelState.AddModelError("Success", message);
        }

        protected void ShowError(string message)
        {
            ModelState.AddModelError("Error", message);
        }

        private void ClearMessage()
        {
            TempData.Remove("message");
            TempData.Remove("isValid");
        }

        protected override void OnException(ExceptionContext filterContext)
        {
            // handle the system exceptions in here
            if (filterContext.Exception is ArgumentNullException)
            {
                Base.RedirectTo("~/account/login?logout=true");
            }
        }
    }
}