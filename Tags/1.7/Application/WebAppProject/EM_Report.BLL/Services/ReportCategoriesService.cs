using System.Collections.Generic;
using System.Linq;
using EM_Report.Common.Utilities;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Domain;

namespace EM_Report.BLL.Services
{
    public interface I_ReportCategoriesService : I_Service<Report_Categories>
    {
        Report_Categories CreateOrUpdate(Report_Categories model);

        void UpdateStatus(Report_Categories model, short status);

        IEnumerable<object> GetCategories();

        IEnumerable<Report_Categories> GetCategoriesUserCanAccess(int userid);
    }

    public class ReportCategoriesService : ServiceBase<Report_Categories, Report_CategoryDO>, I_ReportCategoriesService
    {
        private I_Repository<UserDO> _userRepository;
        private I_Repository<StatusDO> _statusRepository;

        public I_Repository<UserDO> UserRepository
        {
            get { return _userRepository; }
            set { _userRepository = value; }
        }

        public I_Repository<StatusDO> StatusRepository
        {
            get { return _statusRepository; }
            set { _statusRepository = value; }
        }

        public ReportCategoriesService(I_LoginSession session)
            : base(session)
        {
            _userRepository = new RepositoryBase<UserDO>(((RepositoryBase<Report_CategoryDO>)Repository).Context);
            _statusRepository = new RepositoryBase<StatusDO>(((RepositoryBase<Report_CategoryDO>)Repository).Context);
        }

        protected override IQueryable<Report_Categories> Filter(string keyword, IQueryable<Report_Categories> query)
        {
            var predicate = PredicateBuilder.False<Report_Categories>();
            if (!string.IsNullOrEmpty(keyword))
            {
                predicate = predicate.Or(p => p.Name.Contains(keyword));
                predicate = predicate.Or(p => p.Description.Contains(keyword));
                query = query.Where(predicate);
            }
            return query;
        }

        protected override IQueryable<Report_Categories> GetMapping(IQueryable<Report_CategoryDO> query)
        {
            I_ReportService qReportService = new ReportService(Session);

            var statusQuery = StatusRepository.GetQueryable();
            var userQuery = UserRepository.GetQueryable();

            var result = from category in query
                         join status in statusQuery on category.Status equals status.StatusId
                         join user in userQuery on category.Owner equals user.UserId into temp
                         from user in temp.DefaultIfEmpty()
                         select new Report_Categories()
                         {
                             CategoryId = category.CategoryId,
                             Name = category.Name,
                             Description = category.Description,
                             Create_Date = category.Create_Date,
                             Owner = category.Owner ?? 0,
                             OwnerName = user != null ? user.UserName : string.Empty,
                             Status = category.Status ?? 0,
                             StatusName = status.Name,
                             UpdatedBy = category.UpdatedBy
                         };
            return result;
        }

        public Report_Categories CreateOrUpdate(Report_Categories model)
        {
            return (model.CategoryId > 0) ? Update(model, model.CategoryId) : Create(model);
        }

        public void UpdateStatus(Report_Categories model, short status)
        {
            model.Status = status;
            Update(model, model.CategoryId);
        }

        public IEnumerable<object> GetCategories()
        {
            foreach (var cate in Repository.GetQueryable())
            {
                yield return new { cate.CategoryId, cate.Name };
            }
        }

        public IEnumerable<Report_Categories> GetCategoriesUserCanAccess(int userid)
        {
            I_ReportService qReportService = new ReportService(null);
            var listReport = qReportService.GetAllReportUserCanAccess(0, userid, false, "", "");
            var lstCat = GetAllQueryable("Name|asc", "").Where(p => p.StatusName == ResourcesHelper.Action_Active);
            foreach (var category in lstCat)
            {
                if (listReport.Any(l => l.CategoryId == category.CategoryId))
                {
                    yield return new Report_Categories
                    {
                        CategoryId = category.CategoryId,
                        Name = category.Name,
                        Description = category.Description,
                        Create_Date = category.Create_Date,
                        UpdatedBy = category.UpdatedBy,
                        TotalAccessItem = qReportService.CountReportByCategoryUserCanAccess(userid, category.CategoryId)
                    };
                }
            }
        }
    }
}