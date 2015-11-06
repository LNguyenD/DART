using System;
using System.Linq;
using EM_Report.BLL.Commons;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Models;

namespace EM_Report.BLL.Services
{
    public interface I_UserService : I_Service<UserModel>
    {
        void UpdateStatus(UserModel model, short status);
        bool IsValidUser(UserModel model);
        bool IsValidUser(UserModel model, int userid);
        UserModel GetUserByUserName(string username);
        UserModel GetUserById(int userid);
        UserModel CreateUser(UserModel model);
        UserModel UpdateUser(UserModel model);
    }
    
    public class UserService : ServiceBase<UserModel, User>, I_UserService
    {
        #region private member variables
        private I_Repository<Status> _statusRepository;
        private I_Repository<SystemUser> _repositorySystemUser;
        private I_Repository<ReportUser> _repositoryReportUser;
        #endregion

        #region public properties
        public I_Repository<Status> StatusRepository
        {
            get { return _statusRepository; }
            set { _statusRepository = value; }
        }

        public I_Repository<SystemUser> RepositorySystemUser
        {
            get { return _repositorySystemUser; }
            set { _repositorySystemUser = value; }
        }

        public I_Repository<ReportUser> RepositoryReportUser
        {
            get { return _repositoryReportUser; }
            set { _repositoryReportUser = value; }
        }
        #endregion

        #region constructor
        public UserService(I_LoginSession session)
            : base(session)
        {
            _statusRepository = new RepositoryBase<Status>(((RepositoryBase<User>)Repository).Context);
            _repositorySystemUser = new RepositoryBase<SystemUser>();
            _repositoryReportUser = new RepositoryBase<ReportUser>();
        }
        #endregion

        #region private method
        protected override UserModel MappingToModel(User tbl)
        {
            return tbl == null ? null : new UserModel()
            {
                UserId = tbl.UserId,
                Password = tbl.Password,
                UserName = tbl.UserName,
                FirstName = tbl.FirstName,
                LastName = tbl.LastName,
                Email = tbl.Email,
                Address = tbl.Address,
                Status = tbl.Status.Value,
                Phone = tbl.Phone,
                Online_Locked_Until_Datetime = tbl.Online_Locked_Until_Datetime,
                Online_No_Of_Login_Attempts =tbl.Online_No_Of_Login_Attempts,
                Last_Online_Login_Date = tbl.Last_Online_Login_Date,
                Create_Date = tbl.Create_Date??DateTime.Now,
                Owner = tbl.Owner??0,
                UpdatedBy = Session!=null?Session.intUserId:0,
                Is_System_User = tbl.Is_System_User
            };
        }

        protected override User MappingToDAL(UserModel tbl)
        {
             return tbl == null ? null : new User()
            {
                UserId = tbl.UserId,
                Password = tbl.Password,
                UserName = tbl.UserName,
                FirstName = tbl.FirstName,
                LastName = tbl.LastName,
                Email = tbl.Email,
                Address = tbl.Address,
                Status = tbl.Status,
                Phone = tbl.Phone,
                Online_Locked_Until_Datetime = tbl.Online_Locked_Until_Datetime,
                Online_No_Of_Login_Attempts = tbl.Online_No_Of_Login_Attempts,
                Last_Online_Login_Date = tbl.Last_Online_Login_Date,
                Create_Date =tbl.Create_Date,
                Owner = tbl.Owner,
                UpdatedBy = Session != null ? Session.intUserId : 0,
                Is_System_User = tbl.Is_System_User
            };
        }

        protected override IQueryable<UserModel> Filter(string keyword, IQueryable<UserModel> query)
        {
            if (string.IsNullOrEmpty(keyword))
            {
                return query;
            }
            var predicate = PredicateBuilder.False<UserModel>();
            predicate = predicate.Or(p => p.UserName.Contains(keyword));
            predicate = predicate.Or(p => p.FirstName.Contains(keyword));
            predicate = predicate.Or(p => p.LastName.Contains(keyword));
            predicate = predicate.Or(p => p.Email.Contains(keyword));             
            return query.Where(predicate);
        }

