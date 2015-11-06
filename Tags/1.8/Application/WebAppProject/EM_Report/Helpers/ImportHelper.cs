using System;
using System.Configuration;
using System.Linq;
//using System.Runtime.Caching;
using System.Web;
using System.Collections.Generic;
using EM_Report.Common.Utilities;
using EM_Report.Domain.Resources;
using EM_Report.Domain.Enums;
using EM_Report.Repositories;
using EM_Report.Domain;

namespace EM_Report.Helpers
{
    public class ImportHelper
    {
        private static string[] PROJECTION_TYPE_DOMAIN_VALUES = new string[] {
            "1-2", "3-5", "5-plus", "Whole-TMF", "TMF", "Whole-EML", "EML", "Whole-HEM", "HEM" };

        private static IUserRepository _userRepository;
        
        public static IUserRepository UserRepository
        {
            get
            {
                if (_userRepository == null)
                {
                    _userRepository = new UserRepository();
                }
                return _userRepository;
            }
        }

        public static List<Dashboard_Graph_Description> Get_Graph_Description_List(string csvFilePath)
        {
            var modelList = new List<Dashboard_Graph_Description>();

            var graphDescriptionFields = new FieldValue[] 
            { 
                new FieldValue { FieldName = "System", DataType = DataType.String, 
                    DomainValues = (Base.LoginSession.lstSystems != null ? Base.LoginSession.lstSystems.Select(a => a.Name).ToArray() : null), IsRequired = true },
                new FieldValue { FieldName = "Type", DataType = DataType.String, IsRequired = true },
                new FieldValue { FieldName = "Description", DataType = DataType.String, IsRequired = true }
            };

            var csvResults = ExcelHelper.GetItems2(csvFilePath, graphDescriptionFields);

            // update model
            if (csvResults.Count > 0)
            {
                modelList = Update_Graph_Description_Model(csvResults);
            }

            return modelList;
        }

        public static List<User> Get_User_List(string csvFilePath)
        {
            var modelList = new List<User>();

            var userFields = new FieldValue[]
            {
                new FieldValue { FieldName = "System", DataType = DataType.String,
                    DomainValues = (Base.LoginSession.lstSystems != null ? Base.LoginSession.lstSystems.Select(a => a.Name).ToArray() : null), IsRequired = true },
                new FieldValue { FieldName = "UserName", DataType = DataType.String, IsRequired = true },
                new FieldValue { FieldName = "Password", DataType = DataType.String, IsRequired = true },
                new FieldValue { FieldName = "FirstName", DataType = DataType.String, IsRequired = true },
                new FieldValue { FieldName = "LastName", DataType = DataType.String, IsRequired = true },
                new FieldValue { FieldName = "Email", DataType = DataType.String, IsRequired = true }
            };

            var csvResults = ExcelHelper.GetItems2(csvFilePath, userFields);

            // update model
            if (csvResults.Count > 0)
            {
                modelList = UpdateUserModel(csvResults);
            }

            return modelList;
        }

        static List<Dashboard_Graph_Description> Update_Graph_Description_Model(List<ExcelResult> excelResults)
        {
            var descriptionList = new List<Dashboard_Graph_Description>();

            foreach (var item in excelResults)
            {
                var graphDescription = new Dashboard_Graph_Description();

                var systemName = item.Items.FirstOrDefault(a => a.FieldName.ToLower() == "system");
                if (systemName != null && systemName.Value != null && systemName.Value.ToString() != "")
                {
                    graphDescription.SystemId = UserRepository.GetSystemIdByName(systemName.Value.ToString());
                }

                var type = item.Items.FirstOrDefault(a => a.FieldName.ToLower() == "type");
                if (type != null && type.Value != null)
                {
                    graphDescription.Type = type.Value.ToString();
                }

                var description = item.Items.FirstOrDefault(a => a.FieldName.ToLower() == "description");
                if (description != null && description.Value != null)
                {
                    graphDescription.Description = description.Value.ToString();
                }

                graphDescription.IsError = item.IsError;
                graphDescription.ErrorFields = item.ErrorFields;

                descriptionList.Add(graphDescription);
            }

            return descriptionList;
        }        

