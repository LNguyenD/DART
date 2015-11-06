using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using EM_Report.BLL.Commons;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Models;

namespace EM_Report.BLL.Services
{
    public interface I_ReportService : I_Service<ReportModel>
    {
        ReportModel GetReportByReportPath(string reportpath);
        ReportModel CreateOrUpdate(ReportModel model);
        void DeleteReportView(ReportPermissionModel model);
        void UpdateStatus(ReportModel model, short status);
        ReportPermissionModel GetReportViewById(object id);
        IEnumerable<int> GetAllReporIdUserCanAccess(int userId);
        IEnumerable<ReportModel> GetAllReportUserCanAccess(int userId);
        
        //External Access
        void AddReportExternalAccess(ReportPermissionModel model, Report_External_AccessModel externalGroup);
        void AddReportExternalAccesses(ReportPermissionModel model, IEnumerable<Report_External_AccessModel> reaList);
        void RemoveReportExternalAccess(ReportPermissionModel model, Report_External_AccessModel externalGroup);
        void RemoveReportExternalAccesses(ReportPermissionModel model, IEnumerable<Report_External_AccessModel> reaList);

        //Organisation Role
        void AddOrganisationRole(ReportPermissionModel model, Report_Organisation_LevelsModel organisationRole);
        void AddOrganisationRoles(ReportPermissionModel model, IEnumerable<Report_Organisation_LevelsModel> rorList);
        void RemoveOrganisationRole(ReportPermissionModel model, Report_Organisation_LevelsModel organisationRole);
        void RemoveOrganisationRoles(ReportPermissionModel model, IEnumerable<Report_Organisation_LevelsModel> rorList);

        //Recent & Favorite
        void AddOrRemoveFavoriteReport(int userid, int reportid);
        IQueryable<ReportModel> GetFavoriteReport(int userid);
        IQueryable<ReportModel> GetRecentlyReport(int userid);
        void AddRecentlyReport(int userid, int reportid);
        int CountReportByCategoryUserCanAccess(int userId, int categoryid);
    }

    /// <summary>
    /// 
    /// </summary>
    public class ReportService : ServiceBase<ReportModel, Report>, I_ReportService
    {
        #region private member variables
        private I_Repository<Report_External_Access> _repositoryReport_External_Access;
        private I_Repository<Report_Organisation_Level> _repositoryReport_Organisation_Level;
        private I_Repository<User> _repositoryUser;
        private I_Repository<Organisation_Level> _repositoryOrganisation_Level;
        private I_Repository<External_Group> _repositoryExternal_Group;
        private I_Repository<Report_Category> _repositoryReport_Category;
        private I_Repository<Status> _repositoryStatus;
        private I_Repository<Report_Favorite> _repositoryReport_Favorite;
        private I_Repository<Report_Recently> _repositoryReport_Recently;
        #endregion
        
        #region public properties
        public I_Repository<Report_Recently> RepositoryReport_Recently
        {
            get { return _repositoryReport_Recently; }
            set { _repositoryReport_Recently = value; }
        }
        public I_Repository<Report_Favorite> RepositoryReport_Favorite
        {
            get { return _repositoryReport_Favorite; }
            set { _repositoryReport_Favorite = value; }
        }
        public I_Repository<External_Group> RepositoryExternal_Group
        {
            get { return _repositoryExternal_Group; }
            set { _repositoryExternal_Group = value; }
        }
        public I_Repository<Status> RepositoryStatus
        {
            get { return _repositoryStatus; }
            set { _repositoryStatus = value; }
        }
        public I_Repository<Report_Category> RepositoryReport_Category
        {
            get { return _repositoryReport_Category; }
            set { _repositoryReport_Category = value; }
        }
        public I_Repository<Organisation_Level> RepositoryOrganisation_Level
        {
            get { return _repositoryOrganisation_Level; }
            set { _repositoryOrganisation_Level = value; }
        }
        public I_Repository<Report_Organisation_Level> RepositoryReport_Organisation_Level
        {
            get { return _repositoryReport_Organisation_Level; }
            set { _repositoryReport_Organisation_Level = value; }
        }
        public I_Repository<Report_External_Access> RepositoryReport_External_Access
        {
            get { return _repositoryReport_External_Access; }
            set { _repositoryReport_External_Access = value; }
        }

