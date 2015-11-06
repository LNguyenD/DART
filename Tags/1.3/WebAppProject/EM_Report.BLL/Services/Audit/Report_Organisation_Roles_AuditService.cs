using System;
using System.Linq;
using EM_Report.BLL.Commons;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Models;

namespace EM_Report.BLL.Services
{
    public interface I_Report_Organisation_Roles_AuditService : I_Service<Report_Organisation_Roles_AuditModel>
    {
        
    }

    public class Report_Organisation_Roles_AuditService : ServiceBase<Report_Organisation_Roles_AuditModel, Report_Organisation_Roles_Audit>, I_Report_Organisation_Roles_AuditService
    {
        private I_Repository<User> _userRepository;
        private I_Repository<Organisation_Level> _organisationrole_levelsRepository;
        private I_Repository<Report> _reportRepository;

        public I_Repository<Report> ReportRepository
        {
            get { return _reportRepository; }
            set { _reportRepository = value; }
        }

        public I_Repository<Organisation_Level> OrganisationRole_LevelsRepository
        {
            get { return _organisationrole_levelsRepository; }
            set { _organisationrole_levelsRepository = value; }
        }

        public I_Repository<User> UserRepository
        {
            get { return _userRepository; }
            set { _userRepository = value; }
        }

        public Report_Organisation_Roles_AuditService(I_LoginSession session)
            : base(session)
        {
            _userRepository = new RepositoryBase<User>(((RepositoryBase<Report_Organisation_Roles_Audit>)Repository).Context);
            _organisationrole_levelsRepository = new RepositoryBase<Organisation_Level>(((RepositoryBase<Report_Organisation_Roles_Audit>)Repository).Context);
            _reportRepository = new RepositoryBase<Report>(((RepositoryBase<Report_Organisation_Roles_Audit>)Repository).Context);
        }        
       

        protected override Report_Organisation_Roles_AuditModel MappingToModel(Report_Organisation_Roles_Audit tbl)
        {
            return tbl == null ? null : new Report_Organisation_Roles_AuditModel()
            {
                Id = tbl.Id,
                ReportId = tbl.ReportId,
                LevelId = tbl.LevelId,
                Action_Date = tbl.Action_Date,
                Action_Type = tbl.Action_Type,
                Action_Owner = tbl.Action_Owner
            };
        }

        protected override Report_Organisation_Roles_Audit MappingToDAL(Report_Organisation_Roles_AuditModel tbl)
        {
            return tbl == null ? null : new Report_Organisation_Roles_Audit()
            {
                Id = tbl.Id,
                ReportId = tbl.ReportId,
                LevelId = tbl.LevelId,
                Action_Date = tbl.Action_Date,
                Action_Type = tbl.Action_Type,
                Action_Owner = tbl.Action_Owner                
            };
        }

        protected override IQueryable<Report_Organisation_Roles_AuditModel> Filter(string keyword, string startdate, string enddate, IQueryable<Report_Organisation_Roles_AuditModel> query)
        {
            var predicate = PredicateBuilder.False<Report_Organisation_Roles_AuditModel>();
            predicate = predicate.Or(p => p.Action_Type.Contains(keyword));
            predicate = predicate.Or(p => p.OwnerName.Contains(keyword));
            predicate = predicate.Or(p => p.ReportName.Contains(keyword));
            predicate = predicate.Or(p => p.LevelName.Contains(keyword));

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

        protected override IQueryable<Report_Organisation_Roles_AuditModel> GetMapping(IQueryable<Report_Organisation_Roles_Audit> query)
        {
            var userQuery = UserRepository.GetQueryable();
            var organisationrole_levelsQuery = OrganisationRole_LevelsRepository.GetQueryable();
            var reportQuery = ReportRepository.GetQueryable();

            var result = from q in query
                         join r in reportQuery on q.ReportId equals r.ReportId into temp1
                         from r in temp1.DefaultIfEmpty()                         
                         join l in organisationrole_levelsQuery on q.LevelId equals l.LevelId into temp2
                         from l in temp2.DefaultIfEmpty()  
                         join u in userQuery on q.Action_Owner equals u.UserId into temp3
                         from u in temp3.DefaultIfEmpty()                         
                         select new Report_Organisation_Roles_AuditModel()
                         {
                             Id = q.Id,
                             ReportId = q.ReportId,
                             LevelId = q.LevelId,
                             OwnerName = u != null ? u.UserName : string.Empty,
                             Action_Date = q.Action_Date,
                             Action_Type = q.Action_Type,
                             Action_Owner = q.Action_Owner,
                             LevelName = l.Name,
                             ReportName = r.Name
                         };          

            return result;
        }
    }    
}