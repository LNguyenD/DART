using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Linq.Expressions;
using EM_Report.Common.Utilities;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Domain;

namespace EM_Report.BLL.Services
{
    public interface I_ReportService : I_Service<Report>
    {
        Report GetReportByReportPath(string reportpath);

        Report CreateOrUpdate(Report model);

        void DeleteReportView(ReportPermission model);

        void UpdateStatus(Report model, short status);

        ReportPermission GetReportViewById(object id);

        IQueryable<Report> GetAllReports(int systemId, string sort, string keyword);

        IEnumerable<int> GetAllReporIdUserCanAccess(int userId);

        IQueryable<Report> GetAllReportUserCanAccess(int systemId, int userId, bool isSystemUser, string sort, string keyword);

        IQueryable<Report> GetAllReportUserCanAccess(int systemId, int userId, bool isSystemUser, int categoryid, string sort, string keyword);

        //External Access
        void AddReportExternalAccess(ReportPermission model, Report_External_Access externalGroup);

        void AddReportExternalAccesses(ReportPermission model, IEnumerable<Report_External_Access> reaList);

        void RemoveReportExternalAccess(ReportPermission model, Report_External_Access externalGroup);

        void RemoveReportExternalAccesses(ReportPermission model, IEnumerable<Report_External_Access> reaList);

        //Organisation Role
        void AddOrganisationRole(ReportPermission model, Report_Organisation_Levels organisationRole);

        void AddOrganisationRoles(ReportPermission model, IEnumerable<Report_Organisation_Levels> rorList);

        void RemoveOrganisationRole(ReportPermission model, Report_Organisation_Levels organisationRole);

        void RemoveOrganisationRoles(ReportPermission model, IEnumerable<Report_Organisation_Levels> rorList);

        //Recent & Favorite
        void AddOrRemoveFavoriteReport(int userid, int reportid);

        IQueryable<Report> GetFavoriteReport(int systemId, int userid);

        IQueryable<Report> GetRecentlyReport(int systemId, int userid);

        void AddRecentlyReport(int userid, int reportid);

        int CountReportByCategoryUserCanAccess(int userId, int categoryid);
    }

    /// <summary>
    ///
    /// </summary>
    public class ReportService : ServiceBase<Report, ReportDO>, I_ReportService
    {
        #region private member variables

        private I_Repository<Report_External_AccessDO> _repositoryReport_External_Access;
        private I_Repository<Report_Organisation_LevelDO> _repositoryReport_Organisation_Level;
        private I_Repository<UserDO> _repositoryUser;
        private I_Repository<Organisation_LevelDO> _repositoryOrganisation_Level;
        private I_Repository<External_GroupDO> _repositoryExternal_Group;
        private I_Repository<Report_CategoryDO> _repositoryReport_Category;
        private I_Repository<StatusDO> _repositoryStatus;
        private I_Repository<Report_FavoriteDO> _repositoryReport_Favorite;
        private I_Repository<Report_RecentlyDO> _repositoryReport_Recently;

        #endregion private member variables

        #region public properties

        public I_Repository<Report_RecentlyDO> RepositoryReport_Recently
        {
            get { return _repositoryReport_Recently; }
            set { _repositoryReport_Recently = value; }
        }

        public I_Repository<Report_FavoriteDO> RepositoryReport_Favorite
        {
            get { return _repositoryReport_Favorite; }
            set { _repositoryReport_Favorite = value; }
        }

        public I_Repository<External_GroupDO> RepositoryExternal_Group
        {
            get { return _repositoryExternal_Group; }
            set { _repositoryExternal_Group = value; }
        }

        public I_Repository<StatusDO> RepositoryStatus
        {
            get { return _repositoryStatus; }
            set { _repositoryStatus = value; }
        }

        public I_Repository<Report_CategoryDO> RepositoryReport_Category
        {
            get { return _repositoryReport_Category; }
            set { _repositoryReport_Category = value; }
        }

        public I_Repository<Organisation_LevelDO> RepositoryOrganisation_Level
        {
            get { return _repositoryOrganisation_Level; }
            set { _repositoryOrganisation_Level = value; }
        }

        public I_Repository<Report_Organisation_LevelDO> RepositoryReport_Organisation_Level
        {
            get { return _repositoryReport_Organisation_Level; }
            set { _repositoryReport_Organisation_Level = value; }
        }