        public I_Repository<User> RepositoryUser
        {
            get { return _repositoryUser; }
            set { _repositoryUser = value; }
        }
        #endregion

        #region constructor
        public ReportService(I_LoginSession session)
            : base(session)
        {
            _repositoryExternal_Group = new RepositoryBase<External_Group>(((RepositoryBase<Report>)Repository).Context);
            _repositoryReport_External_Access = new RepositoryBase<Report_External_Access>();
            _repositoryReport_Organisation_Level = new RepositoryBase<Report_Organisation_Level>();
            _repositoryUser = new RepositoryBase<User>(((RepositoryBase<Report>)Repository).Context);
            _repositoryOrganisation_Level = new RepositoryBase<Organisation_Level>(((RepositoryBase<Report>)Repository).Context);
            _repositoryReport_Category = new RepositoryBase<Report_Category>(((RepositoryBase<Report>)Repository).Context);
            _repositoryStatus = new RepositoryBase<Status>(((RepositoryBase<Report>)Repository).Context);
            _repositoryReport_Favorite = new RepositoryBase<Report_Favorite>(((RepositoryBase<Report>)Repository).Context);
            _repositoryReport_Recently = new RepositoryBase<Report_Recently>(((RepositoryBase<Report>)Repository).Context);
        }
        #endregion

        #region private method
        protected override ReportModel MappingToModel(Report table)
        {
            try
            {
                return table == null ? null : new ReportModel()
                {
                    ReportId = table.ReportId,
                    CategoryId = table.CategoryId,
                    Name = table.Name,
                    ShortName = table.ShortName,
                    Url = table.Url,
                    UrlFullPath = Commons.Commons.GetReportPathFromDB(table.Url),
                    Description = table.Description,
                    Status = table.Status ?? 0,
                    Create_Date = table.Create_Date,
                    Owner = table.Owner ?? 0,
                    UpdatedBy = table.UpdatedBy
                };
            }
            catch (Exception ex)
            {
                Logger.Error("MappingToModel error", ex);
            }
            return null;
        }

        protected override Report MappingToDAL(ReportModel model)
        {
            try
            {
                return model == null ? null : new Report()
                {
                    ReportId = model.ReportId,
                    CategoryId = model.CategoryId,
                    Name = model.Name,
                    ShortName = model.ShortName,
                    Url = model.Url,
                    Description = model.Description,
                    Status = model.Status,
                    Create_Date = (model.Create_Date.HasValue) ? model.Create_Date.Value : DateTime.Now,
                    Owner = model.Owner,
                    UpdatedBy = Session.intUserId
                };
            }
            catch (Exception ex)
            {
                Logger.Error("MappingToDAL error", ex);
            }
            return null;
        }

        private Report_External_AccessModel MappingToModel(Report_External_Access table)
        {
            try
            {
                return table == null ? null : new Report_External_AccessModel()
                {
                    ReportId = table.ReportId,
                    External_GroupId = table.External_GroupId,
                    Create_Date = table.Create_Date,
                    Owner = table.Owner ?? 0,
                    UpdatedBy = table.UpdatedBy
                };
            }
            catch (Exception ex)
            {
                Logger.Error("MappingToModel error", ex);
                return null;
            }
        }

        private Report_External_Access MappingToDAL(Report_External_AccessModel model)
        {
            try
            {
                return model == null ? null : new Report_External_Access()
                {
                    ReportId = model.ReportId,
                    External_GroupId = model.External_GroupId,
                    Create_Date = (model.Create_Date.HasValue) ? model.Create_Date.Value : DateTime.Now,
                    Owner = model.Owner,
                    UpdatedBy = Session.intUserId
                };
            }
            catch (Exception ex)
            {
                Logger.Error("MappingToDAL error", ex);
                return null;
            }
        }

        private Report_Organisation_LevelsModel MappingToModel(Report_Organisation_Level table)
        {
            try
            {
                return table == null ? null : new Report_Organisation_LevelsModel()
                {
                    ReportId = table.ReportId,
                    LevelId = table.LevelId,
                    Create_Date = table.Create_Date,
                    Owner = table.Owner ?? 0,
                    UpdatedBy = table.UpdatedBy
                };
            }
            catch (Exception ex)
            {
                Logger.Error("MappingToModel error", ex);
                return null;
            }
        }

