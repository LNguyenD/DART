﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using EM_Report.Service.MessageBase;

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
        public IList<string> ClaimLiabilityIndicators;

        [DataMember]
        public string Max_Rpt_Date;
        
    }
}
