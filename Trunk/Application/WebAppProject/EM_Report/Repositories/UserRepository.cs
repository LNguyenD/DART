using System;
using System.Collections.Generic;
using System.Linq;
using EM_Report.ActionServiceReference;
using EM_Report.Domain;
using EM_Report.Domain.Resources;
using EM_Report.Helpers;

namespace EM_Report.Repositories
{
    /// <summary>
    /// User Repository interface.
    /// Note: does not derive from IRepository.
    /// </summary>
    public interface IUserRepository
    {
        List<User> GetList();

        List<User> GetList(string search, string sort);

        List<User> GetList(string search, string sort, int pageindex, int pagesize);

        List<User> GetList(string search, string sort, int pageindex, int pagesize, int systemid);

        List<User> GetList(string search, string sort, int pageindex, int pagesize, int systemid, string usertype);

        User Get(int userId);

        User Get(string username);

        User Get(string username, string email);

        void Insert(User user);

        void Update(User user);

        void UpdateStatus(User user, short status);

        void Delete(int userId);

        bool IsValidUser(User model);

        void UpdateStatus(string listOption);

        Systems[] GetSystemList();

        string GetSystemNameById(int systemid);

        int GetSystemIdByName(string systemname);        
    }

    /// <summary>
    /// User Repository. Implements just one method.
    /// </summary>
    public class UserRepository : RepositoryBase, IUserRepository
    {
        /// <summary>
        /// Gets list of users.
        /// </summary>
        /// <param name="criterion"></param>
        /// <returns></returns>
        public List<User> GetList()
        {
            var request = new UserRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };
            request.Criteria = new Criteria();
            var response = Client.GetUsers(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.Users == null ? null : response.Users.ToList();
        }

        /// <summary>
        /// Gets list of users.
        /// </summary>
        /// <param name="criterion"></param>
        /// <returns></returns>
        public List<User> GetList(string search, string sort)
        {
            var request = new UserRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search };

            var response = Client.GetUsers(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.Users == null ? null : response.Users.ToList();
        }

        /// <summary>
        /// Gets list of users.
        /// </summary>
        /// <param name="criterion"></param>
        /// <returns></returns>
        public List<User> GetList(string search, string sort, int pageindex, int pagesize)
        {
            var request = new UserRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize };

            var response = Client.GetUsers(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.Users == null ? null : response.Users.ToList();
        }

        public List<User> GetList(string search, string sort, int pageindex, int pagesize, int systemid)
        {
            var request = new UserRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize, SystemId = systemid };

            var response = Client.GetUsers(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.Users == null ? null : response.Users.ToList();
        }

        public List<User> GetList(string search, string sort, int pageindex, int pagesize, int systemid, string usertype)
        {
            var request = new UserRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_List };
            request.Criteria = new Criteria { SortExpression = sort, SearchKeyWord = search, PageIndex = pageindex, PageSize = pagesize, SystemId = systemid, };
            request.UserType = usertype;
            var response = Client.GetUsers(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.Users == null ? null : response.Users.ToList();
        }

        /// <summary>
        /// Gets an individual user by id.
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public User Get(int userId)
        {
            var request = new UserRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.UserId = userId;

            var response = Client.GetUsers(request);

            Correlate(request, response);

            return response.User;
        }

        public User Get(string username)
        {
            var request = new UserRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.UserName = username;

            var response = Client.GetUsers(request);

            Correlate(request, response);

            return response.User;
        }

        public User Get(string username, string email)
        {
            var request = new UserRequest().Prepare();
            request.LoadOptions = new string[] { Resource.GetUser_By_UserNameOrEmail };
            var user = new User
            {
                UserName = username,
                Email = email
            };
            request.User = user;

            var response = Client.GetUsers(request);

            Correlate(request, response);

            return response.Users.FirstOrDefault();
        }

        /// <summary>
        /// Inserts a new users.
        /// </summary>
        /// <param name="user"></param>
        public void Insert(User user)
        {
            user.Create_Date = DateTime.Now;
            user.Owner = Base.LoginSession.intUserId;
            var request = new UserRequest().Prepare();
            request.Action = Resource.Action_Create;
            request.User = user;

            var response = Client.SetUsers(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        /// <summary>
        /// Updates an existing user.
        /// </summary>
        /// <param name="user"></param>
        public void Update(User user)
        {
            if (Base.LoginSession != null)
            {
                user.UpdatedBy = Base.LoginSession.intUserId;
            }
            var request = new UserRequest().Prepare();
            request.Action = Resource.Action_Update;
            request.User = user;

            var response = Client.SetUsers(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        /// <summary>
        /// Updates Status an existing user.
        /// </summary>
        /// <param name="user"></param>
        public void UpdateStatus(User user, short status)
        {
            user.UpdatedBy = Base.LoginSession.intUserId;
            var request = new UserRequest().Prepare();
            request.Action = Resource.Action_UpdateStatus;
            request.Criteria = new Criteria { Status = status };
            request.User = user;

            var response = Client.SetUsers(request);

            Correlate(request, response);

            // These messages are for public consumption. Includes validation errors.
            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        /// <summary>
        /// Deletes an existing user.
        /// </summary>
        /// <param name="userId"></param>
        public void Delete(int userId)
        {
            var request = new UserRequest().Prepare();

            request.Action = Resource.Action_Delete;
            request.UserId = userId;

            var response = Client.SetUsers(request);

            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);

            // return response.RowsAffected;
        }

        public bool IsValidUser(User model)
        {
            var request = new UserRequest().Prepare();
            request.LoadOptions = new string[] { Resource.GetUser_By_UserNameOrEmail };
            request.User = model;

            var response = Client.GetUsers(request);

            Correlate(request, response);

            return response.Users == null || !response.Users.Any() ? true : false;
        }

        public void UpdateStatus(string listOption)
        {
            if (!string.IsNullOrEmpty(listOption))
            {
                User model;
                string[] listOptionSplit = listOption.Split('|');
                if (listOptionSplit.Length > 0)
                {
                    foreach (var item in listOptionSplit[1].Split(','))
                    {
                        model = Get(int.Parse(item));
                        UpdateStatus(model, short.Parse(listOptionSplit[0]));
                    }
                }
            }
        }

        public Systems[] GetSystemList()
        {
            if (!Base.LoginSession.lstSystems.Any())
            {
                var request = new UserRequest().Prepare();
                request.LoadOptions = new string[] { Resource.Get_List_System };
                request.UserId = Base.LoginSession.intUserId;

                var response = Client.GetUsers(request);

                Base.TotalItemCount = response.TotalItemCount;

                Correlate(request, response);
                Base.LoginSession.lstSystems = response.Systems;
            }
            return Base.LoginSession.lstSystems as Systems[];
        }

        public Systems[] GetAllSystemList()
        {
            var request = new UserRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_List_System };
            request.UserId = Base.LoginSession.intUserId;

            var response = Client.GetUsers(request);
            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);
            return response.Systems;
        }

        public string GetSystemNameById(int systemid)
        {
            return GetSystemList().Where(l => l.SystemId == systemid).SingleOrDefault().Name;
        }

        public string GetSystemNameByIdLevel0(int systemid)
        {
            return GetAllSystemList().Where(l => l.SystemId == systemid).SingleOrDefault().Name;
        }

        public int GetSystemIdByName(string systemname)
        {
            var system = GetSystemList().Where(l => l.Name.ToLower().Contains(systemname.ToLower())).SingleOrDefault();
            return system != null ? system.SystemId : 0;
        }              
    }
}