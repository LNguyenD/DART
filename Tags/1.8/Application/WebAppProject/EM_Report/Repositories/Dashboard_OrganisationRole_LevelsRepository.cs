
using EM_Report.Domain;
using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using EM_Report.Service.Messages;
using EM_Report.Service.Criteria;
using EM_Report.Service.ServiceContracts;
using EM_Report.Service.MessageBase;

namespace EM_Report.Repositories
{
    /// <summary>
    /// Authentication Repository interface.
    /// Note: does not derive from IRepository.
    /// </summary>
    public interface IDashboard_OrganisationRole_LevelsRepository
    {
        bool HaveDashboardPermission(bool issystemuser, string Dashboard_Url, int LevelId, short Dashboard_Level_Sort_Value);        

        Dashboard_OrganisationRole_Levels Get(string Dashboard_Url, int LevelId, int Dashboard_LevelId_Value);

        List<Dashboard_OrganisationRole_Levels> GetList();

        List<Dashboard_OrganisationRole_Levels> GetList(int dashboardId);

        Dashboard_OrganisationRole_Levels GetById(int dashboardId);

        void Update(Dashboard_OrganisationRole_Levels dashboardLevel);

        void Insert(Dashboard_OrganisationRole_Levels dashboardLevel);

        void Delete(int dashboardId);
    }

    /// <summary>
    /// Authentication Repository class.
    /// Note: this repository class is different from others (i.e. no CRUD operations)
    /// and therefore does not need to implement IRepository<T> (like all other repositories).
    /// </summary>
    public class Dashboard_OrganisationRole_LevelsRepository : RepositoryBase, IDashboard_OrganisationRole_LevelsRepository
    {
        public List<Dashboard_OrganisationRole_Levels> GetList()
        {
            var request = new Dashboard_OrganisationRole_LevelsRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };

            Dashboard_OrganisationRole_LevelsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetDashboard_OrganisationRole_Levels(request);
            });

            Base.TotalItemCount = response.TotalItemCount;

            return response.Dashboard_OrganisationRole_Levels.ToList();
        }

        public List<Dashboard_OrganisationRole_Levels> GetList(int dashboardId)
        {
            var request = new Dashboard_OrganisationRole_LevelsRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };
            request.DashboardId = dashboardId;

            Dashboard_OrganisationRole_LevelsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetDashboard_OrganisationRole_Levels(request);
            });

            Base.TotalItemCount = response.TotalItemCount;

            return response.Dashboard_OrganisationRole_Levels.ToList();
        }

        public Dashboard_OrganisationRole_Levels GetById(int dashboardId)
        {
            var request = new Dashboard_OrganisationRole_LevelsRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.DashboardId = dashboardId;

            Dashboard_OrganisationRole_LevelsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetDashboard_OrganisationRole_Levels(request);
            });

            return response.Dashboard_OrganisationRole_Level;
        }

        public Dashboard_OrganisationRole_Levels Get(string Dashboard_Url, int LevelId, int Dashboard_LevelId_Value)
        {
            var request = new Dashboard_OrganisationRole_LevelsRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.Url = Dashboard_Url;
            request.LevelId = LevelId;
            request.DashboardLevelId = Dashboard_LevelId_Value;

            Dashboard_OrganisationRole_LevelsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetDashboard_OrganisationRole_Levels(request);
            });

            Base.TotalItemCount = response.TotalItemCount;

            return response.Dashboard_OrganisationRole_Level;
        }

        public bool HaveDashboardPermission(bool issystemuser, string Dashboard_Url, int LevelId, short Dashboard_Level_Sort_Value)
        {
            if (issystemuser)
                return true;

            if (Base.LoginSession.lstSystems == null)
                return false;

            var request = new Dashboard_OrganisationRole_LevelsRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single_Internal_User_Permission };
            request.Url = Dashboard_Url;
            request.LevelId = LevelId;

            // correct level id follow the requested system
            var systemName = Base.GetSystemNameByUrl(Dashboard_Url);
            if (systemName != string.Empty)
            {
                var system = Base.LoginSession.lstSystems.SingleOrDefault(s => s.Name.ToLower() == systemName.ToLower());                
                if (system != null && system.LevelId > 0)
                    request.LevelId = system.LevelId; // pass only level id for system that user has requested
            }
            else
            {
                // handle for level 0 or some others that not depend on systems
                var levelIdList = new List<int>();

                foreach (var oLevelId in Base.LoginSession.Organisation_LevelList)
                    levelIdList.Add(oLevelId);

                // pass all of level ids for each system that user belongs to
                request.LevelIdList = levelIdList;
            }

            request.Sort = Dashboard_Level_Sort_Value;

            Dashboard_OrganisationRole_LevelsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetDashboard_OrganisationRole_Levels(request);
            });

            Base.TotalItemCount = response.TotalItemCount;

            return response.Dashboard_OrganisationRole_Level != null ? true : false;
        }        

        public void Update(Dashboard_OrganisationRole_Levels dashboardOrganisationRoleLevels)
        {
            dashboardOrganisationRoleLevels.UpdatedBy = Base.LoginSession.intUserId;
            var request = new Dashboard_OrganisationRole_LevelsRequest().Prepare();
            request.Action = Resource.Action_Update;
            request.Dashboard_OrganisationRole_Level = dashboardOrganisationRoleLevels;

            Dashboard_OrganisationRole_LevelsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetDashboard_OrganisationRole_Levels(request);
            });

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Insert(Dashboard_OrganisationRole_Levels dashboardOrganisationRoleLevels)
        {
            dashboardOrganisationRoleLevels.Create_Date = DateTime.Now;
            dashboardOrganisationRoleLevels.Owner = Base.LoginSession.intUserId;
            var request = new Dashboard_OrganisationRole_LevelsRequest().Prepare();
            request.Action = Resource.Action_Create;
            request.Dashboard_OrganisationRole_Level = dashboardOrganisationRoleLevels;

            Dashboard_OrganisationRole_LevelsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetDashboard_OrganisationRole_Levels(request);
            });

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Delete(int dashboardOganisationLevelId)
        {
            var request = new Dashboard_OrganisationRole_LevelsRequest().Prepare();
            request.Action = Resource.Action_Delete;
            request.DashboardOrganisationlevelId = dashboardOganisationLevelId;

            Dashboard_OrganisationRole_LevelsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetDashboard_OrganisationRole_Levels(request);
            });

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }
    }
}