        public I_Repository<Report_External_AccessDO> RepositoryReport_External_Access
        {
            get { return _repositoryReport_External_Access; }
            set { _repositoryReport_External_Access = value; }
        }

        public I_Repository<UserDO> RepositoryUser
        {
            get { return _repositoryUser; }
            set { _repositoryUser = value; }
        }

        #endregion public properties

        #region constructor

        public ReportService(I_LoginSession session)
            : base(session)
        {
            _repositoryExternal_Group = new RepositoryBase<External_GroupDO>(((RepositoryBase<ReportDO>)Repository).Context);
            _repositoryReport_External_Access = new RepositoryBase<Report_External_AccessDO>(((RepositoryBase<ReportDO>)Repository).Context);
            _repositoryReport_Organisation_Level = new RepositoryBase<Report_Organisation_LevelDO>(((RepositoryBase<ReportDO>)Repository).Context);
            _repositoryUser = new RepositoryBase<UserDO>(((RepositoryBase<ReportDO>)Repository).Context);
            _repositoryOrganisation_Level = new RepositoryBase<Organisation_LevelDO>(((RepositoryBase<ReportDO>)Repository).Context);
            _repositoryReport_Category = new RepositoryBase<Report_CategoryDO>(((RepositoryBase<ReportDO>)Repository).Context);
            _repositoryStatus = new RepositoryBase<StatusDO>(((RepositoryBase<ReportDO>)Repository).Context);
            _repositoryReport_Favorite = new RepositoryBase<Report_FavoriteDO>(((RepositoryBase<ReportDO>)Repository).Context);
            _repositoryReport_Recently = new RepositoryBase<Report_RecentlyDO>(((RepositoryBase<ReportDO>)Repository).Context);
        }

        public ReportService(I_Repository<ReportDO> repo, I_LoginSession session)
            : base(repo, session) { }

        #endregion constructor

        #region private method

        protected override IQueryable<Report> Filter(string keyword, IQueryable<Report> query, Expression<Func<Report, bool>> expression)
        {
            var predicate = PredicateBuilder.False<Report>();
            if (!string.IsNullOrEmpty(keyword))
            {
                predicate = predicate.Or(p => p.Name.Contains(keyword));
                predicate = predicate.Or(p => p.Description.Contains(keyword));
                query = query.Where(predicate);
            }

            if (expression != null)
            {
                query = query.Where(expression);
            }
            return query;
        }

        protected override IQueryable<Report> Filter(string keyword, IQueryable<Report> query)
        {
            return Filter(keyword, query, null);
        }

        protected override IQueryable<Report> GetMapping(IQueryable<ReportDO> query)
        {
            try
            {
                var statusQuery = RepositoryStatus.GetQueryable();
                var userQuery = RepositoryUser.GetQueryable();
                var categoryQuery = RepositoryReport_Category.GetQueryable();
                var result = from report in query
                             join category in categoryQuery on report.CategoryId equals category.CategoryId
                             join status in statusQuery on report.Status equals status.StatusId
                             join user in userQuery on report.Owner equals user.UserId into temp
                             from user in temp.DefaultIfEmpty()
                             select new Report()
                             {
                                 ReportId = report.ReportId,
                                 CategoryId = report.CategoryId,
                                 CategoryName = category.Name,
                                 Name = report.Name,
                                 ShortName = report.ShortName,
                                 Url = report.Url,
                                 Description = report.Description,
                                 Create_Date = report.Create_Date,
                                 Owner = report.Owner ?? 0,
                                 OwnerName = user != null ? user.UserName : string.Empty,
                                 Status = report.Status ?? 0,
                                 StatusName = status.Name,
                                 UpdatedBy = report.UpdatedBy,
                                 ForSubscription = report.ForSubscription ?? false
                             };

                return result;
            }
            catch (Exception ex)
            {
                Logger.Error("GetMapping error", ex);
                return null;
            }
        }

        protected override IQueryable<ReportDO> Authorization(IQueryable<ReportDO> query)
        {
            try
            {
                return FilterReport(query, Session.intUserId);
            }
            catch (Exception ex)
            {
                Logger.Debug("Session:" + (Session != null ? Session.intUserId.ToString() : "is null"), ex);
                Logger.Error("Authorization error", ex);
                return null;
            }
        }

