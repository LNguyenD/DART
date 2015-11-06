using EM_Report.BLL.Commons;
using EM_Report.DAL;
using EM_Report.Models;

namespace EM_Report.BLL.Services
{
    public interface I_System_PermissionService : I_Service<System_PermissionModel>
    {
        System_PermissionModel CreateOrUpdate(System_PermissionModel model);
        void UpdateStatus(System_PermissionModel model, int status);
    }

    public class System_PermissionService : ServiceBase<System_PermissionModel, System_Permission>, I_System_PermissionService
    {
        #region private member variables
        #endregion

        #region private properties
        #endregion

        #region private methods
        protected override System_PermissionModel MappingToModel(System_Permission tbPermissions)
        {
            return tbPermissions == null ? null : new System_PermissionModel()
            {
                System_PermissionId = tbPermissions.System_PermissionId,
                Name = tbPermissions.Name,                
                Status = tbPermissions.Status ?? 0
            };
        }

        protected override System_Permission MappingToDAL(System_PermissionModel permissionModel)
        {
            return permissionModel == null ? null : new System_Permission()
            {
                System_PermissionId  = permissionModel.System_PermissionId,
                Name = permissionModel.Name,                
                Status = (short)permissionModel.Status
            };
        }
        #endregion

        #region constructors
        public System_PermissionService(I_LoginSession session)
            : base(session)
        {
        }    
        #endregion

        #region public properties
        #endregion

        #region public methods
        public System_PermissionModel CreateOrUpdate(System_PermissionModel permissionModel)
        {
            return (permissionModel.System_PermissionId > 0) ? Update(permissionModel,permissionModel.System_PermissionId) : Create(permissionModel);
        }      
        
        public void UpdateStatus(System_PermissionModel model, int status)
        {
            model.Status = status;
            Update(model, model.System_PermissionId);
        }
        #endregion
    }
}
