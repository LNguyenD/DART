using System;
using System.Linq;
using EM_Report.BLL.Commons;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Models;

namespace EM_Report.BLL.Services
{
    public interface I_Teams_AuditService : I_Service<Teams_AuditModel>
    {

    }

    public class Teams_AuditService : ServiceBase<Teams_AuditModel, Teams_Audit>, I_Teams_AuditService
    {
        private I_Repository<User> _userRepository;        

        public I_Repository<User> UserRepository
        {
            get { return _userRepository; }
            set { _userRepository = value; }
        }

        public Teams_AuditService(I_LoginSession session)
            : base(session)
        {            
            _userRepository = new RepositoryBase<User>(((RepositoryBase<Teams_Audit>)Repository).Context);
        }


        protected override Teams_AuditModel MappingToModel(Teams_Audit tbl)
        {
            return tbl == null ? null : new Teams_AuditModel()
            {
                Id = tbl.Id,
                TeamId = tbl.TeamId,
                Name = tbl.Name,
                Action_Date = tbl.Action_Date,
                Action_Type = tbl.Action_Type,
                Action_Owner = tbl.Action_Owner
            };
        }

        protected override Teams_Audit MappingToDAL(Teams_AuditModel tbl)
        {
            return tbl == null ? null : new Teams_Audit()
            {
                Id = tbl.Id,
                TeamId = tbl.TeamId,
                Name = tbl.Name,
                Action_Date = tbl.Action_Date,
                Action_Type = tbl.Action_Type,
                Action_Owner = tbl.Action_Owner
            };
        }

        protected override IQueryable<Teams_AuditModel> Filter(string keyword, string startdate, string enddate, IQueryable<Teams_AuditModel> query)
        {
            var predicate = PredicateBuilder.False<Teams_AuditModel>();
            predicate = predicate.Or(p => p.Name.Contains(keyword));
            predicate = predicate.Or(p => p.Action_Type.Contains(keyword));            
            predicate = predicate.Or(p => p.OwnerName.Contains(keyword));
            predicate = predicate.Or(p => p.Description.Contains(keyword));            

            if (!string.IsNullOrEmpty(startdate) && startdate != "mm/dd/yyyy")
            {
                predicate = predicate.And(p => p.Action_Date >= DateTime.ParseExact(startdate + " 00:00:00.000", "MM/dd/yyyy HH:mm:ss.fff", new System.Globalization.CultureInfo("en-US", true)));
            }
            if (!string.IsNullOrEmpty(enddate) && enddate != "mm/dd/yyyy")
            {
                predicate = predicate.And(p => p.Action_Date <= DateTime.ParseExact(enddate + " 23:59:59.000", "MM/dd/yyyy HH:mm:ss.fff", new System.Globalization.CultureInfo("en-US", true)));
            }

            return query.Where(predicate);
        }

        protected override IQueryable<Teams_AuditModel> GetMapping(IQueryable<Teams_Audit> query)
        {            
            var userQuery = UserRepository.GetQueryable();
            var result = from q in query                         
                         join u in userQuery on q.Action_Owner equals u.UserId into temp
                         from u in temp.DefaultIfEmpty()
                         select new Teams_AuditModel()
                         {
                             Id = q.Id,
                             TeamId = q.TeamId,
                             Name = q.Name,                             
                             OwnerName = u != null ? u.UserName : string.Empty,
                             Action_Date = q.Action_Date,
                             Action_Type = q.Action_Type,
                             Action_Owner = q.Action_Owner
                         };

            return result;
        }
    }
}