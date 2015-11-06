using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using EM_Report.Service.MessageBase;

namespace EM_Report.Service.Messages
{
    [DataContract(Namespace = "http://www.yourcompany.com/types/")]
    public class PortfolioRequest : RequestBase
    {
        [DataMember]
        public string SystemName { get; set; }

        [DataMember]
        public string Value { get; set; }

        [DataMember]
        public SystemValueType ValueType { get; set; }

        [DataMember]
        public string Team { get; set; }
    }

    public enum SystemValueType
    {
        Group,
        Agency,
        Portfolio,
        AccountManager,
        EmployerSize
    }
}
