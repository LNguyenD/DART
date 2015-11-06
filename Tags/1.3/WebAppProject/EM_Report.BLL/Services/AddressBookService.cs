using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EM_Report.Models;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.BLL.Commons;

namespace EM_Report.BLL.Services
{
    public interface I_AddressBookService : I_Service<AddressBookModel>
    {
        AddressBookModel CreateOrUpdate(AddressBookModel model);
    }

    public class AddressBookService : ServiceBase<AddressBookModel, AddressBook>, I_AddressBookService
    {
        private I_Repository<User> _userRepository;
        
        public I_Repository<User> UserRepository
        {
            get { return _userRepository; }
            set { _userRepository = value; }
        }

        public AddressBookService(I_LoginSession session)
            : base(session)
        {
            _userRepository = new RepositoryBase<User>(((RepositoryBase<AddressBook>)Repository).Context);
        }

        protected override AddressBookModel MappingToModel(AddressBook table)
        {
            return table == null ? null : new AddressBookModel()
            {
                Id = table.Id,
                UserId = table.UserId,
                Address = table.Address,
                BusinessPhone = table.BusinessPhone,
                Email = table.Email,
                FirstName = table.FirstName,
                HomePhone = table.HomePhone,
                LastName = table.LastName,
                MiddleName = table.MiddleName,
                MobilePhone = table.MobilePhone
            };
        }

        protected override AddressBook MappingToDAL(AddressBookModel model)
        {
            return model == null ? null : new AddressBook()
            {
                Id = model.Id,
                UserId = model.UserId,
                Address = model.Address,
                BusinessPhone = model.BusinessPhone,
                Email = model.Email,
                FirstName = model.FirstName,
                HomePhone = model.HomePhone,
                LastName = model.LastName,
                MiddleName = model.MiddleName,
                MobilePhone = model.MobilePhone
            };
        }

        protected override IQueryable<AddressBookModel> Filter(string keyword, IQueryable<AddressBookModel> query)
        {
            if (string.IsNullOrEmpty(keyword))
            {
                return query;
            }
            var predicate = PredicateBuilder.False<AddressBookModel>();
            predicate = predicate.Or(p => p.FirstName.Contains(keyword));
            predicate = predicate.Or(p => p.MiddleName.Contains(keyword));
            predicate = predicate.Or(p => p.LastName.Contains(keyword));
            predicate = predicate.Or(p => p.Email.Contains(keyword));
            return query.Where(predicate);
        }

        protected override IQueryable<AddressBookModel> GetMapping(IQueryable<AddressBook> query)
        {
            try
            {
                var result = from address in query
                             select new AddressBookModel()
                             {
                                 Id = address.Id,
                                 UserId = address.UserId,
                                 Address = address.Address,
                                 BusinessPhone = address.BusinessPhone,
                                 Email = address.Email,
                                 FirstName = address.FirstName,
                                 HomePhone = address.HomePhone,
                                 LastName = address.LastName,
                                 MiddleName = address.MiddleName,
                                 MobilePhone = address.MobilePhone
                             };
                return result;
            }
            catch (Exception ex)
            {
                Logger.Error("GetMapping error", ex);
                return null;
            }
        }

        /// <summary>
        /// Creates the or update.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns></returns>
        public AddressBookModel CreateOrUpdate(AddressBookModel model)
        {
            return (model.Id > 0) ? Update(model, model.Id) : Create(model);
        }
    }    
}