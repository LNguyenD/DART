using System.Collections.Generic;
using System.Web;
using EM_Report.Domain.Attributes;

namespace EM_Report.Domain
{
    public class User_Import
    {
        [FileSize(4194304)]
        [FileTypes("csv")]
        public HttpPostedFileBase File { get; set; }

        public IList<User> UserList { get; set; }
    }
}