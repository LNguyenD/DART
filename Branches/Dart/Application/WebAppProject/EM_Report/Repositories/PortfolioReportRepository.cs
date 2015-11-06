using EM_Report.Domain;
using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using EM_Report.Service.Messages;
using EM_Report.Service.ServiceContracts;
using System;
using System.Collections.Generic;

namespace EM_Report.Repositories
{
    public interface IPortfolioReportRepository
    {
        IEnumerable<string> GetSystemValues(string systemName, SystemValueType valueType);

        IEnumerable<string> GetSystemSubValues(string systemName, string value, SystemValueType valueType);

        IEnumerable<string> GetClaimOfficers(string team);

        IEnumerable<Dashboard_Claim_Liability_Indicator> GetClaimLiabilityIndicators(string systemName);

        string GetMaxRptDate(string systemName);
    }

    public class PortfolioReportRepository : RepositoryBase, IPortfolioReportRepository
    {
        public IEnumerable<string> GetSystemValues(string systemName, SystemValueType valueType)
        {
            var request = new PortfolioRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Portfolio_Param_Values };
            request.SystemName = systemName;
            request.ValueType = valueType;

            PortfolioResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetPortfolio(request);
            });

            return response.Values;
        }

        public IEnumerable<string> GetSystemSubValues(string systemName, string value, SystemValueType valueType)
        {
            var request = new PortfolioRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Portfolio_Param_SubValues };
            request.SystemName = systemName;
            request.ValueType = valueType;
            request.Value = value;

            PortfolioResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetPortfolio(request);
            });

            return response.SubValues;
        }

        public IEnumerable<string> GetClaimOfficers(string team)
        {
            var request = new PortfolioRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Portfolio_Param_ClaimOfficers };
            request.Team = team;

            PortfolioResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetPortfolio(request);
            });

            return response.ClaimOfficers;
        }

        public IEnumerable<Dashboard_Claim_Liability_Indicator> GetClaimLiabilityIndicators(string systemName)
        {
            var request = new PortfolioRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Portfolio_Param_ClaimLiabilityIndicators };
            request.SystemName = systemName;

            PortfolioResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetPortfolio(request);
            });

            return response.ClaimLiabilityIndicators;
        }

        public string GetMaxRptDate(string systemName)
        {
            var request = new PortfolioRequest().Prepare();
            request.LoadOptions = new string[] { Resource.GetMaxRptDate };
            request.SystemName = systemName;

            PortfolioResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetPortfolio(request);
            });

            var maxRptDate = Convert.ToDateTime(response.Max_Rpt_Date);
            if (maxRptDate == DateTime.MinValue)
                maxRptDate = DateTime.Now.AddDays(-1);

            return maxRptDate.ToString();
        }
    }
}