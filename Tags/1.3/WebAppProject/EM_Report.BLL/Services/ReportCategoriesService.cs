using System;
using System.Collections.Generic;
using System.Linq;
using EM_Report.BLL.Commons;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Models;

namespace EM_Report.BLL.Services
{
    public interface I_ReportCategoriesService : I_Service<Report_CategoriesModel>
    {
        Report_CategoriesModel CreateOrUpdate(Report_CategoriesModel model);
        void UpdateStatus(Report_CategoriesModel model, short status);
        IEnumerable<object> GetCategories();
        IEnumerable<Report_CategoriesModel> GetCategoriesUserCanAccess(int userid);
    }

    public class ReportCategoriesService :ServiceBase<Report_CategoriesModel, Report_Category>, I_ReportCategoriesService
    {
        private I_Repository<User> _userRepository;
        private I_Repository<Status> _statusRepository;

        public I_Repository<User> UserRepository
        {
            get { return _userRepository; }
            set { _userRepository = value; }
        }
        public I_Repository<Status> StatusRepository
        {
            get { return _statusRepository; }
            set { _statusRepository = value; }
        }

        public ReportCategoriesService(I_LoginSession session)
            : base(session)
        {
            _userRepository = new RepositoryBase<User>(((RepositoryBase<Report_Category>)Repository).Context);
            _statusRepository = new RepositoryBase<Status>(((RepositoryBase<Report_Category>)Repository).Context);
        }

        protected override Report_CategoriesModel MappingToModel(Report_Category table)
        {
            return table == null ? null : new Report_CategoriesModel()
            {
                CategoryId = table.CategoryId,
                Create_Date = table.Create_Date,
                Description = table.Description,
                Name = table.Name,
                Owner = table.Owner ?? 0,
                Status = table.Status ?? 0,
                UpdatedBy = Session != null ? Session.intUserId : new Nullable<int>()
            };
        }

        protected override Report_Category MappingToDAL(Report_CategoriesModel model)
        {
            return model == null ? null : new Report_Category()
            {
                CategoryId = model.CategoryId,
                Create_Date = (model.Create_Date.HasValue) ? model.Create_Date.Value :  DateTime.Now,
                Description = model.Description,
                Name = model.Name,
                Owner = model.Owner,
                Status = model.Status,
                UpdatedBy = Session != null ? Session.intUserId : new Nullable<int>()
            };
        }

        protected override IQueryable<Report_CategoriesModel> Filter(string keyword, IQueryable<Report_CategoriesModel> query)
        {
            var predicate = PredicateBuilder.False<Report_CategoriesModel>();
            if (!string.IsNullOrEmpty(keyword))
            {
                predicate = predicate.Or(p => p.Name.Contains(keyword));
                predicate = predicate.Or(p => p.Description.Contains(keyword));
                query = query.Where(predicate);
            }
            return query;
        }

        protected override IQueryable<Report_CategoriesModel> GetMapping(IQueryable<Report_Category> query)
        {
            var statusQuery = StatusRepository.GetQueryable();
            var userQuery = UserRepository.GetQueryable();

            var result = from category in query
                         join status in statusQuery on category.Status equals status.StatusId
                         join user in userQuery on category.Owner equals user.UserId into temp
                         from user in temp.DefaultIfEmpty()
                         select new Report_CategoriesModel()
                         {
                             CategoryId = category.CategoryId,
                             Name = category.Name,
                             Description = category.Description,
                             Create_Date = category.Create_Date,
                             Owner = category.Owner ?? 0,
                             OwnerName = user != null ? user.UserName : string.Empty,
                             Status = category.Status ?? 0,
                             StatusName = status.Name,
                             UpdatedBy = Session != null ? Session.intUserId : new Nullable<int>()
                         };
            return result;
        }

        public Report_CategoriesModel CreateOrUpdate(Report_CategoriesModel model)
        {
            return (model.CategoryId > 0) ? Update(model, model.CategoryId) : Create(model);
        }

        public void UpdateStatus(Report_CategoriesModel model, short status)
        {
            model.Status = status;
            Update(model, model.CategoryId);
        }

        public IEnumerable<object> GetCategories()
        {
            foreach (var cate in Repository.GetQueryable().Where(e => e.Status == ResourcesHelper.StatusActive))
            {
                yield return new  { cate.CategoryId, cate.Name };
            }
        }

        public IEnumerable<Report_CategoriesModel> GetCategoriesUserCanAccess(int userid)
        {
            I_ReportService qReportService = new ReportService(null);            
            var listReport = qReportService.GetAllReportUserCanAccess(userid);
            var lstCat = GetAllQueryable("Name|asc", "").Where(p => p.Status == ResourcesHelper.StatusActive);
            foreach (var category in lstCat)
            {
                if (listReport.Any(l => l.CategoryId == category.CategoryId))
                {
                    yield return new Report_CategoriesModel
                    {
                        CategoryId = category.CategoryId,
                        Name = category.Name,
                        Description = category.Description,
                        Create_Date = category.Create_Date,
                        UpdatedBy = Session != null ? Session.intUserId : new Nullable<int>()
                    };
                }
            }        
        }

        public override void Delete(object id)
        {
            var model = GetById(id);
            UpdateStatus(model, ResourcesHelper.StatusInactive);
        }
    }
}