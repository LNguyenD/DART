using System;
using System.Linq;
using System.Collections.Generic;
using EM_Report.Common.Utilities;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Domain;
using LinqKit;

namespace EM_Report.BLL.Services
{
    public interface I_Organisation_Levels_Service : I_Service<Organisation_Levels>
    {
        Organisation_Levels CreateOrUpdate(Organisation_Levels model);
        void ReArrangeLevel(string data, int updatedBy);
    }

    public class Organisation_Levels_Service : ServiceBase<Organisation_Levels, Organisation_LevelDO>, I_Organisation_Levels_Service
    {
        private I_Repository<UserDO> _userRepository;

        public I_Repository<UserDO> UserRepository
        {
            get { return _userRepository; }
            set { _userRepository = value; }
        }

        private I_Repository<StatusDO> _statusRepository;

        public I_Repository<StatusDO> StatusRepository
        {
            get { return _statusRepository; }
            set { _statusRepository = value; }
        }       

        public Organisation_Levels_Service(I_LoginSession session)
            : base(session)
        {
            _statusRepository = new RepositoryBase<StatusDO>(((RepositoryBase<Organisation_LevelDO>)Repository).Context);
            _userRepository = new RepositoryBase<UserDO>(((RepositoryBase<Organisation_LevelDO>)Repository).Context);
        }

        public Organisation_Levels_Service(I_Repository<Organisation_LevelDO> repo, I_LoginSession session) : base(repo, session) { }

        protected override IQueryable<Organisation_Levels> Filter(string keyword, IQueryable<Organisation_Levels> query)
        {
            if (string.IsNullOrEmpty(keyword))
            {
                return query;
            }
            var predicate = PredicateBuilder.False<Organisation_Levels>();
            predicate = predicate.Or(p => p.Description.Contains(keyword));
            predicate = predicate.Or(p => p.Name.Contains(keyword));
            return query.Where(predicate);
        }

        protected override IQueryable<Organisation_Levels> GetMapping(IQueryable<Organisation_LevelDO> query)
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
                         select new Organisation_Levels()
                         {
                             Name = levels.Name,
                             LevelId = levels.LevelId,     
                             SystemId = levels.SystemId,
                             Sort = levels.Sort ?? 0,
                             ParentLevelName = parent != null ? parent.Name : string.Empty,
                             Description = levels.Description,
                             Create_Date = levels.Create_Date,
                             Owner = levels.Owner ?? 0,
                             OwnerName = user != null ? user.UserName : string.Empty,
                             UpdatedBy = levels.UpdatedBy ?? 0,
                             Status = levels.Status ?? 0,
                             StatusName = s.Name
                         };
            return result;
        }        

        public Organisation_Levels CreateOrUpdate(Organisation_Levels model)
        {
            return (model.LevelId > 0) ? Update(model, model.LevelId) : Create(model);
        }

        /// <summary>
        /// Updates the status.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <param name="status">The status.</param>
        public void UpdateStatus(Organisation_Levels model, short status)
        {
            model.Status = status;
            Update(model, model.LevelId);
        }

        public void ReArrangeLevel(string data, int updatedBy)
        {
            Dictionary<string, object> dicParams = new Dictionary<string, object>();
            dicParams.Add("@data", data);
            dicParams.Add("@updatedby", updatedBy);
            Repository.ExecuteNonQueryStoreProcedure("sp_ArrangeLevel_Role", dicParams);   
        }

        public IEnumerable<Organisation_Levels> GetLevelsWithHigherOrEqualPermission(string levelName)
        {
            var level = Repository.GetQueryable().Where(t => t.Name.Contains(levelName)).FirstOrDefault();
            if (level != null)
                return Repository.GetQueryable().Where(t => t.Sort.Value <= level.Sort.Value).Select(t => Mappers.MapTo<Organisation_LevelDO,Organisation_Levels>(t));
            else
                return new List<Organisation_Levels>();
        }
    }    
}