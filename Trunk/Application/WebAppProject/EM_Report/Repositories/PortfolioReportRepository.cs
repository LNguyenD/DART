using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EM_Report.ActionServiceReference;
using EM_Report.Domain.Resources;
using EM_Report.Domain;

namespace EM_Report.Repositories
{
    public interface IPortfolioReportRepository
    {
        IEnumerable<string> GetSystemValues(string systemName, SystemValueType valueType);
        IEnumerable<string> GetSystemSubValues(string systemName, string value, SystemValueType valueType);
        IEnumerable<string> GetClaimOfficers(string team);
        IEnumerable<string> GetClaimLiabilityIndicators(string systemName);
    }

    public class PortfolioReportRepository : RepositoryBase, IPortfolioReportRepository
    {
        public IEnumerable<string> GetSystemValues(string systemName, SystemValueType valueType)
        {
            var request = new PortfolioRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Portfolio_Param_Values };
            request.SystemName = systemName;
            request.ValueType = valueType;

            var response = Client.GetPortfolio(request);

            Correlate(request, response);

            return response.Values;
        }

        public IEnumerable<string> GetSystemSubValues(string systemName, string value, SystemValueType valueType)
        {
            var request = new PortfolioRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Portfolio_Param_SubValues };
            request.SystemName = systemName;
            request.ValueType = valueType;
            request.Value = value;

            var response = Client.GetPortfolio(request);

            Correlate(request, response);

            return response.SubValues;
        }

        public IEnumerable<string> GetClaimOfficers(string team)
        {
            var request = new PortfolioRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Portfolio_Param_ClaimOfficers };
            request.Team = team;

            var response = Client.GetPortfolio(request);

            Correlate(request, response);

            return response.ClaimOfficers;
        }

        public IEnumerable<string> GetClaimLiabilityIndicators(string systemName)
        {
            var request = new PortfolioRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Portfolio_Param_ClaimLiabilityIndicators };
            request.SystemName = systemName;

            var response = Client.GetPortfolio(request);

            Correlate(request, response);

            return response.ClaimLiabilityIndicators;
        }
    }
}