        private IQueryable<ReportDO> FilterReport(IQueryable<ReportDO> query, int userId, bool isSystemUser)
        {
            if (isSystemUser)
            {
                return query; //return all report if user is systemUser
            }
            var canAccesstList = GetAllReportIdAssignToUser(userId);
            var result = from report in query
                         where (canAccesstList.Contains(report.ReportId))
                         select report;
            return result;
        }

        private IQueryable<ReportDO> FilterReport(IQueryable<ReportDO> query, int userId)
        {
            if (Session != null && Session.isSystemUser)
            {
                return query; //return all report if user is systemUser
            }
            var canAccesstList = GetAllReportIdAssignToUser(userId);
            var result = from report in query
                         where (canAccesstList.Contains(report.ReportId))
                         select report;
            return result;
        }

        private IQueryable<Report> FilterReport(IQueryable<Report> query, int systemId)
        {
            var filteredReports = new List<Report>();

            var categoryQuery = RepositoryReport_Category.GetQueryable();
            var reportList = (from table in query
                              join cat in categoryQuery on table.CategoryId equals cat.CategoryId into temp
                              from cat in temp.DefaultIfEmpty()
                              //where (table.StatusName == ResourcesHelper.Action_Active)
                              select table == null ? null : new Report()
                              {
                                  ReportId = table.ReportId,
                                  CategoryId = table.CategoryId,
                                  CategoryName = cat.Name,
                                  Name = table.Name,
                                  ShortName = table.ShortName,
                                  Url = table.Url,
                                  Description = table.Description,
                                  Status = table.Status,
                                  StatusName = table.StatusName,
                                  Create_Date = table.Create_Date,
                                  Owner = table.Owner,
                                  OwnerName = table.OwnerName,
                                  UpdatedBy = table.UpdatedBy,
                                  ForSubscription = table.ForSubscription
                              }).ToList();

            if (reportList.Any())
            {
                foreach (var report in reportList)
                {
                    if (GetAllSystemIdsOfReport(report.ReportId).Contains(systemId) || systemId <= 0)
                    {
                        var reportOrganisationLevels = RepositoryReport_Organisation_Level.GetQueryable().Where(a => a.ReportId == report.ReportId);
                        if (reportOrganisationLevels.Any())
                        {
                            report.Report_OrganisationRole_Levels = new List<Report_Organisation_Levels>();
                            foreach (var reportOrgLevel in reportOrganisationLevels.AsEnumerable())
                            {
                                report.Report_OrganisationRole_Levels.Add(new Report_Organisation_Levels
                                {
                                    ReportId = reportOrgLevel.ReportId,
                                    LevelId = reportOrgLevel.LevelId,
                                    Create_Date = reportOrgLevel.Create_Date,
                                    Owner = reportOrgLevel.Owner ?? 0,
                                    UpdatedBy = reportOrgLevel.UpdatedBy
                                });
                            }
                        }

                        filteredReports.Add(report);
                    }
                }
            }

            return filteredReports.AsQueryable<Report>();
        }

