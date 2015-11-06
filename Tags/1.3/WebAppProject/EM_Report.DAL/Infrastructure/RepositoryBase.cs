using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Configuration;
using System.Data.Linq;
using System.Data.Linq.Mapping;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;

namespace EM_Report.DAL.Infrastructure
{
    public class RepositoryBase<T> : I_Repository<T> 
        where T : class
    {
        private const string STR_EM_ReportConnectionString = "EM_ReportConnectionString";

        #region private member variables
        private string connectionStr;
       
        private DataContext context;

        public string ConnectionStr
        {
            get { return connectionStr; }
            set { connectionStr = value; }
        }

        public DataContext Context
        {
            get { return context; }
            set { context = value; }
        }
        #endregion

        #region private properties
        #endregion

        #region private methods
        private Table<T> Table
        {
            get
            {
                return context.GetTable<T>();
            }
        }
        #endregion

        #region constructors
        public RepositoryBase()
        {
            context = new ReportModelDataContext(ConfigurationManager.ConnectionStrings[STR_EM_ReportConnectionString].ToString());
        }

        public RepositoryBase(DataContext db)
        {
            context = db;
        }
        #endregion

        #region public properties
        #endregion

        #region public methods
        public IQueryable<T> GetQueryable()
        {
           return context.GetTable<T>();
        }

        public T GetByPK(object id)
        {
            // get the metamodel mappings (database to domain objects)     = Table..Context.Mapping;
            var modelMap = Table.Context.Mapping;
            // get the data members for this type
            ReadOnlyCollection<MetaDataMember> dataMembers = modelMap.GetMetaType(typeof(T)).DataMembers;
            // find the primary key field name by checking for IsPrimaryKey
            string pk = (dataMembers.Single<MetaDataMember>(m => m.IsPrimaryKey)).Name;
            // return a single object where the id argument matches the primary key field value
            return Table.SingleOrDefault<T>(delegate(T t)
            {
                String memberId = t.GetType().GetProperty(pk).GetValue(t, null).ToString();
                return memberId.ToString() == id.ToString();
            });
        }
        
        public string GetPrimaryKeyName()
        {
            try
            {
                MetaModel modelMapping = Table.Context.Mapping;
                // get the data members for this type
                ReadOnlyCollection<MetaDataMember> dataMembers = modelMapping.GetMetaType(typeof(T)).DataMembers;
                // find the primary key field and return its name
                return (dataMembers.Single<MetaDataMember>(m => m.IsPrimaryKey)).Name;
            }
            catch (Exception)
            {
                throw;
            }

        }

        public Type GetPrimaryKeyType()
        {   
            try
            {
               MetaModel modelMapping = Table.Context.Mapping;
                // get the data members for this type                   
                ReadOnlyCollection<MetaDataMember> dataMembers = modelMapping.GetMetaType(typeof(T)).DataMembers;
                // find the primary key and return its type
                return (dataMembers.Single<MetaDataMember>(m => m.IsPrimaryKey)).Type;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public T Insert(T entity)
        {
            try
            {
                Table.InsertOnSubmit(entity);
                context.SubmitChanges();
                return entity;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public T Update(T entity,object id)
        {
            object propertyValue = null;

            T entityFromDB = GetByPK(id);
            if (null == entityFromDB)
            {
                throw new NullReferenceException("Query Supplied to " + "Get entity from DB is invalid, NULL value returned");
            }

            PropertyInfo[] properties = entityFromDB.GetType().GetProperties();

            foreach (PropertyInfo property in properties)
            {
                propertyValue = null;
                if (null != property.GetSetMethod())
                {
                    PropertyInfo entityProperty = entity.GetType().GetProperty(property.Name);
                    if (property.Name != "Create_Date" && property.Name != "Owner")
                    {
                        if (entityProperty.PropertyType.BaseType == Type.GetType("System.ValueType") || entityProperty.PropertyType == Type.GetType("System.String"))
                        {
                            propertyValue = entity.GetType().GetProperty(property.Name).GetValue(entity, null);
                        }
                        if ((null == propertyValue && entityProperty.PropertyType == Type.GetType("System.String")) || null != propertyValue)
                        {
                            if (propertyValue!=null && propertyValue.ToString() == "0")
                            {
                                propertyValue = null;
                            }
                            property.SetValue(entityFromDB, propertyValue, null);
                        }
                    }
                }
            }
            CommitChanges();
            return entity;
        }

        public void DeleteById(object id)
        {
            try
            {
                Table.DeleteOnSubmit(GetByPK(id));
            }
            catch (Exception)
            {
                throw;
            }
            CommitChanges();
        }  
        
        public void Delete(T entity)
        {
            try
            {               
                Table.DeleteOnSubmit(entity);
            }
            catch(InvalidOperationException)
            {
                Table.Attach(entity);
                Table.DeleteOnSubmit(entity);
                //CommitChanges();
                //throw;
            }
            CommitChanges();
        }       
        
        public int ExecuteNonQueryStoreProcedure(string storename,IDictionary<string,object> dicParams)
        {
            int objNoneQuery;
            using (SqlConnection myConnection = new SqlConnection(ConfigurationManager.ConnectionStrings[STR_EM_ReportConnectionString].ToString()))
            {
                SqlCommand command = new SqlCommand();
                command.Connection = myConnection;

                myConnection.Open();
                if(dicParams!=null && dicParams.Count()>0)
                {
                    foreach (KeyValuePair<string, object> dictitem in dicParams)
                    {
                       command.Parameters.AddWithValue(dictitem.Key, dictitem.Value);
                    }                   
                }

                command.CommandText = storename;
                command.CommandType = System.Data.CommandType.StoredProcedure;                

                objNoneQuery = command.ExecuteNonQuery();
                myConnection.Close();
                return objNoneQuery;
            }
        }

        public object ExecuteScalarStoreProcedure(string storename, IDictionary<string, object> dicParams)
        {
            object objScalar;
            using (SqlConnection myConnection = new SqlConnection(ConfigurationManager.ConnectionStrings[STR_EM_ReportConnectionString].ToString()))
            {
                SqlCommand command = new SqlCommand();
                command.Connection = myConnection;

                myConnection.Open();
                if (dicParams != null && dicParams.Count() > 0)
                {
                    foreach (KeyValuePair<string, object> dictitem in dicParams)
                    {
                        command.Parameters.AddWithValue(dictitem.Key, dictitem.Value);
                    }
                }

                command.CommandText = storename;
                command.CommandType = System.Data.CommandType.StoredProcedure;

                objScalar =command.ExecuteScalar();
                myConnection.Close();
                return objScalar;
            }
        }

        public void CommitChanges()
        {
            //context.SubmitChanges(ConflictMode.ContinueOnConflict);
            try
            {
                context.SubmitChanges(ConflictMode.ContinueOnConflict);
            }
            catch (ChangeConflictException)
            {
                foreach (ObjectChangeConflict occ in context.ChangeConflicts)
                {
                    //Keep current values that have changed, 
                    //updates other values with database values

                    occ.Resolve(RefreshMode.KeepChanges);
                }
                throw;
            }
        }

        public void Dispose()
        {
            context.Dispose();
        }
        #endregion
    }
}
