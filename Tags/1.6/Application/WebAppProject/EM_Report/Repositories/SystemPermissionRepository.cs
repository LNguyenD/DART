using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EM_Report.ActionServiceReference;
using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using EM_Report.Domain;

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
            var response = Client.GetSystemPermissions(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.SystemPermissions == null ? null : response.SystemPermissions.ToList();
        }

        public List<System_Permission> GetList(string search, string sort)
        {
            var request = new System_PermissionRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };

            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search };

            var response = Client.GetSystemPermissions(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.SystemPermissions == null ? null : response.SystemPermissions.ToList();
        }

        public List<System_Permission> GetList(string search, string sort, int pageindex, int pagesize)
        {
            var request = new System_PermissionRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };

            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize };

            var response = Client.GetSystemPermissions(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.SystemPermissions == null ? null : response.SystemPermissions.ToList();
        }

        public System_Permission GetById(int sysPermissionId)
        {
            var request = new System_PermissionRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.System_PermissionId = sysPermissionId;

            var response = Client.GetSystemPermissions(request);

            Correlate(request, response);

            return response.SystemPermission;
        }

        public void Insert(System_Permission sysPermission)
        {
            //permission.Owner = Base.LoginSession.intUserId;
            var request = new System_PermissionRequest().Prepare();
            request.Action = Resource.Action_Create;
            request.SystemPermission = sysPermission;

            var response = Client.SetSystemPermissions(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Update(System_Permission sysPermission)
        {
            // permission.UpdatedBy = Base.LoginSession.intUserId;
            var request = new System_PermissionRequest().Prepare();
            request.Action = Resource.Action_Update;
            request.SystemPermission = sysPermission;

            var response = Client.SetSystemPermissions(request);

            Correlate(request, response);

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

            var response = Client.SetSystemPermissions(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Delete(int sysPermissionId)
        {
            var request = new System_PermissionRequest().Prepare();
            request.Action = Resource.Action_Delete;
            request.System_PermissionId = sysPermissionId;

            var response = Client.SetSystemPermissions(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }
    }
}