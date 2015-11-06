using System;
using System.Linq;
using EM_Report.BLL.Commons;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Models;

namespace EM_Report.BLL.Services
{
    public interface I_Users_AuditService : I_Service<Users_AuditModel>
    {
        
    }

    public class Users_AuditService : ServiceBase<Users_AuditModel, Users_Audit>, I_Users_AuditService
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

        public Users_AuditService(I_LoginSession session)
            : base(session)
        {
            _statusRepository = new RepositoryBase<Status>(((RepositoryBase<Users_Audit>)Repository).Context);
            _userRepository = new RepositoryBase<User>(((RepositoryBase<Users_Audit>)Repository).Context);
        }        
       

        protected override Users_AuditModel MappingToModel(Users_Audit tbl)
        {
            return tbl == null ? null : new Users_AuditModel()
            {
                Id = tbl.Id,
                UserId = tbl.UserId,
                Password = tbl.Password,
                UserName = tbl.UserName,
                FirstName = tbl.FirstName,
                LastName = tbl.LastName,
                Email = tbl.Email,
                Address = tbl.Address,
                Status = tbl.Status.Value,
                Phone = tbl.Phone,
                Online_Locked_Until_Datetime = tbl.Last_Online_Login_Date,
                Online_No_Of_Login_Attempts =tbl.Online_No_Of_Login_Attempts,
                Last_Online_Login_Date = tbl.Last_Online_Login_Date,
                Action_Date =tbl.Action_Date,
                Action_Type =tbl.Action_Type,
                Action_Owner = tbl.Action_Owner
            };
        }

        protected override Users_Audit MappingToDAL(Users_AuditModel tbl)
        {
            return tbl == null ? null : new Users_Audit()
            {
                Id = tbl.Id,
                UserId = tbl.UserId,
                Password = tbl.Password,
                UserName = tbl.UserName,
                FirstName = tbl.FirstName,
                LastName = tbl.LastName,
                Email = tbl.Email,
                Address = tbl.Address,
                Status = tbl.Status,
                Phone = tbl.Phone,                
                Online_Locked_Until_Datetime = tbl.Last_Online_Login_Date,
                Online_No_Of_Login_Attempts = tbl.Online_No_Of_Login_Attempts,
                Last_Online_Login_Date = tbl.Last_Online_Login_Date,              
                Action_Date = tbl.Action_Date,
                Action_Type = tbl.Action_Type,
                Action_Owner = tbl.Action_Owner
            };
        }

        protected override IQueryable<Users_AuditModel> Filter(string keyword, string startdate, string enddate, IQueryable<Users_AuditModel> query)
        {
            var predicate = PredicateBuilder.False<Users_AuditModel>();
            predicate = predicate.Or(p => p.UserName.Contains(keyword));
            predicate = predicate.Or(p => p.FirstName.Contains(keyword));
            predicate = predicate.Or(p => p.LastName.Contains(keyword));
            predicate = predicate.Or(p => p.Email.Contains(keyword));
            predicate = predicate.Or(p => p.Phone.Contains(keyword));
            predicate = predicate.Or(p => p.StatusName.Contains(keyword));
            predicate = predicate.Or(p => p.OwnerName.Contains(keyword));
            if (!string.IsNullOrEmpty(startdate) && startdate!="mm/dd/yyyy")
            {
                predicate = predicate.And(p => p.Action_Date >= DateTime.ParseExact(startdate + " 00:00:00.000", "MM/dd/yyyy HH:mm:ss.fff", new System.Globalization.CultureInfo("en-US", true)));                
            }
            if (!string.IsNullOrEmpty(enddate) && enddate != "mm/dd/yyyy")
            {
                predicate = predicate.And(p => p.Action_Date <= DateTime.ParseExact(enddate + " 23:59:59.000", "MM/dd/yyyy HH:mm:ss.fff", new System.Globalization.CultureInfo("en-US", true)));
            }
            
            return query.Where(predicate);
        }

        protected override IQueryable<Users_AuditModel> GetMapping(IQueryable<Users_Audit> query)
        {
            var statusQuery = StatusRepository.GetQueryable();
            var userQuery = UserRepository.GetQueryable();
            var result = from q in query
                         join s in statusQuery on q.Status equals s.StatusId 
                         join u in userQuery on q.Action_Owner equals u.UserId into temp
                         from u in temp.DefaultIfEmpty()                         
                         select new Users_AuditModel()
                         {
                             Id = q.Id,
                             UserId = q.UserId,
                             Password = q.Password,
                             UserName = q.UserName,
                             FirstName = q.FirstName,
                             LastName = q.LastName,
                             Email = q.Email,
                             Address = q.Address,
                             Status = q.Status??0,
                             Phone = q.Phone,                             
                             Online_Locked_Until_Datetime = q.Last_Online_Login_Date,
                             Online_No_Of_Login_Attempts = q.Online_No_Of_Login_Attempts,
                             Last_Online_Login_Date = q.Last_Online_Login_Date,                            
                             OwnerName = u != null ? u.UserName : string.Empty,                            
                             StatusName = s.Name,
                             Action_Date = q.Action_Date,
                             Action_Type = q.Action_Type,
                             Action_Owner = q.Action_Owner
                         };          

            return result;
        }
    }    
}