using System;
using System.Linq;
using System.Collections.Generic;
using EM_Report.Common.Utilities;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Domain;

namespace EM_Report.BLL.Services
{
    public interface I_Organisation_RolesService : I_Service<Organisation_Roles>
    {        
        void UpdateStatus(Organisation_Roles model, short status);
        void UpdateLevel(int roleid, int levelid, int userId);
        IQueryable<Organisation_Roles> GetRoleOfLevel(int levelId);
        bool IsTeamLeaderOrAbove(int organisationId);
    }

    public class Organisation_RolesService : ServiceBase<Organisation_Roles, Organisation_RoleDO>, I_Organisation_RolesService
    {
        private I_Repository<UserDO> _userRepository;
        private I_Repository<StatusDO> _statusRepository;
        private I_Repository<Organisation_LevelDO> _levelRepository; 
        
        public I_Repository<Organisation_LevelDO> LevelRepository
        {
            get { return _levelRepository; }
            set { _levelRepository = value; }
        }

        public I_Repository<StatusDO> StatusRepository
        {
            get { return _statusRepository; }
            set { _statusRepository = value; }
        }
        public I_Repository<UserDO> UserRepository
        {
            get { return _userRepository; }
            set { _userRepository = value; }
        }

        public Organisation_RolesService(I_LoginSession session)
            : base(session)
        {
            _statusRepository = new RepositoryBase<StatusDO>(((RepositoryBase<Organisation_RoleDO>)Repository).Context);
            _userRepository = new RepositoryBase<UserDO>(((RepositoryBase<Organisation_RoleDO>)Repository).Context);
            _levelRepository = new RepositoryBase<Organisation_LevelDO>(((RepositoryBase<Organisation_RoleDO>)Repository).Context);            
        }

        public Organisation_RolesService(I_Repository<Organisation_RoleDO> repo, I_LoginSession session) : base(repo, session) { }

        protected override IQueryable<Organisation_Roles> Filter(string keyword, IQueryable<Organisation_Roles> query)
        {
            if (string.IsNullOrEmpty(keyword))
            {
                return query;
            }
            var predicate = PredicateBuilder.False<Organisation_Roles>();
            predicate = predicate.Or(p => p.Name.Contains(keyword));
            predicate = predicate.Or(p => p.Description.Contains(keyword));
            predicate = predicate.Or(p => p.StatusName.Contains(keyword));
            predicate = predicate.Or(p => p.OwnerName.Contains(keyword));
            return query.Where(predicate);
        }

        protected override IQueryable<Organisation_Roles> GetMapping(IQueryable<Organisation_RoleDO> query)
        {
            var statusQuery = StatusRepository.GetQueryable();
            var levelQuery = LevelRepository.GetQueryable();
            var userQuery = UserRepository.GetQueryable();            
            var result = from q in query
                         join s in statusQuery on q.Status equals s.StatusId 
                         join level in levelQuery on q.LevelId equals level.LevelId into lvlTemp
                         from level in lvlTemp.DefaultIfEmpty()                        
                         join u in userQuery on q.Owner equals u.UserId into temp                         
                         from u in temp.DefaultIfEmpty()                         
                         select new Organisation_Roles()
                         {
                             Organisation_RoleId = q.Organisation_RoleId,
                             Name = q.Name,
                             Description = q.Description,
                             Status = q.Status ?? 0,
                             Create_Date = q.Create_Date ?? DateTime.Now,
                             Owner = q.Owner ?? 0,
                             OwnerName = u != null ? u.UserName : string.Empty,
                             StatusName = s.Name,
                             UpdatedBy = q.UpdatedBy != null ? q.UpdatedBy : 0,
                             LevelId = q.LevelId ?? 0,
                             LevelName = level != null ? level.Name : string.Empty,
                             SystemId = level.SystemId
                         };

            return result;
        }       
        
        public void UpdateStatus(Organisation_Roles model, short status)
        {
            model.Status = status;
            Update(model,model.Organisation_RoleId);
        }        

        public void UpdateLevel(int roleid, int levelid, int userId)
        {
            Dictionary<string, object> dicParams = new Dictionary<string, object>();
            dicParams.Add("@roleid", roleid);
            dicParams.Add("@levelid", levelid);
            dicParams.Add("@updatedby", userId);
            Repository.ExecuteNonQueryStoreProcedure("sp_Update_OrganisationRole_Level", dicParams);   
        }

        public IQueryable<Organisation_Roles> GetRoleOfLevel(int levelId)
        {
            return base.GetAllQueryable("Name|asc", string.Empty).Where(r => r.LevelId == levelId);
        }

        public bool IsTeamLeaderOrAbove(int organisationId)
        {
            Organisation_Levels_Service organisationLevelsService = new Organisation_Levels_Service(base.Session);
            var levelIds = organisationLevelsService.GetLevelsWithHigherOrEqualPermission("Level 4 - TL").Select(t => t.LevelId);
            if(levelIds.ToList().Count == 0)
            {
                var levelId = Repository.GetQueryable().Where(r => r.Name.Contains("Team Leader")).Select(r => r.LevelId).ToList()[0];
                string levelName = organisationLevelsService.GetById(levelId).Name;
                levelIds = organisationLevelsService.GetLevelsWithHigherOrEqualPermission(levelName).Select(t => t.LevelId);
            }
            
            var satisfyRoles = base.GetAllQueryable("Name|asc", string.Empty).Where(r => levelIds.Contains(r.LevelId));
            return satisfyRoles.Any(r => r.Organisation_RoleId == organisationId);
        }
    }    
}