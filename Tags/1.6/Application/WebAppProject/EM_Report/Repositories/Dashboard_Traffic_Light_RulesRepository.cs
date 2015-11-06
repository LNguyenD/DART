using System;
using System.Collections.Generic;
using System.Linq;
using EM_Report.ActionServiceReference;
using EM_Report.Domain;
using EM_Report.Domain.Resources;
using EM_Report.Helpers;

namespace EM_Report.Repositories
{
    public interface IDashboard_Traffic_Light_RulesRepository
    {
        List<Dashboard_Traffic_Light_Rule> GetList();

        List<Dashboard_Traffic_Light_Rule> GetList(string search, string sort);

        List<Dashboard_Traffic_Light_Rule> GetList(string search, string sort, int pageindex, int pagesize);

        List<Dashboard_Traffic_Light_Rule> GetList(string search, string sort, int pageindex, int pagesize, int systemid);

        Dashboard_Traffic_Light_Rule Get(string dashboardType, string name, int systemid);

        string GetFilteredList(bool filteredFlag, string parseString, int systemid);

        Dashboard_Traffic_Light_Rule GetById(int Id);

        void Insert(Dashboard_Traffic_Light_Rule dashboardTrafficLightRules);

        void Update(Dashboard_Traffic_Light_Rule target);

        void Delete(int Id);

        void DeleteAll();
    }

    public class Dashboard_Traffic_Light_RulesRepository : RepositoryBase, IDashboard_Traffic_Light_RulesRepository
    {
        public Dashboard_Traffic_Light_Rule Get(string dashboardType, string name, int systemid)
        {
            var request = new Dashboard_Traffic_Light_RulesRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List };
            request.Criteria = new Criteria();
            request.DashboardType = dashboardType;
            request.Name = name;
            request.SystemId = systemid;
            var response = Client.GetDashboard_Traffic_Light_Rules(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Dashboard_Traffic_Light_Rules == null ? null : response.Dashboard_Traffic_Light_Rules.ToList().FirstOrDefault();
        }

        public List<Dashboard_Traffic_Light_Rule> GetList()
        {
            var request = new Dashboard_Traffic_Light_RulesRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List };
            request.Criteria = new Criteria();
            var response = Client.GetDashboard_Traffic_Light_Rules(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Dashboard_Traffic_Light_Rules == null ? null : response.Dashboard_Traffic_Light_Rules.ToList();
        }

        public List<Dashboard_Traffic_Light_Rule> GetList(string search, string sort)
        {
            var request = new Dashboard_Traffic_Light_RulesRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search };

            var response = Client.GetDashboard_Traffic_Light_Rules(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Dashboard_Traffic_Light_Rules == null ? null : response.Dashboard_Traffic_Light_Rules.ToList();
        }

        public List<Dashboard_Traffic_Light_Rule> GetList(string search, string sort, int pageindex, int pagesize)
        {
            var request = new Dashboard_Traffic_Light_RulesRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize };

            var response = Client.GetDashboard_Traffic_Light_Rules(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Dashboard_Traffic_Light_Rules == null ? null : response.Dashboard_Traffic_Light_Rules.ToList();
        }

        public List<Dashboard_Traffic_Light_Rule> GetList(string search, string sort, int pageindex, int pagesize, int systemid)
        {
            var request = new Dashboard_Traffic_Light_RulesRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };

            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize, SystemId = systemid };
            
            var response = Client.GetDashboard_Traffic_Light_Rules(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.Dashboard_Traffic_Light_Rules == null ? null : response.Dashboard_Traffic_Light_Rules.ToList();
        }

        public string GetFilteredList(bool filteredFlag, string parseString, int systemid)
        {
            var request = new Dashboard_Traffic_Light_RulesRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };
            request.SystemId = systemid;
            request.filteredFlag = filteredFlag;
            request.parseString = parseString;

            request.Criteria = new Criteria ();

            var response = Client.GetDashboard_Traffic_Light_Rules(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.parseString == null ? null : response.parseString;
        }

        public Dashboard_Traffic_Light_Rule GetById(int Id)
        {
            var request = new Dashboard_Traffic_Light_RulesRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.Id = Id;

            var response = Client.GetDashboard_Traffic_Light_Rules(request);

            Correlate(request, response);

            return response.Dashboard_Traffic_Light_Rule;
        }

        public void Insert(Dashboard_Traffic_Light_Rule target)
        {
            target.Create_Date = DateTime.Now;
            target.Owner = Base.LoginSession.intUserId;
            var request = new Dashboard_Traffic_Light_RulesRequest().Prepare();
            request.Action = Resource.Action_Create;
            request.Dashboard_Traffic_Light_Rules = target;

            var response = Client.SetDashboard_Traffic_Light_Rules(request);
            Correlate(request, response);

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Update(Dashboard_Traffic_Light_Rule target)
        {
            target.UpdatedBy = Base.LoginSession.intUserId;
            var request = new Dashboard_Traffic_Light_RulesRequest().Prepare();
            request.Action = Resource.Action_Update;
            request.Dashboard_Traffic_Light_Rules = target;

            var response = Client.SetDashboard_Traffic_Light_Rules(request);

            Correlate(request, response);

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Delete(int Id)
        {
            var request = new Dashboard_Traffic_Light_RulesRequest().Prepare();
            request.Action = Resource.Action_Delete;
            request.Id = Id;

            var response = Client.SetDashboard_Traffic_Light_Rules(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void DeleteAll()
        {
            var request = new Dashboard_Traffic_Light_RulesRequest().Prepare();
            request.Action = Resource.Action_DeleteAll;

            var response = Client.SetDashboard_Traffic_Light_Rules(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }
    }
}