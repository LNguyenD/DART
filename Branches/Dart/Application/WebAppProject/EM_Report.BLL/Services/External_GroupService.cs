using System;
using System.Linq;
using EM_Report.Common.Utilities;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Domain;
using EM_Report.Domain.Enums;
using System.Globalization;
using LinqKit;

namespace EM_Report.BLL.Services
{
    public interface I_External_GroupService : I_Service<External_Group>
    {
        void UpdateStatus(External_Group model, short status);

        IQueryable<External_Group> GetGroups(GroupStatusFilter status, string sort, string keyword);
    }

    public class External_GroupService : ServiceBase<External_Group, External_GroupDO>, I_External_GroupService
    {
        private I_Repository<UserDO> _userRepository;
        private I_Repository<StatusDO> _statusRepository;

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

        public External_GroupService(I_LoginSession session)
            : base(session)
        {
            _statusRepository = new RepositoryBase<StatusDO>(((RepositoryBase<External_GroupDO>)Repository).Context);
            _userRepository = new RepositoryBase<UserDO>(((RepositoryBase<External_GroupDO>)Repository).Context);
        }       

        public void UpdateStatus(External_Group model, short status)
        {
            model.Status = status;            
            Update(model,model.External_GroupId);
        }

        protected override IQueryable<External_Group> Filter(string keyword, IQueryable<External_Group> query)
        {
            if (string.IsNullOrEmpty(keyword))
            {
                return query;
            }
            var predicate = PredicateBuilder.False<External_Group>();
            predicate = predicate.Or(p => p.Name.Contains(keyword));
            predicate = predicate.Or(p => p.Description.Contains(keyword));
            predicate = predicate.Or(p => p.StatusName.Contains(keyword));
            predicate = predicate.Or(p => p.OwnerName.Contains(keyword));

            // EF NOT SUPPORT
            //predicate = predicate.Or(p => (p.Create_Date.GetValueOrDefault().Day.ToString().PadLeft(2, '0') + "/"
            //                              + p.Create_Date.GetValueOrDefault().Month.ToString().PadLeft(2, '0') + "/"
            //                              + p.Create_Date.GetValueOrDefault().Year).Contains(keyword));

            
            return query.Where(predicate);
        }

        protected override IQueryable<External_Group> GetMapping(IQueryable<External_GroupDO> query)
        {
            var statusQuery = StatusRepository.GetQueryable();
            var userQuery = UserRepository.GetQueryable();
            var result = from q in query
                         join s in statusQuery on q.Status equals s.StatusId
                         join u in userQuery on q.Owner equals u.UserId into temp
                         from u in temp.DefaultIfEmpty()
                         select new External_Group()
                         {
                             External_GroupId = q.External_GroupId,
                             Name = q.Name,
                             Description = q.Description,
                             Status = q.Status ?? 0,
                             Create_Date = q.Create_Date ?? DateTime.Now,
                             Owner = q.Owner ?? 0,
                             OwnerName = u != null ? u.UserName : string.Empty,
                             StatusName = s.Name,
                             UpdatedBy = q.UpdatedBy,
                             SystemId = q.SystemId
                         };

            return result;
        }

        public IQueryable<External_Group> GetGroups(GroupStatusFilter status, string sort, string keyword)
        {
            var groups = GetAllQueryable(sort, keyword);
            if(status == GroupStatusFilter.Active)
            {
                groups = groups.Where(g => g.Status == 1);
            }
            else if(status == GroupStatusFilter.Inactive)
            {
                groups = groups.Where(g => g.Status == 2);
            }

            return groups;
        }
    }    
}