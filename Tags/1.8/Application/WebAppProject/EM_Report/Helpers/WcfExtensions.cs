
using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceModel;
using System.Web;
using EM_Report.Service.Messages;
using EM_Report.Service.Criteria;
using EM_Report.Service.ServiceContracts;
using EM_Report.Service.MessageBase;

namespace EM_Report.Helpers
{
    public static class WcfExtensions
    {
        public static void Using<T>(this ICommunicationObject client, Action<T> work)
        {
            try
            {
                work((T)client);
                client.Close();
            }
            catch (CommunicationException e)
            {
                client.Abort();
            }
            catch (TimeoutException e)
            {
                client.Abort();
            }
            catch (Exception e)
            {
                client.Abort();
                throw;
            }
        }
    }
}