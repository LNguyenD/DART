using EM_Report.Domain;
using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using EM_Report.Service.MessageBase;
using EM_Report.Service.Messages;
using EM_Report.Service.ServiceContracts;
using System;
using System.Collections.Generic;
using System.Linq;

namespace EM_Report.Repositories
{
    public interface IDashboardExternal_GroupsRepository
    {
        bool HaveDashboardPermissionEx(bool IsSystemUser, string Dashboard_ConfigUrls, int GroupExId, short Dashboard_Level_Sort_Value);

        DashboardExternal_Groups Get(string Dashboard_Url, int GroupId, int Dashboard_LevelId_Value);

        List<DashboardExternal_Groups> GetList();

        List<DashboardExternal_Groups> GetList(int dashboardId);

        DashboardExternal_Groups GetById(int dashboardId);

        void Update(DashboardExternal_Groups dashboardLevel);

        void Insert(DashboardExternal_Groups dashboardLevel);

        void Delete(int dashboardId);
    }

    public class DashboardExternal_GroupsRepository : RepositoryBase, IDashboardExternal_GroupsRepository
    {
        public bool HaveDashboardPermissionEx(bool IsSystemUser, string Dashboard_ConfigUrls, int GroupExId, short Dashboard_Level_Sort_Value)
        {
            if (Base.LoginSession.lstSystems == null)
                return false;

            var request = new DashboardExternal_GroupsRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single_External_User_Permission };

            // retrieve dashboard Url
            var dashboard_url = Base.GetParameterValueByName(Dashboard_ConfigUrls, "dashboardUrl");

            request.Url = dashboard_url;
            request.GroupId = GroupExId;

            var systemName = Base.GetSystemNameByUrl(dashboard_url);

            var system = Base.LoginSession.lstSystems.SingleOrDefault(s => s.Name.ToLower() == systemName.ToLower());
            if (system != null && system.External_GroupId > 0)
                request.GroupId = system.External_GroupId;

            // handle for level 0 or some others that not depend on systems
            var GroupIdList = new List<int>();

            foreach (var oLevelId in Base.LoginSession.Organisation_GroupList)
                GroupIdList.Add(oLevelId);

            // pass all of group ids for each system that user belongs to
            request.GroupIdList = GroupIdList;

            request.Sort = Dashboard_Level_Sort_Value;

            DashboardExternal_GroupsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetDashboardExternal_Groups(request);
            });

            Base.TotalItemCount = response.TotalItemCount;

            // check permission on external group
            var haveExternalGroupPermission = Base.HaveExternalGroupPermission(
                Base.GetParameterValueByName(Dashboard_ConfigUrls, "system"),
                Base.GetParameterValueByName(Dashboard_ConfigUrls, "type"),
                Base.GetParameterValueByName(Dashboard_ConfigUrls, "level"));

            //return response.DashboardExternal_Group.DashboardId != 0 ? true : false;
            return response.DashboardExternal_Group != null && haveExternalGroupPermission ? true : false;
        }

        public DashboardExternal_Groups Get(string Dashboard_Url, int GroupId, int Dashboard_LevelId_Value)
        {
            var request = new DashboardExternal_GroupsRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.Url = Dashboard_Url;
            request.GroupId = GroupId;
            request.DashboardLevelId = Dashboard_LevelId_Value;

            DashboardExternal_GroupsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetDashboardExternal_Groups(request);
            });

            Base.TotalItemCount = response.TotalItemCount;

            return response.DashboardExternal_Group;
        }

        public List<DashboardExternal_Groups> GetList()
        {
            var request = new DashboardExternal_GroupsRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };

            DashboardExternal_GroupsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetDashboardExternal_Groups(request);
            });

            Base.TotalItemCount = response.TotalItemCount;

            return response.DashboardExternal_Groups.ToList();
        }

        public List<DashboardExternal_Groups> GetList(int dashboardId)
        {
            var request = new DashboardExternal_GroupsRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };
            request.DashboardId = dashboardId;

            DashboardExternal_GroupsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetDashboardExternal_Groups(request);
            });

            Base.TotalItemCount = response.TotalItemCount;

            return response.DashboardExternal_Groups.ToList();
        }

        public DashboardExternal_Groups GetById(int dashboardId)
        {
            var request = new DashboardExternal_GroupsRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.DashboardId = dashboardId;

            DashboardExternal_GroupsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetDashboardExternal_Groups(request);
            });

            Base.TotalItemCount = response.TotalItemCount;

            return response.DashboardExternal_Group;
        }

        public void Update(DashboardExternal_Groups dashboardExternal_Groups)
        {
            dashboardExternal_Groups.UpdatedBy = Base.LoginSession.intUserId;
            var request = new DashboardExternal_GroupsRequest().Prepare();
            request.Action = Resource.Action_Update;
            request.DashboardExternal_Group = dashboardExternal_Groups;

            DashboardExternal_GroupsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetDashboardExternal_Groups(request);
            });

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Insert(DashboardExternal_Groups dashboardExternal_Groups)
        {
            dashboardExternal_Groups.Create_Date = DateTime.Now;
            dashboardExternal_Groups.Owner = Base.LoginSession.intUserId;
            var request = new DashboardExternal_GroupsRequest().Prepare();
            request.Action = Resource.Action_Create;
            request.DashboardExternal_Group = dashboardExternal_Groups;

            DashboardExternal_GroupsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetDashboardExternal_Groups(request);
            });

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Delete(int dashboardExternalGroupId)
        {
            var request = new DashboardExternal_GroupsRequest().Prepare();
            request.Action = Resource.Action_Delete;
            request.DashboardExternal_GroupId = dashboardExternalGroupId;

            DashboardExternal_GroupsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetDashboardExternal_Groups(request);
            });

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }
    }
}