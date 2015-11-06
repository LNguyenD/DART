using EM_Report.Common.Utilities;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Domain;
using System.Collections.Generic;
using System.Linq;

namespace EM_Report.BLL.Services
{
    public interface I_UserService : I_Service<User>
    {
        void UpdateStatus(User model, short status);

        bool IsValidUser(User model);

        bool IsValidUser(User model, int userid);

        User GetUserByUserNameOrEmail(string email);

        User GetUserById(int userid);

        User GetUserById(int userid, int systemid);

        User CreateUser(User model);

        User UpdateUser(User model);

        IQueryable<Systems> GetListSystemByUser(string email);

        IQueryable<Systems> GetListSystem();

        IQueryable<User> GetListUserBySystemId(string sort, string keyword, int systemid);
    }

    public class UserService : ServiceBase<User, UserDO>, I_UserService
    {
        #region private member variables

        private I_Repository<StatusDO> _statusRepository;
        private I_Repository<SystemUserDO> _repositorySystemUser;
        private I_Repository<ReportUserDO> _repositoryReportUser;
        private I_Repository<SystemDO> _repositorySystem;
        private I_Repository<Organisation_RoleDO> _repositoryOrganisationRole;
        private I_Repository<Organisation_LevelDO> _repositoryOrganisationLevel;

        #endregion private member variables

        #region public properties

        public I_Repository<StatusDO> StatusRepository
        {
            get { return _statusRepository; }
            set { _statusRepository = value; }
        }

        public I_Repository<SystemUserDO> RepositorySystemUser
        {
            get { return _repositorySystemUser; }
            set { _repositorySystemUser = value; }
        }

        public I_Repository<ReportUserDO> RepositoryReportUser
        {
            get { return _repositoryReportUser; }
            set { _repositoryReportUser = value; }
        }

        public I_Repository<SystemDO> RepositorySystem
        {
            get { return _repositorySystem; }
            set { _repositorySystem = value; }
        }

        public I_Repository<Organisation_RoleDO> RepositoryOrganisationRole
        {
            get { return _repositoryOrganisationRole; }
            set { _repositoryOrganisationRole = value; }
        }

        public I_Repository<Organisation_LevelDO> RepositoryOrganisationLevel
        {
            get { return _repositoryOrganisationLevel; }
            set { _repositoryOrganisationLevel = value; }
        }

        #endregion public properties

        #region constructor

        public UserService(I_LoginSession session)
            : base(session)
        {
            _statusRepository = new RepositoryBase<StatusDO>(((RepositoryBase<UserDO>)Repository).Context);
            _repositorySystemUser = new RepositoryBase<SystemUserDO>(((RepositoryBase<UserDO>)Repository).Context);
            _repositoryReportUser = new RepositoryBase<ReportUserDO>(((RepositoryBase<UserDO>)Repository).Context);
            _repositorySystem = new RepositoryBase<SystemDO>(((RepositoryBase<UserDO>)Repository).Context);
            _repositoryOrganisationRole = new RepositoryBase<Organisation_RoleDO>(((RepositoryBase<UserDO>)Repository).Context);
            _repositoryOrganisationLevel = new RepositoryBase<Organisation_LevelDO>(((RepositoryBase<UserDO>)Repository).Context);
        }

        public UserService(I_Repository<UserDO> repo, I_LoginSession session)
            : base(repo, session)
        {
        }

        #endregion constructor

        #region private method

        protected override IQueryable<User> Filter(string keyword, IQueryable<User> query)
        {
            if (string.IsNullOrEmpty(keyword))
            {
                return query;
            }
            var predicate = PredicateBuilder.False<User>();
            predicate = predicate.Or(p => p.UserName.Contains(keyword));
            predicate = predicate.Or(p => p.FirstName.Contains(keyword));
            predicate = predicate.Or(p => p.LastName.Contains(keyword));
            predicate = predicate.Or(p => p.Email.Contains(keyword));
            return query.Where(predicate);
        }

