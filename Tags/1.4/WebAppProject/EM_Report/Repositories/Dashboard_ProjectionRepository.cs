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
    public interface IDashboard_ProjectionRepository
    {
        List<Dashboard_Projection> GetList(string systemName);
        List<Dashboard_Projection> GetList(string systemName, string search, string sort);
        List<Dashboard_Projection> GetList(string systemName, string search, string sort, int pageindex, int pagesize );
        Dashboard_Projection GetDuplicatedList(string systemName, string unitName, string unitType, string Type, string timeId);
        Dashboard_Projection GetById(string systemName, int projectionId);
        void Insert(string systemName, Dashboard_Projection projection);
        void Update(string systemName, Dashboard_Projection projection);
        void Delete(string systemName, int projectionId);
        void SignalProjectionImport(string systemName, string dataPath);
        void DeleteAll(string systemName);
    }

    public class Dashboard_ProjectionRepository : RepositoryBase, IDashboard_ProjectionRepository
    {
        public Dashboard_Projection GetDuplicatedList(string systemName, string unitName, string unitType, string Type, string timeId)
        {
            var request = new Dashboard_ProjectionRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.Criteria = new Criteria { SystemName = systemName };
            request.Unit_Name = unitName;
            request.Unit_Type = unitType;
            request.Time_Id = timeId;
            request.Type = Type;

            var response = Client.GetDashboard_Projection(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.Dashboard_Projection;
        }

        public List<Dashboard_Projection> GetList(string systemName)
        {
            var request = new Dashboard_ProjectionRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List};
            request.Criteria = new Criteria { SystemName=systemName};

            var response = Client.GetDashboard_Projection(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.Dashboard_Projections == null ? null : response.Dashboard_Projections.ToList();
        }

        public List<Dashboard_Projection> GetList(string systemName, string search, string sort)
        {
            var request = new Dashboard_ProjectionRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };

            request.Criteria = new Criteria { SystemName = systemName, SortExpression = sort, SearchKeyWord = search };

            var response = Client.GetDashboard_Projection(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.Dashboard_Projections == null ? null : response.Dashboard_Projections.ToList();
        }

        public List<Dashboard_Projection> GetList(string systemName, string search, string sort, int pageindex, int pagesize)
        {
            var request = new Dashboard_ProjectionRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };

            request.Criteria = new Criteria { SystemName = systemName, SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize };

            var response = Client.GetDashboard_Projection(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.Dashboard_Projections == null ? null : response.Dashboard_Projections.ToList();
        }

        public void Insert(string systemName, Dashboard_Projection projection)
        {
            var request = new Dashboard_ProjectionRequest().Prepare();
            request.Action = Resource.Action_Create;
            request.Dashboard_Projection = projection;
            request.Criteria = new Criteria { SystemName = systemName};

            var response = Client.SetDashboard_Projection(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void SignalProjectionImport(string systemName, string dataPath)
        {
            var request = new Dashboard_ProjectionRequest().Prepare();
            request.Action = Resource.Action_Create;
            request.ProjectionDataPath = dataPath;
            request.Criteria = new Criteria { SystemName = systemName};

            var response = Client.SignalProjectionImport(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Delete(string systemName, int projectionId)
        {
            var request = new Dashboard_ProjectionRequest().Prepare();
            request.Action = Resource.Action_Delete;
            request.Id = projectionId;
            request.Criteria = new Criteria { SystemName = systemName };

            var response = Client.SetDashboard_Projection(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void DeleteAll(string systemName)
        {
            var request = new Dashboard_ProjectionRequest().Prepare();
            request.Action = Resource.Action_DeleteAll;
            request.Criteria = new Criteria { SystemName = systemName };

            var response = Client.SetDashboard_Projection(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Update(string systemName, Dashboard_Projection projection)
        {
            var request = new Dashboard_ProjectionRequest().Prepare();
            request.Action = Resource.Action_Update;
            request.Dashboard_Projection = projection;
            request.Criteria = new Criteria { SystemName = systemName };

            var response = Client.SetDashboard_Projection(request);

            Correlate(request, response);

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public Dashboard_Projection GetById(string systemName, int projectionId)
        {
            var request = new Dashboard_ProjectionRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.Id = projectionId;
            request.Criteria = new Criteria { SystemName = systemName };

            var response = Client.GetDashboard_Projection(request);

            Correlate(request, response);

            return response.Dashboard_Projection;
        }
    }
}