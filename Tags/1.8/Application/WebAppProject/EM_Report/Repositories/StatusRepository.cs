using System;
using System.Collections.Generic;
using System.Linq;
//using System.Runtime.Caching;
using System.Web;

using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using EM_Report.Domain;
using EM_Report.Common.Utilities;
using EM_Report.Helpers;
using EM_Report.Service.Messages;
using EM_Report.Service.Criteria;
using EM_Report.Service.ServiceContracts;

namespace EM_Report.Repositories
{
    public interface IStatusRepository
    {
        Status[] GetList();
        Status GetById(short statusId);
        IEnumerable<Status> StatusList();
        string GetStatusName(short id);
        short GetStatusIdByName(string name);
        string ReplaceNameById(string strData);
    }

    public class StatusRepository : RepositoryBase, IStatusRepository
    {
        public Status[] GetList()
        {
            if (HttpContext.Current.Application["StatusList"]==null)
            {                
                var request = new StatusRequest().Prepare();
                request.LoadOptions = new string[] { Resource.Get_Option_List };
                request.Criteria = new Criteria();

                StatusResponse response = null;
                Client.Using<IActionService>(proxy => {
                    response = proxy.GetStatus(request);
                });

                Base.TotalItemCount = response.TotalItemCount;

                HttpContext.Current.Application["StatusList"] = response.Statuses;                              
            }
            return HttpContext.Current.Application["StatusList"] as Status[];
        }

        public Status GetById(short statusId)
        {
            return GetList().FirstOrDefault(l => l.StatusId == statusId);
        }

        public IEnumerable<Status> StatusList()
        {            
            return GetList() as IEnumerable<Status>;
        }

        public string GetStatusName(short id)
        {
            return StatusList().Where(s => s.StatusId == id).Select(s => s.Name).FirstOrDefault();
        }

        public short GetStatusIdByName(string name)
        {
            return StatusList().Where(s => s.Name.ToLower() == name.ToLower()).FirstOrDefault().StatusId;
        }

        public string ReplaceNameById(string strData)
        {
            if (strData.IndexOf(ResourcesHelper.Action_InActive) >= 0)
            {
                strData = strData.Replace(ResourcesHelper.Action_InActive, GetStatusIdByName(ResourcesHelper.Action_InActive).ToString());
            }
            else if (strData.IndexOf(ResourcesHelper.Action_Active) >= 0)
            {
                strData = strData.Replace(ResourcesHelper.Action_Active, GetStatusIdByName(ResourcesHelper.Action_Active).ToString());
            }
            return strData;
        }        
    }
}