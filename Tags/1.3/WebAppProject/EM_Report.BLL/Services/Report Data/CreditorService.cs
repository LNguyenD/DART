using System.Configuration;
using System.Linq;
using EM_Report.BLL.Commons;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Models.Report_Data_Object;
using System;
using System.Collections.Generic;
using System.Data;

namespace EM_Report.BLL.Services
{
    using System.Collections.ObjectModel;

    public interface I_CreditorService : I_Service<CreditorModel>
    {
        IQueryable<CreditorModel> Search(string name, string ABN, string wcProviderCode, string hcNo, string claimNumber, string orderBy);
        //DataTable Search(string name, string ABN, string wcProviderCode, string hcNo, string claimNumber, string orderBy);
    }

    public class CreditorService : ServiceBase<CreditorModel, CREDITOR>, I_CreditorService
    {
        public CreditorService(I_LoginSession session)
            : base(session)
        {
            base.Repository = new RepositoryBase<CREDITOR>(new EmicsModelDataContext(ConfigurationManager.ConnectionStrings[Constants.STR_RS_CONNECTIONSTRING].ToString()));
            
        }

        protected override CreditorModel MappingToModel(CREDITOR table)
        {
            return table == null ? null : new CreditorModel()
            {
                CreditorNo = table.Creditor_no,
                Name = table.Name,
                ABN = table.ABN,
                AKA = table.AKA,
                WCProviderCode = table.WC_Provider_Code,
                HCNumber = table.HC_Number,
                IsDeleted = table.is_deleted,
                Inactive = table.Inactive
            };
        }

        protected override CREDITOR MappingToDAL(CreditorModel model)
        {
            return model == null ? null : new CREDITOR()
            {
                Creditor_no = model.CreditorNo,
                Name = model.Name,
                ABN = model.ABN,
                AKA = model.AKA,
                WC_Provider_Code = model.WCProviderCode,
                HC_Number = model.HCNumber,
                is_deleted = model.IsDeleted,
                Inactive = model.Inactive
            };
        }

        protected override IQueryable<CreditorModel> GetMapping(IQueryable<CREDITOR> query)
        {
            var result = from creditor in query
                         where creditor.is_deleted.Equals(0) && creditor.Inactive.Equals(0)
                         select new CreditorModel()
                         {
                             CreditorNo = creditor.Creditor_no,
                             Name = creditor.Name,
                             ABN = creditor.ABN,
                             AKA = creditor.AKA,
                             WCProviderCode = creditor.WC_Provider_Code,
                             HCNumber = creditor.HC_Number,
                             IsDeleted = creditor.is_deleted,
                             Inactive = creditor.Inactive,
                         };
            return result;
        }

        //public IQueryable<CreditorModel> Search(string name, string ABN, string wcProviderCode, string hcNo, string orderBy)
        //{
        //    var query = this.GetAllQueryable(orderBy, string.Empty);
        //    var predicate = PredicateBuilder.False<CreditorModel>();
        //    if (!string.IsNullOrEmpty(name))
        //    {
        //        predicate = predicate.Or(p => p.Name.Contains(name));
        //        predicate = predicate.Or(p => p.AKA.Contains(name));
        //    }
        //    if (!string.IsNullOrEmpty(ABN))
        //    {
        //        predicate = predicate.Or(p => p.ABN.Equals(ABN));
        //    }
        //    if (!string.IsNullOrEmpty(wcProviderCode))
        //    {
        //        predicate = predicate.Or(p => p.WCProviderCode.Contains(wcProviderCode));
        //    }
        //    if (!string.IsNullOrEmpty(hcNo))
        //    {
        //        predicate = predicate.Or(p => p.HCNumber.Contains(hcNo));
        //    }
            
        //    return query.Where(predicate);
        //}

        public IQueryable<CreditorModel> Search(string name, string ABN, string wcProviderCode, string hcNo, string claimNumber, string orderBy)
        {
            Dictionary<string, object> prms = new Dictionary<string, object>();
            prms.Add("Name", name);
            prms.Add("ABN", ABN);
            prms.Add("WCProviderCode", wcProviderCode);
            prms.Add("HCNo", hcNo);
            prms.Add("ClaimNumber", claimNumber);

            DataTable allCreditors = RepositoryBaseExtension.ExecuteQueryStoreProcedure("usp_GetAllCreditors", prms);
            
            List<CreditorModel> result = new List<CreditorModel>();
            foreach (DataRow row in allCreditors.Rows)
            {
                CreditorModel creditor = new CreditorModel()
                    {
                        CreditorNo = row["CreditorNo"].ToString(),
                        Name = row["Name"].ToString(),
                        ABN = string.IsNullOrEmpty(row["ABN"].ToString()) ? 0 : (double)row["ABN"],
                        AKA = row["AKA"].ToString(),
                        WCProviderCode = row["WCProviderCode"].ToString(),
                        HCNumber = row["HCNo"].ToString(),
                    };
                result.Add(creditor);
            }
            
            return result.AsQueryable();
        }

    }
}