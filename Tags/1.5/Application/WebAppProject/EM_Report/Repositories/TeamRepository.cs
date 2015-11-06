using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EM_Report.ActionServiceReference;
using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using EM_Report.Domain;
namespace EM_Report.Repositories
{

    public interface ITeamRepository
    {
        List<Team> GetList();
        List<Team> GetList(string search, string sort);

        List<Team> GetList(string search, string sort, int pageindex, int pagesize);
        List<Team> GetList(string search, string sort, int pageindex, int pagesize, int systemid);
        Team GetById(int teamId);
        void Insert(Team team);
        void Update(Team team);
        void UpdateStatus(Team team, short status);
        void Delete(int teamId);
        bool IsRIG(User user, string site);
        bool IsRIG(string username, string site);
        void UpdateStatus(string listOption);
    }

    public class TeamRepository : RepositoryBase, ITeamRepository
    {
        public List<Team> GetList()
        {
            var request = new TeamRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };
            request.Criteria = new Criteria();
            var response = Client.GetTeams(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.Teams == null ? null : response.Teams.ToList();
        }
    

        public List<Team> GetList(string search, string sort)
        {
            var request = new TeamRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };

            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search };

            var response = Client.GetTeams(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.Teams == null ? null : response.Teams.ToList();
        }

        public List<Team> GetList(string search, string sort, int pageindex, int pagesize)
        {
            var request = new TeamRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };

            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize };

            var response = Client.GetTeams(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.Teams == null ? null : response.Teams.ToList();
        }

        public List<Team> GetList(string search, string sort, int pageindex, int pagesize, int systemid)
        {
            var request = new TeamRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };

            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize,SystemId = systemid};

            var response = Client.GetTeams(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.Teams == null ? null : response.Teams.ToList();
        }

        public Team GetById(int teamId)
        {
            var request = new TeamRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.TeamId = teamId;

            var response = Client.GetTeams(request);

            Correlate(request, response);

            return response.Team;
        }

        public void Insert(Team team)
        {
            team.Create_Date = DateTime.Now;
            team.Owner = Base.LoginSession.intUserId;
            var request = new TeamRequest().Prepare();
            request.Action = Resource.Action_Create;
            request.Team = team;

            var response = Client.SetTeams(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Update(Team team)
        {
            team.UpdatedBy = Base.LoginSession.intUserId;
            var request = new TeamRequest().Prepare();
            request.Action = Resource.Action_Update;
            request.Team = team;

            var response = Client.SetTeams(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void UpdateStatus(Team team, short status)
        {
            team.UpdatedBy = Base.LoginSession.intUserId;
            var request = new TeamRequest().Prepare();
            request.Action = Resource.Action_UpdateStatus;
            request.Criteria = new Criteria { Status = status };
            request.Team = team;

            var response = Client.SetTeams(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void Delete(int teamId)
        {
            var request = new TeamRequest().Prepare();
            request.Action = Resource.Action_Delete;
            request.TeamId = teamId;            

            var response = Client.SetTeams(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public bool IsRIG(User user, string site)
        {
            throw new NotImplementedException();
        }

        public bool IsRIG(string username, string site)
        {
            var request = new TeamRequest().Prepare();
            request.Action = Resource.IsRig;
            request.UserName = username;
            request.Site = site;

            var response = Client.GetTeams(request);

            Correlate(request, response);

            return response.IsRig;
        }

        public void UpdateStatus(string listOption)
        {
            if (!string.IsNullOrEmpty(listOption))
            {
                Team model;
                string[] listOptionSplit = listOption.Split('|');
                if (listOptionSplit.Length > 0)
                {
                    foreach (var item in listOptionSplit[1].Split(','))
                    {
                        model = GetById(int.Parse(item));                        
                        if(listOptionSplit[0].ToString()==Control.Status_Delete)
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