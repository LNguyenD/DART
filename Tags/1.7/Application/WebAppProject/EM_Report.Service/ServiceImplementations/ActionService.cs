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
    using System.Linq;
    using System.ServiceModel;
    using System.ServiceModel.Activation;

    /// <summary>
    /// Main facade into Patterns in Action application.
    /// Important: Each Session has its own instance of this class (see ServiceBehavior Attribute).
    /// </summary>
    /// <remarks>
    /// Application Facade Pattern.
    /// </remarks>
    [ServiceBehavior(InstanceContextMode = InstanceContextMode.PerSession)]
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

        #endregion Create default static services

        #region private

        // Session state variables
        private string _accessToken;

        //private string _email;
        private string _username;

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

        private void AssignConfigPermissionWhenLoginSuccess(LoginResponse response, string AccessToken, string RequestId)
        {
            if (response.User.Is_System_User)
            {
                SystemRole_PermissionsRequest systemrole_permissionRequest = new SystemRole_PermissionsRequest();
                systemrole_permissionRequest.AccessToken = AccessToken;
                systemrole_permissionRequest.RequestId = RequestId;
                systemrole_permissionRequest.LoadOptions = new string[] { Resource.Get_SystemRolePermission_By_SystemRoleId };
                systemrole_permissionRequest.System_RoleId = response.User.System_RoleId ?? 0;
                response.System_Role_Permissions = GetSystemRolePermissions(systemrole_permissionRequest).SystemRolePermissions;
            }
        }

        #endregion private

        /// <summary>
        /// Gets unique session based token that is valid for the duration of the session.
        /// </summary>
        /// <param name="request">Token request message.</param>
        /// <returns>Token response message.</returns>
        public TokenResponse GetToken(TokenRequest request)
        {
            var response = new TokenResponse(request.RequestId);

            // Validate client tag only
            if (!ValidRequest(request, response, Validate.ClientTag))
                return response;

            // Note: these are session based and expire when session expires.
            _accessToken = Guid.NewGuid().ToString();
            //_shoppingCart = new ShoppingCart(_defaultShippingMethod);

            response.AccessToken = _accessToken;
            return response;
        }

        /// <summary>
        /// Login to application service.
        /// </summary>
        /// <param name="request">Login request message.</param>
        /// <returns>Login response message.</returns>
        public LoginResponse Login(LoginRequest request)
        {
            //_email = request.Email;
            _username = request.UserName;
            var response = new LoginResponse(request.RequestId);

            // Validate client tag and access token
            if (!ValidRequest(request, response, Validate.ClientTag | Validate.AccessToken))
                return response;

            var intLogin = IAccountService.Login(_username, request.Password, int.Parse(ConfigurationSettings.AppSettings["No_Limit_Login_Attempts"]), int.Parse(ConfigurationSettings.AppSettings["No_Days_Blocked_Attempts"]), request.SystemId, request.LoginType);
            if (intLogin <= 0)
            {
                response.Acknowledge = AcknowledgeType.Failure;
                if (intLogin == -1)
                {
                    response.Message = Resource.msgInvalidUserNameOrPassLogin;
                }
                else if (intLogin == -2)
                {
                    response.Message = Resource.msgBlockedLogin;
                }
            }
            else
            {
                // get user
                var user = IUserService.GetUserById(intLogin, request.SystemId);

                // get dashboard favorite
                var dashboardFavorite = IDashboard_FavourService.GetAllQueryable("", "")
                    .FirstOrDefault(f => f.UserId == user.UserId && f.Is_Landing_Page == true);
                if (dashboardFavorite != null)
                    user.LandingPage_Url = dashboardFavorite.Url;

                response.User = user;
                var system = IUserService.GetListSystem().Where(q => q.SystemId == response.User.Default_System_Id).SingleOrDefault();
                response.defaultSystemName = system.Name;
                AssignConfigPermissionWhenLoginSuccess(response, request.AccessToken, request.RequestId);
            }

            response.returnValue = intLogin;
            return response;
        }

        /// <summary>
        /// Logout from application service.
        /// </summary>
        /// <param name="request">Logout request message.</param>
        /// <returns>Login request message.</returns>
        public LogoutResponse Logout(LogoutRequest request)
        {
            var response = new LogoutResponse(request.RequestId);

            // Validate client tag and access token
            if (!ValidRequest(request, response, Validate.ClientTag | Validate.AccessToken))
                return response;

            //_email = null;
            _username = null;

            return response;
        }

        /// <summary>
        /// Login to application service.
        /// </summary>
        /// <param name="request">Login request message.</param>
        /// <returns>Login response message.</returns>
        public LoginResponse AutoLogin(LoginRequest request)
        {
            //_email = request.Email;
            _username = request.UserName;
            var response = new LoginResponse(request.RequestId);

            // Validate client tag and access token
            if (!ValidRequest(request, response, Validate.ClientTag | Validate.AccessToken))
                return response;

            var intLogin = IAccountService.AutoLogin(request.UserId, _username, request.Password, int.Parse(ConfigurationSettings.AppSettings["No_Limit_Login_Attempts"]), int.Parse(ConfigurationSettings.AppSettings["No_Days_Blocked_Attempts"]), request.SystemId, request.LoginType);
            if (intLogin <= 0)
            {
                response.Acknowledge = AcknowledgeType.Failure;
                if (intLogin == -1)
                {
                    response.Message = string.Format(Resource.msgInvalidUserNameOrPassLogin, ConfigurationSettings.AppSettings["No_Limit_Login_Attempts"]);
                }
                else if (intLogin == -2)
                {
                    response.Message = string.Format(Resource.msgBlockedLogin, ConfigurationSettings.AppSettings["No_Days_Blocked_Attempts"]);
                }
            }
            else
            {
                // get user
                var user = IUserService.GetUserById(intLogin, request.SystemId);

                // get dashboard favorite
                var dashboardFavorite = IDashboard_FavourService.GetAllQueryable("", "")
                    .FirstOrDefault(f => f.UserId == user.UserId && f.Is_Landing_Page == true);
                if (dashboardFavorite != null)
                    user.LandingPage_Url = dashboardFavorite.Url;

                response.User = user;
                var system = IUserService.GetListSystem().Where(q => q.SystemId == response.User.Default_System_Id).SingleOrDefault();
                response.defaultSystemName = system.Name;

                AssignConfigPermissionWhenLoginSuccess(response, request.AccessToken, request.RequestId);
            }

            response.returnValue = intLogin;
            return response;
        }

        /// <summary>
        /// Change password for user.
        /// </summary>
        /// <param name="request">ChangePassword request message.</param>
        /// <returns>ChangePassword response message.</returns>
        public ChangePasswordResponse ChangePassword(ChangePasswordRequest request)
        {
            var response = new ChangePasswordResponse(request.RequestId);

            // Validate client tag and access token
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new ResetPasswordResponse(request.RequestId);

            // Validate client tag and access token
            if (!ValidRequest(request, response, Validate.ClientTag | Validate.AccessToken))
                return response;

            var user = IUserService.GetAllQueryable("", "").Where(l => l.Email == request.UserName_Email || l.UserName == request.UserName_Email).SingleOrDefault();
            if (user != null)
            {
                //_email = user.Email;
                _username = user.Email;
                response.returnValue = IAccountService.ResetPassword(request.UserName_Email, EM_Report.Common.Utilities.EnCryption.Encrypt(request.Password));
                if (response.returnValue > 0)
                {
                    string mailbody = ConfigurationSettings.AppSettings["MailResetPasswordBody"];
                    mailbody = mailbody.Replace("[FullName]", user.FirstName + " " + user.LastName);
                    mailbody = mailbody.Replace("[NewPassWord]", request.Password);
                    mailbody = mailbody.Replace("[UserName]", user.Email);
                    SendMail(user.Email, ConfigurationSettings.AppSettings["MailResetPasswordSubject"], mailbody);
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
            var response = new UserResponse(request.RequestId);

            // Validate client tag and access token
            if (!ValidRequest(request, response, Validate.All))
                return response;

            IUserService = new UserService(null);
            if (request.LoadOptions.Contains(Resource.Get_Option_List))
            {
                var users = !string.IsNullOrEmpty(request.UserType)
                            ? (request.UserType.ToLower().IndexOf("system") >= 0
                            ? IUserService.GetAllQueryable(request.Criteria.SortExpression, request.Criteria.SearchKeyWord).Where(l => l.Is_System_User == true)
                            : request.UserType.ToLower().IndexOf("external") >= 0
                            ? IUserService.GetAllQueryable(request.Criteria.SortExpression, request.Criteria.SearchKeyWord).Where(l => l.Is_External_User == true)
                            : IUserService.GetListUserBySystemId(request.Criteria.SortExpression, request.Criteria.SearchKeyWord, request.Criteria.SystemId))
                            : IUserService.GetAllQueryable(request.Criteria.SortExpression, request.Criteria.SearchKeyWord);

                response.TotalItemCount = users != null ? users.LongCount() : 0;

                var usersPaged = users.ToPagedList<User>(request.Criteria.PageIndex, request.Criteria.PageSize);

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
                    var external_users = IUserService.GetAllQueryable("", "").Where(l => ((l.UserName.ToLower() == request.User.UserName.ToLower() || l.Email.ToLower() == request.User.Email.ToLower()) && l.UserId != request.User.UserId && l.Is_External_User));
                    if (external_users.Any())
                    {
                        response.Users = external_users.ToList();
                    }
                    else
                    {
                        var system_users = IUserService.GetAllQueryable("", "").Where(l => ((l.UserName.ToLower() == request.User.UserName.ToLower() || l.Email.ToLower() == request.User.Email.ToLower()) && l.UserId != request.User.UserId && l.Is_System_User));
                        if (system_users.Any())
                        {
                            response.Users = system_users.ToList();
                        }
                        else
                        {
                            if (request.User.SystemId > 0)
                            {
                                var internal_users = IUserService.GetAllQueryable("", "").Where(l => ((l.UserName.ToLower() == request.User.UserName.ToLower() || l.Email.ToLower() == request.User.Email.ToLower()) && l.UserId != request.User.UserId && !l.Is_System_User && !l.Is_External_User));
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
                        || l.Email.ToLower() == request.User.Email.ToLower())).SingleOrDefault();
                    if (singleUser != null)
                        response.Users.Add(singleUser);
                }
            }
            else if (request.LoadOptions.Contains(Resource.Get_List_System))
            {
                response.Systems = IUserService.GetListSystem().ToList();
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
            var response = new UserResponse(request.RequestId);

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response, Validate.All))
                return response;

            // Transform customer data transfer object to customer business object
            var user = request.User;

            // Run within the context of a database transaction. Currently commented out.
            // The Decorator Design Pattern.
            if (request.Action == Resource.Action_Create)
            {
                var PasswordWithoutCrypt = user.Password;
                user.Password = EnCryption.Encrypt(user.Password);
                IUserService.CreateUser(user);
                response.User = user;
                if (user != null)
                {
                    user.Password = PasswordWithoutCrypt;
                    SendMailToNewUser(user);
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
                    user.Password = EnCryption.Encrypt(user.Password);
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
            var response = new ReportCategoryResponse(request.RequestId);

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response, Validate.All))
                return response;

            IReportCategoriesService = new ReportCategoriesService(null);

            if (request.LoadOptions.Contains(Resource.Get_Option_List))
            {
                var categories = IReportCategoriesService.GetAllQueryable(request.Criteria.SortExpression, request.Criteria.SearchKeyWord);
                response.TotalItemCount = categories != null ? categories.LongCount() : 0;

                var categoryPaged = categories.ToPagedList<Report_Categories>(request.Criteria.PageIndex, request.Criteria.PageSize);

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
            var response = new ReportCategoryResponse(request.RequestId);

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new ReportPermissionResponse(request.RequestId);

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new ReportPermissionResponse(request.RequestId);
            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new StatusResponse(request.RequestId);
            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new StatusResponse(request.RequestId);
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new PermissionResponse(request.RequestId);
            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new PermissionResponse(request.RequestId);

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new ReportResponse(request.RequestId);

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response, Validate.All))
                return response;

            IReportService = new ReportService(null);
            if (request.LoadOptions.Contains(Resource.Get_Option_List))
            {
                var reports = IReportService.GetAllReports(request.Criteria.SystemId,
                    request.Criteria.SortExpression, request.Criteria.SearchKeyWord);

                response.TotalItemCount = reports != null ? reports.LongCount() : 0;

                var reportsPage = reports.ToPagedList<Report>(request.Criteria.PageIndex, request.Criteria.PageSize);

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

                var reportsPage = reports.ToPagedList<Report>(request.Criteria.PageIndex, request.Criteria.PageSize);

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

                var reportsPage = reports.ToPagedList(request.Criteria.PageIndex, request.Criteria.PageSize);
                response.Reports = request.Criteria.PageIndex == 0 ? reports.ToList() : reportsPage.ToList();
            }
            return response;
        }

        public ReportResponse SetReports(ReportRequest request)
        {
            var response = new ReportResponse(request.RequestId);

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new Dashboard_LevelsResponse(request.RequestId);
            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new Dashboard_LevelsResponse(request.RequestId);
            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new DashboardResponse(request.RequestId);
            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response, Validate.All))
                return response;

            if (request.LoadOptions.Contains(Resource.Get_Option_List_Traffic_Light))
            {
                IDashboard_Traffic_Light_RulesService = new Dashboard_Traffic_Light_RulesService(null);
                var trafficLightRules = IDashboard_Traffic_Light_RulesService.GetAllQueryable("", "").Where(l => l.SystemId == request.SystemsId);

                // Temporay ToList
                var lst = (from l in trafficLightRules
                           group l by new { l.DashboardType, l.Name, l.Description, l.ImageUrl, l.FromValue, l.ToValue } into g
                           select new Dashboard_Traffic_Light_Rule
                           {
                               DashboardType = g.Key.DashboardType,
                               Name = g.Key.Name,
                               Description = g.Key.Description,
                               ImageUrl = g.Key.ImageUrl,
                               FromValue = g.Key.FromValue,
                               ToValue = g.Key.ToValue
                           }).Cast<Dashboard_Traffic_Light_Rule>();

                var lstRTW = lst.Where(l => l.DashboardType.ToLower() == "rtw").ToList().OrderBy(l => l.ToValue);

                var lstAWC = lst.Where(l => l.DashboardType.ToLower() == "awc").ToList().OrderBy(l => l.ToValue);

                response.Dashboard_Traffic_Light_Rules = lstRTW.Union(lstAWC).ToList();
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

                    var reportsPage = dashboards.ToPagedList(request.Criteria.PageIndex, request.Criteria.PageSize);

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
            var response = new DashboardResponse(request.RequestId);
            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new SystemRole_PermissionsResponse(request.RequestId);
            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new SystemRole_PermissionsResponse(request.RequestId);

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new Organisation_RolesResponse(request.RequestId);
            if (!ValidRequest(request, response, Validate.All))
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

                var rolesPage = roles.ToPagedList(request.Criteria.PageIndex, request.Criteria.PageSize);
                response.Roles = request.Criteria.PageIndex == 0 ? roles.ToList() : rolesPage.ToList();
            }
            else if (request.LoadOptions.Contains(Resource.Get_Option_List_RolesOfLevel))
            {
                var roles = IOrganisation_RolesService.GetRoleOfLevel(request.LevelId);
                response.TotalItemCount = roles != null ? roles.LongCount() : 0;

                var rolesPage = roles.ToPagedList(request.Criteria.PageIndex, request.Criteria.PageSize);
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
            var response = new Organisation_RolesResponse(request.RequestId);
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new Organisation_LevelsResponse(request.RequestId);
            if (!ValidRequest(request, response, Validate.All))
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

                var levelsPage = levels.ToPagedList(request.Criteria.PageIndex, request.Criteria.PageSize);
                response.Levels = request.Criteria.PageIndex == 0 ? levels.ToList() : levelsPage.ToList();
            }

            return response;
        }

        public Organisation_LevelsResponse SetOrganisationLevels(Organisation_LevelsRequest request)
        {
            var response = new Organisation_LevelsResponse(request.RequestId);
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new System_RolesResponse(request.RequestId);
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new System_RolesResponse(request.RequestId);
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new System_PermissionResponse(request.RequestId);
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new System_PermissionResponse(request.RequestId);
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new Dashboard_Traffic_Light_RulesResponse(request.RequestId);
            var filteredResponse = new Dashboard_Traffic_Light_RulesResponse(request.RequestId);

            if (!ValidRequest(request, response, Validate.All))
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

                var dashboardTrafficLightRulePaged = dashboardTrafficLightRule.ToPagedList<Dashboard_Traffic_Light_Rule>(request.Criteria.PageIndex, request.Criteria.PageSize);

                response.Dashboard_Traffic_Light_Rules = request.Criteria.PageSize == 0 && request.Criteria.PageIndex == 0 ? dashboardTrafficLightRule.ToList() : dashboardTrafficLightRulePaged.ToList();
            }

            if (request.filteredFlag) return filteredResponse;
            else return response;
        }

        public Dashboard_Traffic_Light_RulesResponse SetDashboard_Traffic_Light_Rules(Dashboard_Traffic_Light_RulesRequest request)
        {
            var response = new Dashboard_Traffic_Light_RulesResponse(request.RequestId);
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new TeamResponse(request.RequestId);

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response, Validate.All))
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

                    var teamsPaged = teams.ToPagedList<Team>(request.Criteria.PageIndex, request.Criteria.PageSize);

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
            var response = new TeamResponse(request.RequestId);

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new External_GroupResponse(request.RequestId);

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response, Validate.All))
                return response;

            IExternal_GroupService = new External_GroupService(null);
            if (request.LoadOptions.Contains(Resource.Get_Option_List))
            {
                var groups = IExternal_GroupService.GetGroups(request.GroupStatusFilter, request.Criteria.SortExpression, request.Criteria.SearchKeyWord);

                response.TotalItemCount = groups != null ? groups.LongCount() : 0;

                var groupsPaged = groups.ToPagedList<External_Group>(request.Criteria.PageIndex, request.Criteria.PageSize);

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
            var response = new External_GroupResponse(request.RequestId);

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response, Validate.All))
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

        public Dashboard_OrganisationRole_LevelsResponse GetDashboard_OrganisationRole_Levels(
            Dashboard_OrganisationRole_LevelsRequest request)
        {
            var response = new Dashboard_OrganisationRole_LevelsResponse(request.RequestId);

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response, Validate.All))
                return response;

            // update permissions to response base on request
            UpdateDashboard_OrganisationRole_LevelsResponse(request, response);

            return response;
        }

        private void UpdateDashboard_OrganisationRole_LevelsResponse(
            Dashboard_OrganisationRole_LevelsRequest request,
            Dashboard_OrganisationRole_LevelsResponse response)
        {
            IDashboard_OrganisationRole_LevelsService = new Dashboard_OrganisationRole_LevelsService(null);
            IDashboardService = new DashboardService(null);
            IDashboard_LevelsService = new DashboardLevelService(null);
            IOrganisation_Levels_Service = new Organisation_Levels_Service(null);

            if (request.LoadOptions.Contains(Resource.Get_Option_List))
            {
                var list = IDashboard_OrganisationRole_LevelsService.GetAllQueryable("", "");
                if (request.DashboardId > 0)
                    list = list.Where(l => l.DashboardId == request.DashboardId);

                response.Dashboard_OrganisationRole_Levels = list.ToList();
            }
            else if (request.LoadOptions.Contains(Resource.Get_Option_Single))
            {
                if (!string.IsNullOrEmpty(request.Url) && request.LevelId > 0 && request.DashboardLevelId > 0)
                {
                    var dashboardList = IDashboardService.GetAllQueryable("", "")
                        .Where(l => (l.Url.ToLower() + ",")
                        .Contains(request.Url.ToLower())).ToList();

                    // get dashboard level detail
                    var dashboardLevelDetail = IDashboard_LevelsService.GetAllQueryable("", "")
                        .Where(l => l.Sort == request.DashboardLevelId).FirstOrDefault();

                    Organisation_Levels userlevelDetail = null;
                    if (request.LevelIdList != null && request.LevelIdList.Any())
                    {
                        // handle for level 0 or some others that not depend on systems
                        var orgRoleLevelList = IDashboard_OrganisationRole_LevelsService.GetAllQueryable("", "");
                        var orgRoleLevel = orgRoleLevelList.Where(
                                l => l.DashboardLevelId == dashboardLevelDetail.DashboardLevelId
                                && request.LevelIdList.Contains(l.LevelId)).FirstOrDefault();

                        if (orgRoleLevel != null)
                            request.LevelId = orgRoleLevel.LevelId;
                    }

                    userlevelDetail = IOrganisation_Levels_Service.GetById(request.LevelId);
                    if (userlevelDetail != null)
                    {
                        var currUserLevelSort = userlevelDetail.Sort;
                        var currSystemId = userlevelDetail.SystemId;

                        var userLevelsCanBeInherited = IOrganisation_Levels_Service.GetAllQueryable("", "")
                            .Where(l => l.Sort >= currUserLevelSort
                                && l.SystemId == currSystemId).Select(l => l.LevelId).ToList();

                        var orgRoleLevelList = IDashboard_OrganisationRole_LevelsService.GetAllQueryable("", "");
                        if (orgRoleLevelList.Any() && dashboardList.Any())
                        {
                            var lstDashId = dashboardList.Select(l => l.DashboardId);
                            var orgRoleLevel = orgRoleLevelList.Where(
                                l => l.DashboardLevelId == dashboardLevelDetail.DashboardLevelId
                                && userLevelsCanBeInherited.Contains(l.LevelId)
                                && lstDashId.Contains(l.DashboardId)).FirstOrDefault();

                            response.Dashboard_OrganisationRole_Level = orgRoleLevel;
                        }
                    }
                }
            }
        }

        #endregion Get Dashboard OrganisationRole Levels

        #region Get Report Organisation Levels

        public Report_Organisation_LevelsResponse GetReport_Organisation_Levels(
            Report_Organisation_LevelsRequest request)
        {
            var response = new Report_Organisation_LevelsResponse(request.RequestId);

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response, Validate.All))
                return response;

            // update permissions to response base on request
            UpdateReport_Organisation_LevelsResponse(request, response);

            return response;
        }

        private void UpdateReport_Organisation_LevelsResponse(
            Report_Organisation_LevelsRequest request,
            Report_Organisation_LevelsResponse response)
        {
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
        }

        #endregion Get Report Organisation Levels

        #region Get Landing Page

        private void UpdateDashboard_LandingPage(User user)
        {
            if (user != null)
            {
                var defaultSystemName = "tmf";
                var defaultDashboardName = "rtw";

                // get dashboard favorite
                var dashboardFavorite = IDashboard_FavourService.GetAllQueryable("", "")
                    .FirstOrDefault(f => f.UserId == user.UserId && f.Is_Landing_Page == true);
                if (dashboardFavorite != null && !string.IsNullOrEmpty(dashboardFavorite.Url))
                {
                    // user has landing page

                    // get dashboard url
                    var dashboardUrl = GetDashboardUrl(dashboardFavorite.Url);

                    var hasPermission = HasPermissionOnDashboard(dashboardUrl, user);
                    if (hasPermission)
                    {
                        // user has permission on landing page
                        user.LandingPage_Url = dashboardFavorite.Url;
                    }
                    else
                    {
                        // user has no permission on landing page

                        // Choose a other landing page with rules:
                        // + In levels 0, 1 or 2
                        // + Same system with landing page or default system
                        // + Same dashboard type with landing page

                        if (dashboardUrl == "level0")
                        {
                            var defaultSystem = user.Systems.FirstOrDefault(s => s.SystemId == user.Default_System_Id);
                            if (defaultSystem != null)
                                defaultSystemName = defaultSystem.Name;
                        }
                        else
                        {
                            // get system name of landing page
                            var systemName = GetSystemNameByUrl(dashboardUrl);
                            if (!string.IsNullOrEmpty(systemName))
                                defaultSystemName = systemName;

                            // get dashboard name of landing page
                            var dashboardName = GetDashboardNameByUrl(dashboardUrl);
                            if (!string.IsNullOrEmpty(dashboardName))
                                defaultDashboardName = dashboardName;
                        }

                        //user.LandingPage_DashboardUrl = ChooseValidDashboardInLevelRange(
                        //    user,
                        //    defaultSystemName,
                        //    defaultDashboardName,
                        //    dashboardUrl, 0, 2);
                    }
                }
                else
                {
                    // user has no landing page

                    // Choose a other landing page with rules:
                    // + In levels 0, 1 or 2
                    // + Base on default system of user
                    // + Dashboard type is RTW
                    // + System user always land to level 0

                    if (user.Is_System_User)
                    {
                        //user.LandingPage_DashboardUrl = "level0";
                    }
                    else
                    {
                        var defaultSystem = user.Systems.FirstOrDefault(s => s.SystemId == user.Default_System_Id);
                        if (defaultSystem != null)
                            defaultSystemName = defaultSystem.Name;

                        //user.LandingPage_DashboardUrl = ChooseValidDashboardInLevelRange(
                        //        user,
                        //        defaultSystemName,
                        //        defaultDashboardName,
                        //        string.Empty, 0, 2);
                    }
                }
            }
        }

        private string GetDashboardUrl(string url)
        {
            if (string.IsNullOrEmpty(url))
                return string.Empty;

            var dashboardUrl = string.Empty;
            var reportPathPrefix = Get_AppSetting("ReportPathPrefix");

            var urlParts = url.Split('?', '&');
            if (urlParts.Length > 0)
            {
                var reportPath = urlParts.FirstOrDefault(s => s.IndexOf("reportpath=") >= 0);
                if (!string.IsNullOrEmpty(reportPath))
                {
                    dashboardUrl = reportPath.ToLower().Replace("reportpath="
                        + reportPathPrefix.ToLower(), "");
                }
            }

            return dashboardUrl;
        }

        private string GetSystemNameByUrl(string url)
        {
            var urlLower = url.ToLower();
            var systemName = string.Empty;

            if (urlLower.IndexOf("tmf_") >= 0)
            {
                systemName = "TMF";
            }
            else if (urlLower.IndexOf("eml_") >= 0)
            {
                systemName = "EML";
            }
            else if (urlLower.IndexOf("hem_") >= 0)
            {
                systemName = "HEM";
            }

            return systemName;
        }

        private string GetDashboardNameByUrl(string url)
        {
            var urlLower = url.ToLower();
            var dashboardName = string.Empty;

            if (urlLower.IndexOf("rtw_") >= 0)
            {
                dashboardName = "rtw";
            }
            else if (urlLower.IndexOf("awc_") >= 0)
            {
                dashboardName = "awc";
            }

            return dashboardName;
        }

        private int GetDashboardLevelId(string dashboardUrl)
        {
            if (string.IsNullOrEmpty(dashboardUrl))
                return 0;

            var dashboardUrlParts = dashboardUrl.Split('_');
            if (dashboardUrlParts.Length > 0)
            {
                var levelName = dashboardUrlParts.FirstOrDefault(s => s.IndexOf("level") >= 0);
                if (!string.IsNullOrEmpty(levelName))
                {
                    switch (levelName.ToLower())
                    {
                        case "level0":
                            return int.Parse(Control.Dashboard_Levels0_Value);

                        case "level1":
                            return int.Parse(Control.Dashboard_Levels1_Value);

                        case "level2":
                            return int.Parse(Control.Dashboard_Levels2_Value);

                        case "level3":
                            return int.Parse(Control.Dashboard_Levels3_Value);

                        case "level4":
                            return int.Parse(Control.Dashboard_Levels4_Value);

                        case "level5":
                            return int.Parse(Control.Dashboard_Levels5_Value);
                    }
                }
            }

            return 0;
        }

        private bool HasPermissionOnDashboard(string dashboardUrl, User user)
        {
            if (user.Is_System_User)
                return true;

            // get dashboard level id
            var dashboardLevelId = GetDashboardLevelId(dashboardUrl);

            // get system name
            var systemName = GetSystemNameByUrl(dashboardUrl);

            var orgLevelsResponse = new Dashboard_OrganisationRole_LevelsResponse();
            var orgLevelsRequest = new Dashboard_OrganisationRole_LevelsRequest();
            orgLevelsRequest.LoadOptions = new string[] { Resource.Get_Option_Single };
            orgLevelsRequest.Url = dashboardUrl;
            orgLevelsRequest.LevelId = user.LevelId;
            orgLevelsRequest.DashboardLevelId = dashboardLevelId;

            if (dashboardUrl == "level0")
                orgLevelsRequest.LevelIdList = GetLevelIdList(user);
            else
            {
                foreach (KeyValuePair<string, int> item in user.Organisation_LevelIdList)
                {
                    if (item.Key == systemName)
                        orgLevelsRequest.LevelId = item.Value;
                }
            }

            // update permissions to response base on request
            UpdateDashboard_OrganisationRole_LevelsResponse(orgLevelsRequest, orgLevelsResponse);

            return orgLevelsResponse.Dashboard_OrganisationRole_Level != null ? true : false;
        }

        private List<int> GetLevelIdList(User user)
        {
            var levelIdList = new List<int>();
            if (user != null && user.Organisation_LevelIdList != null)
            {
                foreach (KeyValuePair<string, int> item in user.Organisation_LevelIdList)
                {
                    levelIdList.Add(item.Value);
                }
            }

            return levelIdList;
        }

        private string ChooseValidDashboardInLevelRange(
            User user,
            string systemName,
            string dashboardName,
            string excludedDashboardUrl,
            int levelStart,
            int levelEnd)
        {
            var levelOrderRunner = GetLevelOrderRunner(excludedDashboardUrl, levelStart, levelEnd);
            if (!levelOrderRunner.Any())
            {
                // default: scan from left to right
                for (int level = levelStart; level <= levelEnd; level++)
                    levelOrderRunner.Add(level);
            }

            foreach (var level in levelOrderRunner)
            {
                if (string.IsNullOrEmpty(excludedDashboardUrl)
                    || !excludedDashboardUrl.Contains("level" + level))
                {
                    var dashboardUrl = string.Empty;
                    if (level == 0)
                        dashboardUrl = "level0";
                    else if (level == 1)
                        dashboardUrl = systemName + "_level1";
                    else
                        dashboardUrl = systemName + "_" + dashboardName + "_level" + level;

                    var hasPermission = HasPermissionOnDashboard(dashboardUrl, user);
                    if (hasPermission)
                        return dashboardUrl;
                }
            }

            return string.Empty;
        }

        private List<int> GetLevelOrderRunner(string excludedDashboardUrl,
            int levelStart,
            int levelEnd)
        {
            var levelOrderRunner = new List<int>();

            var iLevelName = excludedDashboardUrl.IndexOf("level");
            if (iLevelName >= 0)
            {
                int excludedLevelNo;
                if (int.TryParse(excludedDashboardUrl.Substring(iLevelName + 5), out excludedLevelNo))
                {
                    if (excludedLevelNo == levelStart)
                    {
                        // scan from left to right
                        for (int level = levelStart + 1; level <= levelEnd; level++)
                            levelOrderRunner.Add(level);
                    }
                    else if (excludedLevelNo >= levelEnd)
                    {
                        // scan from right to left
                        for (int level = levelEnd; level >= levelStart; level--)
                            levelOrderRunner.Add(level);
                    }
                    else
                    {
                        // scan from excluded level No to left
                        for (int level = excludedLevelNo - 1; level >= levelStart; level--)
                            levelOrderRunner.Add(level);

                        // scan from excluded level No to right
                        for (int level = excludedLevelNo + 1; level <= levelEnd; level++)
                            levelOrderRunner.Add(level);
                    }
                }
            }

            return levelOrderRunner;
        }

        #endregion Get Landing Page

        public Dashboard_OrganisationRole_LevelsResponse SetDashboard_OrganisationRole_Levels(Dashboard_OrganisationRole_LevelsRequest request)
        {
            var response = new Dashboard_OrganisationRole_LevelsResponse(request.RequestId);

            // Validate client tag, access token, and user credentials
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new Dashboard_FavoursResponse(request.RequestId);
            if (!ValidRequest(request, response, Validate.All))
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

                var favoursPaged = favours.ToPagedList<Dashboard_Favours>(request.Criteria.PageIndex, request.Criteria.PageSize);

                response.Dashboard_Favours = request.Criteria.PageSize == 0 && request.Criteria.PageIndex == 0 ? favours.ToList() : favoursPaged.ToList();
            }

            return response;
        }

        public Dashboard_FavoursResponse setDashboard_Favours(Dashboard_FavoursRequest request)
        {
            var response = new Dashboard_FavoursResponse(request.RequestId);
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new Dashboard_Graph_DescriptionResponse(request.RequestId);
            if (!ValidRequest(request, response, Validate.All))
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

                var descriptionsPaged = descriptions.ToPagedList<Dashboard_Graph_Description>(request.Criteria.PageIndex, request.Criteria.PageSize);

                response.Dashboard_Graph_Descriptions = request.Criteria.PageSize == 0 && request.Criteria.PageIndex == 0 ? descriptions.ToList() : descriptionsPaged.ToList();
            }

            return response;
        }

        public Dashboard_Graph_DescriptionResponse SetDashboard_Graph_Description(Dashboard_Graph_DescriptionRequest request)
        {
            var response = new Dashboard_Graph_DescriptionResponse(request.RequestId);
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new Dashboard_ProjectionResponse(request.RequestId);
            if (!ValidRequest(request, response, Validate.All))
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

                var projectionPaged = projections.ToPagedList<Dashboard_Projection>(request.Criteria.PageIndex, request.Criteria.PageSize);

                response.Dashboard_Projections = request.Criteria.PageSize == 0 && request.Criteria.PageIndex == 0 ? projections.ToList() : projectionPaged.ToList();
            }

            return response;
        }

        public Dashboard_ProjectionResponse SetDashboard_Projection(Dashboard_ProjectionRequest request)
        {
            var response = new Dashboard_ProjectionResponse(request.RequestId);
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new Dashboard_Target_BaseResponse(request.RequestId);
            if (!ValidRequest(request, response, Validate.All))
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

                var target_basePaged = target_bases.ToPagedList<Dashboard_Target_Base>(request.Criteria.PageIndex, request.Criteria.PageSize);

                response.Dashboard_Target_Bases = request.Criteria.PageSize == 0 && request.Criteria.PageIndex == 0 ? target_bases.ToList() : target_basePaged.ToList();
            }

            return response;
        }

        public Dashboard_Target_BaseResponse SetDashboard_Target_Base(Dashboard_Target_BaseRequest request)
        {
            var response = new Dashboard_Target_BaseResponse(request.RequestId);
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new Dashboard_TimeAccessResponse(request.RequestId);
            if (!ValidRequest(request, response, Validate.All))
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

                var DashboardTimeAccessPaged = DashboardTimeAccess.ToPagedList<Dashboard_TimeAccess>(request.Criteria.PageIndex, request.Criteria.PageSize);

                response.Dashboard_TimeAccesss = request.Criteria.PageSize == 0 && request.Criteria.PageIndex == 0 ? DashboardTimeAccess.ToList() : DashboardTimeAccessPaged.ToList();
            }

            return response;
        }

        public Dashboard_TimeAccessResponse SetDashboard_TimeAccess(Dashboard_TimeAccessRequest request)
        {
            var response = new Dashboard_TimeAccessResponse(request.RequestId);
            if (!ValidRequest(request, response, Validate.All))
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
            var response = new PortfolioResponse(request.RequestId);
            if (!ValidRequest(request, response, Validate.All))
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
                        response.ClaimLiabilityIndicators = (IList<string>)IHEMPortfolioService.GetCliamLiabilityIndicators();
                        break;

                    case "EML":
                        response.ClaimLiabilityIndicators = (IList<string>)IEMLPortfolioService.GetCliamLiabilityIndicators();
                        break;

                    case "TMF":
                        response.ClaimLiabilityIndicators = (IList<string>)ITMFPortfolioService.GetCliamLiabilityIndicators();
                        break;
                }
            }

            return response;
        }

        public Dashboard_ProjectionResponse SignalProjectionImport(Dashboard_ProjectionRequest request)
        {
            var response = new Dashboard_ProjectionResponse(request.RequestId);
            if (!ValidRequest(request, response, Validate.All))
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

        public void EncryptConnectionStrings()
        {
            Common.Utilities.Commons.EncryptConnectionStrings();
        }

        private void SendMailToNewUser(User model)
        {
            if (model.Email != string.Empty)
            {
                string mailbody = ConfigurationSettings.AppSettings["MailNewAccountBody"];
                mailbody = mailbody.Replace("[FullName]", model.FirstName + " " + model.LastName);
                mailbody = mailbody.Replace("[UserName]", model.Email);
                mailbody = mailbody.Replace("[Password]", model.Password);
                SendMail(model.Email, ConfigurationSettings.AppSettings["MailNewAccountSubject"], mailbody);
            }
        }

        private bool SendMail(string to, string subject, string body)
        {
            try
            {
                System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
                message.From = new System.Net.Mail.MailAddress(ConfigurationSettings.AppSettings["MailFrom"]);
                message.To.Add(new System.Net.Mail.MailAddress(to));
                message.Subject = subject;
                message.Body = body;
                System.Net.Mail.SmtpClient mSmtpClient = new System.Net.Mail.SmtpClient(ConfigurationSettings.AppSettings["MailHost"]);
                mSmtpClient.Send(message);
                return true;
            }
            catch { return false; }
        }

        /// <summary>
        /// Validate 3 security levels for a request: ClientTag, AccessToken, and User Credentials
        /// </summary>
        /// <param name="request">The request message.</param>
        /// <param name="response">The response message.</param>
        /// <param name="validate">The validation that needs to take place.</param>
        /// <returns></returns>
        private bool ValidRequest(RequestBase request, ResponseBase response, Validate validate)
        {
            // Validate access token
            if ((Validate.AccessToken & validate) == Validate.AccessToken)
            {
                if (_accessToken == null)
                {
                    _accessToken = request.AccessToken;
                }
                else if (request.AccessToken != _accessToken)
                {
                    response.Acknowledge = AcknowledgeType.Failure;
                    response.Message = "Invalid or expired AccessToken. Call GetToken()";
                    return false;
                }
            }

            // Validate user credentials
            if ((Validate.UserCredentials & validate) == Validate.UserCredentials)
            {
                //if (_email == null)
                if (_username == null)
                {
                    response.Acknowledge = AcknowledgeType.Failure;
                    response.Message = "Please login and provide user credentials before accessing these methods.";
                    return false;
                }
            }
            return true;
        }

        /// <summary>
        /// Validation options enum. Used in validation of messages.
        /// </summary>
        [Flags]
        private enum Validate
        {
            ClientTag = 0x0001,
            AccessToken = 0x0002,
            UserCredentials = 0x0004,
            All = ClientTag | AccessToken | UserCredentials
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

            // The service parameter is ignored here because we know our service.
            ServiceHost serviceHost = new ServiceHost(typeof(ActionService),
                baseAddresses);
            return serviceHost;
        }
    }
}