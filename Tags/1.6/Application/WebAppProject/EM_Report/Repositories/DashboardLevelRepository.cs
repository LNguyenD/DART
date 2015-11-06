using System;
using System.Collections.Generic;
using System.Linq;
using EM_Report.ActionServiceReference;
using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using EM_Report.Domain;

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

    public class DashboardLevelRepository :RepositoryBase,IDashboardLevelRepository
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
            var response = Client.GetDashBoardLevels(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.DashboardLevelses == null ? null : response.DashboardLevelses.ToList();
        }
        public List<Dashboard_Levels> GetList(string search, string sort)
        {
            var request = new Dashboard_LevelsRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search };

            var response = Client.GetDashBoardLevels(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.DashboardLevelses == null ? null : response.DashboardLevelses.ToList();
        }
        public List<Dashboard_Levels> GetList(string search, string sort, int pageindex, int pagesize)
        {
            var request = new Dashboard_LevelsRequest().Prepare();
            request.LoadOptions = Base.LoginSession.isSystemUser ? new[] { Resource.Get_Option_List } : new[] { Resource.Get_Option_List_UserCanAccess };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize };

            var response = Client.GetDashBoardLevels(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.DashboardLevelses == null ? null : response.DashboardLevelses.ToList();
        }
        public Dashboard_Levels GetById(int dashboardLevelId)
        {
            var request = new Dashboard_LevelsRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.DashboardLevelId = dashboardLevelId;
            var response = Client.GetDashBoardLevels(request);

            Correlate(request, response);

            return response.DashboardLevels;
        }
        public void Update(Dashboard_Levels dashboardLevel)
        {
            dashboardLevel.UpdatedBy = Base.LoginSession.intUserId;
            var request = new Dashboard_LevelsRequest().Prepare();
            request.Action = Resource.Action_Update;
            request.DashboardLevels = dashboardLevel;

            var response = Client.SetDashBoardLevels(request);

            Correlate(request, response);

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

            var response = Client.SetDashBoardLevels(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }
        public void Delete(int dashboardLevelId)
        {
            var request = new Dashboard_LevelsRequest().Prepare();
            request.Action = Resource.Action_Delete;
            request.DashboardLevelId = dashboardLevelId;

            var response = Client.SetDashBoardLevels(request);

            Correlate(request, response);

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

            var response = Client.SetDashBoardLevels(request);

            Correlate(request, response);

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