        protected override IQueryable<User> GetMapping(IQueryable<UserDO> query)
        {
            var statusQuery = StatusRepository.GetQueryable();
            var userQuery = Repository.GetQueryable();
            var result = from q in query
                         join s in statusQuery on q.Status equals s.StatusId
                         join u in userQuery on q.Owner equals u.UserId into temp
                         from u in temp.DefaultIfEmpty()
                         select new User()
                         {
                             UserId = q.UserId,
                             Password = q.Password,
                             UserName = q.UserName,
                             FirstName = q.FirstName,
                             LastName = q.LastName,
                             Email = q.Email,
                             Address = q.Address,
                             Status = q.Status ?? 0,
                             Phone = q.Phone,
                             Online_Locked_Until_Datetime = q.Online_Locked_Until_Datetime,
                             Online_No_Of_Login_Attempts = q.Online_No_Of_Login_Attempts,
                             Last_Online_Login_Date = q.Last_Online_Login_Date,
                             Create_Date = q.Create_Date,
                             Owner = q.Owner ?? 0,
                             OwnerName = u != null ? u.UserName : string.Empty,
                             StatusName = s.Name,
                             UpdatedBy = q.UpdatedBy != null ? q.UpdatedBy : 0,
                             Is_System_User = q.Is_System_User,
                             System_RoleId = q.Is_System_User ? q.SystemUserDO.System_RoleId : 0,
                             Is_External_User = !q.Is_System_User ? q.ReportUserDOs.Where(l => l.UserId == q.UserId).FirstOrDefault().Is_External_User ?? false : false,
                             TeamIdList = new Dictionary<string, int> { },
                             Organisation_RoleIdList = new Dictionary<string, int> { },
                             Organisation_LevelIdList = new Dictionary<string, int> { },
                             External_GroupId = !q.Is_System_User && q.ReportUserDOs.Where(l => l.UserId == q.UserId).FirstOrDefault().Is_External_User != false ? q.ReportUserDOs.Where(l => l.UserId == q.UserId).FirstOrDefault().External_GroupId : 0,
                             Default_System_Id = q.Default_System_Id ?? 2
                         };

            return result;
        }

        #endregion private method

        #region public method

        public bool IsValidUser(User model)
        {
            return Repository.GetQueryable().Where(l => l.UserName == model.UserName || (l.Email == model.Email && (model.Email ?? string.Empty) != string.Empty)).Count() <= 0 ? true : false;
        }

        public bool IsValidUser(User model, int userid)
        {
            return Repository.GetQueryable().Where(l => (l.UserName == model.UserName || (l.Email == model.Email && (model.Email ?? string.Empty) != string.Empty)) && (l.UserId != userid)).Count() <= 0 ? true : false;
        }

        public void UpdateStatus(User model, short status)
        {
            model.Status = status;
            Update(model, model.UserId);
        }

        public User GetUserById(int userid, int systemid)
        {
            var result = new User();
            var user = Repository.GetQueryable().Where(l => l.UserId == userid);
            if (user.Any())
            {
                result = GetUserFromMapping(user);
                if (!result.Is_External_User)
                {
                    result.SystemId = !result.Is_System_User ? GetListSystemByUser(userid).ToList().FirstOrDefault().SystemId : GetListSystem().ToList().FirstOrDefault().SystemId;
                    result.Systems = !result.Is_System_User ? GetListSystemByUser(userid).ToList() : GetListSystem().ToList();
                    result.LevelId = !result.Is_System_User ? RepositoryOrganisationRole.GetByPK(RepositoryReportUser.GetQueryable().Where(l => l.UserId == userid).FirstOrDefault().Organisation_RoleId).LevelId ?? 0 : 0;

                    // get organisation level list
                    var query = from l in RepositoryOrganisationLevel.GetQueryable()
                                join o in RepositoryOrganisationRole.GetQueryable() on l.LevelId equals o.LevelId
                                join r in RepositoryReportUser.GetQueryable() on o.Organisation_RoleId equals r.Organisation_RoleId
                                where (r.UserId == userid)
                                select new { l, o };

                    foreach (var s in RepositorySystem.GetQueryable())
                    {
                        var roleListQuery = query.Where(l => l.l.SystemId == s.SystemId);
                        if (roleListQuery.Any())
                        {
                            result.Organisation_LevelIdList[s.Name] = roleListQuery.FirstOrDefault().o.LevelId ?? 0;
                        }
                        else
                        {
                            result.Organisation_LevelIdList[s.Name] = 0;
                        }
                    }
                }
            }

            return result;
        }

