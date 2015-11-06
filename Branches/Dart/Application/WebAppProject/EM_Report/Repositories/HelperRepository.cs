using EM_Report.Service.ServiceContracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EM_Report.Helpers;

namespace EM_Report.Repositories
{
    public interface IHelperRepository
    {
        void EncryptConnectionStrings();
    }

    public class HelperRepository : RepositoryBase, IHelperRepository
    {
        public void EncryptConnectionStrings()
        {
            Client.Using<IActionService>(proxy =>
            {
                proxy.EncryptConnectionStrings();
            });
        }
    }
}