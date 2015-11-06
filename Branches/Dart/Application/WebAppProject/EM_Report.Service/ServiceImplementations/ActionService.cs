namespace EM_Report.Service.ServiceImplementations
{
    using EM_Report.BLL.Services;
    using EM_Report.Common.Pager;
    using EM_Report.Common.Utilities;
    using EM_Report.Domain;
    using EM_Report.Domain.Resources;
    using EM_Report.Service.Helpers;
    using EM_Report.Service.MessageBase;
    using EM_Report.Service.Messages;
    using EM_Report.Service.ServiceContracts;
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using System.ServiceModel;
    using System.ServiceModel.Activation;
    using System.Web;

    /// <summary>
    /// Main facade into Patterns in Action application.
    /// Important: Each Session has its own instance of this class (see ServiceBehavior Attribute).
    /// </summary>
    /// <remarks>
    /// Application Facade Pattern.
    /// </remarks>
    [ServiceBehavior(InstanceContextMode = InstanceContextMode.PerCall)]
    public class ActionService : IActionService
    {
        #region Create default static services

        internal static I_AccountService IAccountService { get; set; }

        internal static I_UserService IUserService { get; set; }

        internal static I_Organisation_RolesService IOrganisation_RolesService { get; set; }

        internal static I_Organisation_Levels_Service IOrganisation_Levels_Service { get; set; }

        internal static I_ReportCategoriesService IReportCategoriesService { get; set; }

        internal static I_TeamService ITeamService { get; set; }

        internal static I_System_RolesService ISystem_RolesService { get; set; }

        internal static I_SystemPermissionService ISystem_PermissionService { get; set; }

        internal static I_External_GroupService IExternal_GroupService { get; set; }

        internal static I_StatusService IStatusService { get; set; }

        internal static I_PermissionService IPermissionService { get; set; }

        internal static I_System_Role_PermissionsService ISystemRolePermissionService { get; set; }

        internal static I_ReportService IReportService { get; set; }

        internal static I_DashboardService IDashboardService { get; set; }

        internal static I_Dashboard_OrganisationRole_LevelsServiceService IDashboard_OrganisationRole_LevelsService { get; set; }

        internal static I_DashboardExternal_GroupsServiceService IDashboardExternal_GroupsService { get; set; }

        internal static I_DashboardLevelService IDashboard_LevelsService { get; set; }

        internal static I_Dashboard_Traffic_Light_RulesService IDashboard_Traffic_Light_RulesService { get; set; }

        internal static I_Dashboard_FavoursService IDashboard_FavourService { get; set; }

        internal static I_Dashboard_Graph_DescriptionService IDashboard_Graph_DescriptionService { get; set; }

        internal static I_Dashboard_ProjectionService IDashboard_ProjectionService { get; set; }

        internal static I_Dashboard_TimeAccessService IDashboard_TimeAccessService { get; set; }

        internal static I_Dashboard_Target_BaseService IDashboard_Target_BaseService { get; set; }

        internal static I_Report_Organisation_LevelsService IReport_Organisation_LevelsService { get; set; }

        internal static I_EMLPortfolioService IEMLPortfolioService { get; set; }

        internal static I_HEMPortfolioService IHEMPortfolioService { get; set; }

        internal static I_TMFPortfolioService ITMFPortfolioService { get; set; }

        internal static IProjectionService IProjectionService { get; set; }

        internal static I_CONTROLService ICONTROL { get; set; }

        internal static I_WOWPortfolioService IWOWPortfolioService { get; set; }

        #endregion Create default static services

        #region private

        // Session state variables
        private static string _accessToken = ConfigurationManager.AppSettings["AccessToken"];

        /// <summary>
        /// Gets connection string value
        /// </summary>
        private string Get_ConnectionString(string connectionstring)
        {
            return ConfigurationManager.ConnectionStrings[connectionstring].ToString();
        }

        /// <summary>
        /// Gets connection string value
        /// </summary>
        private string Get_AppSetting(string appSetting)
        {
            return ConfigurationManager.AppSettings[appSetting].ToString();
        }

        #endregion private

        /// <summary>
        /// Login to application service.
        /// </summary>
        /// <param name="request">Login request message.</param>
        /// <returns>Login response message.</returns>
        public LoginResponse Login(LoginRequest request)
        {
            var response = new LoginResponse();

            response.UserExt = IAccountService.Login(request.UserId, request.UserName, request.Password, int.Parse(ConfigurationSettings.AppSettings["No_Limit_Login_Attempts"]), int.Parse(ConfigurationSettings.AppSettings["No_Days_Blocked_Attempts"]), request.LoginType);
            if (response.UserExt != null && response.UserExt.UserId > 0)
            {
                response.AccessToken = _accessToken;
            }

            return response;
        }

        /// <summary>
        /// Logout from application service.
        /// </summary>
        /// <param name="request">Logout request message.</param>
        /// <returns>Login request message.</returns>
        public LogoutResponse Logout(LogoutRequest request)
        {
            var response = new LogoutResponse();

            // Validate client tag and access token
            if (!ValidRequest(request, response))
                return response;

            //_email = null;
            //_username = null;

            return response;
        }

        /// <summary>
        /// Change password for user.
        /// </summary>
        /// <param name="request">ChangePassword request message.</param>
        /// <returns>ChangePassword response message.</returns>
        public ChangePasswordResponse ChangePassword(ChangePasswordRequest request)
        {
            var response = new ChangePasswordResponse();

            // Validate client tag and access token
            if (!ValidRequest(request, response))
                return response;
            response.returnValue = IAccountService.ChangePassword(request.UserId, request.OldPassword, request.NewPassword);

            return response;
        }

        /// <summary>
        /// Reset password for user.
        /// </summary>
        /// <param name="request">ResetPassword request message.</param>
        /// <returns>ResetPassword response message.</returns>
        public ResetPasswordResponse ResetPassword(ResetPasswordRequest request)
        {
            var response = new ResetPasswordResponse();
            if (request.LoadOptions.Contains(Resource.Request_Reset_Password))
            {
                response.returnValue = IUserService.SendmailResetPassword(request.Email, request.ResetPassword_Activation_Url);
            }
            else if (request.LoadOptions.Contains(Resource.Verify_URL_Reset_Password))
            {
                IUserService = new UserService(null);
                var user = IUserService.GetUserByUserNameOrEmail(request.Email);
                if (user != null)
                {
                    response.returnValue = IAccountService.VerifyURLResetPassword(user.Password, request.OldPassword, user.Is_External_User);
                }
            }
            else if (request.LoadOptions.Contains(Resource.Reset_Password))
            {
                IUserService = new UserService(null);
                var user = IUserService.GetUserByUserNameOrEmail(request.Email);
                if (user != null)
                {
                    response.returnValue = IAccountService.ResetPassword(user.Password, request.OldPassword, user.Is_External_User, user.Email, EnCryption.HashUserPassword(user.UserName.Substring(user.UserName.IndexOf("\\") + 1), request.NewPassword));
                }
            }
            return response;
        }

        /// <summary>
        /// Request user data.
        /// </summary>
        /// <param name="request">User request message.</param>
        /// <returns>User response message.</returns>
        public UserResponse GetUsers(UserRequest request)
        {
            var response = new UserResponse();

            IUserService = new UserService(null);

            if (request.LoadOptions.Contains(Resource.GetUserNameByEmail))
            {
                response.UserExt = IUserService.GetUserExtInfo(request.UserName);
            }
            else if (request.LoadOptions.Contains(Resource.Get_External_User_by_CronJob))
            {
                response.Users = IUserService.GetUserbyCronJob(false).ToList();
            }
            else if (request.LoadOptions.Contains(Resource.Get_Internal_User_by_CronJob))
            {
                response.Users = IUserService.GetUserbyCronJob(true).ToList();
            }
            else
            {
                // Validate client tag and access token
                if (!ValidRequest(request, response))
                    return response;

                if (request.LoadOptions.Contains(Resource.Get_Option_List))
                {
                    var users = !string.IsNullOrEmpty(request.UserType)
                                ? (request.UserType.ToLower().IndexOf("system") >= 0
                                ? IUserService.GetAllQueryable(request.Criteria.SortExpression, request.Criteria.SearchKeyWord).ToList().AsQueryable().Where(l => l.Is_System_User == true)
                                : request.UserType.ToLower().IndexOf("external") >= 0
                                ? IUserService.GetAllQueryable(request.Criteria.SortExpression, request.Criteria.SearchKeyWord).ToList().AsQueryable().Where(l => l.Is_External_User == true)
                                : IUserService.GetAllQueryable(request.Criteria.SortExpression, request.Criteria.SearchKeyWord).ToList().AsQueryable().Where(l => l.Is_External_User == false))
                                : IUserService.GetAllQueryable(request.Criteria.SortExpression, request.Criteria.SearchKeyWord).ToList().AsQueryable().Where(l => l.Is_External_User == false);

                    response.TotalItemCount = users != null ? users.LongCount() : 0;

                    var sortExpression = string.IsNullOrEmpty(request.Criteria.SortExpression) ? "UserId" : request.Criteria.SortExpression;
                    var usersPaged = users.OrderBy(sortExpression).ToPagedList<User>(request.Criteria.PageIndex, request.Criteria.PageSize);

                    response.Users = request.Criteria.PageSize == 0 && request.Criteria.PageIndex == 0 ? users.ToList() : usersPaged.ToList();
                }
                else if (request.LoadOptions.Contains(Resource.Get_Option_Single))
                {
                    if (request.UserId > 0)
                    {
                        var user = IUserService.GetUserById(request.UserId);
                        response.User = user;
                    }
                    else if (request.UserName != "")
                    {
                        var user = IUserService.GetUserByUserNameOrEmail(request.UserName);
                        response.User = user;
                    }
                }
                else if (request.LoadOptions.Contains(Resource.GetUser_By_UserNameOrEmail))
                {
                    if (request.User.UserId > 0)
                    {
                        var external_users = IUserService.GetAllQueryable("", "").Where(l => ((l.UserName.ToLower() == request.User.UserName.ToLower() || l.Email == request.User.Email) && l.UserId != request.User.UserId && l.Is_External_User));
                        if (external_users.Any())
                        {
                            response.Users = external_users.ToList();
                        }
                        else
                        {
                            var system_users = IUserService.GetAllQueryable("", "").Where(l => ((l.UserName.ToLower() == request.User.UserName.ToLower() || l.Email == request.User.Email) && l.UserId != request.User.UserId && l.Is_System_User));
                            if (system_users.Any())
                            {
                                response.Users = system_users.ToList();
                            }
                            else
                            {
                                if (request.User.SystemId > 0)
                                {
                                    var internal_users = IUserService.GetAllQueryable("", "").Where(l => ((l.UserName.ToLower() == request.User.UserName.ToLower() || l.Email == request.User.Email) && l.UserId != request.User.UserId && !l.Is_System_User && !l.Is_External_User));
                                    if (internal_users.Any())
                                    {
                                        foreach (var s in internal_users)
                                        {
                                            var user = IUserService.GetUserById(s.UserId);
                                            if (user.SystemId == request.User.SystemId)
                                            {
                                                response.Users = internal_users.ToList();
                                                break;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        response.Users = new List<User>();
                        var singleUser = IUserService.GetAllQueryable("", "").Where(l => (l.UserName.ToLower() == request.User.UserName.ToLower()
                            || l.Email == request.User.Email)).SingleOrDefault();
                        if (singleUser != null)
                            response.Users.Add(singleUser);
                    }
                }
                else if (request.LoadOptions.Contains(Resource.Get_List_System))
                {
                    response.Systems = IUserService.GetListSystem().ToList();
                }
            }

            return response;
        }

        /// <summary>
        /// Set (add, update, update status, delete) user value.
        /// </summary>
        /// <param name="request">User request message.</param>
        /// <returns>User response message.</returns>
        public UserResponse SetUsers(UserRequest request)
        {
            var response = new UserResponse();

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response))
                return response;

            // Transform customer data transfer object to customer business object
            var user = request.User;

            // Run within the context of a database transaction. Currently commented out.
            // The Decorator Design Pattern.
            if (request.Action == Resource.Action_Create)
            {
                var PasswordWithoutCrypt = user.Password;
                //user.Password = EnCryption.Encrypt(user.Password);
                user.Password = EnCryption.HashUserPassword(user.UserName, user.Password);
                IUserService.CreateUser(user);
                response.User = user;
                if (user != null)
                {
                    user.Password = PasswordWithoutCrypt;
                    IUserService.SendmailCreateNewUser(user.Email, user.FirstName, user.LastName, user.Password);
                }
            }
            else if (request.Action == Resource.Action_UpdateStatus)
            {
                IUserService.UpdateStatus(user, request.Criteria.Status);
                response.User = user;
            }
            else if (request.Action == Resource.Action_Update)
            {
                var userDb = IUserService.GetById(user.UserId);
                if (user.Password != userDb.Password)
                {
                    user.Password = EnCryption.HashUserPassword(user.UserName, user.Password);
                }
                IUserService.UpdateUser(user);
                response.User = user;
            }
            else if (request.Action == Resource.Action_Delete)
            {
                try
                {
                    IUserService.Delete(request.UserId);
                    response.RowsAffected = 1;
                }
                catch
                {
                    response.RowsAffected = 0;
                }
            }

            return response;
        }

        public ReportCategoryResponse GetRptCategories(ReportCategoryRequest request)
        {
            var response = new ReportCategoryResponse();

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response))
                return response;

            IReportCategoriesService = new ReportCategoriesService(null);

            if (request.LoadOptions.Contains(Resource.Get_Option_List))
            {
                var categories = IReportCategoriesService.GetAllQueryable(request.Criteria.SortExpression, request.Criteria.SearchKeyWord);
                response.TotalItemCount = categories != null ? categories.LongCount() : 0;

                var sortExpression = string.IsNullOrEmpty(request.Criteria.SortExpression) ? "CategoryId" : request.Criteria.SortExpression;
                var categoryPaged = categories.OrderBy(sortExpression).ToPagedList<Report_Categories>(request.Criteria.PageIndex, request.Criteria.PageSize);

                response.ReportCategories = request.Criteria.PageSize == 0 && request.Criteria.PageIndex == 0 ? categories.ToList() : categoryPaged.ToList();
            }

            if (request.LoadOptions.Contains(Resource.Get_Option_Single))
            {
                if (request.CategoryId > 0)
                {
                    var cat = IReportCategoriesService.GetAllQueryable("", "").Where(l => l.CategoryId == request.CategoryId).FirstOrDefault();
                    response.ReportCategory = cat;
                }
            }

            if (request.LoadOptions.Contains(Resource.Get_Option_List_UserCanAccess))
            {
                if (request.UserId > 0)
                {
                    response.ReportCategories = IReportCategoriesService.GetCategoriesUserCanAccess(request.UserId).ToList();
                }
            }

            return response;
        }

        public ReportCategoryResponse SetRptCategories(ReportCategoryRequest request)
        {
            var response = new ReportCategoryResponse();

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response))
                return response;

            // Transform customer data transfer object to customer business object
            var reportCategory = request.ReportCategory;

            if (request.Action == Resource.Action_Create)
            {
                IReportCategoriesService.Create(reportCategory);
                response.ReportCategory = reportCategory;
            }
            else if (request.Action == Resource.Action_UpdateStatus)
            {
                IReportCategoriesService.UpdateStatus(reportCategory, request.Criteria.Status);
                response.ReportCategory = reportCategory;
            }
            else if (request.Action == Resource.Action_Update)
            {
                IReportCategoriesService.Update(reportCategory, reportCategory.CategoryId);
                response.ReportCategory = reportCategory;
            }
            else if (request.Action == Resource.Action_Delete)
            {
                try
                {
                    IReportCategoriesService.Delete(request.CategoryId);
                    response.RowsAffected = 1;
                }
                catch
                {
                    response.RowsAffected = 0;
                }
            }

            return response;
        }

        public ReportPermissionResponse GetReportPermissions(ReportPermissionRequest request)
        {
            var response = new ReportPermissionResponse();

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response))
                return response;

            IReportService = new ReportService(null);
            var criteria = request.Criteria;
            if (request.LoadOptions.Contains(Resource.Get_Option_Single))
            {
                if (request.ReportId > 0)
                {
                    response.ReportPermission = IReportService.GetReportViewById(request.ReportId);
                }
            }
            return response;
        }

        public ReportPermissionResponse SetReportPermissions(ReportPermissionRequest request)
        {
            var response = new ReportPermissionResponse();
            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response))
                return response;

            // Transform  report permission  data transfer object to report permission business object
            var reportPermission = request.ReportPermission;
            {
                if (request.Action == "AddReportExternalAccess")
                {
                    IReportService.AddReportExternalAccess(reportPermission, request.ReportExternalAccess);
                    response.RowsAffected = 1;
                }
                else if (request.Action == "AddReportExternalAccesses")
                {
                    IReportService.AddReportExternalAccesses(reportPermission, request.ReportExternalAccesses.ToList());
                    response.RowsAffected = 1;
                }
                else if (request.Action == "RemoveReportExternalAccess")
                {
                    IReportService.RemoveReportExternalAccess(reportPermission, request.ReportExternalAccess);
                    response.RowsAffected = 1;
                }
                else if (request.Action == "RemoveReportExternalAccesses")
                {
                    IReportService.RemoveReportExternalAccesses(reportPermission, request.ReportExternalAccesses.ToList());
                    response.RowsAffected = 1;
                }
                else if (request.Action == "AddOrganisationRole")
                {
                    IReportService.AddOrganisationRole(reportPermission, request.ReportOrganisationLevel);
                    response.RowsAffected = 1;
                }
                else if (request.Action == "RemoveOrganisationRole")
                {
                    IReportService.RemoveOrganisationRole(reportPermission, request.ReportOrganisationLevel);
                    response.RowsAffected = 1;
                }
                else if (request.Action == Resource.Action_Delete)
                {
                    try
                    {
                        IReportService.DeleteReportView(reportPermission);
                        response.RowsAffected = 1;
                    }
                    catch
                    {
                        response.RowsAffected = 0;
                    }
                }
            }
            return response;
        }

        public StatusResponse GetStatus(StatusRequest request)
        {
            var response = new StatusResponse();
            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response))
                return response;

            IStatusService = new StatusService(null);
            var criteria = request.Criteria;

            if (request.LoadOptions.Contains(Resource.Get_Option_List))
            {
                var statuses = IStatusService.GetAllQueryable("", "");
                response.Statuses = statuses.ToList();
            }
            else if (request.LoadOptions.Contains(Resource.Get_Option_Single))
            {
                if (request.StatusId > 0)
                {
                    response.Status = IStatusService.GetById(request.StatusId);
                }
            }
            return response;
        }

        public StatusResponse SetStatus(StatusRequest request)
        {
            var response = new StatusResponse();
            if (!ValidRequest(request, response))
                return response;

            // Transform customer data transfer object to customer business object
            var status = request.Status;

            if (request.Action == Resource.Action_Create)
            {
                IStatusService.Create(status);
                response.Status = status;
            }
            else if (request.Action == Resource.Action_Update)
            {
                IStatusService.Update(status, status.StatusId);
                response.Status = status;
            }
            else if (request.Action == Resource.Action_Delete)
            {
                try
                {
                    IStatusService.Delete(request.StatusId);
                    response.RowsAffected = 1;
                }
                catch
                {
                    response.RowsAffected = 0;
                }
            }

            return response;
        }

        public PermissionResponse GetPermissions(PermissionRequest request)
        {
            var response = new PermissionResponse();
            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response))
                return response;

            IPermissionService = new PermissionService(null);

            if (request.LoadOptions.Contains(Resource.Get_Option_List))
            {
                var permission = IPermissionService.GetAllQueryable(request.Criteria.SortExpression, request.Criteria.SearchKeyWord);
                response.Permissions = permission.ToList();
            }
            else if (request.LoadOptions.Contains(Resource.Get_Option_Single))
            {
                if (request.PermissionId > 0)
                {
                    response.Permission = IPermissionService.GetById(request.PermissionId);
                }
            }
            return response;
        }

        public PermissionResponse SetPermissions(PermissionRequest request)
        {
            var response = new PermissionResponse();

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response))
                return response;

            // Transform pedrmission data transfer object to permission business object
            var permission = request.Permission;

            if (request.Action == Resource.Action_Create)
            {
                IPermissionService.Create(permission);
                response.Permission = permission;
            }
            else if (request.Action == Resource.Action_UpdateStatus)
            {
                permission.Status = request.Criteria.Status;
                IPermissionService.Update(permission, permission.PermissionId);
                response.Permission = permission;
            }
            else if (request.Action == Resource.Action_Update)
            {
                IPermissionService.Update(permission, permission.PermissionId);
                response.Permission = permission;
            }
            else if (request.Action == Resource.Action_Delete)
            {
                try
                {
                    IPermissionService.Delete(request.PermissionId);
                    response.RowsAffected = 1;
                }
                catch
                {
                    response.RowsAffected = 0;
                }
            }
            return response;
        }

        public ReportResponse GetReports(ReportRequest request)
        {
            var response = new ReportResponse();

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response))
                return response;

            IReportService = new ReportService(null);
            if (request.LoadOptions.Contains(Resource.Get_Option_List))
            {
                var reports = IReportService.GetAllReports(request.Criteria.SystemId,
                    request.Criteria.SortExpression, request.Criteria.SearchKeyWord);

                response.TotalItemCount = reports != null ? reports.LongCount() : 0;

                var sortExpression = string.IsNullOrEmpty(request.Criteria.SortExpression) ? "ReportId" : request.Criteria.SortExpression;
                var reportsPage = reports.OrderBy(sortExpression).ToPagedList<Report>(request.Criteria.PageIndex, request.Criteria.PageSize);

                response.Reports = request.Criteria.PageSize == 0 && request.Criteria.PageIndex == 0 ? reports.ToList() : reportsPage.ToList();
            }
            else if (request.LoadOptions.Contains(Resource.Get_Option_Single))
            {
                if (!string.IsNullOrEmpty(request.Url))
                {
                    response.Report = IReportService.GetReportByReportPath(request.Url);
                }
                else if (request.ReportId > 0)
                {
                    var report = IReportService.GetAllReports(0, "", "").Where(l => l.ReportId == request.ReportId).FirstOrDefault();
                    response.Report = report;
                }
            }
            else if (request.LoadOptions.Contains(Resource.Get_Option_List_UserCanAccess))
            {
                var reports = IReportService.GetAllReportUserCanAccess(request.Criteria.SystemId, request.UserId,
                    request.IsSystemUser, request.CategoryId, request.Criteria.SortExpression, request.Criteria.SearchKeyWord);

                if (request.IsForSubscription)
                {
                    reports = reports.Where(l => l.ForSubscription == true);
                }

                response.TotalItemCount = reports != null ? reports.LongCount() : 0;

                var sortExpression = string.IsNullOrEmpty(request.Criteria.SortExpression) ? "ReportId" : request.Criteria.SortExpression;
                var reportsPage = reports.OrderBy(sortExpression).ToPagedList<Report>(request.Criteria.PageIndex, request.Criteria.PageSize);

                response.Reports = request.Criteria.PageSize == 0 && request.Criteria.PageIndex == 0 ? reports.ToList()
                    : reportsPage.ToList();
            }
            else if (request.LoadOptions.Contains(Resource.Get_Option_List_Favourite))
            {
                //var reports = IReportService.GetFavoriteReport(request.Criteria.SystemId, request.UserId);

                //response.TotalItemCount = reports != null ? reports.LongCount() : 0;
                //response.Reports = reports.ToList();
            }
            else if (request.LoadOptions.Contains(Resource.Get_Option_List_Recently))
            {
                //var reports = IReportService.GetRecentlyReport(request.Criteria.SystemId, request.UserId);

                //response.TotalItemCount = reports != null ? reports.LongCount() : 0;
                //response.Reports = reports.ToList();
            }
            else if (request.LoadOptions.Contains(Resource.Get_Option_List_ByCategory))
            {
                var reports = IReportService.GetAllReportUserCanAccess(request.Criteria.SystemId, request.UserId,
                    request.IsSystemUser, request.CategoryId, request.Criteria.SortExpression, request.Criteria.SearchKeyWord);

                response.TotalItemCount = reports != null ? reports.LongCount() : 0;

                var sortExpression = string.IsNullOrEmpty(request.Criteria.SortExpression) ? "ReportId" : request.Criteria.SortExpression;
                var reportsPage = reports.OrderBy(sortExpression).ToPagedList(request.Criteria.PageIndex, request.Criteria.PageSize);
                response.Reports = request.Criteria.PageIndex == 0 ? reports.ToList() : reportsPage.ToList();
            }
            return response;
        }

        public ReportResponse SetReports(ReportRequest request)
        {
            var response = new ReportResponse();

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response))
                return response;

            // Transform report data transfer object to report business object
            var report = request.Report;

            if (request.Action == Resource.Action_Create)
            {
                response.Report = IReportService.CreateOrUpdate(report);
            }
            else if (request.Action == Resource.Action_UpdateStatus)
            {
                var criteria = request.Criteria;

                IReportService.UpdateStatus(report, criteria.Status);
                response.Report = report;
            }
            else if (request.Action == Resource.Action_Update)
            {
                response.Report = IReportService.CreateOrUpdate(report);
            }
            else if (request.Action == Resource.Action_Delete)
            {
                try
                {
                    IReportService.Delete(request.ReportId);
                    response.RowsAffected = 1;
                }
                catch
                {
                    response.RowsAffected = 0;
                }
            }
            else if (request.Action == Resource.Action_AddOrRemoveFavorite)
            {
                IReportService.AddOrRemoveFavoriteReport(request.UserId, request.ReportId);
            }
            else if (request.Action == Resource.Action_AddRecentlyReport)
            {
                IReportService.AddRecentlyReport(request.UserId, request.ReportId);
            }
            // check user authorization for viewing report
            else if (request.Action == Resource.Action_CanAccessReport)
            {
                var listreportusercanaccess = IReportService.GetAllReportUserCanAccess(0, request.UserId, request.IsSystemUser, "", "");

                if (Enumerable.Any(listreportusercanaccess, item => request.ReportId == item.ReportId))
                {
                    response.TotalItemCount = 1;
                }
            }

            return response;
        }

        public Dashboard_LevelsResponse GetDashBoardLevels(Dashboard_LevelsRequest request)
        {
            var response = new Dashboard_LevelsResponse();
            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response))
                return response;

            IDashboard_LevelsService = new DashboardLevelService(null);
            var criteria = request.Criteria;

            if (request.LoadOptions.Contains(Resource.Get_Option_Single))
            {
                response.DashboardLevels = IDashboard_LevelsService.GetAllQueryable("", "").Where(l => l.DashboardLevelId == request.DashboardLevelId).FirstOrDefault();
            }
            else if (request.LoadOptions.Contains(Resource.Get_Option_List))
            {
                var dashboardLevels = IDashboard_LevelsService.GetAllQueryable(!string.IsNullOrEmpty(request.Criteria.SortExpression) ? request.Criteria.SortExpression : "",
                    !string.IsNullOrEmpty(request.Criteria.SearchKeyWord) ? request.Criteria.SearchKeyWord : "");
                response.DashboardLevelses = dashboardLevels.ToList();
            }

            return response;
        }

        public Dashboard_LevelsResponse SetDashBoardLevels(Dashboard_LevelsRequest request)
        {
            var response = new Dashboard_LevelsResponse();
            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response))
                return response;

            // Transform report data transfer object to report business object
            var dashboardLevel = request.DashboardLevels;
            if (request.Action == Resource.Action_Create)
            {
                IDashboard_LevelsService.Create(dashboardLevel);
                response.DashboardLevels = dashboardLevel;
            }
            else if (request.Action == Resource.Action_UpdateStatus)
            {
                var criteria = request.Criteria;
                dashboardLevel.Status = criteria.Status;
                IDashboard_LevelsService.Update(dashboardLevel, dashboardLevel.DashboardLevelId);
                response.DashboardLevels = dashboardLevel;
            }
            else if (request.Action == Resource.Action_Update)
            {
                IDashboard_LevelsService.Update(dashboardLevel, dashboardLevel.DashboardLevelId);
                response.DashboardLevels = dashboardLevel;
            }
            else if (request.Action == Resource.Action_Delete)
            {
                try
                {
                    IDashboard_LevelsService.Delete(request.DashboardLevelId);
                    response.RowsAffected = 1;
                }
                catch
                {
                    response.RowsAffected = 0;
                }
            }

            return response;
        }

        public DashboardResponse GetDashBoards(DashboardRequest request)
        {
            var response = new DashboardResponse();
            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response))
                return response;

            if (request.LoadOptions.Contains(Resource.Get_Option_List_Traffic_Light))
            {
                IDashboard_Traffic_Light_RulesService = new Dashboard_Traffic_Light_RulesService(null);
                var trafficLightRules = IDashboard_Traffic_Light_RulesService.GetAllQueryable("", "").Where(l => l.SystemId == request.SystemsId);

                // Temporay ToList
                var lst = (from l in trafficLightRules
                           group l by new { l.DashboardType, l.Name, l.Description, l.ImageUrl, l.FromValue, l.ToValue } into g
                           select new
                           {
                               DashboardType = g.Key.DashboardType,
                               Name = g.Key.Name,
                               Description = g.Key.Description,
                               ImageUrl = g.Key.ImageUrl,
                               FromValue = g.Key.FromValue,
                               ToValue = g.Key.ToValue
                           }).ToList();

                var lstRTW = lst.Where(l => l.DashboardType.ToLower() == "rtw").OrderBy(l => l.ToValue);
                var lstAWC = lst.Where(l => l.DashboardType.ToLower() == "awc").OrderBy(l => l.ToValue);

                response.Dashboard_Traffic_Light_Rules = lstRTW.Union(lstAWC).Select(x => new Dashboard_Traffic_Light_Rule
                {
                    DashboardType = x.DashboardType,
                    Name = x.Name,
                    Description = x.Description,
                    ImageUrl = x.ImageUrl,
                    FromValue = x.FromValue,
                    ToValue = x.ToValue
                }).ToList();
            }
            else
            {
                IDashboardService = new DashboardService(null);
                if (request.LoadOptions.Contains(Resource.Get_Option_List))
                {
                    var dashboards = IDashboardService.GetAllQueryable(request.Criteria.SortExpression,
                                                                     request.Criteria.SearchKeyWord);
                    if (request.Criteria.SystemId != 0)
                    {
                        dashboards = dashboards.Where(l => l.SystemId == request.Criteria.SystemId);
                    }
                    response.TotalItemCount = dashboards.LongCount();

                    var sortExpression = string.IsNullOrEmpty(request.Criteria.SortExpression) ? "DashboardId" : request.Criteria.SortExpression;
                    var reportsPage = dashboards.OrderBy(sortExpression).ToPagedList(request.Criteria.PageIndex, request.Criteria.PageSize);

                    response.Dashboards = request.Criteria.PageSize == 0 && request.Criteria.PageIndex == 0 ? dashboards.ToList() : reportsPage.ToList();
                }
                else if (request.LoadOptions.Contains(Resource.Get_Option_Single))
                {
                    if (!string.IsNullOrEmpty(request.Url))
                    {
                        response.Dashboard = IDashboardService.GetAllQueryable(request.Criteria.SortExpression, request.Criteria.SearchKeyWord).Where(e => e.Url == request.Url.Replace(ConfigurationManager.AppSettings["ReportPathPrefix"], "")).FirstOrDefault();
                    }
                    else if (request.DashboardId > 0)
                    {
                        var dashboard = IDashboardService.GetAllQueryable("", "").Where(l => l.DashboardId == request.DashboardId).FirstOrDefault();
                        response.Dashboard = dashboard;
                    }
                }
            }
            return response;
        }

        public DashboardResponse SetDashBoards(DashboardRequest request)
        {
            var response = new DashboardResponse();
            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response))
                return response;

            // Transform report data transfer object to report business object
            var dashboard = request.Dashboard;

            if (request.Action == Resource.Action_Create)
            {
                IDashboardService.Create(dashboard);
                response.Dashboard = dashboard;
            }
            else if (request.Action == Resource.Action_UpdateStatus)
            {
                var criteria = request.Criteria;
                dashboard.Status = criteria.Status;
                IDashboardService.Update(dashboard, dashboard.DashboardId);
                response.Dashboard = dashboard;
            }
            else if (request.Action == Resource.Action_Update)
            {
                IDashboardService.Update(dashboard, dashboard.DashboardId);
                response.Dashboard = dashboard;
            }
            else if (request.Action == Resource.Action_Delete)
            {
                try
                {
                    IDashboardService.Delete(request.DashboardId);
                    response.RowsAffected = 1;
                }
                catch
                {
                    response.RowsAffected = 0;
                }
            }

            return response;
        }

        public SystemRole_PermissionsResponse GetSystemRolePermissions(SystemRole_PermissionsRequest request)
        {
            var response = new SystemRole_PermissionsResponse();
            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response))
                return response;

            ISystemRolePermissionService = new System_Role_PermissionsService(null);
            if (request.LoadOptions.Contains(Resource.Get_Option_List))
            {
                var sysRolePermission = ISystemRolePermissionService.GetAllQueryable(request.Criteria.SortExpression, request.Criteria.SearchKeyWord);
                response.SystemRolePermissions = sysRolePermission.ToList();
            }

            if (request.LoadOptions.Contains(Resource.Get_SystemRolePermission_By_SystemRoleId))
            {
                var sysRolePermission = ISystemRolePermissionService.GetAllQueryable("", "").Where(l => l.System_RoleId == request.System_RoleId);
                response.SystemRolePermissions = sysRolePermission.ToList();
            }
            return response;
        }

        public SystemRole_PermissionsResponse SetSystemRolePermissions(SystemRole_PermissionsRequest request)
        {
            var response = new SystemRole_PermissionsResponse();

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response))
                return response;

            // Transform pedrmission data transfer object to permission business object
            var sysRolePermission = request.SysRolePermission;

            if (request.Action == Resource.Action_Create)
            {
                ISystemRolePermissionService.Create(sysRolePermission);
                response.SystemRolePermission = sysRolePermission;
            }
            else if (request.Action == Resource.Action_Update)
            {
                ISystemRolePermissionService.Update(sysRolePermission, sysRolePermission.System_RoleId);
                response.SystemRolePermission = sysRolePermission;
            }
            else if (request.Action == Resource.Action_Delete)
            {
                try
                {
                    ISystemRolePermissionService.Delete(request.System_RoleId);
                    response.RowsAffected = 1;
                }
                catch
                {
                    response.RowsAffected = 0;
                }
            }
            return response;
        }

        public Organisation_RolesResponse GetOrganisationRoles(Organisation_RolesRequest request)
        {
            var response = new Organisation_RolesResponse();
            if (!ValidRequest(request, response))
                return response;

            IOrganisation_RolesService = new Organisation_RolesService(null);

            if (request.LoadOptions.Contains(Resource.Get_Option_Single))
            {
                var role = IOrganisation_RolesService.GetAllQueryable("", "").Where(l => l.Organisation_RoleId == request.RoleId).FirstOrDefault();
                response.Role = role;
            }
            else if (request.LoadOptions.Contains(Resource.Get_Option_List))
            {
                var roles = IOrganisation_RolesService.GetAllQueryable(request.Criteria.SortExpression, request.Criteria.SearchKeyWord);
                response.TotalItemCount = roles != null ? roles.LongCount() : 0;

                var sortExpression = string.IsNullOrEmpty(request.Criteria.SortExpression) ? "Organisation_RoleId" : request.Criteria.SortExpression;
                var rolesPage = roles.OrderBy(sortExpression).ToPagedList(request.Criteria.PageIndex, request.Criteria.PageSize);
                response.Roles = request.Criteria.PageIndex == 0 ? roles.ToList() : rolesPage.ToList();
            }
            else if (request.LoadOptions.Contains(Resource.Get_Option_List_RolesOfLevel))
            {
                var roles = IOrganisation_RolesService.GetRoleOfLevel(request.LevelId);
                response.TotalItemCount = roles != null ? roles.LongCount() : 0;

                var sortExpression = string.IsNullOrEmpty(request.Criteria.SortExpression) ? "Organisation_RoleId" : request.Criteria.SortExpression;
                var rolesPage = roles.OrderBy(sortExpression).ToPagedList(request.Criteria.PageIndex, request.Criteria.PageSize);
                response.Roles = request.Criteria.PageIndex == 0 ? roles.ToList() : rolesPage.ToList();
            }
            else if (request.LoadOptions.Contains(Resource.IsTeamLeader))
            {
                response.IsTeamLeaderOrAbove = IOrganisation_RolesService.IsTeamLeaderOrAbove(request.RoleId);
            }

            return response;
        }

        public Organisation_RolesResponse SetOrganisationRoles(Organisation_RolesRequest request)
        {
            var response = new Organisation_RolesResponse();
            if (!ValidRequest(request, response))
                return response;

            var role = request.Roles;

            IOrganisation_RolesService = new Organisation_RolesService(null);

            if (request.Action == Resource.Action_Create)
            {
                IOrganisation_RolesService.Create(role);
                response.Role = role;
            }
            else if (request.Action == Resource.Action_UpdateStatus)
            {
                IOrganisation_RolesService.UpdateStatus(role, role.Status);
                response.Role = role;
            }
            else if (request.Action == Resource.Action_UpdateLevel)
            {
                IOrganisation_RolesService.UpdateLevel(request.RoleId, request.LevelId, request.UserId);
                response.Role = role;
            }
            else if (request.Action == Resource.Action_Update)
            {
                response.Role = IOrganisation_RolesService.Update(role, role.Organisation_RoleId);
            }
            else if (request.Action == Resource.Action_Delete)
            {
                try
                {
                    IOrganisation_RolesService.Delete(request.RoleId);
                    response.RowsAffected = 1;
                }
                catch
                {
                    response.RowsAffected = 0;
                }
            }

            return response;
        }

        public Organisation_LevelsResponse GetOrganisationLevels(Organisation_LevelsRequest request)
        {
            var response = new Organisation_LevelsResponse();
            if (!ValidRequest(request, response))
                return response;

            IOrganisation_Levels_Service = new Organisation_Levels_Service(null);
            if (request.LoadOptions.Contains(Resource.Get_Option_Single))
            {
                var level = IOrganisation_Levels_Service.GetAllQueryable("", "").Where(l => l.LevelId == request.LevelId).FirstOrDefault();
                response.Level = level;
            }
            else if (request.LoadOptions.Contains(Resource.Get_Option_List))
            {
                var levels = IOrganisation_Levels_Service.GetAllQueryable(request.Criteria.SortExpression, request.Criteria.SearchKeyWord);
                response.TotalItemCount = levels != null ? levels.LongCount() : 0;

                var sortExpression = string.IsNullOrEmpty(request.Criteria.SortExpression) ? "LevelId" : request.Criteria.SortExpression;
                var levelsPage = levels.OrderBy(sortExpression).ToPagedList(request.Criteria.PageIndex, request.Criteria.PageSize);
                response.Levels = request.Criteria.PageIndex == 0 ? levels.ToList() : levelsPage.ToList();
            }

            return response;
        }

        public Organisation_LevelsResponse SetOrganisationLevels(Organisation_LevelsRequest request)
        {
            var response = new Organisation_LevelsResponse();
            if (!ValidRequest(request, response))
                return response;

            var level = request.Level;

            if (request.Action == Resource.Action_Create)
            {
                IOrganisation_Levels_Service.Create(level);
                response.Level = level;
            }
            else if (request.Action == Resource.Action_Update)
            {
                IOrganisation_Levels_Service.Update(level, level.LevelId);
                response.Level = level;
            }
            else if (request.Action == Resource.Action_ReArrange)
            {
                IOrganisation_Levels_Service.ReArrangeLevel(request.Data, request.UpdatedBy);
            }
            else if (request.Action == Resource.Action_Delete)
            {
                try
                {
                    IOrganisation_Levels_Service.Delete(request.LevelId);
                    response.RowsAffected = 1;
                }
                catch
                {
                    response.RowsAffected = 0;
                }
            }

            return response;
        }

        public System_RolesResponse GetSystemRoles(System_RolesRequest request)
        {
            var response = new System_RolesResponse();
            if (!ValidRequest(request, response))
                return response;
            ISystem_RolesService = new System_RolesService(null);

            if (request.LoadOptions.Contains(Resource.Get_Option_Single))
            {
                response.SystemRole = ISystem_RolesService.GetAllQueryable("", "").Where(r => r.System_RoleId == request.System_RoleId).First();
            }
            else if (request.LoadOptions.Contains(Resource.Get_Option_List))
            {
                var roles = ISystem_RolesService.GetAllQueryable(request.Criteria.SortExpression, request.Criteria.SearchKeyWord);
                response.SystemRoles = roles.ToList();
            }

            return response;
        }

        public System_RolesResponse SetSystemRoles(System_RolesRequest request)
        {
            var response = new System_RolesResponse();
            if (!ValidRequest(request, response))
                return response;

            var systemRole = request.SystemRole;

            if (request.Action == Resource.Action_Create)
            {
                ISystem_RolesService.Create(systemRole);
                response.SystemRole = systemRole;
            }
            else if (request.Action == Resource.Action_Update)
            {
                ISystem_RolesService.Update(systemRole, systemRole.System_RoleId);
                response.SystemRole = systemRole;
            }
            else if (request.Action == Resource.Action_Save)
            {
                response.IsSaveSuccess = ISystem_RolesService.Save(request.SystemRole.System_RoleId, request.SystemRole.Name,
                                                request.SystemRole.Description, request.SystemRoles, request.UpdatedBy);
            }
            else if (request.Action == Resource.Action_Delete)
            {
                try
                {
                    ISystem_RolesService.Delete(request.System_RoleId);
                    response.RowsAffected = 1;
                }
                catch
                {
                    response.RowsAffected = 0;
                }
            }

            return response;
        }

        public System_PermissionResponse GetSystemPermissions(System_PermissionRequest request)
        {
            var response = new System_PermissionResponse();
            if (!ValidRequest(request, response))
                return response;
            ISystem_PermissionService = new SystemPermissionService(null);

            if (request.LoadOptions.Contains(Resource.Get_Option_Single))
            {
                response.SystemPermission = ISystem_PermissionService.GetById(request.System_PermissionId);
            }
            else if (request.LoadOptions.Contains(Resource.Get_Option_List))
            {
                var permissions = ISystem_PermissionService.GetAllQueryable(request.Criteria.SortExpression, request.Criteria.SearchKeyWord);
                response.SystemPermissions = permissions.ToList();
            }

            return response;
        }

        public System_PermissionResponse SetSystemPermissions(System_PermissionRequest request)
        {
            var response = new System_PermissionResponse();
            if (!ValidRequest(request, response))
                return response;

            var systemPermission = request.SystemPermission;

            if (request.Action == Resource.Action_Create)
            {
                ISystem_PermissionService.Create(systemPermission);
                response.SystemPermission = systemPermission;
            }
            else if (request.Action == Resource.Action_Update)
            {
                ISystem_PermissionService.Update(systemPermission, systemPermission.System_PermissionId);
                response.SystemPermission = systemPermission;
            }
            else if (request.Action == Resource.Action_UpdateStatus)
            {
                systemPermission.Status = request.Criteria.Status;
                ISystem_PermissionService.Update(systemPermission, systemPermission.System_PermissionId);
            }
            else if (request.Action == Resource.Action_Delete)
            {
                try
                {
                    ISystem_PermissionService.Delete(request.System_PermissionId);
                    response.RowsAffected = 1;
                }
                catch
                {
                    response.RowsAffected = 0;
                }
            }

            return response;
        }

        public Dashboard_Traffic_Light_RulesResponse GetDashboard_Traffic_Light_Rules(Dashboard_Traffic_Light_RulesRequest request)
        {
            var response = new Dashboard_Traffic_Light_RulesResponse();
            var filteredResponse = new Dashboard_Traffic_Light_RulesResponse();

            if (!ValidRequest(request, response))
                return response;

            IDashboard_Traffic_Light_RulesService = new Dashboard_Traffic_Light_RulesService(null);

            if (request.LoadOptions.Contains(Resource.Get_Option_Single))
            {
                response.Dashboard_Traffic_Light_Rule = IDashboard_Traffic_Light_RulesService.GetAllQueryable("", "").Where(r => r.Id == request.Id).First();
            }
            else if (request.LoadOptions.Contains(Resource.Get_Option_List))
            {
                var systemid = request.SystemId <= 0 ? request.Criteria.SystemId : request.SystemId;

                var dashboardTrafficLightRule = IDashboard_Traffic_Light_RulesService.GetAllQueryable(request.Criteria.SortExpression, request.Criteria.SearchKeyWord);

                if (!string.IsNullOrEmpty(request.DashboardType) && !string.IsNullOrEmpty(request.Name) && systemid > 0)
                {
                    dashboardTrafficLightRule = dashboardTrafficLightRule.Where(d => d.DashboardType == request.DashboardType &&
                                                                                   d.Name == request.Name &&
                                                                                   d.SystemId == request.SystemId);
                }

                response.TotalItemCount = dashboardTrafficLightRule != null ? dashboardTrafficLightRule.LongCount() : 0;

                var sortExpression = string.IsNullOrEmpty(request.Criteria.SortExpression) ? "Id" : request.Criteria.SortExpression;
                var dashboardTrafficLightRulePaged = dashboardTrafficLightRule.OrderBy(sortExpression).ToPagedList<Dashboard_Traffic_Light_Rule>(request.Criteria.PageIndex, request.Criteria.PageSize);

                response.Dashboard_Traffic_Light_Rules = request.Criteria.PageSize == 0 && request.Criteria.PageIndex == 0 ? dashboardTrafficLightRule.ToList() : dashboardTrafficLightRulePaged.ToList();
            }

            if (request.filteredFlag) return filteredResponse;
            else return response;
        }

        public Dashboard_Traffic_Light_RulesResponse SetDashboard_Traffic_Light_Rules(Dashboard_Traffic_Light_RulesRequest request)
        {
            var response = new Dashboard_Traffic_Light_RulesResponse();
            if (!ValidRequest(request, response))
                return response;

            var dashboardTrafficLightRule = request.Dashboard_Traffic_Light_Rules;

            if (request.Action == Resource.Action_Create)
            {
                IDashboard_Traffic_Light_RulesService.Create(dashboardTrafficLightRule);
                response.Dashboard_Traffic_Light_Rule = dashboardTrafficLightRule;
            }
            else if (request.Action == Resource.Action_Update)
            {
                IDashboard_Traffic_Light_RulesService.Update(dashboardTrafficLightRule, dashboardTrafficLightRule.Id);
                response.Dashboard_Traffic_Light_Rule = dashboardTrafficLightRule;
            }
            else if (request.Action == Resource.Action_Delete)
            {
                try
                {
                    IDashboard_Traffic_Light_RulesService.Delete(request.Id);
                    response.RowsAffected = 1;
                }
                catch
                {
                    response.RowsAffected = 0;
                }
            }
            else if (request.Action == Resource.Action_DeleteAll)
            {
                try
                {
                    IDashboard_Traffic_Light_RulesService.DeleteAll();
                    response.RowsAffected = 1;
                }
                catch
                {
                    response.RowsAffected = 0;
                }
            }

            return response;
        }

        /// <summary>
        /// Request Team data
        /// </summary>
        /// <param name="request">Team request message.</param>
        /// <returns>Team response message.</returns>
        ///

        public TeamResponse GetTeams(TeamRequest request)
        {
            var response = new TeamResponse();

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response))
                return response;

            ITeamService = new TeamService(null);
            if (string.IsNullOrEmpty(request.UserName))
            {
                if (request.LoadOptions.Contains(Resource.Get_Option_List))
                {
                    var teams = ITeamService.GetAllQueryable(request.Criteria.SortExpression, request.Criteria.SearchKeyWord);

                    if (request.Criteria.SystemId > 0)
                    {
                        teams = teams.Where(l => l.SystemId == request.Criteria.SystemId);
                    }
                    response.TotalItemCount = teams != null ? teams.LongCount() : 0;

                    var sortExpression = string.IsNullOrEmpty(request.Criteria.SortExpression) ? "TeamId" : request.Criteria.SortExpression;
                    var teamsPaged = teams.OrderBy(sortExpression).ToPagedList<Team>(request.Criteria.PageIndex, request.Criteria.PageSize);

                    response.Teams = request.Criteria.PageSize == 0 && request.Criteria.PageIndex == 0 ? teams.ToList() : teamsPaged.ToList();
                }

                if (request.LoadOptions.Contains(Resource.Get_Option_Single))
                {
                    if (request.TeamId > 0)
                    {
                        var team = ITeamService.GetAllQueryable("", "").Where(l => l.TeamId == request.TeamId).FirstOrDefault();
                        response.Team = ITeamService.GetById(request.TeamId);
                    }
                }
            }
            else
            {
                if (request.Action == Resource.IsRig)
                {
                    response.IsRig = ITeamService.IsRIG(request.UserName, request.Site);
                }
            }

            return response;
        }

        /// <summary>
        /// Set (add, update, update status, delete) team value.
        /// </summary>
        /// <param name="request">Team request message.</param>
        /// <returns>Team response message.</returns>
        public TeamResponse SetTeams(TeamRequest request)
        {
            var response = new TeamResponse();

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response))
                return response;

            // Transform customer data transfer object to customer business object
            var team = request.Team;

            // Run within the context of a database transaction. Currently commented out.
            // The Decorator Design Pattern.
            //using (TransactionDecorator transaction = new TransactionDecorator())
            {
                if (request.Action == Resource.Action_Create)
                {
                    ITeamService.Create(team);
                    response.Team = team;
                }
                else if (request.Action == Resource.Action_UpdateStatus)
                {
                    var criteria = request.Criteria;

                    ITeamService.UpdateStatus(team, criteria.Status);
                    response.Team = team;
                }
                else if (request.Action == Resource.Action_Update)
                {
                    ITeamService.Update(team, team.TeamId);
                    response.Team = team;
                }
                else if (request.Action == Resource.Action_Delete)
                {
                    try
                    {
                        ITeamService.Delete(request.TeamId);
                        response.RowsAffected = 1;
                    }
                    catch
                    {
                        response.RowsAffected = 0;
                    }
                }
            }

            return response;
        }

        /// <summary>
        /// Request ExternalGroup dara.
        /// </summary>
        /// <param name="request">ExternalGroup request message.</param>
        /// <returns>ExternalGroup response message.</returns>
        public External_GroupResponse GetExternal_Groups(External_GroupRequest request)
        {
            var response = new External_GroupResponse();

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response))
                return response;

            IExternal_GroupService = new External_GroupService(null);
            if (request.LoadOptions.Contains(Resource.Get_Option_List))
            {
                var groups = IExternal_GroupService.GetGroups(request.GroupStatusFilter, request.Criteria.SortExpression, request.Criteria.SearchKeyWord);

                response.TotalItemCount = groups != null ? groups.LongCount() : 0;

                var sortExpression = string.IsNullOrEmpty(request.Criteria.SortExpression) ? "External_GroupId" : request.Criteria.SortExpression;
                var groupsPaged = groups.OrderBy(sortExpression).ToPagedList<External_Group>(request.Criteria.PageIndex, request.Criteria.PageSize);

                response.External_Groups = request.Criteria.PageSize == 0 && request.Criteria.PageIndex == 0 ? groups.ToList() : groupsPaged.ToList();
            }

            if (request.LoadOptions.Contains(Resource.Get_Option_Single))
            {
                if (request.External_GroupId > 0)
                {
                    var extGroup = IExternal_GroupService.GetAllQueryable("", "").Where(l => l.External_GroupId == request.External_GroupId).FirstOrDefault();
                    response.External_Group = extGroup;
                }
            }

            return response;
        }

        /// <summary>
        /// Set (add, update, update status, delete) ExternalGroup value.
        /// </summary>
        /// <param name="request">ExternalGroup request message.</param>
        /// <returns>ExternalGroup response message.</returns>
        public External_GroupResponse SetExternal_Groups(External_GroupRequest request)
        {
            var response = new External_GroupResponse();

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response))
                return response;

            // Transform customer data transfer object to customer business object
            var group = request.External_Group;

            if (request.Action == Resource.Action_Create)
            {
                IExternal_GroupService.Create(group);
                response.External_Group = group;
            }
            else if (request.Action == Resource.Action_UpdateStatus)
            {
                var criteria = request.Criteria;

                IExternal_GroupService.UpdateStatus(group, criteria.Status);
                response.External_Group = group;
            }
            else if (request.Action == Resource.Action_Update)
            {
                IExternal_GroupService.Update(group, group.External_GroupId);
                response.External_Group = group;
            }
            else if (request.Action == Resource.Action_Delete)
            {
                try
                {
                    IExternal_GroupService.Delete(request.External_GroupId);
                    response.RowsAffected = 1;
                }
                catch
                {
                    response.RowsAffected = 0;
                }
            }
            return response;
        }

        #region Get Dashboard OrganisationRole Levels
        public Dashboard_OrganisationRole_LevelsResponse GetDashboard_OrganisationRole_Levels(Dashboard_OrganisationRole_LevelsRequest request)
        {
            var response = new Dashboard_OrganisationRole_LevelsResponse();

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response))
                return response;

            IDashboard_OrganisationRole_LevelsService = new Dashboard_OrganisationRole_LevelsService(null);

            if (request.LoadOptions.Contains(Resource.Get_Option_List))
            {
                var list = IDashboard_OrganisationRole_LevelsService.GetAllQueryable("", "");
                if (request.DashboardId > 0)
                    list = list.Where(l => l.DashboardId == request.DashboardId);

                response.Dashboard_OrganisationRole_Levels = list.ToList();
            }
            else if (request.LoadOptions.Contains(Resource.Get_Option_Single_Internal_User_Permission))
            {
                if (!string.IsNullOrEmpty(request.Url) && request.LevelId > 0 && request.Sort > 0)
                {                    
                    var OrgRoleLevel = IDashboard_OrganisationRole_LevelsService.GetPermissionForInternalUser(request.LevelId, request.Sort, request.Url);
                    response.Dashboard_OrganisationRole_Level = OrgRoleLevel.FirstOrDefault();
                }
            }

            return response;
        }
        #endregion Get Dashboard OrganisationRole Levels

        #region Dashboard External groups
        public DashboardExternal_GroupsResponse GetDashboardExternal_Groups(DashboardExternal_GroupsRequest request)
        {
            var response = new DashboardExternal_GroupsResponse();

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response))
                return response;

            IDashboardExternal_GroupsService = new DashboardExternal_GroupsService(null);

            if (request.LoadOptions.Contains(Resource.Get_Option_List))
            {
                var list = IDashboardExternal_GroupsService.GetAllQueryable("", "");
                if (request.DashboardId > 0)
                    list = list.Where(l => l.DashboardId == request.DashboardId);

                response.DashboardExternal_Groups = list.ToList();
            }
            else if (request.LoadOptions.Contains(Resource.Get_Option_Single_External_User_Permission))
            {               
                var ExtGroup = IDashboardExternal_GroupsService.GetPermissionForExternalUser(request.GroupId, request.Sort, request.Url).FirstOrDefault();
                response.DashboardExternal_Group = ExtGroup;
            }

            return response;
        }

        public DashboardExternal_GroupsResponse SetDashboardExternal_Groups(DashboardExternal_GroupsRequest request)
        {
            var response = new DashboardExternal_GroupsResponse();

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response))
                return response;

            // Transform pedrmission data transfer object to permission business object
            var single = request.DashboardExternal_Group;

            if (request.Action == Resource.Action_Create)
            {
                IDashboardExternal_GroupsService.Create(single);
                response.DashboardExternal_Group = single;
            }
            else if (request.Action == Resource.Action_Delete)
            {
                try
                {
                    IDashboardExternal_GroupsService.Delete(request.DashboardExternal_GroupId);
                    response.RowsAffected = 1;
                }
                catch
                {
                    response.RowsAffected = 0;
                }
            }

            return response;
        }

        #endregion

        #region Get Report Organisation Levels
        public Report_Organisation_LevelsResponse GetReport_Organisation_Levels(Report_Organisation_LevelsRequest request)
        {
            var response = new Report_Organisation_LevelsResponse();

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response))
                return response;

            IReport_Organisation_LevelsService = new Report_Organisation_LevelsService(null);
            IReportService = new ReportService(null);

            if (request.LoadOptions.Contains(Resource.Get_Option_Single))
            {
                if (!string.IsNullOrEmpty(request.Url) && request.LevelId > 0)
                {
                    var reportList = IReportService.GetAllQueryable("", "")
                        .Where(l => (l.Url.ToLower() + ",")
                        .Contains(request.Url.ToLower())).ToList();

                    Organisation_Levels userlevelDetail = IOrganisation_Levels_Service.GetById(request.LevelId);
                    if (userlevelDetail != null)
                    {
                        var currUserLevelSort = userlevelDetail.Sort;
                        var currSystemId = userlevelDetail.SystemId;

                        var userLevelsCanBeInherited = IOrganisation_Levels_Service.GetAllQueryable("", "")
                            .Where(l => l.Sort >= currUserLevelSort
                                && l.SystemId == currSystemId).Select(l => l.LevelId).ToList();

                        var reportOrgLevelList = IReport_Organisation_LevelsService.GetAllQueryable("", "");
                        if (reportOrgLevelList.Any() && reportList.Any())
                        {
                            var lstReportId = reportList.Select(l => l.ReportId);
                            var reportOrgLevel = reportOrgLevelList.Where(
                                l => userLevelsCanBeInherited.Contains(l.LevelId)
                                && lstReportId.Contains(l.ReportId)).FirstOrDefault();

                            response.Report_Organisation_Level = reportOrgLevel;
                        }
                    }
                }
            }

            return response;
        }

        #endregion Get Report Organisation Levels
        public Dashboard_OrganisationRole_LevelsResponse SetDashboard_OrganisationRole_Levels(Dashboard_OrganisationRole_LevelsRequest request)
        {
            var response = new Dashboard_OrganisationRole_LevelsResponse();

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response))
                return response;

            // Transform pedrmission data transfer object to permission business object
            var single = request.Dashboard_OrganisationRole_Level;

            if (request.Action == Resource.Action_Create)
            {
                IDashboard_OrganisationRole_LevelsService.Create(single);
                response.Dashboard_OrganisationRole_Level = single;
            }
            else if (request.Action == Resource.Action_Delete)
            {
                try
                {
                    IDashboard_OrganisationRole_LevelsService.Delete(request.DashboardOrganisationlevelId);
                    response.RowsAffected = 1;
                }
                catch
                {
                    response.RowsAffected = 0;
                }
            }

            return response;
        }

        public Dashboard_FavoursResponse GetDashboard_Favours(Dashboard_FavoursRequest request)
        {
            var response = new Dashboard_FavoursResponse();
            if (!ValidRequest(request, response))
                return response;

            IDashboard_FavourService = new Dashboard_FavourService(null);

            if (request.LoadOptions.Contains(Resource.Get_Option_Single))
            {
                response.Dashboard_Favour = IDashboard_FavourService.GetAllQueryable("", "").Where(r => r.FavourId == request.FavourId).First();
            }
            else if (request.LoadOptions.Contains(Resource.Get_Option_List))
            {
                var favours = IDashboard_FavourService.GetAllQueryable(request.Criteria.SortExpression, request.Criteria.SearchKeyWord);

                response.TotalItemCount = favours != null ? favours.LongCount() : 0;

                var sortExpression = string.IsNullOrEmpty(request.Criteria.SortExpression) ? "FavourId" : request.Criteria.SortExpression;
                var favoursPaged = favours.OrderBy(sortExpression).ToPagedList<Dashboard_Favours>(request.Criteria.PageIndex, request.Criteria.PageSize);

                response.Dashboard_Favours = request.Criteria.PageSize == 0 && request.Criteria.PageIndex == 0 ? favours.ToList() : favoursPaged.ToList();
            }

            return response;
        }

        public Dashboard_FavoursResponse SetDashboard_Favours(Dashboard_FavoursRequest request)
        {
            var response = new Dashboard_FavoursResponse();
            if (!ValidRequest(request, response))
                return response;

            var dashboardFavour = request.Dashboard_Favours;

            if (request.Action == Resource.Action_Create)
            {
                IDashboard_FavourService.Create(dashboardFavour);
                response.Dashboard_Favour = dashboardFavour;
            }
            else if (request.Action == Resource.Action_Update)
            {
                IDashboard_FavourService.Update(dashboardFavour, dashboardFavour.FavourId);
                response.Dashboard_Favour = dashboardFavour;
            }
            else if (request.Action == Resource.Action_Delete)
            {
                try
                {
                    IDashboard_FavourService.Delete(request.FavourId);
                    response.RowsAffected = 1;
                }
                catch
                {
                    response.RowsAffected = 0;
                }
            }

            return response;
        }

        public Dashboard_Graph_DescriptionResponse GetDashboard_Graph_Description(Dashboard_Graph_DescriptionRequest request)
        {
            var response = new Dashboard_Graph_DescriptionResponse();
            if (!ValidRequest(request, response))
                return response;

            IDashboard_Graph_DescriptionService = new Dashboard_Graph_DescriptionService(null);

            if (request.LoadOptions.Contains(Resource.Get_Option_Single))
            {
                response.Dashboard_Graph_Description = IDashboard_Graph_DescriptionService.GetAllQueryable("", "").Where(r => r.DescriptionId == request.DescriptionId).First();
            }
            else if (request.LoadOptions.Contains(Resource.Get_Option_List))
            {
                var descriptions = IDashboard_Graph_DescriptionService.GetList(request.Criteria.SortExpression, request.Criteria.SearchKeyWord);

                if (request.SystemId > 0 && !string.IsNullOrEmpty(request.Type))
                {
                    descriptions = descriptions.Where(d => d.SystemId == request.SystemId && d.Type == request.Type);
                }
                else if (request.SystemId > 0)
                {
                    descriptions = descriptions.Where(d => d.SystemId == request.SystemId);
                }

                response.TotalItemCount = descriptions != null ? descriptions.LongCount() : 0;

                var sortExpression = string.IsNullOrEmpty(request.Criteria.SortExpression) ? "DescriptionId" : request.Criteria.SortExpression;
                var descriptionsPaged = descriptions.OrderBy(sortExpression).ToPagedList<Dashboard_Graph_Description>(request.Criteria.PageIndex, request.Criteria.PageSize);

                response.Dashboard_Graph_Descriptions = request.Criteria.PageSize == 0 && request.Criteria.PageIndex == 0 ? descriptions.ToList() : descriptionsPaged.ToList();
            }

            return response;
        }

        public Dashboard_Graph_DescriptionResponse SetDashboard_Graph_Description(Dashboard_Graph_DescriptionRequest request)
        {
            var response = new Dashboard_Graph_DescriptionResponse();
            if (!ValidRequest(request, response))
                return response;

            var dashboardDescription = request.Dashboard_Graph_Descriptions;

            if (request.Action == Resource.Action_Create)
            {
                IDashboard_Graph_DescriptionService.Create(dashboardDescription);
                response.Dashboard_Graph_Description = dashboardDescription;
            }
            else if (request.Action == Resource.Action_Update)
            {
                IDashboard_Graph_DescriptionService.Update(dashboardDescription, dashboardDescription.DescriptionId);
                response.Dashboard_Graph_Description = dashboardDescription;
            }
            else if (request.Action == Resource.Action_Delete)
            {
                try
                {
                    IDashboard_Graph_DescriptionService.Delete(request.DescriptionId);
                    response.RowsAffected = 1;
                }
                catch
                {
                    response.RowsAffected = 0;
                }
            }
            else if (request.Action == Resource.Action_DeleteAll)
            {
                try
                {
                    IDashboard_Graph_DescriptionService.DeleteAll();
                    response.RowsAffected = 1;
                }
                catch
                {
                    response.RowsAffected = 0;
                }
            }

            return response;
        }

        public Dashboard_ProjectionResponse GetDashboard_Projection(Dashboard_ProjectionRequest request)
        {
            var response = new Dashboard_ProjectionResponse();
            if (!ValidRequest(request, response))
                return response;

            if (request.Criteria.SystemName == "TMF")
            {
                IDashboard_ProjectionService = new Dashboard_TMF_ProjectionService(request.Criteria.SystemName);
            }
            else if (request.Criteria.SystemName == "EML")
            {
                IDashboard_ProjectionService = new Dashboard_EML_ProjectionService(request.Criteria.SystemName);
            }
            else if (request.Criteria.SystemName == "HEM")
            {
                IDashboard_ProjectionService = new Dashboard_HEM_ProjectionService(request.Criteria.SystemName);
            }

            if (request.LoadOptions.Contains(Resource.Get_Option_Single))
            {
                if (!string.IsNullOrEmpty(request.Unit_Name) && !string.IsNullOrEmpty(request.Unit_Type) && !string.IsNullOrEmpty(request.Type) && !string.IsNullOrEmpty(request.Time_Id))
                {
                    try
                    {
                        response.Dashboard_Projection = IDashboard_ProjectionService.GetAllQueryable("", "").Where(r => r.Unit_Type.ToLower() == request.Unit_Type.ToLower()
                                                                                                                        && r.Unit_Name.ToLower() == request.Unit_Name.ToLower()
                                                                                                                        && r.Type.ToLower() == request.Type.ToLower()
                                                                                                                        && r.Time_Id == DateTime.Parse(request.Time_Id)).First();
                    }
                    catch
                    {
                        response.Dashboard_Projection = null;
                    }
                }
                else
                {
                    response.Dashboard_Projection = IDashboard_ProjectionService.GetAllQueryable("", "").Where(r => r.Id == request.Id).First();
                }
            }
            else if (request.LoadOptions.Contains(Resource.Get_Option_List))
            {
                var projections = IDashboard_ProjectionService.GetAllQueryable(request.Criteria.SortExpression, request.Criteria.SearchKeyWord);

                response.TotalItemCount = projections != null ? projections.LongCount() : 0;

                var sortExpression = string.IsNullOrEmpty(request.Criteria.SortExpression) ? "Id" : request.Criteria.SortExpression;
                var projectionPaged = projections.OrderBy(sortExpression).ToPagedList<Dashboard_Projection>(request.Criteria.PageIndex, request.Criteria.PageSize);

                response.Dashboard_Projections = request.Criteria.PageSize == 0 && request.Criteria.PageIndex == 0 ? projections.ToList() : projectionPaged.ToList();
            }

            return response;
        }

        public Dashboard_ProjectionResponse SetDashboard_Projection(Dashboard_ProjectionRequest request)
        {
            var response = new Dashboard_ProjectionResponse();
            if (!ValidRequest(request, response))
                return response;

            if (request.Criteria.SystemName == "TMF")
            {
                IDashboard_ProjectionService = new Dashboard_TMF_ProjectionService(request.Criteria.SystemName);
            }
            else if (request.Criteria.SystemName == "EML")
            {
                IDashboard_ProjectionService = new Dashboard_EML_ProjectionService(request.Criteria.SystemName);
            }
            else if (request.Criteria.SystemName == "HEM")
            {
                IDashboard_ProjectionService = new Dashboard_HEM_ProjectionService(request.Criteria.SystemName);
            }

            var projection = request.Dashboard_Projection;

            if (request.Action == Resource.Action_Create)
            {
                IDashboard_ProjectionService.Create(projection);
                response.Dashboard_Projection = projection;
            }
            else if (request.Action == Resource.Action_Update)
            {
                IDashboard_ProjectionService.Update(projection, projection.Id);
                response.Dashboard_Projection = projection;
            }
            else if (request.Action == Resource.Action_Delete)
            {
                try
                {
                    IDashboard_ProjectionService.Delete(request.Id);
                    response.RowsAffected = 1;
                }
                catch
                {
                    response.RowsAffected = 0;
                }
            }
            else if (request.Action == Resource.Action_DeleteAll)
            {
                try
                {
                    IDashboard_ProjectionService.DeleteAll();
                    response.RowsAffected = 1;
                }
                catch
                {
                    response.RowsAffected = 0;
                }
            }

            return response;
        }

        /// <summary>
        /// Get Dashboard Target Base
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>

        public Dashboard_Target_BaseResponse GetDashboard_Target_Base(Dashboard_Target_BaseRequest request)
        {
            var response = new Dashboard_Target_BaseResponse();
            if (!ValidRequest(request, response))
                return response;

            if (request.Criteria.SystemName == "TMF")
            {
                IDashboard_Target_BaseService = new Dashboard_TMF_Target_BaseService(request.Criteria.SystemName);
            }
            else if (request.Criteria.SystemName == "EML")
            {
                IDashboard_Target_BaseService = new Dashboard_EML_Target_BaseService(request.Criteria.SystemName);
            }
            else if (request.Criteria.SystemName == "HEM")
            {
                IDashboard_Target_BaseService = new Dashboard_HEM_Target_BaseService(request.Criteria.SystemName);
            }

            if (request.LoadOptions.Contains(Resource.Get_Option_Single))
            {
                response.Dashboard_Target_Base = IDashboard_Target_BaseService.GetAllQueryable("", "").Where(r => r.Id == request.Id).First();
            }
            else if (request.LoadOptions.Contains(Resource.Get_Option_List))
            {
                var target_bases = IDashboard_Target_BaseService.GetAllQueryable(request.Criteria.SortExpression, request.Criteria.SearchKeyWord);

                response.TotalItemCount = target_bases != null ? target_bases.LongCount() : 0;

                var sortExpression = string.IsNullOrEmpty(request.Criteria.SortExpression) ? "Id" : request.Criteria.SortExpression;
                var target_basePaged = target_bases.OrderBy(sortExpression).ToPagedList<Dashboard_Target_Base>(request.Criteria.PageIndex, request.Criteria.PageSize);

                response.Dashboard_Target_Bases = request.Criteria.PageSize == 0 && request.Criteria.PageIndex == 0 ? target_bases.ToList() : target_basePaged.ToList();
            }

            return response;
        }

        public Dashboard_Target_BaseResponse SetDashboard_Target_Base(Dashboard_Target_BaseRequest request)
        {
            var response = new Dashboard_Target_BaseResponse();
            if (!ValidRequest(request, response))
                return response;

            if (request.Criteria.SystemName == "TMF")
            {
                IDashboard_Target_BaseService = new Dashboard_TMF_Target_BaseService(request.Criteria.SystemName);
            }
            else if (request.Criteria.SystemName == "EML")
            {
                IDashboard_Target_BaseService = new Dashboard_EML_Target_BaseService(request.Criteria.SystemName);
            }
            else if (request.Criteria.SystemName == "HEM")
            {
                IDashboard_Target_BaseService = new Dashboard_HEM_Target_BaseService(request.Criteria.SystemName);
            }

            var target_base = request.Dashboard_Target_Base;

            if (request.Action == Resource.Action_Create)
            {
                IDashboard_Target_BaseService.Create(target_base);
                response.Dashboard_Target_Base = target_base;
            }
            else if (request.Action == Resource.Action_Update)
            {
                IDashboard_Target_BaseService.Update(target_base, target_base.Id);
                response.Dashboard_Target_Base = target_base;
            }
            else if (request.Action == Resource.Action_Delete)
            {
                try
                {
                    IDashboard_Target_BaseService.Delete(request.Id);
                    response.RowsAffected = 1;
                }
                catch
                {
                    response.RowsAffected = 0;
                }
            }
            else if (request.Action == Resource.Action_DeleteAll)
            {
                try
                {
                    IDashboard_Target_BaseService.DeleteAll();
                    response.RowsAffected = 1;
                }
                catch
                {
                    response.RowsAffected = 0;
                }
            }

            return response;
        }

        /// <summary>
        /// Get Time Access Dashboard Data
        /// </summary>
        public Dashboard_TimeAccessResponse GetDashboard_TimeAccess(Dashboard_TimeAccessRequest request)
        {
            var response = new Dashboard_TimeAccessResponse();
            if (!ValidRequest(request, response))
                return response;

            IDashboard_TimeAccessService = new Dashboard_TimeAccessService(null);

            if (request.LoadOptions.Contains(Resource.Get_Option_Single))
            {
                response.Dashboard_TimeAccess = IDashboard_TimeAccessService.GetAllQueryable("", "").Where(r => r.Id == request.Id).First();
            }
            else if (request.LoadOptions.Contains(Resource.Get_Option_List))
            {
                var DashboardTimeAccess = IDashboard_TimeAccessService.GetAllQueryable(request.Criteria.SortExpression, request.Criteria.SearchKeyWord);

                response.TotalItemCount = DashboardTimeAccess != null ? DashboardTimeAccess.LongCount() : 0;

                var sortExpression = string.IsNullOrEmpty(request.Criteria.SortExpression) ? "Id" : request.Criteria.SortExpression;
                var DashboardTimeAccessPaged = DashboardTimeAccess.OrderBy(sortExpression).ToPagedList<Dashboard_TimeAccess>(request.Criteria.PageIndex, request.Criteria.PageSize);

                response.Dashboard_TimeAccesss = request.Criteria.PageSize == 0 && request.Criteria.PageIndex == 0 ? DashboardTimeAccess.ToList() : DashboardTimeAccessPaged.ToList();
            }

            return response;
        }

        public Dashboard_TimeAccessResponse SetDashboard_TimeAccess(Dashboard_TimeAccessRequest request)
        {
            var response = new Dashboard_TimeAccessResponse();
            if (!ValidRequest(request, response))
                return response;

            var DashboardTimeAccess = request.Dashboard_TimeAccess;

            if (request.Action == Resource.Action_Create)
            {
                IDashboard_TimeAccessService.Create(DashboardTimeAccess);
                response.Dashboard_TimeAccess = DashboardTimeAccess;
            }
            else if (request.Action == Resource.Action_Update)
            {
                IDashboard_TimeAccessService.Update(DashboardTimeAccess, DashboardTimeAccess.Id);
                response.Dashboard_TimeAccess = DashboardTimeAccess;
            }
            else if (request.Action == Resource.Action_Delete)
            {
                try
                {
                    IDashboard_TimeAccessService.Delete(request.Id);
                    response.RowsAffected = 1;
                }
                catch
                {
                    response.RowsAffected = 0;
                }
            }

            return response;
        }

        public PortfolioResponse GetPortfolio(PortfolioRequest request)
        {
            var response = new PortfolioResponse();
            if (!ValidRequest(request, response))
                return response;

            if (request.LoadOptions.Contains(Resource.Get_Portfolio_Param_Values))
            {
                switch (request.SystemName)
                {
                    case "HEM":
                        switch (request.ValueType)
                        {
                            case SystemValueType.Group:
                                response.Values = (IList<string>)IHEMPortfolioService.GetSystemGroups();
                                break;

                            case SystemValueType.Portfolio:
                                response.Values = (IList<string>)IHEMPortfolioService.GetSystemPortfolios();
                                break;

                            case SystemValueType.AccountManager:
                                response.Values = (IList<string>)IHEMPortfolioService.GetSystemAccountManagers();
                                break;
                        }
                        break;

                    case "EML":
                        switch (request.ValueType)
                        {
                            case SystemValueType.Group:
                                response.Values = (IList<string>)IEMLPortfolioService.GetSystemGroups();
                                break;

                            case SystemValueType.EmployerSize:
                                response.Values = (IList<string>)IEMLPortfolioService.GetSystemEMPL_Sizes();
                                break;

                            case SystemValueType.AccountManager:
                                response.Values = (IList<string>)IEMLPortfolioService.GetSystemAccountManagers();
                                break;
                        }
                        break;

                    case "TMF":
                        switch (request.ValueType)
                        {
                            case SystemValueType.Group:
                                response.Values = (IList<string>)ITMFPortfolioService.GetSystemGroups();
                                break;

                            case SystemValueType.Agency:
                                response.Values = (IList<string>)ITMFPortfolioService.GetSystemAgencies();
                                break;
                        }
                        break;
                }
            }
            else if (request.LoadOptions.Contains(Resource.Get_Portfolio_Param_SubValues))
            {
                switch (request.SystemName)
                {
                    case "HEM":
                        switch (request.ValueType)
                        {
                            case SystemValueType.Group:
                                response.SubValues = (IList<string>)IHEMPortfolioService.GetTeams(request.Value);
                                break;

                            case SystemValueType.AccountManager:
                                response.SubValues = (IList<string>)IHEMPortfolioService.GetEMPL_SizesByAccountManager(request.Value);
                                break;

                            case SystemValueType.Portfolio:
                                response.SubValues = (IList<string>)IHEMPortfolioService.GetEMPL_SizesByPortfolio(request.Value);
                                break;
                        }
                        break;

                    case "EML":
                        switch (request.ValueType)
                        {
                            case SystemValueType.Group:
                                response.SubValues = (IList<string>)IEMLPortfolioService.GetTeams(request.Value);
                                break;

                            case SystemValueType.AccountManager:
                                response.SubValues = (IList<string>)IEMLPortfolioService.GetEMPL_SizesByAccountManager(request.Value);
                                break;
                        }
                        break;

                    case "TMF":
                        switch (request.ValueType)
                        {
                            case SystemValueType.Group:
                                response.SubValues = (IList<string>)ITMFPortfolioService.GetTeams(request.Value);
                                break;

                            case SystemValueType.Agency:
                                response.SubValues = (IList<string>)ITMFPortfolioService.GetSubCategories(request.Value);
                                break;
                        }
                        break;
                }
            }
            else if (request.LoadOptions.Contains(Resource.Get_Portfolio_Param_ClaimOfficers))
            {
                response.ClaimOfficers = (IList<string>)ITMFPortfolioService.GetClaimOfficers(request.Team);
            }
            else if (request.LoadOptions.Contains(Resource.Get_Portfolio_Param_ClaimLiabilityIndicators))
            {
                switch (request.SystemName)
                {
                    case "HEM":
                        response.ClaimLiabilityIndicators = (IList<Dashboard_Claim_Liability_Indicator>)IHEMPortfolioService.GetCliamLiabilityIndicators("HEM");
                        break;

                    case "EML":
                        response.ClaimLiabilityIndicators = (IList<Dashboard_Claim_Liability_Indicator>)IEMLPortfolioService.GetCliamLiabilityIndicators("EML");
                        break;

                    case "TMF":
                        response.ClaimLiabilityIndicators = (IList<Dashboard_Claim_Liability_Indicator>)ITMFPortfolioService.GetCliamLiabilityIndicators("TMF");
                        break;

                    case "WOW":
                        response.ClaimLiabilityIndicators = (IList<Dashboard_Claim_Liability_Indicator>)IWOWPortfolioService.GetCliamLiabilityIndicators("WOW");
                        break;
                }
            }
            else if (request.LoadOptions.Contains(Resource.GetMaxRptDate))
            {
                switch (request.SystemName)
                {
                    case "HEM":
                        response.Max_Rpt_Date = (string)IHEMPortfolioService.GetMaxRptDate();
                        break;

                    case "EML":
                        response.Max_Rpt_Date = (string)IEMLPortfolioService.GetMaxRptDate();
                        break;

                    case "TMF":
                        response.Max_Rpt_Date = (string)ITMFPortfolioService.GetMaxRptDate();
                        break;

                    case "WOW":
                        response.Max_Rpt_Date = (string)IWOWPortfolioService.GetMaxRptDate();
                        break;
                }
            }

            return response;
        }

        public Dashboard_ProjectionResponse SignalProjectionImport(Dashboard_ProjectionRequest request)
        {
            var response = new Dashboard_ProjectionResponse();
            if (!ValidRequest(request, response))
                return response;

            var projectionTableName = "";
            var projectionData = ProjectionDataHelper.Process(request.ProjectionDataPath);
            switch (request.Criteria.SystemName)
            {
                case "HEM":
                    IProjectionService = new HEMProjectionService("HEM");
                    projectionTableName = "HEM_AWC_Projections";
                    break;

                case "EML":
                    IProjectionService = new EMLProjectionService("EML");
                    projectionTableName = "EML_AWC_Projections";
                    break;

                case "TMF":
                    IProjectionService = new TMFProjectionService("TMF");
                    projectionTableName = "TMF_AWC_Projections";
                    break;
            }

            if (!string.IsNullOrEmpty(projectionTableName))
                IProjectionService.ImportData(projectionData, projectionTableName);

            return response;
        }

        public CONTROLResponse GetCONTROL(CONTROLRequest request)
        {
            var response = new CONTROLResponse();
            if (!ValidRequest(request, response))
                return response;
            try
            {
                if (request.LoadOptions.Contains(Resource.Get_Option_Single))
                {
                    response.Control = ICONTROL.GetAllQueryable("", "").Where(r => r.Type.ToLower() == request.Type.ToLower()).FirstOrDefault();
                }
                else if (request.LoadOptions.Contains(Resource.Get_Option_List))
                {
                    response.Controls = ICONTROL.GetAllQueryable("", "").ToList();
                }
            }
            catch (Exception)
            {
                return response = new CONTROLResponse();
            }

            return response;
        }

        public void EncryptConnectionStrings()
        {
            Common.Utilities.Commons.EncryptConnectionStrings();
        }

        private bool ValidRequest(RequestBase request, ResponseBase response)
        {
            if (!request.AccessToken.Equals(_accessToken))
            {
                response.Acknowledge = AcknowledgeType.Failure;
                response.Message = "Invalid or expired AccessToken";
                return false;
            }

            return true;
        }

    }

    public class InitHostFactory : ServiceHostFactoryBase
    {
        public override ServiceHostBase CreateServiceHost(string service, Uri[] baseAddresses)
        {
            ActionService.IAccountService = new AccountService(null);
            ActionService.IUserService = new UserService(null);
            ActionService.IOrganisation_RolesService = new Organisation_RolesService(null);
            ActionService.IOrganisation_Levels_Service = new Organisation_Levels_Service(null);
            ActionService.IReportCategoriesService = new ReportCategoriesService(null);
            ActionService.ITeamService = new TeamService(null);
            ActionService.ISystem_RolesService = new System_RolesService(null);
            ActionService.ISystem_PermissionService = new SystemPermissionService(null);
            ActionService.IExternal_GroupService = new External_GroupService(null);
            ActionService.IStatusService = new StatusService(null);
            ActionService.IPermissionService = new PermissionService(null);
            ActionService.ISystemRolePermissionService = new System_Role_PermissionsService(null);
            ActionService.IReportService = new ReportService(null);
            ActionService.IDashboardService = new DashboardService(null);
            ActionService.IDashboard_OrganisationRole_LevelsService = new Dashboard_OrganisationRole_LevelsService(null);
            ActionService.IDashboard_LevelsService = new DashboardLevelService(null);
            ActionService.IDashboard_Traffic_Light_RulesService = new Dashboard_Traffic_Light_RulesService(null);
            ActionService.IDashboard_FavourService = new Dashboard_FavourService(null);
            ActionService.IDashboard_Graph_DescriptionService = new Dashboard_Graph_DescriptionService(null);
            ActionService.IDashboard_ProjectionService = new Dashboard_TMF_ProjectionService("TMF");
            ActionService.IDashboard_ProjectionService = new Dashboard_EML_ProjectionService("EML");
            ActionService.IDashboard_ProjectionService = new Dashboard_HEM_ProjectionService("HEM");
            ActionService.IDashboard_TimeAccessService = new Dashboard_TimeAccessService(null);
            ActionService.IDashboard_Target_BaseService = new Dashboard_TMF_Target_BaseService("TMF");
            ActionService.IDashboard_Target_BaseService = new Dashboard_EML_Target_BaseService("EML");
            ActionService.IDashboard_Target_BaseService = new Dashboard_HEM_Target_BaseService("HEM");
            ActionService.ITMFPortfolioService = new TMFPortfolioService(null);
            ActionService.IHEMPortfolioService = new HEMPortfolioService(null);
            ActionService.IEMLPortfolioService = new EMLPortfolioService(null);
            ActionService.IWOWPortfolioService = new WOWPortfolioService(null);
            ActionService.ICONTROL = new CONTROLService(null);

            // The service parameter is ignored here because we know our service.
            ServiceHost serviceHost = new ServiceHost(typeof(ActionService),
                baseAddresses);
            return serviceHost;
        }
    }
}