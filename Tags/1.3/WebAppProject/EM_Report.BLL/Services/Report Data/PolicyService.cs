using System.Configuration;
using System.Linq;
using EM_Report.BLL.Commons;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Models.Report_Data_Object;

namespace EM_Report.BLL.Services
{
    public interface I_PolicyService : I_Service<PolicyModel>
    {
        IQueryable<PolicyModel> Search(string employer, string policyNo, string ABN, string ACN, string orderBy);
    }

    public class PolicyService : ServiceBase<PolicyModel, POLICY_TERM_DETAIL>, I_PolicyService
    {
        public PolicyService(I_LoginSession session)
            : base(session)
        {
            base.Repository = new RepositoryBase<POLICY_TERM_DETAIL>(new EmicsModelDataContext(ConfigurationManager.ConnectionStrings[Constants.STR_RS_CONNECTIONSTRING].ToString()));
        }

        protected override PolicyModel MappingToModel(POLICY_TERM_DETAIL table)
        {
            return table == null ? null : new PolicyModel()
            {
                PolicyNo = table.POLICY_NO.Trim(),
                LegalName = table.LEGAL_NAME,
                TradingName = table.TRADING_NAME,
                ABN = table.ABN,
                ACN = table.ACN_ARBN,
                PolicyStatus = table.POLICY_STATUS,
                StartYear = table.START_YEAR
            };
        }

        protected override POLICY_TERM_DETAIL MappingToDAL(PolicyModel model)
        {
            return model == null ? null : new POLICY_TERM_DETAIL()
            {
                POLICY_NO = model.PolicyNo,
                LEGAL_NAME = model.LegalName,
                TRADING_NAME = model.TradingName,
                ABN = model.ABN,
                ACN_ARBN = model.ACN,
                POLICY_STATUS = model.PolicyStatus,
                START_YEAR = model.StartYear
            };
        }

        protected override IQueryable<PolicyModel> GetMapping(IQueryable<POLICY_TERM_DETAIL> query)
        {
            var result = from policy in query
                         select new PolicyModel()
                         {
                             PolicyNo = policy.POLICY_NO.Trim(),
                             LegalName = policy.LEGAL_NAME,
                             TradingName = policy.TRADING_NAME,
                             ABN = policy.ABN,
                             ACN = policy.ACN_ARBN,
                             PolicyStatus = policy.POLICY_STATUS,
                             StartYear = policy.START_YEAR
                         };
            return result;
        }

        public IQueryable<PolicyModel> Search(string employer, string policyNo, string ABN, string ACN, string orderBy)
        {
            var query = this.GetAllQueryable(orderBy, string.Empty);
            var predicate = PredicateBuilder.False<PolicyModel>();
            if(string.IsNullOrEmpty(employer) && string.IsNullOrEmpty(policyNo) && 
                    string.IsNullOrEmpty(ABN) && string.IsNullOrEmpty(ACN))
            {
                predicate = PredicateBuilder.True<PolicyModel>();
            }
            if (!string.IsNullOrEmpty(employer))
            {
                predicate = predicate.Or(p => p.LegalName.Contains(employer));
                predicate = predicate.Or(p => p.TradingName.Contains(employer));
            }
            if (!string.IsNullOrEmpty(policyNo))
            {
                predicate = predicate.Or(p => p.PolicyNo.Contains(policyNo));
            }
            if (!string.IsNullOrEmpty(ABN))
            {
                predicate = predicate.Or(p => p.ABN.Equals(ABN));
            }
            if (!string.IsNullOrEmpty(ACN))
            {
                predicate = predicate.Or(p => p.ACN.Equals(ACN));
            }
            return query.Where(predicate);
        }

    }
}