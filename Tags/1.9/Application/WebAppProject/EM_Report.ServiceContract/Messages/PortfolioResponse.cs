using EM_Report.Domain;
using EM_Report.Service.MessageBase;
using System.Collections.Generic;
using System.Runtime.Serialization;

namespace EM_Report.Service.Messages
{
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class PortfolioResponse : ResponseBase
    {
        /// <summary>
        /// Constructor for PortfolioResponse
        /// </summary>
        public PortfolioResponse()
        {
            Values = new List<string>();
        }

        /// <summary>
        /// List of Values.
        /// </summary>
        [DataMember]
        public IList<string> Values;

        /// <summary>
        /// List of Values.
        /// </summary>
        [DataMember]
        public IList<string> SubValues;

        /// <summary>
        /// List of Values.
        /// </summary>
        [DataMember]
        public IList<string> ClaimOfficers;

        /// <summary>
        /// List of Values.
        /// </summary>
        [DataMember]
        public IList<Dashboard_Claim_Liability_Indicator> ClaimLiabilityIndicators;

        [DataMember]
        public string Max_Rpt_Date;
    }
}