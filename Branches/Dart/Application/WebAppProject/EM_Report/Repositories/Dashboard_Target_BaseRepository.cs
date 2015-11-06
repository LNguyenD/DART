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
    public interface IDashboard_Target_BaseRepository
    {
        List<Dashboard_Target_Base> GetList(string systemName);
        List<Dashboard_Target_Base> GetList(string systemName, string search, string sort);
        List<Dashboard_Target_Base> GetList(string systemName, string search, string sort, int pageindex, int pagesize);
        Dashboard_Target_Base GetById(string systemName, int projectionId);
        void Insert(string systemName, Dashboard_Target_Base projection);
        void Update(string systemName, Dashboard_Target_Base projection);
        void Delete(string systemName, int projectionId);
        void DeleteAll(string systemName);
    }

    public class Dashboard_Target_BaseRepository : RepositoryBase, IDashboard_Target_BaseRepository
    {
        public List<Dashboard_Target_Base> GetList(string systemName)
        {
            var request = new Dashboard_Target_BaseRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List};
            request.Criteria = new Criteria { SystemName=systemName};

            Dashboard_Target_BaseResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetDashboard_Target_Base(request);
            });

            Base.TotalItemCount = response.TotalItemCount;

            return response.Dashboard_Target_Bases == null ? null : response.Dashboard_Target_Bases.ToList();
        }

        public List<Dashboard_Target_Base> GetList(string systemName, string search, string sort)
        {
            var request = new Dashboard_Target_BaseRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };

            request.Criteria = new Criteria { SystemName = systemName, SortExpression = sort, SearchKeyWord = search };

            Dashboard_Target_BaseResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetDashboard_Target_Base(request);
            });

            Base.TotalItemCount = response.TotalItemCount;

            return response.Dashboard_Target_Bases == null ? null : response.Dashboard_Target_Bases.ToList();
        }

        public List<Dashboard_Target_Base> GetList(string systemName, string search, string sort, int pageindex, int pagesize)
        {
            var request = new Dashboard_Target_BaseRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };

            request.Criteria = new Criteria { SystemName = systemName, SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize };

            Dashboard_Target_BaseResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetDashboard_Target_Base(request);
            });

            Base.TotalItemCount = response.TotalItemCount;

            return response.Dashboard_Target_Bases == null ? null : response.Dashboard_Target_Bases.ToList();
        }

        public void Insert(string systemName, Dashboard_Target_Base target_base)
        {
            var request = new Dashboard_Target_BaseRequest().Prepare();
            request.Action = Resource.Action_Create;
            request.Dashboard_Target_Base = target_base;
            request.Criteria = new Criteria { SystemName = systemName};

            Dashboard_Target_BaseResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetDashboard_Target_Base(request);
            });

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Delete(string systemName, int target_baseId)
        {
            var request = new Dashboard_Target_BaseRequest().Prepare();
            request.Action = Resource.Action_Delete;
            request.Id = target_baseId;
            request.Criteria = new Criteria { SystemName = systemName };

            Dashboard_Target_BaseResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetDashboard_Target_Base(request);
            });

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void DeleteAll(string systemName)
        {
            var request = new Dashboard_Target_BaseRequest().Prepare();
            request.Action = Resource.Action_DeleteAll;
            request.Criteria = new Criteria { SystemName = systemName };

            Dashboard_Target_BaseResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetDashboard_Target_Base(request);
            });

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Update(string systemName, Dashboard_Target_Base target_base)
        {
            var request = new Dashboard_Target_BaseRequest().Prepare();
            request.Action = Resource.Action_Update;
            request.Dashboard_Target_Base = target_base;
            request.Criteria = new Criteria { SystemName = systemName };

            Dashboard_Target_BaseResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetDashboard_Target_Base(request);
            });

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public Dashboard_Target_Base GetById(string systemName, int target_baseId)
        {
            var request = new Dashboard_Target_BaseRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.Id = target_baseId;
            request.Criteria = new Criteria { SystemName = systemName };

            Dashboard_Target_BaseResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetDashboard_Target_Base(request);
            });

            return response.Dashboard_Target_Base;
        }
    }
}