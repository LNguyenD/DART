namespace EM_Report.Service.ServiceContracts
{
    using EM_Report.Service.Messages;
    using System.ServiceModel;

    /// <summary>
    /// IService is the interface for Patterns in Action public services.
    /// </summary>
    /// <remarks>
    /// Application Facade Pattern.
    /// </remarks>
    [ServiceContract(SessionMode = SessionMode.Required)]
    public interface IActionService
    {
        [OperationContract]
        TokenResponse GetToken(TokenRequest request);

        [OperationContract]
        LoginResponse Login(LoginRequest request);

        [OperationContract]
        LogoutResponse Logout(LogoutRequest request);

        [OperationContract]
        LoginResponse AutoLogin(LoginRequest request);

        [OperationContract]
        ChangePasswordResponse ChangePassword(ChangePasswordRequest request);

        [OperationContract]
        ResetPasswordResponse ResetPassword(ResetPasswordRequest request);

        [OperationContract]
        UserResponse GetUsers(UserRequest request);

        [OperationContract]
        UserResponse SetUsers(UserRequest request);

        [OperationContract]
        Organisation_RolesResponse GetOrganisationRoles(Organisation_RolesRequest request);

        [OperationContract]
        Organisation_RolesResponse SetOrganisationRoles(Organisation_RolesRequest request);

        [OperationContract]
        TeamResponse GetTeams(TeamRequest request);

        [OperationContract]
        TeamResponse SetTeams(TeamRequest request);

        [OperationContract]
        ReportCategoryResponse GetRptCategories(ReportCategoryRequest request);

        [OperationContract]
        ReportCategoryResponse SetRptCategories(ReportCategoryRequest request);

        [OperationContract]
        Organisation_LevelsResponse GetOrganisationLevels(Organisation_LevelsRequest request);

        [OperationContract]
        Organisation_LevelsResponse SetOrganisationLevels(Organisation_LevelsRequest request);

        [OperationContract]
        System_RolesResponse GetSystemRoles(System_RolesRequest request);

        [OperationContract]
        System_RolesResponse SetSystemRoles(System_RolesRequest request);

        [OperationContract]
        External_GroupResponse GetExternal_Groups(External_GroupRequest request);

        [OperationContract]
        External_GroupResponse SetExternal_Groups(External_GroupRequest request);

        [OperationContract]
        StatusResponse GetStatus(StatusRequest request);

        [OperationContract]
        StatusResponse SetStatus(StatusRequest request);

        [OperationContract]
        PermissionResponse GetPermissions(PermissionRequest request);

        [OperationContract]
        PermissionResponse SetPermissions(PermissionRequest request);

        [OperationContract]
        SystemRole_PermissionsResponse GetSystemRolePermissions(SystemRole_PermissionsRequest request);

        [OperationContract]
        SystemRole_PermissionsResponse SetSystemRolePermissions(SystemRole_PermissionsRequest request);

        [OperationContract]
        ReportResponse GetReports(ReportRequest request);

        [OperationContract]
        ReportResponse SetReports(ReportRequest request);

        [OperationContract]
        System_PermissionResponse GetSystemPermissions(System_PermissionRequest request);

        [OperationContract]
        System_PermissionResponse SetSystemPermissions(System_PermissionRequest request);

        [OperationContract]
        ReportPermissionResponse GetReportPermissions(ReportPermissionRequest request);

        [OperationContract]
        ReportPermissionResponse SetReportPermissions(ReportPermissionRequest request);

        [OperationContract]
        DashboardResponse GetDashBoards(DashboardRequest request);

        [OperationContract]
        DashboardResponse SetDashBoards(DashboardRequest request);

        [OperationContract]
        Dashboard_OrganisationRole_LevelsResponse GetDashboard_OrganisationRole_Levels(Dashboard_OrganisationRole_LevelsRequest request);

        [OperationContract]
        Report_Organisation_LevelsResponse GetReport_Organisation_Levels(Report_Organisation_LevelsRequest request);

        [OperationContract]
        Dashboard_OrganisationRole_LevelsResponse SetDashboard_OrganisationRole_Levels(Dashboard_OrganisationRole_LevelsRequest request);

        [OperationContract]
        Dashboard_LevelsResponse GetDashBoardLevels(Dashboard_LevelsRequest request);

        [OperationContract]
        Dashboard_LevelsResponse SetDashBoardLevels(Dashboard_LevelsRequest request);

        [OperationContract]
        Dashboard_FavoursResponse GetDashboard_Favours(Dashboard_FavoursRequest request);

        [OperationContract]
        Dashboard_FavoursResponse setDashboard_Favours(Dashboard_FavoursRequest request);

        [OperationContract]
        Dashboard_Graph_DescriptionResponse GetDashboard_Graph_Description(Dashboard_Graph_DescriptionRequest request);

        [OperationContract]
        Dashboard_Graph_DescriptionResponse SetDashboard_Graph_Description(Dashboard_Graph_DescriptionRequest request);

        [OperationContract]
        Dashboard_Traffic_Light_RulesResponse GetDashboard_Traffic_Light_Rules(Dashboard_Traffic_Light_RulesRequest request);

        [OperationContract]
        Dashboard_Traffic_Light_RulesResponse SetDashboard_Traffic_Light_Rules(Dashboard_Traffic_Light_RulesRequest request);

        [OperationContract]
        Dashboard_ProjectionResponse GetDashboard_Projection(Dashboard_ProjectionRequest request);

        [OperationContract]
        Dashboard_ProjectionResponse SetDashboard_Projection(Dashboard_ProjectionRequest request);

        [OperationContract]
        Dashboard_TimeAccessResponse GetDashboard_TimeAccess(Dashboard_TimeAccessRequest request);

        [OperationContract]
        Dashboard_TimeAccessResponse SetDashboard_TimeAccess(Dashboard_TimeAccessRequest request);

        [OperationContract]
        Dashboard_Target_BaseResponse GetDashboard_Target_Base(Dashboard_Target_BaseRequest request);

        [OperationContract]
        Dashboard_Target_BaseResponse SetDashboard_Target_Base(Dashboard_Target_BaseRequest request);

        [OperationContract]
        PortfolioResponse GetPortfolio(PortfolioRequest request);

        [OperationContract]
        void EncryptConnectionStrings();

        [OperationContract]
        Dashboard_ProjectionResponse SignalProjectionImport(Dashboard_ProjectionRequest request);
    }
}