        public User GetUserById(int userid)
        {
            var result = new User();
            var user = Repository.GetQueryable().Where(l => l.UserId == userid);
            if (user.Any())
            {
                result = GetUserFromMapping(user);
                if (!result.Is_External_User)
                {
                    var query = from l in RepositoryOrganisationLevel.GetQueryable()
                                join o in RepositoryOrganisationRole.GetQueryable() on l.LevelId equals o.LevelId
                                join r in RepositoryReportUser.GetQueryable() on o.Organisation_RoleId equals r.Organisation_RoleId
                                where (r.UserId == userid)
                                select new { l, r };

                    foreach (var s in RepositorySystem.GetQueryable())
                    {
                        var rolistquerry = query.Where(l => l.l.SystemId == s.SystemId);

                        if (rolistquerry.Any())
                        {
                            result.Organisation_RoleIdList[s.Name] = rolistquerry.FirstOrDefault().r.Organisation_RoleId ?? 0;
                            result.TeamIdList[s.Name] = rolistquerry.FirstOrDefault().r.TeamId ?? 0;
                        }
                        else
                        {
                            result.Organisation_RoleIdList[s.Name] = 0;
                            result.TeamIdList[s.Name] = 0;
                        }
                    }
                }
            }

            return result;
        }

        private User GetUserFromMapping(IQueryable<UserDO> user)
        {
            var result = GetMapping(user);
            if (result != null)
            {
                return result.FirstOrDefault();
            }
            return null;
        }

        public User GetUserByUserNameOrEmail(string usernameoremail)
        {
            var user = Repository.GetQueryable().Where(l => l.UserName == usernameoremail || l.Email == usernameoremail);
            return GetUserFromMapping(user);
        }

        public User CreateUser(User model)
        {
            model.UserId = Create(model).UserId;
            if (model.Is_System_User)
            {
                CreateSystemUser(model);
            }
            else
            {
                CreateReportUser(model);
            }
            return model;
        }

        public User UpdateUser(User model)
        {
            Update(model, model.UserId);
            if (model.Is_System_User)
            {
                AddOrUpdateSystemUser(model, model.UserId);
                var reportuser = RepositoryReportUser.GetQueryable().Where(l => l.UserId == model.UserId);

                if (reportuser != null)
                {
                    foreach (var reportuseritem in reportuser)
                    {
                        RepositoryReportUser.Delete(reportuseritem);
                    }
                }
            }
            else
            {
                var systemuser = RepositorySystemUser.GetQueryable().Where(l => l.UserId == model.UserId);
                if (systemuser.Any())
                {
                    foreach (var systemuseritem in systemuser)
                    {
                        RepositorySystemUser.Delete(systemuseritem);
                    }
                }

                var reportuser = RepositoryReportUser.GetQueryable().Where(l => l.UserId == model.UserId);
                if (reportuser != null)
                {
                    foreach (var reportuseritem in reportuser)
                    {
                        RepositoryReportUser.Delete(reportuseritem);
                    }
                }

                CreateReportUser(model);
            }
            return model;
        }

        public IQueryable<Systems> GetListSystemByUser(string email)
        {
            var userIds = Repository.GetQueryable().Where(l => l.Email == email).Select(l => l.UserId);
            var reportusers = RepositoryReportUser.GetQueryable().Where(l => l.Is_External_User == false && userIds.Contains(l.UserId));

            var result = (from reportuser in reportusers
                          join organisationrole in RepositoryOrganisationRole.GetQueryable() on reportuser.Organisation_RoleId equals organisationrole.Organisation_RoleId into temp2
                          from organisationrole in temp2.DefaultIfEmpty()
                          join organisationlevel in RepositoryOrganisationLevel.GetQueryable() on organisationrole.LevelId equals organisationlevel.LevelId into temp3
                          from organisationlevel in temp3.DefaultIfEmpty()
                          join system in RepositorySystem.GetQueryable() on organisationlevel.SystemId equals system.SystemId into temp4
                          from system in temp4.DefaultIfEmpty()
                          select new Systems()
                          {
                              Name = system.Name,
                              SystemId = system.SystemId,
                              Description = system.Description,
                              Owner = system.Owner,
                              UpdatedBy = system.UpdatedBy ?? 0,
                              Status = system.Status ?? 0,
                              Create_Date = system.Create_Date
                          }).Distinct();
            return result;
        }

        public IQueryable<Systems> GetListSystemByUser(int userId)
        {
            var reportusers = RepositoryReportUser.GetQueryable().Where(l => l.Is_External_User == false && l.UserId == userId);

            var result = (from reportuser in reportusers
                          join organisationrole in RepositoryOrganisationRole.GetQueryable() on reportuser.Organisation_RoleId equals organisationrole.Organisation_RoleId into temp2
                          from organisationrole in temp2.DefaultIfEmpty()
                          join organisationlevel in RepositoryOrganisationLevel.GetQueryable() on organisationrole.LevelId equals organisationlevel.LevelId into temp3
                          from organisationlevel in temp3.DefaultIfEmpty()
                          join system in RepositorySystem.GetQueryable() on organisationlevel.SystemId equals system.SystemId into temp4
                          from system in temp4.DefaultIfEmpty()
                          select new Systems()
                          {
                              Name = system.Name,
                              SystemId = system.SystemId,
                              Description = system.Description,
                              Owner = system.Owner,
                              UpdatedBy = system.UpdatedBy ?? 0,
                              Status = system.Status ?? 0,
                              Create_Date = system.Create_Date
                          }).Distinct();
            return result;
        }