        private IQueryable<Report> FilterReport(IQueryable<Report> query, int systemId, int userId, bool isSystemUser)
        {

            if (isSystemUser)
            {
                var organisationLevelQuery = RepositoryOrganisation_Level.GetQueryable();
                var reportOrgLevelQuery = RepositoryReport_Organisation_Level.GetQueryable();
                var result = from table in query
                             join rol in reportOrgLevelQuery on table.ReportId equals rol.ReportId
                             join ol in organisationLevelQuery on rol.LevelId equals ol.LevelId into temp
                             from ol in temp
                             where (ol.SystemId == systemId)
                             select table == null ? null : new Report()
                             {
                                 ReportId = table.ReportId,
                                 CategoryId = table.CategoryId,
                                 Name = table.Name,
                                 ShortName = table.ShortName,
                                 Url = table.Url,
                                 Description = table.Description,
                                 Status = table.Status,
                                 Create_Date = table.Create_Date,
                                 Owner = table.Owner,
                                 UpdatedBy = table.UpdatedBy,
                                 ForSubscription = table.ForSubscription
                             };
                return result;
            }
            else
            {
                var reportFavoriteQuery = RepositoryReport_Favorite.GetQueryable().Where(l => l.UserId == userId);
                var categoryQuery = RepositoryReport_Category.GetQueryable();
                var organisationLevelQuery = RepositoryOrganisation_Level.GetQueryable();
                var reportOrgLevelQuery = RepositoryReport_Organisation_Level.GetQueryable();
                var canAccesstList = GetAllReportIdAssignToUser(userId);
                var result = from table in query
                             join cat in categoryQuery on table.CategoryId equals cat.CategoryId
                             join rol in reportOrgLevelQuery on table.ReportId equals rol.ReportId
                             join ol in organisationLevelQuery on rol.LevelId equals ol.LevelId into temp
                             from ol in temp.DefaultIfEmpty()
                             where (canAccesstList.Contains(table.ReportId)
                                && table.StatusName == ResourcesHelper.Action_Active
                                && ol.SystemId == systemId)
                             select table == null ? null : new Report()
                            {
                                ReportId = table.ReportId,
                                CategoryId = table.CategoryId,
                                CategoryName = cat.Name,
                                Name = table.Name,
                                ShortName = table.ShortName,
                                Url = table.Url,
                                Description = table.Description,
                                Status = table.Status,
                                Create_Date = table.Create_Date,
                                Owner = table.Owner,
                                UpdatedBy = table.UpdatedBy,
                                Is_Favorite = reportFavoriteQuery.Where(l => l.ReportId == table.ReportId).Any() ? true : false,
                                ForSubscription = table.ForSubscription
                            };
                return result;
            }
        }

        /// <summary>
        /// Gets all report id user can acess.
        /// </summary>
        /// <param name="userId">The user id.</param>
        /// <returns></returns>
        protected IEnumerable<int> GetAllReportIdAssignToUser(int userId)
        {
            var user = RepositoryUser.GetQueryable().Where(e => e.UserId == userId).FirstOrDefault();
            if (user == null)
                yield break;

            IList<int> list = new List<int>();

            if (user.ReportUserDOs.Any())
            {
                var reportUser = user.ReportUserDOs[0];
                if (reportUser.Is_External_User.HasValue && reportUser.Is_External_User.Value == true && reportUser.External_GroupId.HasValue)
                {
                    list = RepositoryReport_External_Access.GetQueryable()
                        .Where(e => e.External_GroupId == reportUser.External_GroupId.Value)
                        .Select(e => e.ReportId).ToList();
                }
                else if (reportUser.Organisation_RoleDO != null && reportUser.Organisation_RoleDO.Organisation_LevelDO != null)
                {
                    var levelList = GetAllLevelIdsUserCanAccess(reportUser);
                    list = RepositoryReport_Organisation_Level.GetQueryable()
                        .Where(e => levelList.Contains(e.Organisation_LevelDO.LevelId))
                        .Select(e => e.ReportId).ToList();
                }
            }

            foreach (var item in list.Distinct())
            {
                yield return item;
            }
        }

        private IEnumerable<int> GetAllLevelIdsUserCanAccess(ReportUserDO reportUser)
        {
            var result = new List<int>();

            if (reportUser.Organisation_RoleId != null && reportUser.Organisation_RoleDO != null
                && reportUser.Organisation_RoleDO.Organisation_LevelDO != null)
            {
                var currUserLevelSort = reportUser.Organisation_RoleDO.Organisation_LevelDO.Sort;
                var currSystemId = reportUser.Organisation_RoleDO.Organisation_LevelDO.SystemId;

                var userLevelsCanBeInherited = RepositoryOrganisation_Level.GetQueryable()
                    .Where(l => l.Sort >= currUserLevelSort
                        && l.SystemId == currSystemId).Select(l => l.LevelId).ToList();

                result = result.Union(userLevelsCanBeInherited).ToList();
            }

            return result;
        }

        private IEnumerable<int> GetAllSystemIdsOfReport(int reportId)
        {
            var systemIds = new List<int>();

            var organisationLevelsQuery = RepositoryReport_Organisation_Level.GetQueryable().Where(l => l.ReportId == reportId).Select(a => a.Organisation_LevelDO);
            if (organisationLevelsQuery.Any())
            {
                foreach (var organisationLevel in organisationLevelsQuery.AsEnumerable())
                    systemIds.Add(organisationLevel.SystemId);
            }

            return systemIds;
        }

