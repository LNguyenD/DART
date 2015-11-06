using System;
using System.Collections.Generic;
using System.Linq;
using EM_Report.ActionServiceReference;
using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using EM_Report.Domain;

namespace EM_Report.Repositories
{
    /// <summary>
    /// Organisation Level Repository interface.
    /// Note: does not derive from IRepository.
    /// </summary>
    public interface IOrganisationRolesRepository
    {
        List<Organisation_Roles> GetList();
        List<Organisation_Roles> GetList(string search, string sort);
        List<Organisation_Roles> GetList(string search, string sort, int pageindex, int pagesize);
        Organisation_Roles Get(int roleId);
        List<Organisation_Roles> GetRolesOfLevel(int levelId);
        void Create(Organisation_Roles role);
        void Update(Organisation_Roles role);
        void UpdateStatus(Organisation_Roles role, short status);
        void UpdateLevel(int roleId, int levelId);
        void Delete(int roleId);
        bool IsTeamLeaderOrAbove(int organisationId);
    }

    /// <summary>
    /// Report Repository. Implements just one method.
    /// </summary>
    public class OrganisationRolesRepository : RepositoryBase, IOrganisationRolesRepository
    {
        /// <summary>
        /// Gets list of Organisation Role.
        /// </summary>
        /// <returns></returns>
        public List<Organisation_Roles> GetList()
        {
            var request = new Organisation_RolesRequest().Prepare();      
            request.LoadOptions = new[] { Resource.Get_Option_List };
            request.Criteria = new Criteria();
            var response = Client.GetOrganisationRoles(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Roles == null ? null : response.Roles.ToList();
        }

        /// <summary>
        /// Gets list of Organisation Role.
        /// </summary>
        /// <param name="search"></param>
        /// <param name="sort"></param>
        /// <returns></returns>
        public List<Organisation_Roles> GetList(string search, string sort)
        {
            var request = new Organisation_RolesRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search };

            var response = Client.GetOrganisationRoles(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Roles == null ? null : response.Roles.ToList();
        }

        /// <summary>
        /// Gets list of Organisation Role.
        /// </summary>
        /// <param name="search"></param>
        /// <param name="sort"></param>
        /// <param name="pageindex"></param>
        /// <param name="pagesize"></param>
        /// <returns></returns>
        public List<Organisation_Roles> GetList(string search, string sort, int pageindex, int pagesize)
        {
            var request = new Organisation_RolesRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize };

            var response = Client.GetOrganisationRoles(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Roles == null ? null : response.Roles.ToList();
        }

        /// <summary>
        /// Gets an individual Organisation Role by id.
        /// </summary>
        /// <param name="roleId"></param>
        /// <returns></returns>
        public Organisation_Roles Get(int roleId)
        {
            var request = new Organisation_RolesRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_Single };
            request.RoleId = roleId;

            var response = Client.GetOrganisationRoles(request);            
            Correlate(request, response);

            return response.Role;
        }

        public List<Organisation_Roles> GetRolesOfLevel(int levelId)
        {
            var request = new Organisation_RolesRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List_RolesOfLevel };
            request.Criteria = new Criteria();
            request.LevelId = levelId;

            var response = Client.GetOrganisationRoles(request);
            Correlate(request, response);

            return response.Roles == null ? null : response.Roles.ToList();
        }

        /// <summary>
        /// Inserts a new Organisation Role.
        /// </summary>
        /// <param name="role"></param>
        public void Create(Organisation_Roles role)
        {
            role.Create_Date = DateTime.Now;
            role.Owner = Base.LoginSession.intUserId;
            var request = new Organisation_RolesRequest().Prepare();
            request.Action = Resource.Action_Create;
            request.Roles = role;

            var response = Client.SetOrganisationRoles(request);
            Correlate(request, response);

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        /// <summary>
        /// Update an existing Organisation Role.
        /// </summary>
        /// <param name="role"></param>
        public void Update(Organisation_Roles role)
        {
            role.UpdatedBy = Base.LoginSession.intUserId;
            var request = new Organisation_RolesRequest().Prepare();
            request.Action = Resource.Action_Update;
            request.Roles = role;

            var response = Client.SetOrganisationRoles(request);
            Correlate(request, response);

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        /// <summary>
        /// Updates Status an existing Organisation Role.
        /// </summary>
        /// <param name="role"></param>
        /// <param name="status"></param>
        public void UpdateStatus(Organisation_Roles role, short status)
        {
            var request = new Organisation_RolesRequest().Prepare();
            request.Action = Resource.Action_UpdateStatus;
            request.Criteria = new Criteria { Status = status };
            request.Roles = role;

            var response = Client.SetOrganisationRoles(request);
            Correlate(request, response);

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void UpdateLevel(int roleId, int levelId)
        {
            var request = new Organisation_RolesRequest().Prepare();
            request.Action = Resource.Action_UpdateLevel;

            request.RoleId = roleId;
            request.LevelId = levelId;
            request.UserId = Base.LoginSession.intUserId;

            var response = Client.SetOrganisationRoles(request);
            Correlate(request, response);

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        /// <summary>
        /// Delete an existing Organisation Role.
        /// </summary>
        /// <param name="roleId"></param>
        public void Delete(int roleId)
        {
            var request = new Organisation_RolesRequest().Prepare();

            request.Action = Resource.Action_Delete;
            request.RoleId = roleId;

            var response = Client.SetOrganisationRoles(request);
            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);

            // return response.RowsAffected;
        }

        public bool IsTeamLeaderOrAbove(int organisationId)
        {
            var request = new Organisation_RolesRequest().Prepare();
            request.LoadOptions = new[] { Resource.IsTeamLeader };
            request.LevelId = organisationId;

            var response = Client.GetOrganisationRoles(request);
            Correlate(request, response);

            return response.IsTeamLeaderOrAbove;
        }
    }
}