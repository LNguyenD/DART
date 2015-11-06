using System;
using System.Collections.Generic;
using System.Linq;
using EM_Report.ActionServiceReference;
using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using EM_Report.Domain;

namespace EM_Report.Repositories
{
    /// <summary>
    /// Organisation Level Repository interface.
    /// Note: does not derive from IRepository.
    /// </summary>
    public interface IOrganisationLevelsRepository
    {
        List<Organisation_Levels> GetList();
        List<Organisation_Levels> GetList(string search, string sort);
        List<Organisation_Levels> GetList(string search, string sort, int pageindex, int pagesize);
        Organisation_Levels GetById(int levelId);
        Organisation_Levels Get(object levelId);
        void Create(Organisation_Levels level);
        void Update(Organisation_Levels level);
        void UpdateStatus(Organisation_Levels level, short status);
        void Delete(int levelId);
        void ReArrangeLevel(string data, int updatedBy);
    }

    /// <summary>
    /// Report Repository. Implements just one method.
    /// </summary>
    public class OrganisationLevelsRepository : RepositoryBase, IOrganisationLevelsRepository
    {
        /// <summary>
        /// Gets list of Organisation Level.
        /// </summary>
        /// <returns></returns>
        public List<Organisation_Levels> GetList()
        {
            var request = new Organisation_LevelsRequest().Prepare();            
            request.LoadOptions = new[] { Resource.Get_Option_List };
            request.Criteria = new Criteria();
            var response = Client.GetOrganisationLevels(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Levels == null ? null : response.Levels.ToList();
        }

        /// <summary>
        /// Gets list of Organisation Level.
        /// </summary>
        /// <param name="search"></param>
        /// <param name="sort"></param>
        /// <returns></returns>
        public List<Organisation_Levels> GetList(string search, string sort)
        {
            var request = new Organisation_LevelsRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search };

            var response = Client.GetOrganisationLevels(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Levels == null ? null : response.Levels.ToList();
        }

        /// <summary>
        /// Gets list of Organisation Level.
        /// </summary>
        /// <param name="search"></param>
        /// <param name="sort"></param>
        /// <param name="pageindex"></param>
        /// <param name="pagesize"></param>
        /// <returns></returns>
        public List<Organisation_Levels> GetList(string search, string sort, int pageindex, int pagesize)
        {
            var request = new Organisation_LevelsRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_List };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize };

            var response = Client.GetOrganisationLevels(request);
            Base.TotalItemCount = response.TotalItemCount;
            Correlate(request, response);

            return response.Levels == null ? null : response.Levels.ToList();
        }

        /// <summary>
        /// Gets an individual Organisation Level by id.
        /// </summary>
        /// <param name="levelId"></param>
        /// <returns></returns>
        public Organisation_Levels Get(object levelId)
        {
            var request = new Organisation_LevelsRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_Single };
            request.LevelId = int.Parse(levelId.ToString());

            var response = Client.GetOrganisationLevels(request);
            Correlate(request, response);

            return response.Level;
        }

        public Organisation_Levels GetById(int LevelId)
        {
            var request = new Organisation_LevelsRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.LevelId = LevelId;
            var response = Client.GetOrganisationLevels(request);

            Correlate(request, response);

            return response.Level;
        }

        /// <summary>
        /// Inserts a new Organisation Level.
        /// </summary>
        /// <param name="level"></param>
        public void Create(Organisation_Levels level)
        {
            level.Create_Date = DateTime.Now;
            level.Owner = Base.LoginSession.intUserId;
            var request = new Organisation_LevelsRequest().Prepare();
            request.Action = Resource.Action_Create;
            request.Level = level;

            var response = Client.SetOrganisationLevels(request);
            Correlate(request, response);

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        /// <summary>
        /// Update an existing Organisation Level.
        /// </summary>
        /// <param name="level"></param>
        public void Update(Organisation_Levels level)
        {
            level.UpdatedBy = Base.LoginSession.intUserId;
            var request = new Organisation_LevelsRequest().Prepare();
            request.Action = Resource.Action_Update;
            request.Level = level;

            var response = Client.SetOrganisationLevels(request);
            Correlate(request, response);

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        /// <summary>
        /// Updates Status an existing Organisation Level.
        /// </summary>
        /// <param name="level"></param>
        /// <param name="status"></param>
        public void UpdateStatus(Organisation_Levels level, short status)
        {
            var request = new Organisation_LevelsRequest().Prepare();
            request.Action = Resource.Action_UpdateStatus;
            request.Criteria = new Criteria { Status = status };
            request.Level = level;

            var response = Client.SetOrganisationLevels(request);
            Correlate(request, response);

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        /// <summary>
        /// Delete an existing Organisation Level.
        /// </summary>
        /// <param name="levelId"></param>
        public void Delete(int levelId)
        {
            var request = new Organisation_LevelsRequest().Prepare();

            request.Action = Resource.Action_Delete;
            request.LevelId = levelId;

            var response = Client.SetOrganisationLevels(request);
            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);

            // return response.RowsAffected;
        }

        public void ReArrangeLevel(string data, int updatedBy)
        {
            var request = new Organisation_LevelsRequest().Prepare();

            request.Action = Resource.Action_ReArrange;
            request.Data = data;
            request.UpdatedBy = updatedBy;

            var response = Client.SetOrganisationLevels(request);
            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);

            // return response.RowsAffected;
        }        
    }
}