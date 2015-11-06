using System;
using System.Collections.Generic;
using System.Linq;
using EM_Report.ActionServiceReference;
using EM_Report.Domain;
using EM_Report.Domain.Resources;
using EM_Report.Helpers;

namespace EM_Report.Repositories
{
    /// <summary>
    /// Authentication Repository interface.
    /// Note: does not derive from IRepository.
    /// </summary>
    public interface IDashboard_OrganisationRole_LevelsRepository
    {
        bool HaveDashboardPermission(bool issystemuser, string Dashboard_Url, int LevelId, int Dashboard_LevelId_Value);

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

            var response = Client.GetDashboard_OrganisationRole_Levels(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.Dashboard_OrganisationRole_Levels.ToList();
        }

        public List<Dashboard_OrganisationRole_Levels> GetList(int dashboardId)
        {
            var request = new Dashboard_OrganisationRole_LevelsRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };
            request.DashboardId = dashboardId;
            var response = Client.GetDashboard_OrganisationRole_Levels(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.Dashboard_OrganisationRole_Levels.ToList();
        }

        public Dashboard_OrganisationRole_Levels GetById(int dashboardId)
        {
            var request = new Dashboard_OrganisationRole_LevelsRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.DashboardId = dashboardId;

            var response = Client.GetDashboard_OrganisationRole_Levels(request);

            Correlate(request, response);

            return response.Dashboard_OrganisationRole_Level;
        }

        public Dashboard_OrganisationRole_Levels Get(string Dashboard_Url, int LevelId, int Dashboard_LevelId_Value)
        {
            var request = new Dashboard_OrganisationRole_LevelsRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.Url = Dashboard_Url;
            request.LevelId = LevelId;
            request.DashboardLevelId = Dashboard_LevelId_Value;

            var response = Client.GetDashboard_OrganisationRole_Levels(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.Dashboard_OrganisationRole_Level;
        }

        public bool HaveDashboardPermission(bool issystemuser, string Dashboard_Url, int LevelId, int Dashboard_LevelId_Value)
        {
            if (issystemuser)
                return true;

            var request = new Dashboard_OrganisationRole_LevelsRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.Url = Dashboard_Url;
            request.LevelId = LevelId; // default level id

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
                foreach (var system in Base.LoginSession.lstSystems)
                    levelIdList.Add(system.LevelId);

                // pass all of level ids for each system that user belongs to
                request.LevelIdList = levelIdList.ToArray();
            }

            request.DashboardLevelId = Dashboard_LevelId_Value;

            var response = Client.GetDashboard_OrganisationRole_Levels(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.Dashboard_OrganisationRole_Level != null ? true : false;
        }

        public void Update(Dashboard_OrganisationRole_Levels dashboardOrganisationRoleLevels)
        {
            dashboardOrganisationRoleLevels.UpdatedBy = Base.LoginSession.intUserId;
            var request = new Dashboard_OrganisationRole_LevelsRequest().Prepare();
            request.Action = Resource.Action_Update;
            request.Dashboard_OrganisationRole_Level = dashboardOrganisationRoleLevels;

            var response = Client.SetDashboard_OrganisationRole_Levels(request);

            Correlate(request, response);

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

            var response = Client.SetDashboard_OrganisationRole_Levels(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Delete(int dashboardOganisationLevelId)
        {
            var request = new Dashboard_OrganisationRole_LevelsRequest().Prepare();
            request.Action = Resource.Action_Delete;
            request.DashboardOrganisationlevelId = dashboardOganisationLevelId;

            var response = Client.SetDashboard_OrganisationRole_Levels(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }
    }
}