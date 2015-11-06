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
    /// <summary>
    /// Dashboard_Favour Repository interface
    /// note: dose not derive from IRepository
    /// </summary>
    public interface IDashboard_FavoursRepository
    {
        List<Dashboard_Favours> GetList();
        List<Dashboard_Favours> GetList(string search, string sort);
        List<Dashboard_Favours> GetList(string search, string sort, int pageindex, int pagesize);
        Dashboard_Favours GetByUserId(int userId);
        Dashboard_Favours GetById(int favourId);
        void Insert(Dashboard_Favours dashboardFavour);
        bool Update(Dashboard_Favours rpt,string name, int updateby);
        void Delete(int favourId);      
    }

    /// <summary>
    /// Dashboard_Favour Repository.
    /// </summary>
    public class Dashboard_FavoursRepository : RepositoryBase, IDashboard_FavoursRepository
    {
        /// <summary>
        /// Get list of Dashboard_Favours
        /// </summary>
        /// <returns></returns>
        public List<Dashboard_Favours> GetList()
        {
            var request = new Dashboard_FavoursRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List };
            request.Criteria = new Criteria();
            var response = Client.GetDashboard_Favours(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Dashboard_Favours == null ? null : response.Dashboard_Favours.ToList();
        }

        /// <summary>
        /// Gets list of Dashboard_Favours
        /// </summary>
        /// <param name="search"></param>
        /// <param name="sort"></param>
        /// <returns></returns>
        public List<Dashboard_Favours> GetList(string search, string sort)
        {
            var request = new Dashboard_FavoursRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search };

            var response = Client.GetDashboard_Favours(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Dashboard_Favours == null ? null : response.Dashboard_Favours.ToList();
        }

        /// <summary>
        /// Gets list of Dashboard_Favours.
        /// </summary>
        /// <param name="search"></param>
        /// <param name="sort"></param>
        /// <param name="pageindex"></param>
        /// <param name="pagesize"></param>
        /// <returns></returns>
        public List<Dashboard_Favours> GetList(string search, string sort, int pageindex, int pagesize)
        {
            var request = new Dashboard_FavoursRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize };

            var response = Client.GetDashboard_Favours(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Dashboard_Favours == null ? null : response.Dashboard_Favours.ToList();
        }

        public Dashboard_Favours GetByUserId(int userId)
        {
            var request = new Dashboard_FavoursRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.UserId = userId;

            var response = Client.GetDashboard_Favours(request);

            Correlate(request, response);

            return response.Dashboard_Favour;
        }

        public Dashboard_Favours GetById(int favourId)
        {
            var request = new Dashboard_FavoursRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.FavourId = favourId;

            var response = Client.GetDashboard_Favours(request);

            Correlate(request, response);

            return response.Dashboard_Favour;
        }

        public void Insert(Dashboard_Favours rpt)
        {
            // rpt.Owner = Base.LoginSession.intUserId;
            var request = new Dashboard_FavoursRequest().Prepare();
            request.Action = Resource.Action_Create;
            request.Dashboard_Favours = rpt;

            var response = Client.setDashboard_Favours(request);
            Correlate(request, response);

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        /// <summary>
        /// Update an existing dashboard_favour.
        /// </summary>
        /// <param name="rpt"></param>
        public bool Update(Dashboard_Favours rpt, string name, int updatedby)
        {
            //rpt.UpdatedBy = Base.LoginSession.intUserId;
            var request = new Dashboard_FavoursRequest().Prepare();
            request.Action = Resource.Action_Update;
            request.Name = name;
            request.UpdatedBy = updatedby;
            request.Dashboard_Favours = rpt;

            var response = Client.setDashboard_Favours(request);
            Correlate(request, response);

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
            return response.IsSaveSuccess;
        }

        public void Delete(int favourId)
        {
            var request = new Dashboard_FavoursRequest().Prepare();
            request.Action = Resource.Action_Delete;
            request.FavourId = favourId;

            var response = Client.setDashboard_Favours(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }
    }
}