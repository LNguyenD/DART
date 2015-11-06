using System;
using System.Linq;
using System.Collections.Generic;
using EM_Report.BLL.Commons;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Models;

namespace EM_Report.BLL.Services
{
    public interface I_Organisation_RolesService : I_Service<Organisation_RolesModel>
    {
        void UpdateStatus(Organisation_RolesModel model, short status);
        void UpdateLevel(int roleid, int levelid);
        IQueryable<Organisation_RolesModel> GetRoleOfLevel(int levelId);
        bool IsTeamLeaderOrAbove(int organisationId);
    }

    public class Organisation_RolesService : ServiceBase<Organisation_RolesModel, Organisation_Role>, I_Organisation_RolesService
    {
        private I_Repository<User> _userRepository;
        private I_Repository<Status> _statusRepository;
        private I_Repository<Organisation_Level> _levelRepository;

        public I_Repository<Organisation_Level> LevelRepository
        {
            get { return _levelRepository; }
            set { _levelRepository = value; }
        }

        public I_Repository<Status> StatusRepository
        {
            get { return _statusRepository; }
            set { _statusRepository = value; }
        }
        public I_Repository<User> UserRepository
        {
            get { return _userRepository; }
            set { _userRepository = value; }
        }

        public Organisation_RolesService(I_LoginSession session)
            : base(session)
        {
            _statusRepository = new RepositoryBase<Status>(((RepositoryBase<Organisation_Role>)Repository).Context);
            _userRepository = new RepositoryBase<User>(((RepositoryBase<Organisation_Role>)Repository).Context);
            _levelRepository = new RepositoryBase<Organisation_Level>(((RepositoryBase<Organisation_Role>)Repository).Context);
        }
        
        protected override Organisation_RolesModel MappingToModel(Organisation_Role tbOrganisation_Roles)
        {
            return tbOrganisation_Roles == null ? null : new Organisation_RolesModel()
            {
                Organisation_RoleId = tbOrganisation_Roles.Organisation_RoleId,
                Name = tbOrganisation_Roles.Name,
                Description = tbOrganisation_Roles.Description,
                Status = tbOrganisation_Roles.Status??0,
                Create_Date = tbOrganisation_Roles.Create_Date??DateTime.Now,
                Owner = tbOrganisation_Roles.Owner ?? 0,
                UpdatedBy = Session.intUserId,
                LevelId = tbOrganisation_Roles.LevelId ?? 0,
                LevelName = tbOrganisation_Roles.Organisation_Level != null ? tbOrganisation_Roles.Organisation_Level.Name : string.Empty
            };
        }

        protected override Organisation_Role MappingToDAL(Organisation_RolesModel tbOrganisation_Roles)
        {
            return tbOrganisation_Roles == null ? null : new Organisation_Role()
            {
                Organisation_RoleId = tbOrganisation_Roles.Organisation_RoleId,
                Name = tbOrganisation_Roles.Name,
                Description = tbOrganisation_Roles.Description,
                Status = short.Parse(tbOrganisation_Roles.Status.ToString()),
                Create_Date = tbOrganisation_Roles.Create_Date,
                Owner = tbOrganisation_Roles.Owner,
                UpdatedBy = Session.intUserId,
                LevelId = tbOrganisation_Roles.LevelId,
            };
        }        

        protected override IQueryable<Organisation_RolesModel> Filter(string keyword, IQueryable<Organisation_RolesModel> query)
        {
            if (string.IsNullOrEmpty(keyword))
            {
                return query;
            }
            var predicate = PredicateBuilder.False<Organisation_RolesModel>();
            predicate = predicate.Or(p => p.Name.Contains(keyword));
            predicate = predicate.Or(p => p.Description.Contains(keyword));
            predicate = predicate.Or(p => p.StatusName.Contains(keyword));
            predicate = predicate.Or(p => p.OwnerName.Contains(keyword));
            return query.Where(predicate);
        }
        
        protected override IQueryable<Organisation_RolesModel> GetMapping(IQueryable<Organisation_Role> query)
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
                         select new Organisation_RolesModel()
                         {
                             Organisation_RoleId = q.Organisation_RoleId,
                             Name = q.Name,
                             Description = q.Description,
                             Status = q.Status ?? 0,
                             Create_Date = q.Create_Date ?? DateTime.Now,
                             Owner = q.Owner ?? 0,
                             OwnerName = u != null ? u.UserName : string.Empty,
                             StatusName = s.Name,
                             UpdatedBy = Session.intUserId,
                             LevelId = q.LevelId ?? 0,
                             LevelName = level != null ? level.Name : string.Empty
                         };

            return result;
        }
       
        public void UpdateStatus(Organisation_RolesModel model, short status)
        {
            model.Status = status;
            Update(model,model.Organisation_RoleId);
        }

        public void UpdateLevel(int roleid, int levelid)
        {
            Dictionary<string, object> dicParams = new Dictionary<string, object>();
            dicParams.Add("@roleid", roleid);
            dicParams.Add("@levelid", levelid);
            dicParams.Add("@updatedby", Session.intUserId);
            Repository.ExecuteNonQueryStoreProcedure("sp_Update_OrganisationRole_Level", dicParams);   
        }

        public IQueryable<Organisation_RolesModel> GetRoleOfLevel(int levelId)
        {
            return base.GetAllQueryable("Name|asc", string.Empty).Where(r => r.LevelId == levelId);
        }

        public bool IsTeamLeaderOrAbove(int organisationId)
        {
            var levelIds = new Organisation_Levels_Service(base.Session).GetLevelsWithHigherOrEqualPermission("Team Leader").Select(t => t.LevelId);
            var satisfyRoles = base.GetAllQueryable("Name|asc", string.Empty).Where(r => levelIds.Contains(r.LevelId));
            return satisfyRoles.Any(r => r.Organisation_RoleId == organisationId);
        }
    }    
}