        public IQueryable<User> GetListUserBySystemId(string sort, string keyword, int systemid)
        {
            var result = from q in GetAllQueryable(sort, keyword)
                         join reportuser in RepositoryReportUser.GetQueryable() on q.UserId equals reportuser.UserId into temp1
                         from reportuser in temp1.DefaultIfEmpty()
                         join organisationrole in RepositoryOrganisationRole.GetQueryable() on reportuser.Organisation_RoleId equals organisationrole.Organisation_RoleId into temp2
                         from organisationrole in temp2.DefaultIfEmpty()
                         join organisationlevel in RepositoryOrganisationLevel.GetQueryable() on organisationrole.LevelId equals organisationlevel.LevelId into temp3
                         from organisationlevel in temp3.DefaultIfEmpty()
                         join system in RepositorySystem.GetQueryable() on organisationlevel.SystemId equals system.SystemId into temp4
                         from system in temp4.DefaultIfEmpty()
                         where system.SystemId == systemid

                         select q;
            return result;
        }

        public IQueryable<Systems> GetListSystem()
        {
            var result = from system in RepositorySystem.GetQueryable()
                         select new Systems()
                         {
                             Name = system.Name,
                             SystemId = system.SystemId,
                             Description = system.Description,
                             Owner = system.Owner,
                             UpdatedBy = system.UpdatedBy ?? 0,
                             Status = system.Status ?? 0,
                             Create_Date = system.Create_Date
                         };
            return result;
        }

        protected void CreateReportUser(User model)
        {
            if (model.Is_External_User)
            {
                ReportUserDO _entity = new ReportUserDO();
                _entity.UserId = model.UserId;
                _entity.Is_External_User = true;
                _entity.External_GroupId = model.External_GroupId;
                RepositoryReportUser.Insert(_entity);
            }
            else
            {
                var lstSystem = RepositorySystem.GetQueryable();// GetSystemList();
                foreach (var systemitem in lstSystem)
                {
                    ReportUserDO _entity = new ReportUserDO();
                    _entity.UserId = model.UserId;
                    _entity.Is_External_User = false;
                    //if (!model.Is_External_User)
                    //{
                    if (model.Organisation_RoleIdList[systemitem.Name] != 0)
                    {
                        _entity.Organisation_RoleId = model.Organisation_RoleIdList[systemitem.Name];
                        if (model.TeamIdList[systemitem.Name] != 0)
                        {
                            if (model.TeamIdList[systemitem.Name] != 0) _entity.TeamId = model.TeamIdList[systemitem.Name];
                        }
                        RepositoryReportUser.Insert(_entity);
                    }
                }
            }
        }

        protected void CreateSystemUser(User model)
        {
            SystemUserDO _entity = new SystemUserDO();
            _entity.UserId = model.UserId;
            _entity.System_RoleId = model.System_RoleId ?? 0;
            RepositorySystemUser.Insert(_entity);
        }

        protected void AddOrUpdateReportUser(User model, int id)
        {
            ReportUserDO _entity = RepositoryReportUser.GetQueryable().SingleOrDefault(l => l.UserId == id);

            if (_entity != null)
            {
                _entity.Is_External_User = model.Is_External_User;
                if (model.Is_External_User)
                {
                    _entity.External_GroupId = model.External_GroupId;
                    _entity.Organisation_RoleId = null;
                    _entity.TeamId = null;
                }
                else
                {
                    _entity.External_GroupId = null;
                }
                RepositoryReportUser.Update(_entity, id);
            }
            else
            {
                CreateReportUser(model);
            }
        }

        protected void AddOrUpdateSystemUser(User model, int id)
        {
            SystemUserDO _entity = RepositorySystemUser.GetQueryable().SingleOrDefault(l => l.UserId == id);
            if (_entity != null)
            {
                _entity.UserId = model.UserId;
                _entity.System_RoleId = model.System_RoleId ?? _entity.System_RoleId;
                RepositorySystemUser.Update(_entity, id);
            }
            else
            {
                CreateSystemUser(model);
            }
        }

        #endregion public method
    }
}