        private void GetOrganisationRoleOfReport(ReportPermission reportView, ReportDO report, IQueryable<UserDO> userQuery)
        {
            var levelQuery = RepositoryOrganisation_Level.GetQueryable();
            var levelGroupQuery = RepositoryReport_Organisation_Level.GetQueryable().Where(l => l.ReportId == report.ReportId);
            var levelGroups = from levelGroup in levelGroupQuery
                              join level in levelQuery on levelGroup.LevelId equals level.LevelId
                              join user in userQuery on levelGroup.Owner equals user.UserId into temp
                              from user in temp.DefaultIfEmpty()
                              select new Report_Organisation_Levels()
                              {
                                  ReportId = levelGroup.ReportId,
                                  LevelId = levelGroup.LevelId,
                                  Create_Date = levelGroup.Create_Date,
                                  Owner = levelGroup.Owner ?? 0,
                                  OwnerName = user != null ? user.UserName : string.Empty,
                                  LevelName = level.Name
                              };
            foreach (var level in levelGroups.AsEnumerable())
            {
                reportView.ReportOrganisationLevelList.Add(level);
            }
        }

        private void GetExeternalGroupAccessOfReport(ReportPermission reportView, ReportDO report, IQueryable<UserDO> userQuery)
        {
            var groupQuery = RepositoryExternal_Group.GetQueryable();
            var externalGroupQuery = report.Report_External_AccessDOs.AsQueryable();
            var externalGroups = from externalGroup in externalGroupQuery
                                 join groups in groupQuery on externalGroup.External_GroupId equals groups.External_GroupId
                                 join user in userQuery on externalGroup.Owner equals user.UserId into temp
                                 from user in temp.DefaultIfEmpty()
                                 select new Report_External_Access()
                                 {
                                     ReportId = externalGroup.ReportId,
                                     External_GroupId = externalGroup.External_GroupId,
                                     Create_Date = externalGroup.Create_Date,
                                     Owner = externalGroup.Owner ?? 0,
                                     OwnerName = user != null ? user.UserName : string.Empty,
                                     ExternalGroupName = groups.Name
                                 };
            foreach (var excessgroup in externalGroups.AsEnumerable())
            {
                reportView.ReportExternalAccessList.Add(excessgroup);
            }
        }

        #endregion private method

        /// <summary>
        /// Creates the or update.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns></returns>
        public Report CreateOrUpdate(Report model)
        {
            return (model.ReportId > 0) ? Update(model, model.ReportId) : Create(model);

        }

        /// <summary>
        /// Gets the report by report path.
        /// </summary>
        /// <param name="reportpath">The reportpath.</param>
        /// <returns></returns>
        public Report GetReportByReportPath(string reportpath)
        {
            return Mappers.MapTo<ReportDO, Report>(Repository.GetQueryable().Where(e => e.Url == reportpath.Replace(ConfigurationManager.AppSettings["ReportPathPrefix"], "")).FirstOrDefault());
        }

        /// <summary>
        /// Updates the status.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <param name="status">The status.</param>
        public void UpdateStatus(Report model, short status)
        {
            model.Status = status;
            Update(model, model.ReportId);
        }

        /// <summary>
        /// Adds the report external access.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <param name="externalGroup">The external group.</param>
        public void AddReportExternalAccess(ReportPermission model, Report_External_Access externalGroup)
        {
            if (externalGroup.External_GroupId > 0 && RepositoryReport_External_Access.GetQueryable().Where(e => e.External_GroupId == externalGroup.External_GroupId && e.ReportId == model.ReportId).IsNullOrEmpty())
            {
                RepositoryReport_External_Access.Insert(Mappers.MapTo<Report_External_Access, Report_External_AccessDO>(externalGroup));
            }
        }

        /// <summary>
        /// Adds the report external accesses.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <param name="externalGroupList">The external group list.</param>
        public void AddReportExternalAccesses(ReportPermission model, IEnumerable<Report_External_Access> externalGroupList)
        {
            foreach (var externalGroup in externalGroupList)
            {
                AddReportExternalAccess(model, externalGroup);
            }
        }

