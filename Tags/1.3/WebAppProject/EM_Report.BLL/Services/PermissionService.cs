using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EM_Report.Models;
using EM_Report.DAL;
using EM_Report.BLL.Commons;

namespace EM_Report.BLL.Services
{
    public interface I_PermissionService : I_Service<PermissionModel>
    {
        PermissionModel CreateOrUpdate(PermissionModel permissionModel);
        void UpdateStatus(PermissionModel permissionModel, int status);
    }

    public class PermissionService : ServiceBase<PermissionModel, Permission>, I_PermissionService
    {
        #region private member variables
        #endregion

        #region private properties
        #endregion

        #region private methods
        protected override PermissionModel MappingToModel(Permission tbPermissions)
        {
            return tbPermissions == null ? null : new PermissionModel() 
            { 
                PermissionId = tbPermissions.PermissionId,
                Name = tbPermissions.Name, 
                Description = tbPermissions.Description, 
                Status = tbPermissions.Status ?? 0 
            };
        }

        protected override Permission MappingToDAL(PermissionModel permissionModel)
        {
            return permissionModel == null ? null : new Permission() 
            { 
                PermissionId = permissionModel.PermissionId, 
                Name = permissionModel.Name, 
                Description = permissionModel.Description, 
                Status = (short)permissionModel.Status 
            };
        }
        #endregion

        #region constructors
        #endregion

        #region public properties
        public PermissionService(I_LoginSession session)
            : base(session)
        {
        }
        #endregion

        #region public methods
        public PermissionModel CreateOrUpdate(PermissionModel permissionModel)
        {
            return (permissionModel.PermissionId > 0) ? Update(permissionModel,permissionModel.PermissionId) : Create(permissionModel);
        }
               
        public void UpdateStatus(PermissionModel model, int status)
        {
            model.Status = status;
            Update(model,model.PermissionId);
        }
        #endregion
    }
}