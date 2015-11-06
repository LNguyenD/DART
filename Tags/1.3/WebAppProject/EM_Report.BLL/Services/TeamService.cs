using System;
using System.Linq;
using EM_Report.BLL.Commons;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Models;

namespace EM_Report.BLL.Services
{
    public interface I_TeamService : I_Service <TeamModel>
    {
        void UpdateStatus(TeamModel model, short status);
        bool IsRIG(UserModel user, string site);
        bool IsRIG(string username, string site);
    }

    public class TeamService : ServiceBase<TeamModel, Team>, I_TeamService
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

        public TeamService(I_LoginSession session)
            : base(session)
        {
            _statusRepository = new RepositoryBase<Status>(((RepositoryBase<Team>)Repository).Context);
            _userRepository = new RepositoryBase<User>(((RepositoryBase<Team>)Repository).Context);
        }
        
        protected override TeamModel MappingToModel(Team tbTeam)
        {
            return tbTeam == null ? null : new TeamModel()
            {
                TeamId = tbTeam.TeamId,
                Name = tbTeam.Name,
                Description = tbTeam.Description,
                Status = tbTeam.Status ?? 0,
                Create_Date = tbTeam.Create_Date ?? DateTime.Now,
                Owner = tbTeam.Owner ?? 0,
                UpdatedBy = Session.intUserId
            };
        }

        protected override Team MappingToDAL(TeamModel tbTeam)
        {
            return tbTeam == null ? null : new Team()
            {
                TeamId = tbTeam.TeamId,
                Name = tbTeam.Name,
                Description = tbTeam.Description,
                Status = short.Parse(tbTeam.Status.ToString()),
                Create_Date = tbTeam.Create_Date,
                Owner = tbTeam.Owner,
                UpdatedBy = Session.intUserId
            };
        }       

        public void UpdateStatus(TeamModel model, short status)
        {
            model.Status = status;           
            Update(model, model.TeamId);
        }

        protected override IQueryable<TeamModel> Filter(string keyword, IQueryable<TeamModel> query)
        {
            if (string.IsNullOrEmpty(keyword))
            {
                return query;
            }
            var predicate = PredicateBuilder.False<TeamModel>();
            predicate = predicate.Or(p => p.Name.Contains(keyword));
            predicate = predicate.Or(p => p.Description.Contains(keyword));
            predicate = predicate.Or(p => p.StatusName.Contains(keyword));
            predicate = predicate.Or(p => p.OwnerName.Contains(keyword));           
            return query.Where(predicate);
        }

        protected override IQueryable<TeamModel> GetMapping(IQueryable<Team> query)
        {
            var statusQuery = StatusRepository.GetQueryable();
            var userQuery = UserRepository.GetQueryable();
            var result = from q in query
                         join s in statusQuery on q.Status equals s.StatusId 
                         join u in userQuery on q.Owner equals u.UserId into temp
                         from u in temp.DefaultIfEmpty()
                         select new TeamModel()
                         {
                             TeamId = q.TeamId,
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

        public bool IsRIG(UserModel user, string site)
        {
            if (site == Constants.STR_SITE_HEM)
            {
                return false;
            }
            if (user != null && user.TeamId.HasValue && user.TeamId.Value > 0)
            {
                var team = GetById(user.TeamId.Value);
                return (team != null && team.Name.StartsWith("RIG", StringComparison.InvariantCultureIgnoreCase));
            }
            return false;
        }

        public bool IsRIG(string username, string site)
        {
            var userService = new UserService(this.Session);
            return IsRIG(userService.GetUserByUserName(username), site);
        }
    }    
}