        protected override IQueryable<UserModel> GetMapping(IQueryable<User> query)
        {
            var statusQuery = StatusRepository.GetQueryable();
            var userQuery = Repository.GetQueryable();
            var result = from q in query
                         join s in statusQuery on q.Status equals s.StatusId
                         join u in userQuery on q.Owner equals u.UserId into temp
                         from u in temp.DefaultIfEmpty()
                         select new UserModel()
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
                             Create_Date = q.Create_Date ?? DateTime.Now,
                             Owner = q.Owner ?? 0,
                             OwnerName = u != null ? u.UserName : string.Empty,
                             StatusName = s.Name,
                             UpdatedBy = Session != null ? Session.intUserId : 0,
                             Is_System_User = q.Is_System_User,
                             System_RoleId = q.SystemUser != null ? q.SystemUser.System_RoleId : 0,
                             Is_External_User = (q.ReportUser != null && q.ReportUser.Is_External_User != null) ? q.ReportUser.Is_External_User.Value : false,
                             TeamId = q.ReportUser != null ? q.ReportUser.TeamId : 0,
                             Organisation_RoleId = q.ReportUser != null ? q.ReportUser.Organisation_RoleId : 0,
                             External_GroupId = q.ReportUser != null ? q.ReportUser.External_GroupId : 0
                         };

            return result;
        }
        #endregion

        #region public method
        public bool IsValidUser(UserModel model)
        {
            return Repository.GetQueryable().Where(l => l.UserName == model.UserName || (l.Email == model.Email && (model.Email??string.Empty) != string.Empty)).Count() <= 0 ? true : false;        
        }

        public bool IsValidUser(UserModel model,int userid)
        {
            return Repository.GetQueryable().Where(l => (l.UserName == model.UserName || (l.Email == model.Email && (model.Email ?? string.Empty) != string.Empty)) && (l.UserId != userid)).Count() <= 0 ? true : false;        
        }        

        public void UpdateStatus(UserModel model, short status)
        {
            model.Status = status;            
            Update(model, model.UserId);            
        }

        public UserModel GetUserById(int userid)
        {
            var user =Repository.GetQueryable().Where(l => l.UserId == userid);
            return GetUserFromMapping(user);
        }

        private UserModel GetUserFromMapping(IQueryable<User> user)
        {
            var result = GetMapping(user);
            if (result != null)
            {
                return result.SingleOrDefault();
            }
            return null;
        }
        
        public UserModel GetUserByUserName(string username)
        {
            var user = Repository.GetQueryable().Where(l=>l.UserName == username);
            return GetUserFromMapping(user);
        }

        public UserModel  CreateUser(UserModel model)
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

        public UserModel UpdateUser(UserModel model)
        {
            Update(model, model.UserId);
            if (model.Is_System_User)
            {
                AddOrUpdateSystemUser(model, model.UserId);
                var reportuser=RepositoryReportUser.GetQueryable().Where(l=>l.UserId==model.UserId).SingleOrDefault();
                if(reportuser!=null)
                {
                    RepositoryReportUser.Delete(reportuser);
                }
            }
            else
            {
                AddOrUpdateReportUser(model, model.UserId);
                var systemuser = RepositorySystemUser.GetQueryable().Where(l => l.UserId == model.UserId).SingleOrDefault();
                if (systemuser != null)
                {
                    RepositorySystemUser.Delete(systemuser);
                }
            }            
            return model;
        }

        protected void CreateReportUser(UserModel model)
        {
            ReportUser _entity = new ReportUser();
            _entity.UserId = model.UserId;            
            _entity.Is_External_User = _entity.Is_External_User;
            if (!model.Is_External_User)
            {
                _entity.Organisation_RoleId = model.Organisation_RoleId;
                _entity.TeamId = model.TeamId;                
            }
            else
            {               
                _entity.External_GroupId = model.External_GroupId; 
            }            
            RepositoryReportUser.Insert(_entity);            
        }
        
        protected void CreateSystemUser(UserModel model)
        {
            SystemUser _entity = new SystemUser();
            _entity.UserId = model.UserId;
            _entity.System_RoleId = model.System_RoleId ?? 0;
            RepositorySystemUser.Insert(_entity);
        }

        protected void AddOrUpdateReportUser(UserModel model,int id)
        {
            ReportUser _entity = RepositoryReportUser.GetQueryable().SingleOrDefault(l => l.UserId == id);
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
                    _entity.TeamId = model.TeamId;                    
                    _entity.Organisation_RoleId = model.Organisation_RoleId;
                }                
                RepositoryReportUser.Update(_entity, id);
            }
            else
            {
                CreateReportUser(model);
            }
        }

        protected void AddOrUpdateSystemUser(UserModel model,int id)
        {
            SystemUser _entity = RepositorySystemUser.GetQueryable().SingleOrDefault(l => l.UserId == id);
            if (_entity != null)
            {
                _entity.UserId = model.UserId;
                _entity.System_RoleId = model.System_RoleId ?? 0;
                RepositorySystemUser.Update(_entity,id);
            }
            else
            {
                CreateSystemUser(model);
            }
        }
        #endregion

    }    
}