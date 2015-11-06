using System;
using System.Linq;
using EM_Report.BLL.Commons;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Models;

namespace EM_Report.BLL.Services
{
    public interface I_Report_Categories_AuditService : I_Service<Report_Categories_AuditModel>
    {
        
    }

    public class Report_Categories_AuditService : ServiceBase<Report_Categories_AuditModel, Report_Categories_Audit>, I_Report_Categories_AuditService
    {
        private I_Repository<User> _userRepository;

        public I_Repository<User> UserRepository
        {
            get { return _userRepository; }
            set { _userRepository = value; }
        }

        public Report_Categories_AuditService(I_LoginSession session)
            : base(session)
        {
            _userRepository = new RepositoryBase<User>(((RepositoryBase<Report_Categories_Audit>)Repository).Context);
        }        
       

        protected override Report_Categories_AuditModel MappingToModel(Report_Categories_Audit tbl)
        {
            return tbl == null ? null : new Report_Categories_AuditModel()
            {
                Id = tbl.Id,
                CategoryId = tbl.CategoryId,
                Name = tbl.Name,                                
                Action_Date = tbl.Action_Date,
                Action_Type = tbl.Action_Type,
                Action_Owner = tbl.Action_Owner
            };
        }

        protected override Report_Categories_Audit MappingToDAL(Report_Categories_AuditModel tbl)
        {
            return tbl == null ? null : new Report_Categories_Audit()
            {
                Id = tbl.Id,
                CategoryId = tbl.CategoryId,
                Name = tbl.Name,                              
                Action_Date = tbl.Action_Date,
                Action_Type = tbl.Action_Type,
                Action_Owner = tbl.Action_Owner
            };
        }

        protected override IQueryable<Report_Categories_AuditModel> Filter(string keyword, string startdate, string enddate, IQueryable<Report_Categories_AuditModel> query)
        {
            var predicate = PredicateBuilder.False<Report_Categories_AuditModel>();
            predicate = predicate.Or(p => p.Name.Contains(keyword));
            predicate = predicate.Or(p => p.Description.Contains(keyword));
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

        protected override IQueryable<Report_Categories_AuditModel> GetMapping(IQueryable<Report_Categories_Audit> query)
        {
            var userQuery = UserRepository.GetQueryable();

            var result = from q in query
                         join u in userQuery on q.Action_Owner equals u.UserId into temp
                         from u in temp.DefaultIfEmpty()
                         select new Report_Categories_AuditModel()
                         {
                             Id = q.Id,
                             CategoryId = q.CategoryId,
                             Name = q.Name,                                                                                
                             OwnerName = u != null ? u.UserName : string.Empty ,    
                             Action_Date = q.Action_Date,
                             Action_Type = q.Action_Type,
                             Action_Owner = q.Action_Owner
                         };
            return result;
        }
    }    
}