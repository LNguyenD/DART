using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Web.Mvc;
using System.Web.Routing;

namespace EM_Report.Common.Utilities
{
    public static class EnumerableExtensions
    {
        public static int Count(this IEnumerable source)
        {
            int count = 0;

            var enumerator = source.GetEnumerator();
            while (enumerator.MoveNext())
            {
                count++;
            }

            return count;
        }
        
        public static void ForEach<T>(this IEnumerable<T> source, Action<T> action)
        {
            if (action == null)
                throw new ArgumentNullException("action");

            foreach (T item in source)
                action(item);
        }

        public static bool IsNullOrEmpty<T>(this IEnumerable<T> source)
        {
            return (source == null || !source.Any());
        }
    }    

    public static class QueryableExtention
    {
        public static IOrderedQueryable<T> OrderBy<T>(this IQueryable<T> query, string memberName, string sortDirection)
        {
            ParameterExpression[] typeParams = new ParameterExpression[] { Expression.Parameter(typeof(T), string.Empty) };

            System.Reflection.PropertyInfo pi = typeof(T).GetProperty(memberName);

            return (IOrderedQueryable<T>)query.Provider.CreateQuery(
                Expression.Call(
                    typeof(Queryable),
                    sortDirection == Constants.G_ORDER_DESC ? "OrderByDescending" : "OrderBy",
                    new Type[] { typeof(T), pi.PropertyType },
                    query.Expression,
                    Expression.Lambda(Expression.Property(typeParams[0], pi), typeParams))
            );
        }

        public static IOrderedQueryable<T> OrderBy<T>(this IQueryable<T> query, string memberExpression)
        {
            string memberName;
            string sortDirection;
            var sortSplit = memberExpression.Split('|');
            memberName = sortSplit[0];
            if (sortSplit.Length == 2 && sortSplit[1] != null && sortSplit[1].ToLower().IndexOf(Constants.G_ORDER_DESC) >= 0)
            {
                sortDirection = Constants.G_ORDER_DESC;
            }
            else
            {
                sortDirection = Constants.G_ORDER_ASC;
            }

            ParameterExpression[] typeParams = new ParameterExpression[] { Expression.Parameter(typeof(T), string.Empty) };

            System.Reflection.PropertyInfo pi = typeof(T).GetProperty(memberName);

            return (IOrderedQueryable<T>)query.Provider.CreateQuery(
                Expression.Call(
                    typeof(Queryable),
                    sortDirection == Constants.G_ORDER_DESC ? "OrderByDescending" : "OrderBy",
                    new Type[] { typeof(T), pi.PropertyType },
                    query.Expression,
                    Expression.Lambda(Expression.Property(typeParams[0], pi), typeParams))
            );
        }
    }
}
