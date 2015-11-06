using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
namespace EM_Report.Domain
{
    public interface I_Status
    {
        [DataMember]
        short Status { get; set; }

        [DataMember]
        string StatusName { get; set; } 
    }
}