        static List<User> UpdateUserModel(List<ExcelResult> excelResults)
        {
            var userList = new List<User>();

            foreach (var item in excelResults)
            {
                var user = new User();

                var systemName = item.Items.FirstOrDefault(a => a.FieldName.ToLower() == "system");
                if (systemName != null && systemName.Value != null && systemName.Value.ToString() != "")
                {
                    user.SystemId = UserRepository.GetSystemIdByName(systemName.Value.ToString());
                }

                var userName = item.Items.FirstOrDefault(a => a.FieldName.ToLower() == "username");
                if (userName != null && userName.Value != null)
                {
                    user.UserName = userName.Value.ToString();
                }

                var password = item.Items.FirstOrDefault(a => a.FieldName.ToLower() == "password");
                if (password != null && password.Value != null)
                {
                    user.Password = password.Value.ToString();
                }

                var firstName = item.Items.FirstOrDefault(a => a.FieldName.ToLower() == "firstname");
                if (firstName != null && firstName.Value != null)
                {
                    user.FirstName = firstName.Value.ToString();
                }

                var lastName = item.Items.FirstOrDefault(a => a.FieldName.ToLower() == "lastname");
                if (lastName != null && lastName.Value != null)
                {
                    user.LastName = lastName.Value.ToString();
                }

                var email = item.Items.FirstOrDefault(a => a.FieldName.ToLower() == "email");
                if (email != null && email.Value != null)
                {
                    user.Email = email.Value.ToString();
                }

                user.IsError = item.IsError;
                user.ErrorFields = item.ErrorFields;

                userList.Add(user);
            }

            return userList;
        }

        public static List<Dashboard_Traffic_Light_Rule> Get_Dashboard_Traffic_Light_Rules_List(string csvFilePath)
        {
            var modelList = new List<Dashboard_Traffic_Light_Rule>();

            var targetFields = new FieldValue[]
            {
                new FieldValue { FieldName = "System", DataType = DataType.String,
                    DomainValues = (Base.LoginSession.lstSystems != null ? Base.LoginSession.lstSystems.Select(a => a.Name).ToArray() : null), IsRequired = true },
                new FieldValue { FieldName = "DashboardType", DataType = DataType.String, IsRequired = true },
                new FieldValue { FieldName = "Name", DataType = DataType.String, IsRequired = true },
                new FieldValue { FieldName = "Description", DataType = DataType.String, IsRequired = false },
                new FieldValue { FieldName = "FromPercentage", DataType = DataType.Decimal, IsRequired = true },
                new FieldValue { FieldName = "ToPercentage", DataType = DataType.Decimal, IsRequired = true }
            };

            var csvResults = ExcelHelper.GetItems2(csvFilePath, targetFields);

            // update model
            if (csvResults.Count > 0)
            {
                modelList = Update_Dashboard_Traffic_Light_Rules(csvResults);
            }

            return modelList;
        }

        static List<Dashboard_Traffic_Light_Rule> Update_Dashboard_Traffic_Light_Rules(List<ExcelResult> excelResults)
        {
            var targetList = new List<Dashboard_Traffic_Light_Rule>();

            foreach (var item in excelResults)
            {
                var target = new Dashboard_Traffic_Light_Rule();

                var systemName = item.Items.FirstOrDefault(a => a.FieldName == "system");
                if (systemName != null && systemName.Value != null && systemName.Value.ToString() != "")
                {
                    target.SystemId = UserRepository.GetSystemIdByName(systemName.Value.ToString());
                    target.SystemName = systemName.Value.ToString();
                }

                var dashboardtype = item.Items.FirstOrDefault(a => a.FieldName == "dashboardtype");
                if (dashboardtype != null && dashboardtype.Value != null)
                {
                    target.DashboardType = dashboardtype.Value.ToString();
                }

                var name = item.Items.FirstOrDefault(a => a.FieldName == "name");
                if (name != null && name.Value != null)
                {
                    target.Name = name.Value.ToString();

                    // update image URL
                    switch (target.Name)
                    {
                        case "Superb":
                            target.ImageUrl = "images/traffic_light_superb.png";
                            break;

                        case "Better":
                            target.ImageUrl = "images/traffic_light_well.png";
                            break;

                        case "Neutral":
                            target.ImageUrl = "images/traffic_light_ok.png";
                            break;

                        case "Warning":
                            target.ImageUrl = "images/traffic_light_warning.png";
                            break;

                        case "Worse":
                            target.ImageUrl = "images/traffic_light_bad.png";
                            break;

                        case "Unknown":
                            target.ImageUrl = "images/traffic_light_unknown.png";
                            break;
                    }
                }

                var description = item.Items.FirstOrDefault(a => a.FieldName == "description");
                if (description != null && description.Value != null)
                {
                    target.Description = description.Value.ToString();
                }

                var fromValue = item.Items.FirstOrDefault(a => a.FieldName == "frompercentage");
                if (fromValue != null && fromValue.Value != null)
                {
                    double _fromValue = 0;
                    if (double.TryParse(fromValue.Value.ToString(), out _fromValue))
                    {
                        target.FromValue = _fromValue;
                    }
                }

                var toValue = item.Items.FirstOrDefault(a => a.FieldName == "topercentage");
                if (toValue != null && toValue.Value != null)
                {
                    double _toValue = 0;
                    if (double.TryParse(toValue.Value.ToString(), out _toValue))
                    {
                        target.ToValue = _toValue;
                    }
                }

                target.IsError = item.IsError;
                target.ErrorFields = item.ErrorFields;

                targetList.Add(target);
            }

            return targetList;
        }

