using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace EM_Report.DAL
{
    public partial class DartEntities : DbContext
    {
        static DartEntities()
        {
            var ensureDLLIsCopied = System.Data.Entity.SqlServer.SqlProviderServices.Instance;
        }

        public DartEntities(string connectionString) : base(connectionString)
        {

        }
    }
}