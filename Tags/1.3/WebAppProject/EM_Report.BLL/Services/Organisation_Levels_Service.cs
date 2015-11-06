using System;
using System.Linq;
using System.Collections.Generic;
using EM_Report.BLL.Commons;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Models;

namespace EM_Report.BLL.Services
{
    public interface I_Organisation_Levels_Service : I_Service<Organisation_Levels_Model>
    {
        Organisation_Levels_Model CreateOrUpdate(Organisation_Levels_Model model);
        void ReArrangeLevel(string data);
    }

    public class Organisation_Levels_Service : ServiceBase<Organisation_Levels_Model, Organisation_Level>, I_Organisation_Levels_Service
    {
        private I_Repository<User> _userRepository;

        public I_Repository<User> UserRepository
        {
            get { return _userRepository; }
            set { _userRepository = value; }
        }

        private I_Repository<Status> _statusRepository;

        public I_Repository<Status> StatusRepository
        {
            get { return _statusRepository; }
            set { _statusRepository = value; }
        }       

        public Organisation_Levels_Service(I_LoginSession session)
            : base(session)
        {
            _statusRepository = new RepositoryBase<Status>(((RepositoryBase<Organisation_Level>)Repository).Context);
            _userRepository = new RepositoryBase<User>(((RepositoryBase<Organisation_Level>)Repository).Context);
        }

        protected override Organisation_Levels_Model MappingToModel(Organisation_Level table)
        {
            return table == null ? null : new Organisation_Levels_Model()
            {
                Name = table.Name,
                LevelId = table.LevelId,
                Sort = table.Sort ?? 0,
                Description = table.Description,
                Create_Date = table.Create_Date,
                Owner = table.Owner ?? 0,
                UpdatedBy = Session.intUserId,
                Status = table.Status ?? 0
            };
        }

        protected override Organisation_Level MappingToDAL(Organisation_Levels_Model model)
        {
            return model == null ? null : new Organisation_Level()
            {
                Name = model.Name,
                LevelId = model.LevelId,
                Sort = model.Sort,
                Description = model.Description,
                Create_Date = model.Create_Date.HasValue ? model.Create_Date : DateTime.Now,
                Owner = model.Owner,
                UpdatedBy = Session.intUserId,
                Status = model.Status
            };
        }

        protected override IQueryable<Organisation_Levels_Model> Filter(string keyword, IQueryable<Organisation_Levels_Model> query)
        {
            if (string.IsNullOrEmpty(keyword))
            {
                return query;
            }
            var predicate = PredicateBuilder.False<Organisation_Levels_Model>();
            predicate = predicate.Or(p => p.Description.Contains(keyword));
            predicate = predicate.Or(p => p.Name.Contains(keyword));
            return query.Where(predicate);
        }

        protected override IQueryable<Organisation_Levels_Model> GetMapping(IQueryable<Organisation_Level> query)
        {
            var statusQuery = StatusRepository.GetQueryable();
            var userQuery = UserRepository.GetQueryable();
            var levelQuery = Repository.GetQueryable();
            var result = from levels in query
                         join s in statusQuery on levels.Status equals s.StatusId 
                         join parent in levelQuery on levels.Sort equals parent.LevelId into tempLevel
                         from parent in tempLevel.DefaultIfEmpty()
                         join user in userQuery on levels.Owner equals user.UserId into temp
                         from user in temp.DefaultIfEmpty()
                         select new Organisation_Levels_Model()
                         {
                             Name = levels.Name,
                             LevelId = levels.LevelId,                             
                             Sort = levels.Sort ?? 0,
                             ParentLevelName = parent != null ? parent.Name : string.Empty,
                             Description = levels.Description,
                             Create_Date = levels.Create_Date,
                             Owner = levels.Owner ?? 0,
                             OwnerName = user != null ? user.UserName : string.Empty,
                             UpdatedBy = Session.intUserId,
                             Status = levels.Status ?? 0,
                             StatusName = s.Name
                         };
            return result;
        }

        public override void Delete(object id)
        {
            var model = GetById(id);
            UpdateStatus(model, ResourcesHelper.StatusInactive);
        }

        public Organisation_Levels_Model CreateOrUpdate(Organisation_Levels_Model model)
        {
            return (model.LevelId > 0) ? Update(model, model.LevelId) : Create(model);
        }

        /// <summary>
        /// Updates the status.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <param name="status">The status.</param>
        public void UpdateStatus(Organisation_Levels_Model model, short status)
        {
            model.Status = status;
            Update(model, model.LevelId);
        }

        public void ReArrangeLevel(string data)
        {
            Dictionary<string, object> dicParams = new Dictionary<string, object>();            
            dicParams.Add("@data", data);
            dicParams.Add("@updatedby", Session.intUserId);
            Repository.ExecuteNonQueryStoreProcedure("sp_ArrangeLevel_Role", dicParams);   
        }

        public IEnumerable<Organisation_Levels_Model> GetLevelsWithHigherOrEqualPermission(string levelName)
        {
            var level = Repository.GetQueryable().Where(t => t.Name.Contains(levelName)).FirstOrDefault();
            if (level != null)
                return Repository.GetQueryable().Where(t => t.Sort.Value <= level.Sort.Value).Select(t => MappingToModel(t));
            else
                return new List<Organisation_Levels_Model>();
        }
    }    
}