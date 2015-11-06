using System;
using System.Linq;
using EM_Report.Common.Utilities;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Domain;
using System.Globalization;
using LinqKit;

namespace EM_Report.BLL.Services
{
    public interface I_TeamService : I_Service <Team>
    {
        void UpdateStatus(Team model, short status);
        bool IsRIG(User user, string site);
        bool IsRIG(string username, string site);
    }

    public class TeamService : ServiceBase<Team, TeamDO>, I_TeamService
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

        public TeamService(I_LoginSession session)
            : base(session)
        {
            _statusRepository = new RepositoryBase<StatusDO>(((RepositoryBase<TeamDO>)Repository).Context);
            _userRepository = new RepositoryBase<UserDO>(((RepositoryBase<TeamDO>)Repository).Context);
        }             

        public void UpdateStatus(Team model, short status)
        {
            model.Status = status;           
            Update(model, model.TeamId);
        }

        protected override IQueryable<Team> Filter(string keyword, IQueryable<Team> query)
        {
            if (string.IsNullOrEmpty(keyword))
            {
                return query;
            }
            var predicate = PredicateBuilder.False<Team>();
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

        protected override IQueryable<Team> GetMapping(IQueryable<TeamDO> query)
        {
            var statusQuery = StatusRepository.GetQueryable();
            var userQuery = UserRepository.GetQueryable();
            var result = from q in query
                         join s in statusQuery on q.Status equals s.StatusId
                         join u in userQuery on q.Owner equals u.UserId into temp
                         from u in temp.DefaultIfEmpty()
                         select new Team()
                         {
                             TeamId = q.TeamId,
                             SystemId = q.SystemId,
                             Name = q.Name,
                             Description = q.Description,
                             Status = q.Status ?? 0,
                             Create_Date = q.Create_Date ?? DateTime.Now,
                             Owner = q.Owner ?? 0,
                             OwnerName = u != null ? u.UserName : string.Empty,
                             StatusName = s.Name,                            
                             UpdatedBy = q.UpdatedBy != null ? q.UpdatedBy : 0
                         };

            return result;
        }

        public bool IsRIG(User user, string site)
        {
            if (site == Constants.STR_SITE_HEM)
            {
                return false;
            }            
            return false;
        }

        public bool IsRIG(string username, string site)
        {
            var userService = new UserService(this.Session);
            return IsRIG(userService.GetUserByUserNameOrEmail(username), site);
        }
    }    
}