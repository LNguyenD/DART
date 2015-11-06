using System;
using System.Collections.Generic;
using System.Linq;

using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using EM_Report.Domain;
using EM_Report.Service.Messages;
using EM_Report.Service.Criteria;
using EM_Report.Service.ServiceContracts;
using EM_Report.Service.MessageBase;

namespace EM_Report.Repositories
{
    public interface IDashboardLevelRepository
    {
        List<Dashboard_Levels> GetList();
        List<Dashboard_Levels> GetList(string search, string sort, int pageindex, int pagesize);
        List<Dashboard_Levels> GetList(string search, string sort);
        Dashboard_Levels GetById(int dashboardLevelId);
        void Update(Dashboard_Levels dashboardLevel);
        void Insert(Dashboard_Levels dashboardLevel);
        void UpdateStatus(string listOption);
    }

    public class DashboardLevelRepository : RepositoryBase, IDashboardLevelRepository
    {
        /// <summary>
        /// Gets list of reports.
        /// </summary>
        /// <returns></returns>
        public List<Dashboard_Levels> GetList()
        {
            var request = new Dashboard_LevelsRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List };
            request.Criteria = new Criteria();

            Dashboard_LevelsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetDashBoardLevels(request);
            });

            Base.TotalItemCount = response.TotalItemCount;

            return response.DashboardLevelses == null ? null : response.DashboardLevelses.ToList();
        }
        public List<Dashboard_Levels> GetList(string search, string sort)
        {
            var request = new Dashboard_LevelsRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search };

            Dashboard_LevelsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetDashBoardLevels(request);
            });
            Base.TotalItemCount = response.TotalItemCount;

            return response.DashboardLevelses == null ? null : response.DashboardLevelses.ToList();
        }
        public List<Dashboard_Levels> GetList(string search, string sort, int pageindex, int pagesize)
        {
            var request = new Dashboard_LevelsRequest().Prepare();
            request.LoadOptions = Base.LoginSession.isSystemUser ? new[] { Resource.Get_Option_List } : new[] { Resource.Get_Option_List_UserCanAccess };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize };

            Dashboard_LevelsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetDashBoardLevels(request);
            });
            Base.TotalItemCount = response.TotalItemCount;

            return response.DashboardLevelses == null ? null : response.DashboardLevelses.ToList();
        }
        public Dashboard_Levels GetById(int dashboardLevelId)
        {
            var request = new Dashboard_LevelsRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.DashboardLevelId = dashboardLevelId;

            Dashboard_LevelsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetDashBoardLevels(request);
            });


            return response.DashboardLevels;
        }
        public void Update(Dashboard_Levels dashboardLevel)
        {
            dashboardLevel.UpdatedBy = Base.LoginSession.intUserId;
            var request = new Dashboard_LevelsRequest().Prepare();
            request.Action = Resource.Action_Update;
            request.DashboardLevels = dashboardLevel;

            Dashboard_LevelsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetDashBoardLevels(request);
            });


            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }
        public void Insert(Dashboard_Levels dashboardLevel)
        {
            dashboardLevel.Create_Date = DateTime.Now;
            dashboardLevel.Owner = Base.LoginSession.intUserId;
            var request = new Dashboard_LevelsRequest().Prepare();
            request.Action = Resource.Action_Create;
            request.DashboardLevels = dashboardLevel;

            Dashboard_LevelsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetDashBoardLevels(request);
            });


            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }
        public void Delete(int dashboardLevelId)
        {
            var request = new Dashboard_LevelsRequest().Prepare();
            request.Action = Resource.Action_Delete;
            request.DashboardLevelId = dashboardLevelId;

            Dashboard_LevelsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetDashBoardLevels(request);
            });


            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }
        public void UpdateStatus(Dashboard_Levels dashboardLevels, short status)
        {
            dashboardLevels.UpdatedBy = Base.LoginSession.intUserId;
            var request = new Dashboard_LevelsRequest().Prepare();
            request.Action = Resource.Action_UpdateStatus;
            request.Criteria = new Criteria() { Status = status };
            request.DashboardLevels = dashboardLevels;

            Dashboard_LevelsResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetDashBoardLevels(request);
            });


            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }
        public void UpdateStatus(string listOption)
        {
            if (!string.IsNullOrEmpty(listOption))
            {
                Dashboard_Levels model;
                string[] listOptionSplit = listOption.Split('|');
                if (listOptionSplit.Length > 0)
                {
                    foreach (var item in listOptionSplit[1].Split(','))
                    {
                        model = GetById(int.Parse(item));
                        if (listOptionSplit[0].ToString() == Control.Status_Delete)
                        {
                            Delete(int.Parse(item));
                        }
                        else
                        {
                            UpdateStatus(model, short.Parse(listOptionSplit[0]));
                        }
                    }
                }
            }
        }
    }
}