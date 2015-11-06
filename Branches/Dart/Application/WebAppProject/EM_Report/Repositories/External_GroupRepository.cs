using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using EM_Report.Domain;
using EM_Report.Domain.Enums;
using EM_Report.Service.Messages;
using EM_Report.Service.Criteria;
using EM_Report.Service.ServiceContracts;
using EM_Report.Service.MessageBase;

namespace EM_Report.Repositories
{
    public interface IExternal_GroupRepository
    {
        List<External_Group> GetList(GroupStatusFilter status = GroupStatusFilter.All);
        List<External_Group> GetList(string search, string sort, GroupStatusFilter status = GroupStatusFilter.All);
        List<External_Group> GetList(string search, string sort, int pageindex, int pagesize, GroupStatusFilter status = GroupStatusFilter.All);
        External_Group GetById(int groupId);
        void Insert(External_Group group);
        void Update(External_Group group);
        void UpdateStatus(External_Group group, short status);
        void Delete(int External_GroupId);
        void UpdateStatus(string listOption);
    }
    
    public class External_GroupRepository : RepositoryBase, IExternal_GroupRepository
    {
        public List<External_Group> GetList(GroupStatusFilter status = GroupStatusFilter.All)
        {
            var request = new External_GroupRequest().Prepare();
            request.GroupStatusFilter = status;
            request.LoadOptions = new string[] { Resource.Get_Option_List };
            request.Criteria = new Criteria();            

            External_GroupResponse response = null;
            Client.Using<IActionService>(proxy =>
                {
                    response = proxy.GetExternal_Groups(request);
                });

            Base.TotalItemCount = response.TotalItemCount;           

            return response.External_Groups == null ? null : response.External_Groups.ToList();
        }

        public List<External_Group> GetList(string search, string sort, GroupStatusFilter status = GroupStatusFilter.All)
        {
            var request = new External_GroupRequest().Prepare();
            request.GroupStatusFilter = status;
            request.LoadOptions = new string[] { Resource.Get_Option_List };

            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search };

            External_GroupResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetExternal_Groups(request);
            });            

            Base.TotalItemCount = response.TotalItemCount;            

            return response.External_Groups == null ? null : response.External_Groups.ToList();
        }

        public List<External_Group> GetList(string search, string sort, int pageindex, int pagesize, GroupStatusFilter status = GroupStatusFilter.All)
        {
            var request = new External_GroupRequest().Prepare();
            request.GroupStatusFilter = status;
            request.LoadOptions = new string[] { Resource.Get_Option_List };

            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize };

            External_GroupResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetExternal_Groups(request);
            });              

            Base.TotalItemCount = response.TotalItemCount;       

            return response.External_Groups == null ? null : response.External_Groups.ToList();
        }

        public void Insert(External_Group group)
        {
            group.Create_Date = DateTime.Now;
            group.Owner = Base.LoginSession.intUserId;
            var request = new External_GroupRequest().Prepare();
            request.Action = Resource.Action_Create;
            request.External_Group = group;

            External_GroupResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetExternal_Groups(request);
            });          

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }        

        public void UpdateStatus(External_Group group, short status)
        {
            group.UpdatedBy = Base.LoginSession.intUserId;
            var request = new External_GroupRequest().Prepare();
            request.Action = Resource.Action_UpdateStatus;
            request.Criteria = new Criteria { Status = status };
            request.External_Group = group;

            External_GroupResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetExternal_Groups(request);
            });           

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Delete(int External_GroupId)
        {            
            var request = new External_GroupRequest().Prepare();
            request.Action = Resource.Action_Delete;
            request.External_GroupId = External_GroupId;

            External_GroupResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetExternal_Groups(request);
            });                 

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Update(External_Group group)
        {
            group.UpdatedBy = Base.LoginSession.intUserId;
            var request = new External_GroupRequest().Prepare();
            request.Action = Resource.Action_Update;
            request.External_Group = group;

            External_GroupResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.SetExternal_Groups(request);
            });      
          
            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public External_Group GetById(int groupId)
        {
            var request = new External_GroupRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.External_GroupId = groupId;

            External_GroupResponse response = null;
            Client.Using<IActionService>(proxy =>
            {
                response = proxy.GetExternal_Groups(request);
            });      
          
            return response.External_Group;
        }

        public void UpdateStatus(string listOption)
        {
            if (!string.IsNullOrEmpty(listOption))
            {
                External_Group model;
                string[] listOptionSplit = listOption.Split('|');
                if (listOptionSplit.Length > 0)
                {
                    foreach (var item in listOptionSplit[1].Split(','))
                    {
                        model = GetById(int.Parse(item));
                        if (listOptionSplit[0].ToString() == Control.Status_Delete)
                        {
                            Delete(int.Parse(item));
                        }
                        else
                        {
                            UpdateStatus(model, short.Parse(listOptionSplit[0]));
                        }
                    }
                }
            }
        }
    }
}