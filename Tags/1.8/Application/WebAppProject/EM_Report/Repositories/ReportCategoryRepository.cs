using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using EM_Report.Domain;
using EM_Report.Service.Messages;
using EM_Report.Service.Criteria;
using EM_Report.Service.ServiceContracts;
using EM_Report.Service.MessageBase;

namespace EM_Report.Repositories
{
    /// <summary>
    /// User Repository interface.
    /// Note: does not derive from IRepository.
    /// </summary>
    public interface IReportCategoryRepository
    {
        List<Report_Categories> GetList();
        List<Report_Categories> GetList(string search, string sort);
        List<Report_Categories> GetList(string search, string sort, int pageindex, int pagesize);
        List<Report_Categories> GetListCategoriesUserCanAccess(int userid);
        Report_Categories Get(int categoryId);
        void Insert(Report_Categories category);
        void Update(Report_Categories category);
        void UpdateStatus(Report_Categories category, short status);
        void Delete(int categoryId);
        void UpdateStatus(string listOption);
    }
    public class ReportCategoryRepository : RepositoryBase, IReportCategoryRepository
    {
        /// <summary>
        /// Gets list of report categories.
        /// </summary>
        /// <param name="criterion"></param>
        /// <returns></returns>
        public List<Report_Categories> GetList()
        {
            var request = new ReportCategoryRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };
            request.Criteria = new Criteria();

            ReportCategoryResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetRptCategories(request);
            }); 

            Base.TotalItemCount = response.TotalItemCount;

            return response.ReportCategories == null ? null : response.ReportCategories.ToList();
        }
        /// <summary>
        /// Gets list of report categories.
        /// </summary>
        /// <param name="criterion"></param>
        /// <returns></returns>
        public List<Report_Categories> GetList(string search, string sort)
        {
            var request = new ReportCategoryRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search };

            ReportCategoryResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetRptCategories(request);
            }); 

            Base.TotalItemCount = response.TotalItemCount;     

            return response.ReportCategories == null ? null : response.ReportCategories.ToList();
        }

        /// <summary>
        /// Gets list of category report.
        /// </summary>
        /// <param name="criterion"></param>
        /// <returns></returns>
        public List<Report_Categories> GetList(string search, string sort, int pageindex, int pagesize)
        {
            var request = new ReportCategoryRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };
            request.Criteria = new Criteria{ SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize };

            ReportCategoryResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetRptCategories(request);
            }); 

            Base.TotalItemCount = response.TotalItemCount;            

            return response.ReportCategories == null ? null : response.ReportCategories.ToList();
        }

        /// <summary>
        /// Gets list of category reports that user can access.
        /// </summary>
        /// <param name="criterion"></param>
        /// <returns></returns>
        public List<Report_Categories> GetListCategoriesUserCanAccess(int userid)
        {
            var request = new ReportCategoryRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List_UserCanAccess };
            request.UserId = userid;

            ReportCategoryResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetRptCategories(request);
            });            

            Base.TotalItemCount = response.TotalItemCount;            

            return response.ReportCategories == null ? null : response.ReportCategories.ToList();
        }

        /// <summary>
        /// Gets an individual report category by id.
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public Report_Categories Get(int categoryId)
        {
            var request = new ReportCategoryRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.CategoryId = categoryId;

            ReportCategoryResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetRptCategories(request);
            }); 

           
            return response.ReportCategory;
        }

        /// <summary>
        /// Inserts a new report category.
        /// </summary>
        /// <param name="user"></param>
        public void Insert(Report_Categories category)
        {
            category.Create_Date = DateTime.Now;
            category.Owner = Base.LoginSession.intUserId;
            var request = new ReportCategoryRequest().Prepare();
            request.Action = Resource.Action_Create;
            request.ReportCategory = category;

            ReportCategoryResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetRptCategories(request);
            });         

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        /// <summary>
        /// Updates an existing report category.
        /// </summary>
        /// <param name="user"></param>
        public void Update(Report_Categories category)
        {
            category.UpdatedBy = Base.LoginSession.intUserId;            
            var request = new ReportCategoryRequest().Prepare();
            request.Action = Resource.Action_Update;
            request.ReportCategory = category;

            ReportCategoryResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetRptCategories(request);
            });           

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        /// <summary>
        /// Updates Status an existing report category.
        /// </summary>
        /// <param name="user"></param>
        public void UpdateStatus(Report_Categories category, short status)
        {
            category.UpdatedBy = Base.LoginSession.intUserId;
            var request = new ReportCategoryRequest().Prepare();
            request.Action = Resource.Action_UpdateStatus;
            request.Criteria = new Criteria { Status = status };
            request.ReportCategory = category;

            ReportCategoryResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetRptCategories(request);
            });  

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        /// <summary>
        /// Deletes an existing category report.
        /// </summary>
        /// <param name="userId"></param>
        public void Delete(int categoryId)
        {
            var request = new ReportCategoryRequest().Prepare();

            request.Action = Resource.Action_Delete;
            request.CategoryId = categoryId;

            ReportCategoryResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetRptCategories(request);
            });  

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);

            // return response.RowsAffected;
        }

        public void UpdateStatus(string listOption)
        {
            if (!string.IsNullOrEmpty(listOption))
            {
                var selectedItems = listOption.Split('|');
                Report_Categories model;
                if (selectedItems.Length > 0)
                {
                    foreach (var item in selectedItems[1].Split(','))
                    {
                        model = Get(Convert.ToInt32(item));
                        UpdateStatus(model, short.Parse(selectedItems[0]));
                    }
                }
            }
        }
    }
}