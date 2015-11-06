using EM_Report.Common.Utilities;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Domain;
using LinqKit;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System;
using System.IO;
using System.Web;
using System.Configuration;
using System.Security.Cryptography;

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

        //User_Ext GetUserByEmail(string email);

        //User_Ext GetUserByUserName(string username);

        User_Ext GetUserExtInfo(string usernameoremail);

        int SendmailResetPassword(string email, string resetpasswordurl);

        int SendmailCreateNewUser(string email, string firstname, string lastname, string password);

        IQueryable<User> GetUserbyCronJob(bool isinternaluser);

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
        private I_Repository<UserDO> _repositoryUser;

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

        public I_Repository<UserDO> RepositoryUser 
        {
            get { return RepositoryUser; }
            set { RepositoryUser = value; }
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
            _repositoryUser = new RepositoryBase<UserDO>(((RepositoryBase<UserDO>)Repository).Context);
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
            var systemUserQuery = RepositorySystemUser.GetQueryable();
            var reportuserQuery = RepositoryReportUser.GetQueryable();
            var result = from q in query
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
                             OwnerName = q.UserName,
                             StatusName = (from st in statusQuery where st.StatusId == q.Status select st.Name).FirstOrDefault(),
                             UpdatedBy = q.UpdatedBy != null ? q.UpdatedBy : 0,
                             Is_System_User = q.Is_System_User,
                             System_RoleId = q.Is_System_User ? (from s in systemUserQuery where s.UserId == q.UserId select s.System_RoleId).FirstOrDefault() : 0,
                             Is_External_User = !q.Is_System_User ? (from ru in reportuserQuery where ru.UserId == q.UserId select ru.Is_External_User).FirstOrDefault() ?? false : false,
                             External_GroupId = !q.Is_System_User && (from ru in reportuserQuery where ru.UserId == q.UserId select ru.Is_External_User).FirstOrDefault() != false ? (from ru in reportuserQuery where ru.UserId == q.UserId select ru.External_GroupId).FirstOrDefault() : 0,
                             //Is_External_User = !q.Is_System_User ? q.ReportUserDOs.Where(l => l.UserId == q.UserId).FirstOrDefault().Is_External_User ?? false : false,                            
                             //Is_External_User = q.Is_System_User == false ? reportuserQuery.Where(l => l.UserId == q.UserId).FirstOrDefault().Is_External_User ?? false : false,                            
                             //External_GroupId = !q.Is_System_User && q.ReportUserDOs.Where(l => l.UserId == q.UserId).FirstOrDefault().Is_External_User != false ? q.ReportUserDOs.Where(l => l.UserId == q.UserId).FirstOrDefault().External_GroupId : 0,
                             //External_GroupId = q.Is_System_User == false && reportuserQuery.Where(l => l.UserId == q.UserId).FirstOrDefault().Is_External_User != false ? reportuserQuery.Where(l => l.UserId == q.UserId).FirstOrDefault().External_GroupId : 0,
                             //Is_External_User = ru.Is_External_User ?? false,
                             //External_GroupId = ru.External_GroupId ?? 0,
                             Default_System_Id = q.Default_System_Id ?? 2
                         };

            return result;
           
        }

        #endregion private method

        #region public method

        public IQueryable<User> GetUserbyCronJob(bool isinternaluser)
        {
            if (!isinternaluser)
            {
                var user = Repository.GetQueryable();
                var reportusers = RepositoryReportUser.GetQueryable();

                var result = (from l in user
                              join p in reportusers on l.UserId equals p.UserId
                              where l.Is_System_User == false && p.Is_External_User == true
                              select new User()
                              {
                                  UserId = l.UserId,
                                  UserName = l.UserName,
                                  Password = l.Password,
                                  FirstName = l.FirstName,
                                  LastName = l.LastName,
                                  Address = l.Address,
                                  Email = l.Email,
                                  Status = l.Status ?? 0,
                                  Phone = l.Phone,
                                  Online_Locked_Until_Datetime = l.Online_Locked_Until_Datetime,
                                  Online_No_Of_Login_Attempts = l.Online_No_Of_Login_Attempts,
                                  Last_Online_Login_Date = l.Last_Online_Login_Date,
                                  Create_Date = l.Create_Date,
                                  Owner = l.Owner,
                                  UpdatedBy = l.UpdatedBy,
                                  Is_System_User = l.Is_System_User,
                                  Default_System_Id = l.Default_System_Id
                              }).Take(1);

                return result;
            }     
            else
            {
                var user = Repository.GetQueryable().Where(l => l.Is_System_User == true && l.Last_Online_Login_Date != null && l.Password == "").OrderByDescending(l => l.Last_Online_Login_Date).Take(1);
                return GetMapping(user);
            }
        }

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
                else
                {
                    var lstSystem = GetUserExtInfo(result.UserName).SystemList;
                    foreach (var s in RepositorySystem.GetQueryable())
                    {
                        var GroupId = 0;
                        foreach(var system in lstSystem)
                        {
                            if (system.Name == s.Name)
                                GroupId = system.External_GroupId;
                        }
                        result.External_GroupIdList.Add(s.Name, GroupId); 
                    }
                }
            }

            return result;
        }

        private IQueryable<User_Ext> GetUser_ExtMapping(IQueryable<UserDO> query)
        {            
            var result = from q in query.ToList()

                         select new User_Ext()
                         {
                             UserId = q.UserId,
                             UserName = q.UserName,
                             Password = q.Password,                             
                             FirstName = q.FirstName,
                             LastName = q.LastName,
                             Address = q.Address,
                             Email = q.Email,                             
                             Status = q.Status ?? 0,
                             Phone = q.Phone,
                             Online_Locked_Until_Datetime = q.Online_Locked_Until_Datetime,
                             Online_No_Of_Login_Attempts = q.Online_No_Of_Login_Attempts,
                             Last_Online_Login_Date = q.Last_Online_Login_Date,
                             Create_Date = q.Create_Date,                             
                             UpdatedBy = q.UpdatedBy,
                             Is_System_User = q.Is_System_User,
                             Default_System_Id = q.Default_System_Id                             
                         };

            return result.ToList().AsQueryable();
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
                var reportuser = RepositoryReportUser.GetQueryable().Where(l => l.UserId == model.UserId).ToList();

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
                var systemuser = RepositorySystemUser.GetQueryable().Where(l => l.UserId == model.UserId).ToList();
                if (systemuser.Any())
                {
                    foreach (var systemuseritem in systemuser)
                    {
                        RepositorySystemUser.Delete(systemuseritem);
                    }
                }

                var reportuser = RepositoryReportUser.GetQueryable().Where(l => l.UserId == model.UserId).ToList();
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
                var lstSystem = RepositorySystem.GetQueryable().ToList();// GetSystemList();
                foreach (var systemitem in lstSystem)
                {
                    ReportUserDO _entity = new ReportUserDO();
                    _entity.UserId = model.UserId;
                    _entity.Is_External_User = true;
                    if (model.External_GroupIdList[systemitem.Name] != 0)
                    {
                        _entity.External_GroupId = model.External_GroupIdList[systemitem.Name];
                        RepositoryReportUser.Insert(_entity);
                    }
                }
            }
            else
            {
                var lstSystem = RepositorySystem.GetQueryable().ToList();// GetSystemList();
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

        public User_Ext GetUserExtInfo(string usernameoremail)
        {
            var storeParams = new Dictionary<string, object>();
            storeParams.Add("UserNameOrEmail", usernameoremail);

            var data = Repository.ExecuteDataStoreProcedure("usp_GetUserInfo", storeParams);
            var result = new User_Ext();
            foreach (DataRow row in data.Rows)
            {
                result.UserId = (int)(row["UserId"]);
                result.UserName = (string)(row["UserName"]);
                result.Password = (string)(row["Password"]) ?? string.Empty;
                result.FirstName = (string)(row["FirstName"]) ?? string.Empty;
                result.LastName = (string)(row["LastName"]) ?? string.Empty;
                result.Address = (row["Address"] == DBNull.Value) ? string.Empty : (row["Address"].ToString());
                result.Email = (row["Email"] == DBNull.Value) ? string.Empty : (row["Email"].ToString());
                result.Status = (short)(row["Status"]);
                result.Phone = (row["Phone"] == DBNull.Value) ? string.Empty : (row["Phone"].ToString());
                result.Online_Locked_Until_Datetime = row["Online_Locked_Until_Datetime"] == Convert.DBNull ? (DateTime?)null : Convert.ToDateTime(row["Online_Locked_Until_Datetime"].ToString());
                result.Online_No_Of_Login_Attempts = row["Online_No_Of_Login_Attempts"] == Convert.DBNull ? (short?)null : short.Parse(row["Online_No_Of_Login_Attempts"].ToString());
                result.Last_Online_Login_Date = row["Last_Online_Login_Date"] == Convert.DBNull ? (DateTime?)null : Convert.ToDateTime(row["Last_Online_Login_Date"].ToString());
                result.Create_Date = row["Create_Date"] == Convert.DBNull ? (DateTime?)null : Convert.ToDateTime(row["Create_Date"].ToString());
                result.Owner = row["Owner"] == DBNull.Value ? (int?)null : (int)(row["Owner"]);
                result.UpdatedBy = row["UpdatedBy"] == Convert.DBNull ? (int?)null : int.Parse(row["UpdatedBy"].ToString());
                result.Is_System_User = (bool)(row["Is_System_User"]);
                result.Default_System_Id = (int)(row["Default_System_Id"]);                
                result.Is_External_User = (bool)(row["Is_External_User"]);

                var lstSystem = new List<Domain.Systems>();                
                foreach (String st in row["List_Of_System_Group"].ToString() != string.Empty && row["List_Of_System_Group"].ToString() != "" ? (row["List_Of_System_Group"]).ToString().Split(',') : null)
                {
                    var systemId = st.Split('_')[0];
                    var systemName = st.Split('_')[1];
                    var groupId = st.Split('_')[2];
                    var groupName = st.Split('_')[3];
                    var system = new Domain.Systems();
                    system.SystemId = int.Parse(systemId);
                    system.Name = systemName;
                    if (result.Is_External_User)
                    {
                        system.External_GroupId = int.Parse(groupId);
                        system.External_GroupName = groupName.ToString();
                    }
                    else
                        system.LevelId = int.Parse(groupId);

                    lstSystem.Add(system);
                };
                result.SystemList = lstSystem;

                result.Organisation_RoleIdList = row["List_Of_OrganisationRoleId"].ToString() == string.Empty ? (List<Int32>)null : (row["List_Of_OrganisationRoleId"]).ToString().Split(',').Select(Int32.Parse).ToList();
                result.Organisation_LevelIdList = row["List_Of_OrganisationLevelId"].ToString() == string.Empty ? (List<Int32>)null : (row["List_Of_OrganisationLevelId"]).ToString().Split(',').Select(Int32.Parse).ToList();
                result.System_RoleId = row["System_RoleId"] == Convert.DBNull ? (int?)null : int.Parse(row["System_RoleId"].ToString()); 
                
                
                var System_Role_PermissionList = new List<Domain.System_Role_Permissions>();
                if (result.Is_System_User)
                {
                    foreach (var st in row["List_Of_System_Role_Permissions"] != Convert.DBNull && row["List_Of_System_Role_Permissions"].ToString() != "" ? (row["List_Of_System_Role_Permissions"]).ToString().Split(',') : null)
                    {
                        var systemRoleId = st.Split('_')[0];
                        var systemPermissionId = st.Split('_')[1];
                        var PermissionId = st.Split('_')[2];

                        var System_Role_Permissions = new Domain.System_Role_Permissions();
                        System_Role_Permissions.System_RoleId = int.Parse(systemRoleId);
                        System_Role_Permissions.System_PermissionId = int.Parse(systemPermissionId);
                        System_Role_Permissions.PermissionId = int.Parse(PermissionId);
                        System_Role_PermissionList.Add(System_Role_Permissions);
                    };
                }
                result.System_Role_PermissionList = System_Role_PermissionList;
                
                if(result.Is_External_User)
                { 
                    result.External_GroupIdList = row["List_Of_External_GroupId"]==DBNull.Value ? (List<Int32>)null : (row["List_Of_External_GroupId"]).ToString().Split(',').Select(Int32.Parse).ToList();
                }
                result.LandingPage_Url = (row["LandingPage_Url"] == DBNull.Value) ? string.Empty : (row["LandingPage_Url"].ToString());
                result.Default_System_Name = (row["Default_System_Name"] == DBNull.Value) ? string.Empty : (row["Default_System_Name"].ToString());
            }



            return result;
        }
        public int SendmailResetPassword(string email, string resetpasswordurl)
        {
            var returnValue = 0;
            var user = GetUserByUserNameOrEmail(email);
            if (user != null && user.Is_External_User == true)
            {
                var password = user.Password;
                var username = user.UserName.Substring(user.UserName.IndexOf("\\") + 1);
                var timeToExpired = DateTime.Now.AddHours(double.Parse(ConfigurationSettings.AppSettings["ResetPasswordTokenTimeToExpiredByHour"])).ToString();
                var secureCheck = EM_Report.Common.Utilities.EnCryption.Encrypt(password + "<" + timeToExpired);
                secureCheck = secureCheck.Replace("=", "@").Replace("#","|");
                string urlConfirmation = resetpasswordurl.Remove(resetpasswordurl.LastIndexOf("/") + 1) + "ResetPassword?email=" + email + "&securecheck=" + secureCheck;
                string mailbodytemplate = Path.Combine(HttpRuntime.AppDomainAppPath, ConfigurationSettings.AppSettings["ResetPasswordEmaiTemplate"]);
                var mailbody = System.IO.File.ReadAllText(mailbodytemplate);
                mailbody = mailbody.Replace("{UserName}", username);
                mailbody = mailbody.Replace("{Dart_Account_ResetPassword_Active_Link}", urlConfirmation);
                Common.Utilities.Commons.SendMail(user.Email, ConfigurationSettings.AppSettings["ResetPasswordEmailSubject"], mailbody, ConfigurationSettings.AppSettings["MailFrom"], ConfigurationSettings.AppSettings["MailHost"]);
                returnValue = 1;
            }
            return returnValue;
        }
        public int SendmailCreateNewUser(string email, string firstname, string lastname, string password)
        {
            var returnValue = 0;
            if (email != string.Empty)
            {
                string mailbody = ConfigurationSettings.AppSettings["MailNewAccountBody"];
                mailbody = mailbody.Replace("[FullName]", firstname + " " + lastname);
                mailbody = mailbody.Replace("[UserName]", email);
                mailbody = mailbody.Replace("[Password]", password);
                Common.Utilities.Commons.SendMail(email, ConfigurationSettings.AppSettings["MailNewAccountSubject"], mailbody, ConfigurationSettings.AppSettings["MailFrom"], ConfigurationSettings.AppSettings["MailHost"]);
                returnValue = 1;
            }
            return returnValue;
        }
        #endregion public method
    }
}