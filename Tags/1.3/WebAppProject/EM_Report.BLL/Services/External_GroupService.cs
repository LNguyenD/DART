using System;
using System.Linq;
using EM_Report.BLL.Commons;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Models;

namespace EM_Report.BLL.Services
{
    public interface I_External_GroupService : I_Service<External_GroupModel>
    {
        void UpdateStatus(External_GroupModel model, short status);
    }

    public class External_GroupService : ServiceBase<External_GroupModel, External_Group>, I_External_GroupService
    {
        private I_Repository<User> _userRepository;
        private I_Repository<Status> _statusRepository;

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

        public External_GroupService(I_LoginSession session)
            : base(session)
        {
            _statusRepository = new RepositoryBase<Status>(((RepositoryBase<External_Group>)Repository).Context);
            _userRepository = new RepositoryBase<User>(((RepositoryBase<External_Group>)Repository).Context);
        }
        
        protected override External_GroupModel MappingToModel(External_Group tbExternal_Group)
        {
            return tbExternal_Group == null ? null : new External_GroupModel()
            {
                External_GroupId = tbExternal_Group.External_GroupId,
                Name = tbExternal_Group.Name,
                Description = tbExternal_Group.Description,
                Status = tbExternal_Group.Status??0,
                Create_Date = tbExternal_Group.Create_Date??DateTime.Now,
                Owner = tbExternal_Group.Owner ?? 0,
                UpdatedBy = Session.intUserId                
            };
        }

        protected override External_Group MappingToDAL(External_GroupModel tbExternal_Group)
        {
            return tbExternal_Group == null ? null : new External_Group()
            {
                External_GroupId = tbExternal_Group.External_GroupId,
                Name = tbExternal_Group.Name,
                Description = tbExternal_Group.Description,
                Status = short.Parse(tbExternal_Group.Status.ToString()),
                Create_Date = tbExternal_Group.Create_Date,
                Owner = tbExternal_Group.Owner,
                UpdatedBy = Session.intUserId
            };
        }        

        public void UpdateStatus(External_GroupModel model, short status)
        {
            model.Status = status;            
            Update(model,model.External_GroupId);
        }

        protected override IQueryable<External_GroupModel> Filter(string keyword, IQueryable<External_GroupModel> query)
        {
            if (string.IsNullOrEmpty(keyword))
            {
                return query;
            }
            var predicate = PredicateBuilder.False<External_GroupModel>();
            predicate = predicate.Or(p => p.Name.Contains(keyword));
            predicate = predicate.Or(p => p.Description.Contains(keyword));
            predicate = predicate.Or(p => p.StatusName.Contains(keyword));
            predicate = predicate.Or(p => p.OwnerName.Contains(keyword));
            return query.Where(predicate);
        }

        protected override IQueryable<External_GroupModel> GetMapping(IQueryable<External_Group> query)
        {
            var statusQuery = StatusRepository.GetQueryable();
            var userQuery = UserRepository.GetQueryable();
            var result = from q in query
                         join s in statusQuery on q.Status equals s.StatusId 
                         join u in userQuery on q.Owner equals u.UserId into temp
                         from u in temp.DefaultIfEmpty()
                         select new External_GroupModel()
                         {
                             External_GroupId = q.External_GroupId,
                             Name = q.Name,
                             Description = q.Description,
                             Status = q.Status ?? 0,
                             Create_Date = q.Create_Date ?? DateTime.Now,
                             Owner = q.Owner ?? 0,
                             OwnerName = u != null ? u.UserName : string.Empty,
                             StatusName = s.Name,
                             UpdatedBy = Session.intUserId
                         };

            return result;
        }
    }    
}