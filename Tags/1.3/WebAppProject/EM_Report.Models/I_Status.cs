using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace EM_Report.Models
{
    public interface I_Status
    {
        short Status { get; set; }

        string StatusName { get; set; } 
    }
}
