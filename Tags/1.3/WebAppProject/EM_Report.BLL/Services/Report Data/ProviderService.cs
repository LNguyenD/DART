using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EM_Report.Models.Report_Data_Object;
using EM_Report.DAL;
using EM_Report.BLL.Commons;
using EM_Report.DAL.Infrastructure;
using System.Configuration;

namespace EM_Report.BLL.Services
{
    using System.Data;

    public interface I_ProviderService : I_Service<ProviderModel>
    {
        IQueryable<ProviderModel> Search(string name, string orderBy);
        IQueryable<ProviderModel> Search(string name, string claimNumber, string orderBy);
    }

    public class ProviderService : ServiceBase<ProviderModel, provider>, I_ProviderService
    {
        private I_Repository<Payment_Recovery> _repositoryPaymentRecovery;

        public I_Repository<Payment_Recovery> RepositoryPaymentRecovery
        {
            get { return this._repositoryPaymentRecovery; }
            set { this._repositoryPaymentRecovery = value; }
        }

        
        public ProviderService(I_LoginSession session)
            : base(session)
        {
            Repository =
                new RepositoryBase<provider>(new EmicsModelDataContext(
                            ConfigurationManager.ConnectionStrings[Constants.STR_RS_CONNECTIONSTRING].ToString()));
            _repositoryPaymentRecovery = new RepositoryBase<Payment_Recovery>(((RepositoryBase<provider>)Repository).Context);
        }

        protected override ProviderModel MappingToModel(provider table)
        {
            return table == null ? null : new ProviderModel()
            {
                WCRegNo = table.wc_reg_no,
                FirstName = table.firstname,
                LastName = table.lastname,
                Type = table.type,
                OrganisationName = table.organisation_name,
                IsDeleted = table.is_deleted
            };
        }

        protected override provider MappingToDAL(ProviderModel model)
        {
            return model == null ? null : new provider()
            {
                wc_reg_no = model.WCRegNo,
                firstname = model.FirstName,
                lastname = model.LastName,
                type = model.Type,
                organisation_name = model.OrganisationName,
                is_deleted = model.IsDeleted
            };
        }

        protected override IQueryable<ProviderModel> GetMapping(IQueryable<provider> query)
        {
            var result = from p in query
                         where p.is_deleted.Equals(0)
                         select new ProviderModel()
                                 {
                                     WCRegNo = p.wc_reg_no,
                                     FirstName = p.firstname,
                                     LastName = p.lastname,
                                     Type = p.type,
                                     OrganisationName = p.organisation_name,
                                     IsDeleted = p.is_deleted,
                                 };
            return result;
        }

        public IQueryable<ProviderModel> Search(string name, string orderBy)
        {
            var query = this.GetAllQueryable(orderBy, string.Empty);
            var predicate = PredicateBuilder.False<ProviderModel>();
            if (!string.IsNullOrEmpty(name))
            {
                predicate = predicate.Or(p => p.LastName.StartsWith(name));
                predicate = predicate.Or(p => p.OrganisationName.StartsWith(name));
            }
            return query.Where(predicate);
        }

        public IQueryable<ProviderModel> Search(string name, string claimNumber, string orderBy)
        {
            Dictionary<string, object> prms = new Dictionary<string, object>();
            prms.Add("Name", name);
            prms.Add("ClaimNumber", claimNumber);

            DataTable allProviders = RepositoryBaseExtension.ExecuteQueryStoreProcedure("usp_GetAllProvider", prms);

            List<ProviderModel> result = new List<ProviderModel>();
            foreach (DataRow row in allProviders.Rows)
            {
                ProviderModel provider = new ProviderModel()
                {
                    WCRegNo = row["WCRegNo"].ToString(),
                    FirstName = row["FirstName"].ToString(),
                    LastName = row["LastName"].ToString(),
                    Type = row["Type"].ToString(),
                    OrganisationName = row["OrganisationName"].ToString(),
                };
                result.Add(provider);
            }

            return result.AsQueryable();
        }
    }
}