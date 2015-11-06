using System;
using System.Linq;
using EM_Report.BLL.Commons;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Models;

namespace EM_Report.BLL.Services
{
    public interface I_Subscriptions_AuditService : I_Service<Subscriptions_AuditModel>
    {
        
    }

    public class Subscriptions_AuditService : ServiceBase<Subscriptions_AuditModel, Subscriptions_Audit>, I_Subscriptions_AuditService
    {
        private I_Repository<User> _userRepository;
        private I_Repository<Report> _reportRepository;
        private I_Repository<Status> _statusRepository;

        public I_Repository<Status> StatusRepository
        {
            get { return _statusRepository; }
            set { _statusRepository = value; }
        }
        public I_Repository<Report> ReportRepository
        {
            get { return _reportRepository; }
            set { _reportRepository = value; }
        }

        public I_Repository<User> UserRepository
        {
            get { return _userRepository; }
            set { _userRepository = value; }
        }

        public Subscriptions_AuditService(I_LoginSession session)
            : base(session)
        {
            _statusRepository = new RepositoryBase<Status>(((RepositoryBase<Subscriptions_Audit>)Repository).Context);
            _userRepository = new RepositoryBase<User>(((RepositoryBase<Subscriptions_Audit>)Repository).Context);
            _reportRepository = new RepositoryBase<Report>(((RepositoryBase<Subscriptions_Audit>)Repository).Context);
        }        
       

        protected override Subscriptions_AuditModel MappingToModel(Subscriptions_Audit tbl)
        {
            return tbl == null ? null : new Subscriptions_AuditModel()
            {
                Id = tbl.Id,
                SubscriptionID = tbl.SubscriptionID,
                Owner = tbl.Owner,                
                Status = tbl.Status,
                ScheduleID = tbl.ScheduleID,
                Action_Date = tbl.Action_Date,
                Action_Type = tbl.Action_Type,
                Action_Owner = tbl.Action_Owner,
                ReportId = tbl.ReportId
            };
        }

        protected override Subscriptions_Audit MappingToDAL(Subscriptions_AuditModel tbl)
        {
            return tbl == null ? null : new Subscriptions_Audit()
            {
                Id = tbl.Id,
                SubscriptionID = tbl.SubscriptionID,
                Owner = tbl.Owner,                
                Status = tbl.Status,
                ScheduleID = tbl.ScheduleID,
                Action_Date = tbl.Action_Date,
                Action_Type = tbl.Action_Type,
                Action_Owner = tbl.Action_Owner,
                ReportId = tbl.ReportId
            };
        }

        protected override IQueryable<Subscriptions_AuditModel> Filter(string keyword, string startdate, string enddate, IQueryable<Subscriptions_AuditModel> query)
        {
            var predicate = PredicateBuilder.False<Subscriptions_AuditModel>();
            predicate = predicate.Or(p => p.Action_Type.Contains(keyword));
            predicate = predicate.Or(p => p.ReportName.Contains(keyword));
            predicate = predicate.Or(p => p.StatusName.Contains(keyword));
            predicate = predicate.Or(p => p.OwnerName.Contains(keyword));

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

        protected override IQueryable<Subscriptions_AuditModel> GetMapping(IQueryable<Subscriptions_Audit> query)
        {
            var statusQuery = StatusRepository.GetQueryable();
            var userQuery = UserRepository.GetQueryable();
            var reportQuery = ReportRepository.GetQueryable();
            var result = from q in query
                         join s in statusQuery on q.Status equals s.StatusId   
                         join u in userQuery on q.Action_Owner equals u.UserId into temp1
                         from u in temp1.DefaultIfEmpty()
                         join r in reportQuery on q.ReportId equals r.ReportId into temp2
                         from r in temp2.DefaultIfEmpty()  
                         select new Subscriptions_AuditModel()
                         {
                             Id = q.Id,
                             SubscriptionID = q.SubscriptionID,
                             Owner = q.Owner,
                             OwnerName = u != null ? u.UserName : string.Empty,
                             Status = q.Status,
                             ScheduleID = q.ScheduleID,                            
                             Action_Date = q.Action_Date,
                             Action_Type = q.Action_Type,
                             Action_Owner = q.Action_Owner,
                             ReportId = q.ReportId,
                             ReportName =r.Name,
                             StatusName = s.Name
                         };          

            return result;
        }
    }    
}