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
    public interface ISystemPermissionRepository
    {
        List<System_Permission> GetList();
        List<System_Permission> GetList(string search, string sort);
        List<System_Permission> GetList(string search, string sort, int pageindex, int pagesize);
        System_Permission GetById(int sysPermissionId);
        void Insert(System_Permission sysPermission);
        void Update(System_Permission sysPermission);
        void UpdateStatus(System_Permission sysPermission, short status);
        void Delete(int sysPermissionId);
    }
    public class SystemPermissionRepository : RepositoryBase, ISystemPermissionRepository
    {
        public List<System_Permission> GetList()
        {
            var request = new System_PermissionRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };
            request.Criteria = new Criteria();
            System_PermissionResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetSystemPermissions(request);
            });            

            Base.TotalItemCount = response.TotalItemCount;           

            return response.SystemPermissions == null ? null : response.SystemPermissions.ToList();
        }

        public List<System_Permission> GetList(string search, string sort)
        {
            var request = new System_PermissionRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };

            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search };

            System_PermissionResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetSystemPermissions(request);
            });   

            Base.TotalItemCount = response.TotalItemCount;

            return response.SystemPermissions == null ? null : response.SystemPermissions.ToList();
        }

        public List<System_Permission> GetList(string search, string sort, int pageindex, int pagesize)
        {
            var request = new System_PermissionRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };

            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize };

            System_PermissionResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetSystemPermissions(request);
            });   

            Base.TotalItemCount = response.TotalItemCount;

            return response.SystemPermissions == null ? null : response.SystemPermissions.ToList();
        }

        public System_Permission GetById(int sysPermissionId)
        {
            var request = new System_PermissionRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.System_PermissionId = sysPermissionId;

            System_PermissionResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetSystemPermissions(request);
            });   

            return response.SystemPermission;
        }

        public void Insert(System_Permission sysPermission)
        {
            //permission.Owner = Base.LoginSession.intUserId;
            var request = new System_PermissionRequest().Prepare();
            request.Action = Resource.Action_Create;
            request.SystemPermission = sysPermission;

            System_PermissionResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetSystemPermissions(request);
            });   

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Update(System_Permission sysPermission)
        {
            // permission.UpdatedBy = Base.LoginSession.intUserId;
            var request = new System_PermissionRequest().Prepare();
            request.Action = Resource.Action_Update;
            request.SystemPermission = sysPermission;

            System_PermissionResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetSystemPermissions(request);
            });   

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void UpdateStatus(System_Permission sysPermission, short status)
        {
            //permission.UpdatedBy = Base.LoginSession.intUserId;
            var request = new System_PermissionRequest().Prepare();
            request.Action = Resource.Action_UpdateStatus;
            request.Criteria = new Criteria { Status = status };
            request.SystemPermission = sysPermission;

            System_PermissionResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetSystemPermissions(request);
            });   

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Delete(int sysPermissionId)
        {
            var request = new System_PermissionRequest().Prepare();
            request.Action = Resource.Action_Delete;
            request.System_PermissionId = sysPermissionId;

            System_PermissionResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetSystemPermissions(request);
            });   

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }
    }
}