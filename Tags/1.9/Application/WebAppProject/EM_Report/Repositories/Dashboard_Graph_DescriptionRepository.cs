using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using EM_Report.Domain;
using System.Web.Mvc;
using EM_Report.Service.Messages;
using EM_Report.Service.Criteria;
using EM_Report.Service.ServiceContracts;
using EM_Report.Service.MessageBase;

namespace EM_Report.Repositories
{
    public interface IDashboard_Graph_DescriptionRepository
    {
        Dashboard_Graph_Description GetById(int id);
        List<Dashboard_Graph_Description> GetList(string type, int systemId);
        List<Dashboard_Graph_Description> GetList();
        List<Dashboard_Graph_Description> GetList(string search, string sort, int systemID);
        List<Dashboard_Graph_Description> GetList(string search, string sort, int pageindex, int pagesize, int systemID);
        void Insert(Dashboard_Graph_Description description);
        void Update(Dashboard_Graph_Description description);
        void Delete(int descriptionId);
        void DeleteAll();       
    }

    public class Dashboard_Graph_DescriptionRepository : RepositoryBase, IDashboard_Graph_DescriptionRepository
    {
        public Dashboard_Graph_Description GetById(int id)
        {
            var request = new Dashboard_Graph_DescriptionRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.DescriptionId = id;

            Dashboard_Graph_DescriptionResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetDashboard_Graph_Description(request);
            });

            return response.Dashboard_Graph_Description;
        }

        public List<Dashboard_Graph_Description> GetList(string type, int systemId)
        {
            var request = new Dashboard_Graph_DescriptionRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List };
            request.Criteria = new Criteria();
            request.Type = type;
            request.SystemId = systemId;

            Dashboard_Graph_DescriptionResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetDashboard_Graph_Description(request);
            });
            Base.TotalItemCount = response.TotalItemCount;

            return response.Dashboard_Graph_Descriptions == null ? null : response.Dashboard_Graph_Descriptions.ToList();
        }

        public List<Dashboard_Graph_Description> GetList()
        {
            var request = new Dashboard_Graph_DescriptionRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List };
            request.Criteria = new Criteria();

            Dashboard_Graph_DescriptionResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetDashboard_Graph_Description(request);
            });

            Base.TotalItemCount = response.TotalItemCount;

            return response.Dashboard_Graph_Descriptions == null ? null : response.Dashboard_Graph_Descriptions.ToList();
        }

        public List<Dashboard_Graph_Description> GetList(string search, string sort, int systemID)
        {
            var request = new Dashboard_Graph_DescriptionRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };

            request.SystemId = systemID;
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search };

            Dashboard_Graph_DescriptionResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetDashboard_Graph_Description(request);
            });

            Base.TotalItemCount = response.TotalItemCount;

            return response.Dashboard_Graph_Descriptions == null ? null : response.Dashboard_Graph_Descriptions.ToList();
        }

        public List<Dashboard_Graph_Description> GetList(string search, string sort, int pageindex, int pagesize, int systemID)
        {
            var request = new Dashboard_Graph_DescriptionRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };

            request.Criteria = new Criteria { SystemId = systemID, SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize };

            Dashboard_Graph_DescriptionResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetDashboard_Graph_Description(request);
            });

            Base.TotalItemCount = response.TotalItemCount;

            return response.Dashboard_Graph_Descriptions == null ? null : response.Dashboard_Graph_Descriptions.ToList();
        }

        public void Insert(Dashboard_Graph_Description description)
        {
            description.Create_Date = DateTime.Now;
            description.Owner = Base.LoginSession.intUserId;
            var request = new Dashboard_Graph_DescriptionRequest().Prepare();
            request.Action = Resource.Action_Create;
            request.Dashboard_Graph_Descriptions = description;

            Dashboard_Graph_DescriptionResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetDashboard_Graph_Description(request);
            });

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Delete(int DescriptionId)
        {
            var request = new Dashboard_Graph_DescriptionRequest().Prepare();
            request.Action = Resource.Action_Delete;
            request.DescriptionId = DescriptionId;

            Dashboard_Graph_DescriptionResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetDashboard_Graph_Description(request);
            });

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void DeleteAll()
        {
            var request = new Dashboard_Graph_DescriptionRequest().Prepare();
            request.Action = Resource.Action_DeleteAll;

            Dashboard_Graph_DescriptionResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetDashboard_Graph_Description(request);
            });

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Update(Dashboard_Graph_Description description)
        {
            description.UpdatedBy = Base.LoginSession.intUserId;
            var request = new Dashboard_Graph_DescriptionRequest().Prepare();
            request.Action = Resource.Action_Update;
            request.Dashboard_Graph_Descriptions = description;

            Dashboard_Graph_DescriptionResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetDashboard_Graph_Description(request);
            });

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }        
    }
}