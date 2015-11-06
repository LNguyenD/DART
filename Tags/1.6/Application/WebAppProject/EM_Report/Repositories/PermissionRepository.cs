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
    public interface IPermissionRepository
    {
        List<Permission> GetList();
        List<Permission> GetList(string search, string sort);
        List<Permission> GetList(string search, string sort, int pageindex, int pagesize);
        Permission GetById(int teamId);
        void Insert(Permission permission);
        void Update(Permission permission);
        void UpdateStatus(Permission permission, short status);
        void Delete(int permissionId);
    }
    public class PermissionRepository : RepositoryBase, IPermissionRepository
    {
        public List<Permission> GetList()
        {
            var request = new PermissionRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };
            request.Criteria = new Criteria();
            var response = Client.GetPermissions(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.Permissions == null ? null : response.Permissions.ToList();
        }

        public List<Permission> GetList(string search, string sort)
        {
            var request = new PermissionRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };

            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search };

            var response = Client.GetPermissions(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.Permissions == null ? null : response.Permissions.ToList();
        }

        public List<Permission> GetList(string search, string sort, int pageindex, int pagesize)
        {
            var request = new PermissionRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };

            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize };

            var response = Client.GetPermissions(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.Permissions == null ? null : response.Permissions.ToList();
        }

        public Permission GetById(int permissionId)
        {
            var request = new PermissionRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.PermissionId = permissionId;

            var response = Client.GetPermissions(request);

            Correlate(request, response);

            return response.Permission;
        }

        public void Insert(Permission permission)
        {
            //permission.Owner = Base.LoginSession.intUserId;
            var request = new PermissionRequest().Prepare();
            request.Action = Resource.Action_Create;
            request.Permission = permission;

            var response = Client.SetPermissions(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Update(Permission permission)
        {
            // permission.UpdatedBy = Base.LoginSession.intUserId;
            var request = new PermissionRequest().Prepare();
            request.Action = Resource.Action_Update;
            request.Permission = permission;

            var response = Client.SetPermissions(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void UpdateStatus(Permission permission, short status)
        {
            //permission.UpdatedBy = Base.LoginSession.intUserId;
            var request = new PermissionRequest().Prepare();
            request.Action = Resource.Action_UpdateStatus;
            request.Criteria = new Criteria { Status = status };
            request.Permission = permission;

            var response = Client.SetPermissions(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Delete(int permissionId)
        {
            var request = new PermissionRequest().Prepare();
            request.Action = Resource.Action_Delete;
            request.PermissionId = permissionId;

            var response = Client.SetPermissions(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }
    }
}