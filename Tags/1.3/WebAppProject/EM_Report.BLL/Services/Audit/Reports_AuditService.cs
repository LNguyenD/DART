using System;
using System.Linq;
using EM_Report.BLL.Commons;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Models;

namespace EM_Report.BLL.Services
{
    public interface I_Reports_AuditService : I_Service<Reports_AuditModel>
    {
        
    }

    public class Reports_AuditService : ServiceBase<Reports_AuditModel, Reports_Audit>, I_Reports_AuditService
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

        public Reports_AuditService(I_LoginSession session)
            : base(session)
        {
            _statusRepository = new RepositoryBase<Status>(((RepositoryBase<Reports_Audit>)Repository).Context);
            _userRepository = new RepositoryBase<User>(((RepositoryBase<Reports_Audit>)Repository).Context);
        }        
       

        protected override Reports_AuditModel MappingToModel(Reports_Audit tbl)
        {
            return tbl == null ? null : new Reports_AuditModel()
            {
                Id = tbl.Id,
                ReportId = tbl.ReportId,
                CategoryId = tbl.CategoryId,
                Name = tbl.Name,
                ShortName = tbl.ShortName,
                Url = tbl.Url,                             
                Status = tbl.Status ?? 0,
                Action_Date = tbl.Action_Date,
                Action_Type = tbl.Action_Type,
                Action_Owner = tbl.Action_Owner
            };
        }

        protected override Reports_Audit MappingToDAL(Reports_AuditModel tbl)
        {
            return tbl == null ? null : new Reports_Audit()
            {
                Id = tbl.Id,
                ReportId = tbl.ReportId,
                CategoryId = tbl.CategoryId,
                Name = tbl.Name,
                ShortName = tbl.ShortName,
                Url = tbl.Url,                
                Status = tbl.Status,
                Action_Date = tbl.Action_Date,
                Action_Type = tbl.Action_Type,
                Action_Owner = tbl.Action_Owner
            };
        }

        protected override IQueryable<Reports_AuditModel> Filter(string keyword, string startdate, string enddate, IQueryable<Reports_AuditModel> query)
        {
            var predicate = PredicateBuilder.False<Reports_AuditModel>();
            predicate = predicate.Or(p => p.Name.Contains(keyword));
            predicate = predicate.Or(p => p.ShortName.Contains(keyword));
            predicate = predicate.Or(p => p.Url.Contains(keyword));
            predicate = predicate.Or(p => p.Description.Contains(keyword));
            predicate = predicate.Or(p => p.StatusName.Contains(keyword));
            predicate = predicate.Or(p => p.Action_Type.Contains(keyword));
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

        protected override IQueryable<Reports_AuditModel> GetMapping(IQueryable<Reports_Audit> query)
        {
            var statusQuery = StatusRepository.GetQueryable();
            var userQuery = UserRepository.GetQueryable();
            var result = from q in query
                         join s in statusQuery on q.Status equals s.StatusId   
                         join u in userQuery on q.Action_Owner equals u.UserId into temp
                         from u in temp.DefaultIfEmpty()                         
                         select new Reports_AuditModel()
                         {
                             Id = q.Id,
                             ReportId = q.ReportId,
                             CategoryId = q.CategoryId,
                             Name = q.Name,
                             ShortName = q.ShortName,
                             Url = q.Url,                                                  
                             OwnerName = u != null ? u.UserName : string.Empty,
                             Status = q.Status ?? 0, 
                             StatusName = s.Name,
                             Action_Date = q.Action_Date,
                             Action_Type = q.Action_Type,
                             Action_Owner = q.Action_Owner
                         };          

            return result;
        }
    }    
}