        /// <summary>
        /// Removes the report external access.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <param name="externalGroup">The external group.</param>
        public void RemoveReportExternalAccess(ReportPermission model, Report_External_Access externalGroup)
        {
            RepositoryReport_External_Access.Delete(Mappers.MapTo<Report_External_Access, Report_External_AccessDO>(externalGroup));
        }

        /// <summary>
        /// Removes the report external accesses.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <param name="externalGroupList">The external group list.</param>
        public void RemoveReportExternalAccesses(ReportPermission model, IEnumerable<Report_External_Access> externalGroupList)
        {
            foreach (var externalGroup in externalGroupList)
            {
                RemoveReportExternalAccess(model, externalGroup);
            }
        }

        /// <summary>
        /// Gets the report view by id.
        /// </summary>
        /// <param name="id">The id.</param>
        /// <returns></returns>
        public ReportPermission GetReportViewById(object id)
        {
            var reportView = new ReportPermission();
            var report = base.Repository.GetByPK(id);
            reportView.ReportId = report.ReportId;

            var userQuery = RepositoryUser.GetQueryable();

            GetExeternalGroupAccessOfReport(reportView, report, userQuery);

            GetOrganisationRoleOfReport(reportView, report, userQuery);

            return reportView;
        }

        /// <summary>
        /// Deletes the report view.
        /// </summary>
        /// <param name="model">The model.</param>
        public void DeleteReportView(ReportPermission model)
        {
            RemoveReportExternalAccesses(model, model.ReportExternalAccessList);
            Delete(model.ReportId);
        }

        /// <summary>
        /// Adds the organisation role.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <param name="organisationRole">The organisation role.</param>
        public void AddOrganisationRole(ReportPermission model, Report_Organisation_Levels organisationRole)
        {
            if (organisationRole.LevelId > 0 && RepositoryReport_Organisation_Level.GetQueryable().Where(e => e.LevelId == organisationRole.LevelId && e.ReportId == model.ReportId).IsNullOrEmpty())
            {
                RepositoryReport_Organisation_Level.Insert(Mappers.MapTo<Report_Organisation_Levels, Report_Organisation_LevelDO>(organisationRole));
            }
        }

        /// <summary>
        /// Adds the organisation roles.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <param name="rorList">The ror list.</param>
        public void AddOrganisationRoles(ReportPermission model, IEnumerable<Report_Organisation_Levels> rorList)
        {
            foreach (var organisationRole in rorList)
            {
                AddOrganisationRole(model, organisationRole);
            }
        }

        /// <summary>
        /// Removes the organisation role.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <param name="organisationRole">The organisation role.</param>
        public void RemoveOrganisationRole(ReportPermission model, Report_Organisation_Levels organisationRole)
        {
            RepositoryReport_Organisation_Level.Delete(Mappers.MapTo<Report_Organisation_Levels, Report_Organisation_LevelDO>(organisationRole));
        }

        /// <summary>
        /// Removes the organisation roles.
        /// </summary>
        /// <param name="model">The ReportPermissionModel.</param>
        /// <param name="rorList">The Report_Organisation_RolesModel list.</param>
        public void RemoveOrganisationRoles(ReportPermission model, IEnumerable<Report_Organisation_Levels> rorList)
        {
            foreach (var organisationRole in rorList)
            {
                RemoveOrganisationRole(model, organisationRole);
            }
        }

        public IQueryable<Report> GetAllReports(int systemId, string sort, string keyword)
        {
            var query = GetAllQueryable(sort, keyword);
            return this.FilterReport(query, systemId);
        }

        /// <summary>
        /// Gets all repor id user can access.
        /// </summary>
        /// <param name="userId">The user id.</param>
        /// <returns></returns>
        public IEnumerable<int> GetAllReporIdUserCanAccess(int userId)
        {
            return this.FilterReport(Repository.GetQueryable(), userId).Select(r => r.ReportId);
        }

        /// <summary>
        /// Gets all report user can access.
        /// </summary>
        /// <param name="userId">The user id.</param>
        /// <returns></returns>
        public IQueryable<Report> GetAllReportUserCanAccess(int systemId, int userId, bool isSystemUser, string sort, string keyword)
        {
            var query = GetAllQueryable(sort, keyword);
            return this.FilterReport(query, systemId, userId, isSystemUser);
        }

