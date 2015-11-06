using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using EM_Report.Domain;
using System.Web.Mvc;
using EM_Report.Service.Messages;
using EM_Report.Service.Criteria;
using EM_Report.Service.ServiceContracts;
using EM_Report.Service.MessageBase;
namespace EM_Report.Repositories
{
    public interface ICONTROL
    {       
        CONTROL GetByType(string type);        
    }

    public class CONTROLRepository : RepositoryBase, ICONTROL
    {
        public CONTROL GetByType(string type)        
        {                  
            var request = new CONTROLRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.Type = type;
            
            CONTROLResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetCONTROL(request);
            });
                        
            return response.Control;                                                                            
                                                          
        }              
    }
}