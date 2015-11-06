using System;
using System.Linq;
using EM_Report.BLL.Commons;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Models;

namespace EM_Report.BLL.Services
{
    public interface I_System_Role_Permissions_AuditService : I_Service<System_Role_Permissions_AuditModel>
    {
        
    }

    public class System_Role_Permissions_AuditService : ServiceBase<System_Role_Permissions_AuditModel, System_Role_Permissions_Audit>, I_System_Role_Permissions_AuditService
    {
        private I_Repository<User> _userRepository;
        private I_Repository<Permission> _permissionRepository;
        private I_Repository<System_Permission> _systemPermissionRepository;
        private I_Repository<System_Role> _system_RolesRepository;
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

        public I_Repository<Permission> PermissionRepository
        {
            get { return _permissionRepository; }
            set { _permissionRepository = value; }
        }

        public I_Repository<System_Permission> SystemPermissionRepository
        {
            get { return _systemPermissionRepository; }
            set { _systemPermissionRepository = value; }
        }

        public I_Repository<System_Role> SystemRoleRepository
        {
            get { return _system_RolesRepository; }
            set { _system_RolesRepository = value; }
        }

        public System_Role_Permissions_AuditService(I_LoginSession session)
            : base(session)
        {
            _statusRepository = new RepositoryBase<Status>(((RepositoryBase<System_Role_Permissions_Audit>)Repository).Context);
            _userRepository = new RepositoryBase<User>(((RepositoryBase<System_Role_Permissions_Audit>)Repository).Context);
            _permissionRepository = new RepositoryBase<Permission>(((RepositoryBase<System_Role_Permissions_Audit>)Repository).Context);
            _systemPermissionRepository = new RepositoryBase<System_Permission>(((RepositoryBase<System_Role_Permissions_Audit>)Repository).Context);
            _system_RolesRepository = new RepositoryBase<System_Role>(((RepositoryBase<System_Role_Permissions_Audit>)Repository).Context);
        }        
       

        protected override System_Role_Permissions_AuditModel MappingToModel(System_Role_Permissions_Audit tbl)
        {
            return tbl == null ? null : new System_Role_Permissions_AuditModel()
            {
                Id = tbl.Id,
                System_RoleId = tbl.System_RoleId,
                PermissionId = tbl.PermissionId,
                System_PermissionId = tbl.System_PermissionId,
                Status = short.Parse(tbl.Status.ToString()),                            
                Action_Date = tbl.Action_Date,
                Action_Type = tbl.Action_Type,
                Action_Owner = tbl.Action_Owner
            };
        }

        protected override System_Role_Permissions_Audit MappingToDAL(System_Role_Permissions_AuditModel tbl)
        {
            return tbl == null ? null : new System_Role_Permissions_Audit()
            {
                Id = tbl.Id,
                System_RoleId = tbl.System_RoleId,
                PermissionId = tbl.PermissionId,
                System_PermissionId = tbl.System_PermissionId,
                Status = short.Parse(tbl.Status.ToString()),                      
                Action_Date = tbl.Action_Date,
                Action_Type = tbl.Action_Type,
                Action_Owner = tbl.Action_Owner
            };
        }

        protected override IQueryable<System_Role_Permissions_AuditModel> Filter(string keyword, string startdate, string enddate, IQueryable<System_Role_Permissions_AuditModel> query)
        {
            var predicate = PredicateBuilder.False<System_Role_Permissions_AuditModel>();
            predicate = predicate.Or(p => p.Action_Type.Contains(keyword));
            predicate = predicate.Or(p => p.Description.Contains(keyword));
            predicate = predicate.Or(p => p.OwnerName.Contains(keyword));
            predicate = predicate.Or(p => p.StatusName.Contains(keyword));
            predicate = predicate.Or(p => p.System_RoleName.Contains(keyword));
            predicate = predicate.Or(p => p.System_PermissionName.Contains(keyword));
            predicate = predicate.Or(p => p.PermissionName.Contains(keyword));
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

        protected override IQueryable<System_Role_Permissions_AuditModel> GetMapping(IQueryable<System_Role_Permissions_Audit> query)
        {
            var statusQuery = StatusRepository.GetQueryable();
            var systemroleQuery = SystemRoleRepository.GetQueryable();
            var permissionQuery = PermissionRepository.GetQueryable();
            var systempermissionQuery = SystemPermissionRepository.GetQueryable();
            var userQuery = UserRepository.GetQueryable();
            var result = from q in query
                         join st in statusQuery on q.Status equals st.StatusId   
                         join s in systemroleQuery on q.System_RoleId equals s.System_RoleId into temp
                         from s in temp.DefaultIfEmpty()   
                         join p in permissionQuery on q.PermissionId equals p.PermissionId into temp1
                         from p in temp1.DefaultIfEmpty()       
                         join sp in systempermissionQuery on q.System_PermissionId equals sp.System_PermissionId into temp2
                         from sp in temp2.DefaultIfEmpty()       
                         join u in userQuery on q.Action_Owner equals u.UserId into temp3
                         from u in temp3.DefaultIfEmpty()                         
                         select new System_Role_Permissions_AuditModel()
                         {
                             Id = q.Id,
                             System_RoleId = q.System_RoleId,
                             PermissionId = q.PermissionId,
                             System_PermissionId = q.System_PermissionId,
                             Status = q.Status??0,                                                                   
                             OwnerName = u != null ? u.UserName : string.Empty,
                             StatusName = st.Name,
                             System_RoleName = s.Name,
                             System_PermissionName = sp.Name,
                             PermissionName = p.Name,                             
                             Action_Date = q.Action_Date,
                             Action_Type = q.Action_Type,
                             Action_Owner = q.Action_Owner
                         };          

            return result;
        }
    }    
}