using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using EM_Report.Domain;
using EM_Report.Service.Messages;
using EM_Report.Service.Criteria;
using EM_Report.Service.ServiceContracts;
using EM_Report.Service.MessageBase;
namespace EM_Report.Repositories
{
    /// <summary>
    /// User Repository interface.
    /// Note: does not derive from IRepository.
    /// </summary>
    public interface ISystemRole_PermissionRepository
    {
        List<System_Role_Permissions> GetList();
        List<System_Role_Permissions> GetList(string search, string sort);
        List<System_Role_Permissions> GetList(string search, string sort, int pageindex, int pagesize);
        System_Role_Permissions Get(int System_RoleId, int PermissionId, int System_PermissionId);
        List<System_Role_Permissions> GetSystemRolePermissions(int SystemRole_Id);
        void Insert(System_Role_Permissions model);
        void Update(System_Role_Permissions model);
        void UpdateStatus(System_Role_Permissions model, short status);
        void Delete(int System_RoleId, int PermissionId, int System_PermissionId);
    }

    /// <summary>
    /// User Repository. Implements just one method.
    /// </summary>
    public class SystemRole_PermissionRepository : RepositoryBase, ISystemRole_PermissionRepository
    {
        /// <summary>
        /// Gets list of users.
        /// </summary>
        /// <param name="criterion"></param>
        /// <returns></returns>
        public List<System_Role_Permissions> GetList()
        {
            var request = new SystemRole_PermissionsRequest().Prepare();

            request.LoadOptions = new string[] { Resource.Get_Option_List };
            request.Criteria = new Criteria();

            SystemRole_PermissionsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetSystemRolePermissions(request);
            });   

            Base.TotalItemCount = response.TotalItemCount;            

            return response.SystemRolePermissions == null ? null : response.SystemRolePermissions.ToList();
        }

        /// <summary>
        /// Gets list of users.
        /// </summary>
        /// <param name="criterion"></param>
        /// <returns></returns>
        public List<System_Role_Permissions> GetList(string search, string sort)
        {
            var request = new SystemRole_PermissionsRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search };

            SystemRole_PermissionsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetSystemRolePermissions(request);
            });  

            Base.TotalItemCount = response.TotalItemCount;

            return response.SystemRolePermissions == null ? null : response.SystemRolePermissions.ToList();
        }

        /// <summary>
        /// Gets list of users.
        /// </summary>
        /// <param name="criterion"></param>
        /// <returns></returns>
        public List<System_Role_Permissions> GetList(string search, string sort, int pageindex, int pagesize)
        {
            var request = new SystemRole_PermissionsRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize };

            SystemRole_PermissionsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetSystemRolePermissions(request);
            });  

            Base.TotalItemCount = response.TotalItemCount;

            return response.SystemRolePermissions == null ? null : response.SystemRolePermissions.ToList();
        }

        /// <summary>
        /// Gets an individual user by id.
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public System_Role_Permissions Get(int System_RoleId, int PermissionId, int System_PermissionId)
        {
            var request = new SystemRole_PermissionsRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.System_RoleId = System_RoleId;
            request.PermissionId = PermissionId;
            request.System_PermissionId = System_PermissionId;

            SystemRole_PermissionsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetSystemRolePermissions(request);
            });  

            return response.SystemRolePermission;
        }

        public List<System_Role_Permissions> GetSystemRolePermissions(int SystemRole_Id)
        {
            var request = new SystemRole_PermissionsRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_SystemRolePermission_By_SystemRoleId };
            request.Criteria = new Criteria();
            request.System_RoleId = SystemRole_Id;

            SystemRole_PermissionsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetSystemRolePermissions(request);
            });  

            return response.SystemRolePermissions == null ? null : response.SystemRolePermissions.ToList();
        }

        /// <summary>
        /// Inserts a new users.
        /// </summary>
        /// <param name="user"></param>
        public void Insert(System_Role_Permissions model)
        {
            model.Owner = Base.LoginSession.intUserId;
            model.Create_Date = DateTime.Now;
            var request = new SystemRole_PermissionsRequest().Prepare();
            request.Action = Resource.Action_Create;
            request.SysRolePermission = model;

            SystemRole_PermissionsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetSystemRolePermissions(request);
            });  

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        /// <summary>
        /// Updates an existing user.
        /// </summary>
        /// <param name="user"></param>
        public void Update(System_Role_Permissions model)
        {
            model.UpdatedBy = Base.LoginSession.intUserId;
            var request = new SystemRole_PermissionsRequest().Prepare();
            request.Action = Resource.Action_Update;
            request.SysRolePermission = model;

            SystemRole_PermissionsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetSystemRolePermissions(request);
            });  

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        /// <summary>
        /// Updates Status an existing user.
        /// </summary>
        /// <param name="user"></param>
        public void UpdateStatus(System_Role_Permissions model, short status)
        {
            model.UpdatedBy = Base.LoginSession.intUserId;
            var request = new SystemRole_PermissionsRequest().Prepare();
            request.Action = Resource.Action_UpdateStatus;
            request.Criteria = new Criteria { Status = status };
            request.SysRolePermission = model;

            SystemRole_PermissionsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetSystemRolePermissions(request);
            });  

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        /// <summary>
        /// Deletes an existing user.
        /// </summary>
        /// <param name="userId"></param>
        public void Delete(int System_RoleId, int PermissionId, int System_PermissionId)
        {
            var request = new SystemRole_PermissionsRequest().Prepare();

            request.Action = Resource.Action_Delete;
            request.System_RoleId = System_RoleId;
            request.PermissionId = PermissionId;
            request.System_PermissionId = System_PermissionId;

            SystemRole_PermissionsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetSystemRolePermissions(request);
            });  

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);

            // return response.RowsAffected;
        }
    }
}