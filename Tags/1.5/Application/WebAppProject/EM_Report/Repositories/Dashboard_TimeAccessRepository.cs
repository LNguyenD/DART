using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EM_Report.ActionServiceReference;
using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using EM_Report.Domain;
using System.Web.Mvc;

namespace EM_Report.Repositories
{
    public interface IDashboard_TimeAccessRepository
    {
        List<Dashboard_TimeAccess> GetList();
        List<Dashboard_TimeAccess> GetList(string search, string sort);
        List<Dashboard_TimeAccess> GetList(string search, string sort, int pageindex, int pagesize);
        List<Dashboard_TimeAccess> GetList(string search, string sort, int pageindex, int pagesize, int systemid);
        Dashboard_TimeAccess GetById(int Id);
        void Insert(Dashboard_TimeAccess dashboardTimeAccess);
        void Update(Dashboard_TimeAccess rpt, string name, int updateby);
        void Delete(int Id);
    }

    public class Dashboard_TimeAccessRepository: RepositoryBase, IDashboard_TimeAccessRepository
    {
        public List<Dashboard_TimeAccess> GetList()
        {
            var request = new Dashboard_TimeAccessRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List };
            request.Criteria = new Criteria();
            var response = Client.GetDashboard_TimeAccess(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Dashboard_TimeAccesss == null ? null : response.Dashboard_TimeAccesss.ToList();
        }

        public List<Dashboard_TimeAccess> GetList(string search, string sort)
        {
            var request = new Dashboard_TimeAccessRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search };

            var response = Client.GetDashboard_TimeAccess(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Dashboard_TimeAccesss == null ? null : response.Dashboard_TimeAccesss.ToList();
        }

        public List<Dashboard_TimeAccess> GetList(string search, string sort, int pageindex, int pagesize)
        {
            var request = new Dashboard_TimeAccessRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize };

            var response = Client.GetDashboard_TimeAccess(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Dashboard_TimeAccesss == null ? null : response.Dashboard_TimeAccesss.ToList();
        }

        public List<Dashboard_TimeAccess> GetList(string search, string sort, int pageindex, int pagesize, int systemid)
        {
            var request = new Dashboard_TimeAccessRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };

            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize, SystemId = systemid };

            var response = Client.GetDashboard_TimeAccess(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.Dashboard_TimeAccesss == null ? null : response.Dashboard_TimeAccesss.ToList();
        }

        public Dashboard_TimeAccess GetById(int Id)
        {
            var request = new Dashboard_TimeAccessRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.Id = Id;

            var response = Client.GetDashboard_TimeAccess(request);

            Correlate(request, response);

            return response.Dashboard_TimeAccess;
        }

        public void Insert(Dashboard_TimeAccess rpt)
        {           
            var request = new Dashboard_TimeAccessRequest().Prepare();
            request.Action = Resource.Action_Create;
            request.Dashboard_TimeAccess = rpt;

            var response = Client.SetDashboard_TimeAccess(request);
            Correlate(request, response);

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Update(Dashboard_TimeAccess rpt, string name, int updatedby)
        {
            //rpt.UpdatedBy = Base.LoginSession.intUserId;
            var request = new Dashboard_TimeAccessRequest().Prepare();
            request.Action = Resource.Action_Update;
            //request.Name = name;
            //request.UpdateBy = updatedby;
            request.Dashboard_TimeAccess = rpt;

            var response = Client.SetDashboard_TimeAccess(request);
            Correlate(request, response);

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Delete(int Id)
        {
            var request = new Dashboard_TimeAccessRequest().Prepare();
            request.Action = Resource.Action_Delete;
            request.Id = Id;

            var response = Client.SetDashboard_TimeAccess(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }
    }
}