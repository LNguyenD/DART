using System;
using System.Linq;
using EM_Report.BLL.Commons;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Models;

namespace EM_Report.BLL.Services
{
    public interface I_System_Role_PermissionsService : I_Service<System_Role_PermissionsModel>
    {
        
    }

    public class System_Role_PermissionsService : ServiceBase<System_Role_PermissionsModel, System_Role_Permission>, I_System_Role_PermissionsService
    {
        private I_Repository<Status> _statusRepository;

        public I_Repository<Status> StatusRepository
        {
            get { return _statusRepository; }
            set { _statusRepository = value; }
        }

        public System_Role_PermissionsService(I_LoginSession session)
            : base(session)
        {
            _statusRepository = new RepositoryBase<Status>(((RepositoryBase<System_Role_Permission>)Repository).Context);
        }

        protected override System_Role_PermissionsModel MappingToModel(System_Role_Permission tbDal)
        {
            return tbDal == null ? null : new System_Role_PermissionsModel()
            {
                System_RoleId = tbDal.System_RoleId,
                PermissionId = tbDal.PermissionId,
                System_PermissionId = tbDal.System_PermissionId,               
                Status = tbDal.Status ?? 0,                
                Create_Date = tbDal.Create_Date ?? DateTime.Now,
                Owner = tbDal.Owner ?? 0,
                UpdatedBy = Session != null ? Session.intUserId : new Nullable<int>()
            };
        }

        protected override System_Role_Permission MappingToDAL(System_Role_PermissionsModel tbModel)
        {
            return tbModel == null ? null : new System_Role_Permission()
            {
                System_RoleId = tbModel.System_RoleId,
                PermissionId = tbModel.PermissionId,
                System_PermissionId = tbModel.System_PermissionId,
                Status = tbModel.Status,                
                Create_Date = tbModel.Create_Date,
                Owner = tbModel.Owner,
                UpdatedBy = Session.intUserId
            };
        }

        protected override IQueryable<System_Role_PermissionsModel> GetMapping(IQueryable<System_Role_Permission> query)
        {
            var statusQuery = StatusRepository.GetQueryable();
            var result = from q in query                         
                         select new  System_Role_PermissionsModel()
                         {
                             System_RoleId = q.System_RoleId,
                             PermissionId = q.PermissionId,
                             System_PermissionId = q.System_PermissionId,               
                             Status = q.Status ?? 0,                                                        
                             Create_Date = q.Create_Date ?? DateTime.Now,
                             Owner = q.Owner ?? 0,
                             UpdatedBy = Session != null ? Session.intUserId : new Nullable<int>()
                         };

            return result;
        }
    }    
}