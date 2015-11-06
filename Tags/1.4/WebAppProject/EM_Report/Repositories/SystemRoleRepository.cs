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
    /// <summary>
    /// System role Repository interface.
    /// Note: does not derive from IRepository.
    /// </summary>
    public interface ISystemRoleRepository
    {
        List<System_Roles> GetList();
        List<System_Roles> GetList(string search, string sort);
        List<System_Roles> GetList(string search, string sort, int pageindex, int pagesize);
        System_Roles GetById(int systemRoleId);
        void Insert(System_Roles systemRole);
        bool Save(System_Roles systemRole, string sysRole,int updatedby);
        void UpdateStatus(System_Roles systemRole, short status);
        void Delete(int systemRoleId);
        void Delete(string listOption);
    }
    /// <summary>
    /// system role Repository. Implements just one method.
    /// </summary>
    public class SystemRoleRepository : RepositoryBase, ISystemRoleRepository
    {
        /// <summary>
        /// Gets list of system roles.
        /// </summary>
        /// <returns></returns>
        public List<System_Roles> GetList()
        {
            var request = new System_RolesRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List };
            request.Criteria = new Criteria();
            var response = Client.GetSystemRoles(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.SystemRoles == null ? null : response.SystemRoles.ToList();
        }


        /// <summary>
        /// Gets list of System roles.
        /// </summary>
        /// <param name="search"></param>
        /// <param name="sort"></param>
        /// <returns></returns>
        public List<System_Roles> GetList(string search, string sort)
        {
            var request = new System_RolesRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search };

            var response = Client.GetSystemRoles(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.SystemRoles == null ? null : response.SystemRoles.ToList();
        }

        /// <summary>
        /// Gets list of system roles.
        /// </summary>
        /// <param name="search"></param>
        /// <param name="sort"></param>
        /// <param name="pageindex"></param>
        /// <param name="pagesize"></param>
        /// <returns></returns>
        public List<System_Roles> GetList(string search, string sort, int pageindex, int pagesize)
        {
            var request = new System_RolesRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize };

            var response = Client.GetSystemRoles(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.SystemRoles == null ? null : response.SystemRoles.ToList();
        }


        /// <summary>
        /// Gets an individual system role by id.
        /// </summary>
        /// <param name="rptId"></param>
        /// <returns></returns>
        public System_Roles Get(object rptId)
        {
            var request = new System_RolesRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_Single };
            request.System_RoleId = int.Parse(rptId.ToString());

            var response = Client.GetSystemRoles(request);
            Correlate(request, response);

            return response.SystemRole;
        }


        public System_Roles GetById(int systemRoleId)
        {
            var request = new System_RolesRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.System_RoleId = systemRoleId;

            var response = Client.GetSystemRoles(request);

            Correlate(request, response);

            return response.SystemRole;
        }
        /// <summary>
        /// Inserts a new system role.
        /// </summary>
        /// <param name="rpt"></param>
        public void Insert(System_Roles rpt)
        {
           // rpt.Owner = Base.LoginSession.intUserId;
            var request = new System_RolesRequest().Prepare();
            request.Action = Resource.Action_Create;
            request.SystemRole = rpt;

            var response = Client.SetSystemRoles(request);
            Correlate(request, response);

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        /// <summary>
        /// Update an existing system role.
        /// </summary>
        /// <param name="rpt"></param>
        public bool Save(System_Roles rpt,string sysRole,int updatedby)
        {
            //rpt.UpdatedBy = Base.LoginSession.intUserId;
            var request = new System_RolesRequest().Prepare();
            request.Action = Resource.Action_Save;
            request.SystemRoles = sysRole;
            request.UpdatedBy = updatedby;           
            request.SystemRole = rpt;

            var response = Client.SetSystemRoles(request);
            Correlate(request, response);

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
            return response.IsSaveSuccess;
        }

        public void UpdateStatus(System_Roles systemRole, short status)
        {
            //systemRole.UpdatedBy = Base.LoginSession.intUserId;
            var request = new System_RolesRequest().Prepare();
            request.Action = Resource.Action_UpdateStatus;
            request.Criteria = new Criteria { Status = status };
            request.SystemRole = systemRole;

            var response = Client.SetSystemRoles(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Delete(int systemRoleId)
        {
            var request = new System_RolesRequest().Prepare();
            request.Action = Resource.Action_Delete;
            request.System_RoleId = systemRoleId;

            var response = Client.SetSystemRoles(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Delete(string listOption)
        {
            if (!string.IsNullOrEmpty(listOption))
            {
                string[] listOptionSplit = listOption.Split('|');
                if (listOptionSplit.Length > 0)
                {
                    foreach (var item in listOptionSplit[1].Split(','))
                    {
                        Delete(Convert.ToInt32(item));
                    }
                }
            }
        }
    }
}