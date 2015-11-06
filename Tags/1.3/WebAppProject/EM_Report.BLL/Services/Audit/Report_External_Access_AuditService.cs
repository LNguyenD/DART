using System;
using System.Linq;
using EM_Report.BLL.Commons;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Models;

namespace EM_Report.BLL.Services
{
    public interface I_Report_External_Access_AuditService : I_Service<Report_External_Access_AuditModel>
    {
        
    }

    public class Report_External_Access_AuditService : ServiceBase<Report_External_Access_AuditModel, Report_External_Access_Audit>, I_Report_External_Access_AuditService
    {
        private I_Repository<User> _userRepository;
        private I_Repository<Report> _reportRepository;
        private I_Repository<External_Group> _externalGroupRepository;

        public I_Repository<User> UserRepository
        {
            get { return _userRepository; }
            set { _userRepository = value; }

        }
        
        public I_Repository<Report> ReportRepository
        {
            get { return _reportRepository; }
            set { _reportRepository = value; }
        }

        public I_Repository<External_Group> ExternalGroupRepository
        {
            get { return _externalGroupRepository; }
            set { _externalGroupRepository = value; }

        }

        public Report_External_Access_AuditService(I_LoginSession session)
            : base(session)
        {
            _userRepository = new RepositoryBase<User>(((RepositoryBase<Report_External_Access_Audit>)Repository).Context);
            _reportRepository = new RepositoryBase<Report>(((RepositoryBase<Report_External_Access_Audit>)Repository).Context);
            _externalGroupRepository = new RepositoryBase<External_Group>(((RepositoryBase<Report_External_Access_Audit>)Repository).Context);
        }        
       

        protected override Report_External_Access_AuditModel MappingToModel(Report_External_Access_Audit tbl)
        {
            return tbl == null ? null : new Report_External_Access_AuditModel()
            {
                Id = tbl.Id,
                ReportId = tbl.ReportId,
                External_GroupId = tbl.External_GroupId,
                Action_Date = tbl.Action_Date,
                Action_Type = tbl.Action_Type,
                Action_Owner = tbl.Action_Owner
            };
        }

        protected override Report_External_Access_Audit MappingToDAL(Report_External_Access_AuditModel tbl)
        {
            return tbl == null ? null : new Report_External_Access_Audit()
            {
                Id = tbl.Id,
                ReportId = tbl.ReportId,
                External_GroupId = tbl.External_GroupId,
                Action_Date = tbl.Action_Date,
                Action_Type = tbl.Action_Type,
                Action_Owner = tbl.Action_Owner
            };
        }

        protected override IQueryable<Report_External_Access_AuditModel> Filter(string keyword, string startdate, string enddate, IQueryable<Report_External_Access_AuditModel> query)
        {
            var predicate = PredicateBuilder.False<Report_External_Access_AuditModel>();
            predicate = predicate.Or(p => p.Action_Type.Contains(keyword));
            predicate = predicate.Or(p => p.ReportName.Contains(keyword));
            predicate = predicate.Or(p => p.OwnerName.Contains(keyword));
            predicate = predicate.Or(p => p.ExternalGroupName.Contains(keyword));

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

        protected override IQueryable<Report_External_Access_AuditModel> GetMapping(IQueryable<Report_External_Access_Audit> query)
        {
            var userQuery = UserRepository.GetQueryable();
            var reportQuery = ReportRepository.GetQueryable();
            var externalgroupQuery = ExternalGroupRepository.GetQueryable();
            var result = from q in query
                         join u in userQuery on q.Action_Owner equals u.UserId into temp1
                         from u in temp1.DefaultIfEmpty()      
                         join r in reportQuery on q.ReportId equals r.ReportId into temp2
                         from r in temp2.DefaultIfEmpty()       
                         join eg in externalgroupQuery on q.External_GroupId equals eg.External_GroupId into temp3
                         from eg in temp3.DefaultIfEmpty()       
                         select new Report_External_Access_AuditModel()
                         {
                             Id = q.Id,
                             ReportId = q.ReportId,
                             External_GroupId = q.External_GroupId,
                             ReportName = r.Name,
                             ExternalGroupName = eg.Name,
                             OwnerName = u != null ? u.UserName : string.Empty,                                                         
                             Action_Date = q.Action_Date,
                             Action_Type = q.Action_Type,
                             Action_Owner = q.Action_Owner
                         };          

            return result;
        }
    }    
}