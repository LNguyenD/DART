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
    /// Report Repository interface.
    /// Note: does not derive from IRepository.
    /// </summary>
    public interface IDashboardRepository
    {
        List<Dashboard> GetList();
        List<Dashboard> GetList(string search, string sort, int pageindex, int pagesize, int systemid);
        List<Dashboard> GetList(string search, string sort);
        void UpdateStatus(string listOption);       
        Dashboard GetById(int dashboardId);
        void Update(Dashboard dashboard);
        void Insert(Dashboard dashboard);
        void Delete(int dashboardId);
        List<Dashboard_Traffic_Light_Rule> GetList_TrafficLight(int systemid);
    }

    public class DashboardRepository :RepositoryBase,IDashboardRepository
    {
        /// <summary>
        /// Gets list of reports.
        /// </summary>
        /// <returns></returns>
        public List<Dashboard> GetList()
        {
            var request = new DashboardRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List };
            request.Criteria = new Criteria();
            var response = Client.GetDashBoards(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Dashboards == null ? null : response.Dashboards.ToList();
        }
        public List<Dashboard> GetList(string search, string sort)
        {
            var request = new DashboardRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search };

            var response = Client.GetDashBoards(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Dashboards == null ? null : response.Dashboards.ToList();
        }
        public List<Dashboard> GetList(string search, string sort, int pageindex, int pagesize, int systemid)
        {
            var request = new DashboardRequest().Prepare();
            request.LoadOptions = Base.LoginSession.isSystemUser ? new[] { Resource.Get_Option_List } : new[] { Resource.Get_Option_List_UserCanAccess };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize, SystemId = systemid };
            request.UserId = Base.LoginSession.intUserId;
            request.IsSystemUser = Base.LoginSession.isSystemUser;

            var response = Client.GetDashBoards(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Dashboards == null ? null : response.Dashboards.ToList();
        }
        public Dashboard GetById(int dashboardId)
        {
            var request = new DashboardRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.DashboardId = dashboardId;

            var response = Client.GetDashBoards(request);

            Correlate(request, response);

            return response.Dashboard;
        }
        public void UpdateStatus(Dashboard dashboard, short status)
        {
            dashboard.UpdatedBy = Base.LoginSession.intUserId;
            var request = new DashboardRequest().Prepare();
            request.Action = Resource.Action_UpdateStatus;
            request.Criteria = new Criteria { Status = status };
            request.Dashboard = dashboard;

            var response = Client.SetDashBoards(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }
        public void Update(Dashboard dashboard)
        {
            dashboard.UpdatedBy = Base.LoginSession.intUserId;
            var request = new DashboardRequest().Prepare();
            request.Action = Resource.Action_Update;
            request.Dashboard = dashboard;

            var response = Client.SetDashBoards(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }
        public void Insert(Dashboard dashboard)
        {
            dashboard.Create_Date = DateTime.Now;
            dashboard.Owner = Base.LoginSession.intUserId;
            var request = new DashboardRequest().Prepare();
            request.Action = Resource.Action_Create;
            request.Dashboard = dashboard;

            var response = Client.SetDashBoards(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }
        public void Delete(int dashboardId)
        {
            var request = new DashboardRequest().Prepare();
            request.Action = Resource.Action_Delete;
            request.DashboardId = dashboardId;

            var response = Client.SetDashBoards(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }
        public void UpdateStatus(string listOption)
        {
            if (!string.IsNullOrEmpty(listOption))
            {
                Dashboard model;
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
        public List<Dashboard_Traffic_Light_Rule> GetList_TrafficLight(int systemid)
        {
            var request = new DashboardRequest().Prepare();
            request.SystemsId = systemid;
            request.LoadOptions = new[] { Resource.Get_Option_List_Traffic_Light };
            request.Criteria = new Criteria();
            var response = Client.GetDashBoards(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Dashboard_Traffic_Light_Rules == null ? null : response.Dashboard_Traffic_Light_Rules.ToList();
        }
    }
}