        private Report_Organisation_Level MappingToDAL(Report_Organisation_LevelsModel model)
        {
            try
            {
                return model == null ? null : new Report_Organisation_Level()
                {
                    ReportId = model.ReportId,
                    LevelId = model.LevelId,
                    Create_Date = (model.Create_Date.HasValue) ? model.Create_Date.Value : DateTime.Now,
                    Owner = model.Owner,
                    UpdatedBy = Session.intUserId
                };
            }
            catch (Exception ex)
            {
                Logger.Error("MappingToDAL error", ex);
                return null;
            }
        }

        protected override IQueryable<ReportModel> Filter(string keyword, IQueryable<ReportModel> query, Expression<Func<ReportModel, bool>> expression)
        {
            var predicate = PredicateBuilder.False<ReportModel>();
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

        protected override IQueryable<ReportModel> Filter(string keyword, IQueryable<ReportModel> query)
        {
            return Filter(keyword, query, null);
        }

        protected override IQueryable<ReportModel> GetMapping(IQueryable<Report> query)
        {
            try
            {
                var statusQuery = RepositoryStatus.GetQueryable();
                var userQuery = RepositoryUser.GetQueryable();
                var categoryQuery = RepositoryReport_Category.GetQueryable();
                var reportFavoriteQuery = RepositoryReport_Favorite.GetQueryable();
                var result = from report in query
                             join category in categoryQuery on report.CategoryId equals category.CategoryId
                             join status in statusQuery on report.Status equals status.StatusId
                             join user in userQuery on report.Owner equals user.UserId into temp
                             from user in temp.DefaultIfEmpty()
                             join favorite in reportFavoriteQuery on report.ReportId equals favorite.ReportId into temp2
                             from favorite in temp2.Where(l => l.UserId == Session.intUserId).DefaultIfEmpty()

                             select new ReportModel()
                             {
                                 ReportId = report.ReportId,
                                 CategoryId = report.CategoryId,
                                 CategoryName = category.Name,
                                 Name = report.Name,
                                 ShortName = report.ShortName,
                                 Url = report.Url,
                                 UrlFullPath = Commons.Commons.GetReportPathFromDB(report.Url),
                                 Description = report.Description,
                                 Create_Date = report.Create_Date,
                                 Owner = report.Owner ?? 0,
                                 OwnerName = user != null ? user.UserName : string.Empty,
                                 Status = report.Status ?? 0,
                                 StatusName = status.Name,
                                 UpdatedBy = report.UpdatedBy,
                                 Is_Favorite = (favorite != null && favorite.Id != null) ? true : false
                             };
                return result;
            }
            catch (Exception ex)
            {
                Logger.Error("GetMapping error", ex);
                return null;
            }
        }

        protected override IQueryable<Report> Authorization(IQueryable<Report> query)
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
        
        private IQueryable<Report> FilterReport(IQueryable<Report> query, int userId)
        {
            if (Session!=null && Session.isSystemUser)
            {
                return query; //return all report if user is systemUser
            }
            var canAccesstList = GetAllReportIdAssignToUser(userId);
            var result = from report in query
                         where (canAccesstList.Contains(report.ReportId) && report.Status == ResourcesHelper.StatusActive)
                         select report;
            return result;
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

            if (user.ReportUser != null)
            {
                if (user.ReportUser.Is_External_User.HasValue && user.ReportUser.Is_External_User.Value == true && user.ReportUser.External_GroupId.HasValue)
                {
                    list = RepositoryReport_External_Access.GetQueryable()
                        .Where(e => e.External_GroupId == user.ReportUser.External_GroupId.Value && e.External_Group.Status == ResourcesHelper.StatusActive)
                        .Select(e => e.ReportId).ToList();
                }
                else if (user.ReportUser.Organisation_Role != null && user.ReportUser.Organisation_Role.Organisation_Level != null)
                {
                    var levelList = GetAllLevelIdUserCanAccess(user);
                    list = RepositoryReport_Organisation_Level.GetQueryable()
                        .Where(e => levelList.Contains(e.Organisation_Level.LevelId) && e.Organisation_Level.Status == ResourcesHelper.StatusActive)
                        .Select(e => e.ReportId).ToList();
                }
            }
            foreach (var item in list.Distinct())
            {
                yield return item;
            }
        }
        
        private IEnumerable<int> GetAllLevelIdUserCanAccess(User user)
        {
            if (user.ReportUser.Organisation_RoleId != null && user.ReportUser.Organisation_Role != null && user.ReportUser.Organisation_Role.Organisation_Level != null)
            {
                return RepositoryOrganisation_Level.GetQueryable().Where(l => l.Sort >= user.ReportUser.Organisation_Role.Organisation_Level.Sort).Select(l => l.LevelId).ToList();
            } else{
                return  new List<int>();
            }
        }

        private void GetOrganisationRoleOfReport(ReportPermissionModel reportView, Report report, IQueryable<User> userQuery)
        {
            var levelQuery = RepositoryOrganisation_Level.GetQueryable();
            var levelGroupQuery = report.Report_Organisation_Levels.AsQueryable();
            var levelGroups = from levelGroup in levelGroupQuery
                              join level in levelQuery on levelGroup.LevelId equals level.LevelId
                              join user in userQuery on levelGroup.Owner equals user.UserId into temp
                              from user in temp.DefaultIfEmpty()
                              select new Report_Organisation_LevelsModel()
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

        private void GetExeternalGroupAccessOfReport(ReportPermissionModel reportView, Report report, IQueryable<User> userQuery)
        {
            var groupQuery = RepositoryExternal_Group.GetQueryable();
            var externalGroupQuery = report.Report_External_Accesses.AsQueryable();
            var externalGroups = from externalGroup in externalGroupQuery
                                 join groups in groupQuery on externalGroup.External_GroupId equals groups.External_GroupId
                                 join user in userQuery on externalGroup.Owner equals user.UserId into temp
                                 from user in temp.DefaultIfEmpty()
                                 select new Report_External_AccessModel()
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
        #endregion

        #region public methods
        /// <summary>
        /// Deletes the specified id.
        /// </summary>
        /// <param name="id">The id.</param>
        public override void Delete(object id)
        {
            var model = GetById(id);
            UpdateStatus(model, ResourcesHelper.StatusInactive);
        }

        /// <summary>
        /// Creates the or update.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns></returns>
        public ReportModel CreateOrUpdate(ReportModel model)
        {
            return (model.ReportId > 0) ? Update(model, model.ReportId) : Create(model);
        }

        /// <summary>
        /// Gets the report by report path.
        /// </summary>
        /// <param name="reportpath">The reportpath.</param>
        /// <returns></returns>
        public ReportModel GetReportByReportPath(string reportpath)
        {
            return MappingToModel(Repository.GetQueryable().Where(e => e.Url == reportpath.Replace(Commons.Commons.ReportPathPrefix, "")).FirstOrDefault());
        }

        /// <summary>
        /// Updates the status.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <param name="status">The status.</param>
        public void UpdateStatus(ReportModel model, short status)
        {
            model.Status = status;
            Update(model, model.ReportId);
        }

        /// <summary>
        /// Adds the report external access.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <param name="externalGroup">The external group.</param>
        public void AddReportExternalAccess(ReportPermissionModel model, Report_External_AccessModel externalGroup)
        {
            if (externalGroup.External_GroupId > 0 && RepositoryReport_External_Access.GetQueryable().Where(e => e.External_GroupId == externalGroup.External_GroupId && e.ReportId == model.ReportId).IsNullOrEmpty())
            {
                RepositoryReport_External_Access.Insert(MappingToDAL(externalGroup));
            }
        }

        /// <summary>
        /// Adds the report external accesses.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <param name="externalGroupList">The external group list.</param>
        public void AddReportExternalAccesses(ReportPermissionModel model, IEnumerable<Report_External_AccessModel> externalGroupList)
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
        public void RemoveReportExternalAccess(ReportPermissionModel model, Report_External_AccessModel externalGroup)
        {
            _repositoryReport_External_Access.Delete(MappingToDAL(externalGroup));
        }

        /// <summary>
        /// Removes the report external accesses.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <param name="externalGroupList">The external group list.</param>
        public void RemoveReportExternalAccesses(ReportPermissionModel model, IEnumerable<Report_External_AccessModel> externalGroupList)
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
        public ReportPermissionModel GetReportViewById(object id)
        {
            var reportView = new ReportPermissionModel();
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
        public void DeleteReportView(ReportPermissionModel model)
        {
            RemoveReportExternalAccesses(model, model.ReportExternalAccessList);
            Delete(model.ReportId);
        }

        /// <summary>
        /// Adds the organisation role.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <param name="organisationRole">The organisation role.</param>
        public void AddOrganisationRole(ReportPermissionModel model, Report_Organisation_LevelsModel organisationRole)
        {
            if (organisationRole.LevelId > 0 && RepositoryReport_Organisation_Level.GetQueryable().Where(e => e.LevelId == organisationRole.LevelId && e.ReportId == model.ReportId).IsNullOrEmpty())
            {
                RepositoryReport_Organisation_Level.Insert(MappingToDAL(organisationRole));
            }
        }

        /// <summary>
        /// Adds the organisation roles.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <param name="rorList">The ror list.</param>
        public void AddOrganisationRoles(ReportPermissionModel model, IEnumerable<Report_Organisation_LevelsModel> rorList)
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
        public void RemoveOrganisationRole(ReportPermissionModel model, Report_Organisation_LevelsModel organisationRole)
        {
            RepositoryReport_Organisation_Level.Delete(MappingToDAL(organisationRole));
        }

        /// <summary>
        /// Removes the organisation roles.
        /// </summary>
        /// <param name="model">The ReportPermissionModel.</param>
        /// <param name="rorList">The Report_Organisation_RolesModel list.</param>
        public void RemoveOrganisationRoles(ReportPermissionModel model, IEnumerable<Report_Organisation_LevelsModel> rorList)
        {
            foreach (var organisationRole in rorList)
            {
                RemoveOrganisationRole(model, organisationRole);
            }
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
        public IEnumerable<ReportModel> GetAllReportUserCanAccess(int userId)
        {
            return this.FilterReport(Repository.GetQueryable(), userId).OrderBy(r => r.Name).Select(r => MappingToModel(r));
        }

        /// <summary>
        /// Gets all report by category user can access.
        /// </summary>
        /// <param name="userId">The user id.</param>
        /// <returns></returns>
        public int CountReportByCategoryUserCanAccess(int userId,int categoryid)
        {   
            return this.FilterReport(Repository.GetQueryable(), userId).Where(l => l.CategoryId == categoryid).Count();
        }        

        /// <summary>
        /// Add or Remove favorite report.
        /// </summary>
        /// <param name="userId">The user id.</param>
        /// <returns></returns>
        public IQueryable<ReportModel> GetFavoriteReport(int userid)
        {          
            var result = from report in Repository.GetQueryable().Where(l=>l.Status==ResourcesHelper.StatusActive)                          
                         join favorite in  RepositoryReport_Favorite.GetQueryable() on report.ReportId equals favorite.ReportId into temp2
                         from favorite in temp2.DefaultIfEmpty()
                         where favorite.UserId == userid
                         orderby favorite.Create_Date descending
                         select new ReportModel()
                         {
                             ReportId = report.ReportId,
                             CategoryId = report.CategoryId,                            
                             Name = report.Name,
                             ShortName = report.ShortName,
                             Url = report.Url,
                             UrlFullPath = Commons.Commons.GetReportPathFromDB(report.Url),
                             Description = report.Description,
                             Create_Date = report.Create_Date,
                             Owner = report.Owner ?? 0,                    
                             UpdatedBy = report.UpdatedBy,
                             Is_Favorite = favorite != null && favorite.Id != null ? true : false
                         };                         
            return result;    
        }

        public IQueryable<ReportModel> GetRecentlyReport(int userid)
        {
            var result = from report in Repository.GetQueryable().Where(l => l.Status == ResourcesHelper.StatusActive) 
                         join recently in RepositoryReport_Recently.GetQueryable() on report.ReportId equals recently.ReportId into temp2
                         from recently in temp2.DefaultIfEmpty()
                         where recently.UserId == userid orderby recently.Create_Date descending
                         select new ReportModel()
                         {
                             ReportId = report.ReportId,
                             CategoryId = report.CategoryId,
                             Name = report.Name,
                             ShortName = report.ShortName,
                             Url = report.Url,
                             UrlFullPath = Commons.Commons.GetReportPathFromDB(report.Url),
                             Description = report.Description,
                             Create_Date = report.Create_Date,
                             Owner = report.Owner ?? 0,
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
                Report_Favorite entity = new Report_Favorite();
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
            if (recently== null)
            {
                Report_Recently entity = new Report_Recently();
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
        #endregion
    }
}