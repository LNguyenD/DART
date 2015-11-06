using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System;

namespace EM_Report.BLL.Services
{
    public interface I_Service<T> where T : class
    {
        IEnumerable<T> GetAll();
        IQueryable<T> GetAllQueryable(string sort, string keyword);
        IQueryable<T> GetAllQueryable(string sort, string keyword, Expression<Func<T, bool>> expression);
        T GetById(object id);
        T Create(T model);
        T Update(T model,object id);
        void Delete(object id);
        bool IsExist(long id);
        object ExecuteScalarStoreProcedure(string storename, IDictionary<string, object> dicParams);
        int ExecuteNonQueryStoreProcedure(string storename, IDictionary<string, object> dicParams);
    }
}