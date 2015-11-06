using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Configuration;
using System.Data.Linq;
using System.Data.Linq.Mapping;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;
using System.Data;
using System.ComponentModel;

namespace EM_Report.DAL.Infrastructure
{
    public class RepositoryBase<T> : I_Repository<T> 
        where T : class
    {
        private const string STR_DartConnectionString = "DartConnectionString";

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

        public string TableName { get; set; }

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
            context = new ReportModelDataContext(Common.Utilities.EnCryption.Decrypt(ConfigurationManager.ConnectionStrings[STR_DartConnectionString].ToString()));
        }

        public RepositoryBase(DataContext db)
        {
            context = db;
        }
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
            var entity = GetByPK(id);
            try
            {                
                Table.DeleteOnSubmit(entity);
            }
            catch (Exception)
            {
                context = new ReportModelDataContext(Common.Utilities.EnCryption.Decrypt(ConfigurationManager.ConnectionStrings[STR_DartConnectionString].ToString()));                
                Table.Attach(entity);
                Table.DeleteOnSubmit(GetByPK(id));                
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
                context = new ReportModelDataContext(Common.Utilities.EnCryption.Decrypt(ConfigurationManager.ConnectionStrings[STR_DartConnectionString].ToString()));
                Table.Attach(entity);
                Table.DeleteOnSubmit(entity);               
            }
            CommitChanges();
        }       
        
        public int ExecuteNonQueryStoreProcedure(string storename,IDictionary<string,object> dicParams)
        {
            int objNoneQuery;
            using (SqlConnection myConnection = new SqlConnection(Common.Utilities.EnCryption.Decrypt(ConfigurationManager.ConnectionStrings[STR_DartConnectionString].ToString())))
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
            using (SqlConnection myConnection = new SqlConnection(Common.Utilities.EnCryption.Decrypt(ConfigurationManager.ConnectionStrings[STR_DartConnectionString].ToString())))
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

        public DataTable ExecuteDataStoreProcedure(string storename, IDictionary<string, object> dicParams, string connectionString = null)
        {            
            if(string.IsNullOrEmpty(connectionString))
            {
                connectionString = ConfigurationManager.ConnectionStrings[STR_DartConnectionString].ToString();
            }

            DataTable tblTable = new DataTable();
            using (SqlConnection myConnection = new SqlConnection(Common.Utilities.EnCryption.Decrypt(connectionString)))
            {
                SqlCommand command = new SqlCommand();
                command.Connection = myConnection;

                myConnection.Open();
                if (dicParams != null && dicParams.Count() > 0)
                {
                    foreach (KeyValuePair<string, object> dictitem in dicParams)
                    {
                        command.Parameters.AddWithValue(dictitem.Key, dictitem.Value == null ? DBNull.Value : dictitem.Value);
                    }
                }

                command.CommandText = storename;
                command.CommandType = System.Data.CommandType.StoredProcedure;

                SqlDataAdapter adapter = new SqlDataAdapter(command);
                adapter.Fill(tblTable);
                myConnection.Close();
                return tblTable;
            }
        }

        public void CommitChanges()
        {            
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

        public void BulkInsert(IEnumerable<T> data, string tableName)
        {
            var connectionString = Common.Utilities.EnCryption.Decrypt(ConfigurationManager.ConnectionStrings["DartConnectionString"].ToString());

            using (var bulkCopy = new SqlBulkCopy(connectionString))
            {
                bulkCopy.BatchSize = data.Count();
                bulkCopy.DestinationTableName = tableName;

                var table = new DataTable();
                var props = TypeDescriptor.GetProperties(typeof(T))
                    //Dirty hack to make sure we only have system data types 
                    //i.e. filter out the relationships/collections
                                           .Cast<PropertyDescriptor>()
                                           .Where(propertyInfo => propertyInfo.PropertyType.Namespace.Equals("System"))
                                           .ToArray();

                foreach (var propertyInfo in props)
                {
                    bulkCopy.ColumnMappings.Add(propertyInfo.Name, propertyInfo.Name);
                    table.Columns.Add(propertyInfo.Name, Nullable.GetUnderlyingType(propertyInfo.PropertyType) ?? propertyInfo.PropertyType);
                }

                var values = new object[props.Length];
                foreach (var item in data)
                {
                    for (var i = 0; i < values.Length; i++)
                    {
                        values[i] = props[i].GetValue(item);
                    }

                    table.Rows.Add(values);
                }

                bulkCopy.WriteToServer(table);
            }
        }

        public void DeleteAll()
        {
            var sql = string.Format("TRUNCATE TABLE {0}", TableName);
            Context.ExecuteCommand(sql);
        }

        public void Dispose()
        {
            context.Dispose();
        }
        #endregion
    }
}