        public static List<Dashboard_Projection> Get_Dashboard_Porjection_List(string csvFilePath)
        {
            var modelList = new List<Dashboard_Projection>();

            var projectionFields = new FieldValue[] 
            { 
                new FieldValue { FieldName = "Unit_Type", DataType = DataType.String, IsRequired = true },
                new FieldValue { FieldName = "Unit_Name", DataType = DataType.String, IsRequired = true },
                new FieldValue { FieldName = "Type", DataType = DataType.String, DomainValues = PROJECTION_TYPE_DOMAIN_VALUES, IsRequired = true },
                new FieldValue { FieldName = "Time_Id", DataType = DataType.Date, IsRequired = true },
                new FieldValue { FieldName = "Projection", DataType = DataType.Decimal, IsRequired = true }
            };

            var csvResults = ExcelHelper.GetItems2(csvFilePath, projectionFields);

            // update model
            if (csvResults.Count > 0)
            {
                modelList = Update_Dashboard_Porjection(csvResults);
            }

            return modelList;
        }

        static List<Dashboard_Projection> Update_Dashboard_Porjection(List<ExcelResult> excelResults)
        {
            var projectionList = new List<Dashboard_Projection>();

            foreach (var item in excelResults)
            {
                var projection = new Dashboard_Projection();

                var unitType = item.Items.FirstOrDefault(a => a.FieldName.ToLower() == "unit_type");
                if (unitType != null && unitType.Value != null)
                {
                    projection.Unit_Type = unitType.Value.ToString();
                }

                var unitName = item.Items.FirstOrDefault(a => a.FieldName.ToLower() == "unit_name");
                if (unitName != null && unitName.Value != null)
                {
                    projection.Unit_Name = unitName.Value.ToString().ToUpper();
                }

                var type = item.Items.FirstOrDefault(a => a.FieldName.ToLower() == "type");
                if (type != null && type.Value != null)
                {
                    projection.Type = type.Value.ToString();
                }

                var timeId = item.Items.FirstOrDefault(a => a.FieldName.ToLower() == "time_id");
                if (timeId != null && timeId.Value != null)
                {
                    DateTime _timeId;
                    if (DateTime.TryParse(timeId.Value.ToString(), out _timeId))
                    {
                        // update to end of day
                        _timeId = _timeId.AddHours(23).AddMinutes(59);
                        projection.Time_Id = _timeId;
                    }
                }

                var projectionValue = item.Items.FirstOrDefault(a => a.FieldName.ToLower() == "projection");
                if (projectionValue != null && projectionValue.Value != null)
                {
                    double _projection = 0;
                    if (double.TryParse(projectionValue.Value.ToString(), out _projection))
                    {                       
                        projection.Projection = _projection;
                    }
                }

                projection.IsError = item.IsError;
                projection.ErrorFields = item.ErrorFields;

                projectionList.Add(projection);
            }

            return projectionList;
        }
    }
}