        /// <summary>
        /// Gets all report user can access.
        /// </summary>
        /// <param name="userId">The user id.</param>
        /// <returns></returns>
        public IQueryable<Report> GetAllReportUserCanAccess(int systemId, int userId, bool isSystemUser, int categoryid, string sort, string keyword)
        {
            return GetAllReportUserCanAccess(systemId, userId, isSystemUser, sort, keyword).Where(l => l.CategoryId == categoryid);
        }

        /// <summary>
        /// Gets all report by category user can access.
        /// </summary>
        /// <param name="userId">The user id.</param>
        /// <returns></returns>
        public int CountReportByCategoryUserCanAccess(int userId, int categoryid)
        {
            return this.FilterReport(Repository.GetQueryable(), userId).Where(l => l.CategoryId == categoryid).Count();
        }

        /// <summary>
        /// Add or Remove favorite report.
        /// </summary>
        /// <param name="userId">The user id.</param>
        /// <returns></returns>
        public IQueryable<Report> GetFavoriteReport(int systemId, int userid)
        {
            var result = from report in GetAllReportUserCanAccess(systemId, userid, false, "", "")
                         join favorite in RepositoryReport_Favorite.GetQueryable() on report.ReportId equals favorite.ReportId into temp2
                         from favorite in temp2.DefaultIfEmpty()
                         where favorite.UserId == userid
                         orderby favorite.Create_Date descending
                         select new Report()
                         {
                             ReportId = report.ReportId,
                             CategoryId = report.CategoryId,
                             Name = report.Name,
                             ShortName = report.ShortName,
                             Url = report.Url,
                             Description = report.Description,
                             Create_Date = report.Create_Date,
                             Owner = report.Owner,
                             UpdatedBy = report.UpdatedBy,
                             Is_Favorite = true
                         };

            return result;
        }

        public IQueryable<Report> GetRecentlyReport(int systemId, int userid)
        {
            var result = from report in GetAllReportUserCanAccess(systemId, userid, false, "", "")
                         join recently in RepositoryReport_Recently.GetQueryable() on report.ReportId equals recently.ReportId into temp2
                         from recently in temp2.DefaultIfEmpty()
                         where recently.UserId == userid
                         orderby recently.Create_Date descending
                         select new Report()
                         {
                             ReportId = report.ReportId,
                             CategoryId = report.CategoryId,
                             Name = report.Name,
                             ShortName = report.ShortName,
                             Url = report.Url,
                             Description = report.Description,
                             Create_Date = report.Create_Date,
                             Owner = report.Owner,
                             UpdatedBy = report.UpdatedBy
                         };

            return result;
        }

        /// <summary>
        /// Add or Remove favorite report.
        /// </summary>
        /// <param name="userId">The user id.</param>
        /// <returns></returns>
        public void AddOrRemoveFavoriteReport(int userid, int reportid)
        {
            var favorite = RepositoryReport_Favorite.GetQueryable().Where(l => l.UserId == userid && l.ReportId == reportid).SingleOrDefault();
            if (favorite != null)
            {
                RepositoryReport_Favorite.Delete(favorite);
            }
            else
            {
                Report_FavoriteDO entity = new Report_FavoriteDO();
                entity.UserId = userid;
                entity.ReportId = reportid;
                entity.Create_Date = DateTime.Now;
                RepositoryReport_Favorite.Insert(entity);
            }
        }

        /// <summary>
        /// Add recently report.
        /// </summary>
        /// <param name="userId">The user id.</param>
        /// <returns></returns>
        public void AddRecentlyReport(int userid, int reportid)
        {
            var recently = RepositoryReport_Recently.GetQueryable().Where(l => l.UserId == userid && l.ReportId == reportid).SingleOrDefault();
            if (recently == null)
            {
                Report_RecentlyDO entity = new Report_RecentlyDO();
                entity.UserId = userid;
                entity.ReportId = reportid;
                entity.Create_Date = DateTime.Now;
                RepositoryReport_Recently.Insert(entity);
            }
            else
            {
                recently.Create_Date = DateTime.Now;
                RepositoryReport_Recently.Update(recently, recently.Id);
            }
        }
    }
}