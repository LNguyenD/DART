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
    public interface IReportRepository
    {
        List<Report> GetList();
        List<Report> GetList(string search, string sort);
        List<Report> GetList(string search, string sort, int pageindex, int pagesize);
        List<Report> GetList(string search, string sort, int pageindex, int pagesize, int systemid);
        List<Report> GetList_Favourite(int userId);
        List<Report> GetList_Recently(int userId);
        List<Report> GetListUserCanAccess(int userId);
        List<Report> GetListByCategory(string search, string sort, int pageindex, int pagesize, int category);
        List<Report> GetListByCategory(string search, string sort, int pageindex, int pagesize, int category, int systemid);
        Report Get(int rptId);
        Report Get(string reportPath);
        Report Insert(Report rpt);
        Report Update(Report rpt);
        Report UpdateStatus(Report rpt, short status);
        void Delete(int rptId);        
        void UpdateStatus(string listOption);
        bool IsReportUserCanAccess(int userId, int reportId);
        List<Report> GetListUserCanAccess_Subscription(int userId);
    }

    /// <summary>
    /// Report Repository. Implements just one method.
    /// </summary>
    public class ReportRepository : RepositoryBase, IReportRepository
    {
        /// <summary>
        /// Gets list of reports.
        /// </summary>
        /// <returns></returns>
        public List<Report> GetList()
        {
            var request = new ReportRequest().Prepare();
            request.LoadOptions = new []{ Resource.Get_Option_List };
            request.Criteria = new Criteria();
            var response = Client.GetReports(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Reports == null ? null : response.Reports.ToList();
        }

        /// <summary>
        /// Gets list of reports.
        /// </summary>
        /// <param name="search"></param>
        /// <param name="sort"></param>
        /// <returns></returns>
        public List<Report> GetList(string search, string sort)
        {
            var request = new ReportRequest().Prepare();
            request.LoadOptions = new []{ Resource.Get_Option_List };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search };

            var response = Client.GetReports(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Reports == null ? null : response.Reports.ToList();
        }

        /// <summary>
        /// Gets list of reports.
        /// </summary>
        /// <param name="search"></param>
        /// <param name="sort"></param>
        /// <param name="pageindex"></param>
        /// <param name="pagesize"></param>
        /// <returns></returns>
        public List<Report> GetList(string search, string sort, int pageindex, int pagesize)
        {
            var request = new ReportRequest().Prepare();
            request.LoadOptions = Base.LoginSession.isSystemUser ? new[] { Resource.Get_Option_List } : new[] { Resource.Get_Option_List_UserCanAccess };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize };
            request.UserId = Base.LoginSession.intUserId;
            request.IsSystemUser = Base.LoginSession.isSystemUser;

            var response = Client.GetReports(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Reports == null ? null : response.Reports.ToList();
        }

        public List<Report> GetList(string search, string sort, int pageindex, int pagesize, int systemid)
        {
            var request = new ReportRequest().Prepare();
            request.LoadOptions = Base.LoginSession.isSystemUser ? new[] { Resource.Get_Option_List } : new[] { Resource.Get_Option_List_UserCanAccess };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize, SystemId = systemid };
            request.UserId = Base.LoginSession.intUserId;
            request.IsSystemUser = Base.LoginSession.isSystemUser;
            
            var response = Client.GetReports(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Reports == null ? null : response.Reports.ToList();
        }

        /// <summary>
        /// Gets list favourite reports of user.
        /// </summary>
        /// <param name="search"></param>
        /// <param name="sort"></param>
        /// <param name="pageindex"></param>
        /// <param name="pagesize"></param>
        /// <returns></returns>
        public List<Report> GetList_Favourite(int userId)
        {
            var request = new ReportRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List_Favourite };
            request.Criteria = new Criteria();
            request.UserId = userId;

            var response = Client.GetReports(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Reports == null ? null : response.Reports.ToList();
        }

        /// <summary>
        /// Gets list recently reports of user.
        /// </summary>
        /// <param name="search"></param>
        /// <param name="sort"></param>
        /// <param name="pageindex"></param>
        /// <param name="pagesize"></param>
        /// <returns></returns>
        public List<Report> GetList_Recently(int userId)
        {
            var request = new ReportRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List_Recently };
            request.Criteria = new Criteria();
            request.UserId = userId;

            var response = Client.GetReports(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Reports == null ? null : response.Reports.ToList();
        }

        public List<Report> GetListUserCanAccess_Subscription(int userId)
        {
            var request = new ReportRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List_UserCanAccess };
            request.Criteria = new Criteria();
            request.IsForSubscription=true;
            request.UserId = userId;
            request.IsSystemUser = Base.LoginSession.isSystemUser;

            var response = Client.GetReports(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Reports == null ? null : response.Reports.ToList();
        }

        public List<Report> GetListUserCanAccess(int userId)
        {
            var request = new ReportRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List_UserCanAccess };
            request.Criteria = new Criteria();
            request.UserId = userId;
            request.IsSystemUser = Base.LoginSession.isSystemUser;

            var response = Client.GetReports(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Reports == null ? null : response.Reports.ToList();
        }

        public bool IsReportUserCanAccess(int userId, int reportId)
        {
            var request = new ReportRequest().Prepare();
            request.Action = Resource.Action_CanAccessReport;
            request.UserId = userId;
            request.IsSystemUser = Base.LoginSession.isSystemUser;
            request.ReportId = reportId;

            var response = Client.SetReports(request);

            return response.TotalItemCount == 1;
        }

        public List<Report> GetListByCategory(string search, string sort, int pageindex, int pagesize, int category)
        {
            var request = new ReportRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List_ByCategory };
            request.Criteria = new Criteria { SearchKeyWord = search, SortExpression = sort, PageIndex = pageindex, PageSize = pagesize };
            request.CategoryId = category;
            request.UserId=Base.LoginSession.intUserId;
            request.IsSystemUser = Base.LoginSession.isSystemUser;

            var response = Client.GetReports(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Reports == null ? null : response.Reports.ToList();
        }

        public List<Report> GetListByCategory(string search, string sort, int pageindex, int pagesize, int category, int systemid)
        {
            var request = new ReportRequest().Prepare();
            request.LoadOptions = Base.LoginSession.isSystemUser ? new[] { Resource.Get_Option_List_ByCategory } : new[] { Resource.Get_Option_List_UserCanAccess };
            request.Criteria = new Criteria { SearchKeyWord = search, SortExpression = sort, PageIndex = pageindex, PageSize = pagesize, SystemId = systemid };
            request.CategoryId = category;
            request.UserId = Base.LoginSession.intUserId;
            request.IsSystemUser = Base.LoginSession.isSystemUser;          

            var response = Client.GetReports(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Reports == null ? null : response.Reports.ToList();
        }
        
        /// <summary>
        /// Gets an individual user by id.
        /// </summary>
        /// <param name="rptId"></param>
        /// <returns></returns>
        public Report Get(int rptId)
        {
            var request = new ReportRequest().Prepare();
            request.LoadOptions = new []{ Resource.Get_Option_Single };
            request.ReportId = rptId;

            var response = Client.GetReports(request);
            Correlate(request, response);

            return response.Report;
        }

        public Report Get(string reportPath)
        {
            var request = new ReportRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_Single };
            request.Url = reportPath;

            var response = Client.GetReports(request);
            Correlate(request, response);

            return response.Report;
        }

        /// <summary>
        /// Inserts a new report.
        /// </summary>
        /// <param name="rpt"></param>
        public Report Insert(Report rpt)
        {
            rpt.Create_Date = DateTime.Now;
            rpt.Owner = Base.LoginSession.intUserId;
            var request = new ReportRequest().Prepare();
            request.Action = Resource.Action_Create;
            request.Report = rpt;

            var response = Client.SetReports(request);
            Correlate(request, response);

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
            return response.Report;
        }

        /// <summary>
        /// Update an existing report.
        /// </summary>
        /// <param name="rpt"></param>
        public Report Update(Report rpt)
        {
            rpt.UpdatedBy = Base.LoginSession.intUserId;
            var request = new ReportRequest().Prepare();
            request.Action = Resource.Action_Update;
            request.Report = rpt;

            var response = Client.SetReports(request);
            Correlate(request, response);

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
            return response.Report;
        }

        /// <summary>
        /// Updates Status an existing report.
        /// </summary>
        /// <param name="rpt"></param>
        /// <param name="status"></param>
        public Report UpdateStatus(Report rpt, short status)
        {
            rpt.UpdatedBy = Base.LoginSession.intUserId;
            var request = new ReportRequest().Prepare();
            request.Action = Resource.Action_UpdateStatus;
            request.Criteria = new Criteria { Status = status };
            request.Report = rpt;

            var response = Client.SetReports(request);
            Correlate(request, response);

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
            return response.Report;
        }

        /// <summary>
        /// Deletes an existing report.
        /// </summary>
        /// <param name="rptId"></param>
        public void Delete(int rptId)
        {
            var request = new ReportRequest().Prepare();

            request.Action = Resource.Action_Delete;
            request.ReportId = rptId;

            var response = Client.SetReports(request);
            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);

            // return response.RowsAffected;
        }        

        public void UpdateStatus(string listOption)
        {            
            if (!string.IsNullOrEmpty(listOption))
            {
                var selectedItems = listOption.Split('|');
                Report model;
                if (selectedItems.Length > 0)
                {
                    foreach (var item in selectedItems[1].Split(','))
                    {
                        model = Get(int.Parse(item));
                        UpdateStatus(model, short.Parse(selectedItems[0]));
                    }
                }
            }
        }        
    }
}