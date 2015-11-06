using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EM_Report.Repositories;
using RS = Microsoft.SqlServer.ReportingServices2010;
using EM_Report.SSRS;
using EM_Report.ActionServiceReference;
using EM_Report.Common.Utilities;
using EM_Report.Domain;

namespace EM_Report.Helpers
{
    public static class ReportParametersHelper
    {
        public static ItemParameter PopulateParametersData(PortfolioReportParameters paramData, out string reportParameterData)
        {
            var itemParameter = new SSRS.ItemParameter();
            var parameters = new List<RS.ItemParameter>();

            var systemName = paramData.System.ToUpper();
            var type = paramData.Type;

            var values = GetValuesList(systemName, type);
            var defaultValue = string.IsNullOrEmpty(paramData.Value) ? values.ElementAt(0).Value : paramData.Value;

            if (!type.Equals("Employer_Size", StringComparison.OrdinalIgnoreCase))
            {
                var valueParameter = CreateValueParameter(type, values, defaultValue);
                parameters.Add(valueParameter);
            }
            
            if (type.Equals("Group", StringComparison.OrdinalIgnoreCase))
            {
                var subValues = GetSubValuesList(systemName, defaultValue, type);
                var defaultsubValue = string.IsNullOrEmpty(paramData.SubValue) ? subValues.ElementAt(0).Value : paramData.SubValue;
                var subValueParameter = CreateSubValueParameter(type, subValues, defaultsubValue);
                parameters.Add(subValueParameter);
            }

            AddStartDateEndDateParameters(parameters, null, null);

            var claimLiabilityIndicators = GetClaimLiabilityIndicators(systemName);
            var claimLiabilityIndicatorParameter = CreateClaimLiabilityIndicatorParameter(claimLiabilityIndicators, null);
            parameters.Add(claimLiabilityIndicatorParameter);

            AddYesNoParameter("Psychological claims", "Psychological_Claims", parameters, "All");
            AddYesNoParameter("Inactive claims", "Inactive_Claims", parameters, "All");
            AddYesNoParameter("Medically discharged", "Medically_Discharged", parameters, "All");
            AddYesNoParameter("Exempt from reform", "Exempt_From_Reform", parameters, "All");
            //AddYesNoParameter("Premium Impacting", "Premium_Impacting", parameters, "All");
            AddYesNoParameter("Reactivation", "Reactivation", parameters, "All");

            itemParameter.lstRSParameters = parameters;

            reportParameterData = string.Format("System|{0};", systemName);
            reportParameterData += string.Format("Type|{0};", type);
            foreach (var param in parameters)
            {
                if (param.ValidValues != null)
                    reportParameterData += string.Format("{0}|{1};", param.Name, param.ValidValues[0].Value);
                else if (param.DefaultValues != null)
                    reportParameterData += string.Format("{0}|{1};", param.Name, param.DefaultValues[0]);
            }

            return itemParameter;
        }

        #region System parameter

        public static RS.ItemParameter CreateSystemParameter(string systemName)
        {
            var systemParameter = new RS.ItemParameter
            {
                Prompt = "System",
                Name = "System",
                ParameterTypeName = "Text",
                ParameterStateName = "ReadOnly",
                DefaultValues = string.IsNullOrEmpty(systemName) ? new string[] { "" } : new string[] { TranslateSystemName(systemName) }
            };

            return systemParameter;
        }

        public static RS.ItemParameter CreateSystemParameter(IEnumerable<RS.ValidValue> systemsList, string defaultValue)
        {
            var systemParameter = new RS.ItemParameter
            {
                Prompt = "System",
                Name = "System",
                ValidValues = systemsList.ToArray(),
                DefaultValues = string.IsNullOrEmpty(defaultValue) ? null : new string[] { defaultValue }
            };

            return systemParameter;
        }

        public static IEnumerable<RS.ValidValue> GetSystemsList()
        {
            UserRepository userRepo = new Repositories.UserRepository();
            var systems = userRepo.GetAllSystemList();
            var systemsValidValues = new List<RS.ValidValue>() { new RS.ValidValue { Label = "Select ...", Value = "Select ..." } };
            systems.ForEach(s => systemsValidValues.Add(new RS.ValidValue { Label = TranslateSystemName(s.Name), Value = s.Name }));

            return systemsValidValues;
        }

        private static string TranslateSystemName(string systemName)
        {
            var fullName = "";

            switch (systemName)
            {
                case "HEM":
                    fullName = "HOSPITALITY EMPLOYERS MUTUAL";
                    break;
                case "TMF":
                    fullName = "TMF";
                    break;
                case "EML":
                    fullName = "WORKCOVER NSW";
                    break;
            }

            return fullName;
        }

        #endregion

        #region Type parameter

        public static RS.ItemParameter CreateTypeParameter(string defaultValue)
        {
            var typeParameter = new RS.ItemParameter
            {
                Prompt = "Type",
                Name = "Type",
                //ValidValues = typesList.ToArray(),
                //Dependencies = new string[] { "System" },
                ParameterTypeName = "Text",
                ParameterStateName = "ReadOnly",
                DefaultValues = new string[] { defaultValue }
            };

            return typeParameter;
        }

        public static IEnumerable<RS.ValidValue> GetTypesList(string systemName)
        {
            var typesValidValues = new List<RS.ValidValue>();
            //typesValidValues.Add(new RS.ValidValue { Label = "Select ...", Value = "Select ..." });

            switch (systemName)
            {
                case "TMF":
                    typesValidValues.Add(new RS.ValidValue { Label = "Agency", Value = "Agency" });
                    typesValidValues.Add(new RS.ValidValue { Label = "Group", Value = "Group" });
                    break;
                case "EML":
                    typesValidValues.Add(new RS.ValidValue { Label = "Group", Value = "Group" });
                    typesValidValues.Add(new RS.ValidValue { Label = "EMPL_Size", Value = "EMPL_Size" });
                    typesValidValues.Add(new RS.ValidValue { Label = "Account Manager", Value = "Account Manager" });
                    break;
                case "HEM":
                    typesValidValues.Add(new RS.ValidValue { Label = "Group", Value = "Group" });
                    typesValidValues.Add(new RS.ValidValue { Label = "Portfolio", Value = "Portfolio" });
                    typesValidValues.Add(new RS.ValidValue { Label = "Account Manager", Value = "Account Manager" });
                    break;
            }

            return typesValidValues;
        }

        #endregion

        #region Value parameter

        public static RS.ItemParameter CreateValueParameter(string valueType, IEnumerable<RS.ValidValue> valuesList, string defaultValue)
        {
            var valueParameter = new RS.ItemParameter
            {
                Prompt = FormatParameterTitle(valueType),
                Name = "Value",
                ValidValues = valuesList.ToArray(),
                Dependencies = new string[] { "Type" },
                DefaultValues = new string[] { defaultValue }
            };

            return valueParameter;
        }

        public static IEnumerable<RS.ValidValue> GetValuesList(string systemName, string valueType)
        {
            var values = new List<RS.ValidValue>();
            values.Add(new RS.ValidValue { Label = "All", Value = "All" });

            if (!string.IsNullOrEmpty(systemName) && !string.IsNullOrEmpty(valueType) && !valueType.Contains("Select ..."))
            {
                var repo = new PortfolioReportRepository();
                SystemValueType valueTypeEnum;
                if (ParseParameterNameToEnumValue(valueType, out valueTypeEnum))
                {
                    var valuesList = repo.GetSystemValues(systemName, valueTypeEnum);
                    var numericValueList = new List<int>();
                    if (valuesList != null)
                    {
                        //sort and add the numeric values
                        valuesList.Where(g => !g.Equals("Miscellaneous", StringComparison.InvariantCultureIgnoreCase))
                             .Where(g => { double numeric; return double.TryParse(g, out numeric); })
                             .Select(g => double.Parse(g))
                             .OrderBy(g => g)             
                             .ForEach(g => values.Add(new RS.ValidValue { Label = g.ToString(), Value = g.ToString() }));
                        
                        //add the non numeric values
                        valuesList.Where(g => !g.Equals("Miscellaneous", StringComparison.InvariantCultureIgnoreCase))
                                  .Where(g => { double numeric; return !double.TryParse(g, out numeric); })
                                  .ForEach(g => values.Add(new RS.ValidValue { Label = g.ToString(), Value = g.ToString() }));
                                  
                        // put Miscellaneous at the end
                        valuesList.Where(g => g.Equals("Miscellaneous", StringComparison.InvariantCultureIgnoreCase))
                              .ForEach(g => values.Add(new RS.ValidValue { Label = g, Value = g }));
                    }
                }
            }

            //if (valueType.Equals("Portfolio", StringComparison.OrdinalIgnoreCase))
            //{
            //    values.Add(new RS.ValidValue { Label = "Hotel", Value = "Hotel" });
            //}
            //else if (valueType.Equals("Agency", StringComparison.OrdinalIgnoreCase))
            //{
            //    values.Add(new RS.ValidValue { Label = "Health & Other", Value = "Health & Other" });
            //    values.Add(new RS.ValidValue { Label = "Police & Fire", Value = "Police & Fire" });
            //}

            return values;
        }

        #endregion

        #region Subvalue parameter

        public static RS.ItemParameter CreateSubValueParameter(string valueType, IEnumerable<RS.ValidValue> subValuesList, string defaultValue)
        {
            var subValueParameter = new RS.ItemParameter
            {
                Prompt = GetSubValueTypeName(valueType),
                Name = "SubValue",
                ValidValues = subValuesList.ToArray(),
                Dependencies = new string[] { "Value" },
                DefaultValues = new string[] { defaultValue }
            };

            return subValueParameter;
        }

        private static string GetSubValueTypeName(string valueType)
        {
            string subValueType = "";
            SystemValueType valueTypeEnum;
            if (ParseParameterNameToEnumValue(valueType, out valueTypeEnum))
            {
                switch (valueTypeEnum)
                {
                    case SystemValueType.Group:
                        subValueType = "Team";
                        break;
                    case SystemValueType.Agency:
                        subValueType = "Subcategory";
                        break;
                    case SystemValueType.Portfolio:
                        subValueType = "EMPL size";
                        break;
                    case SystemValueType.AccountManager:
                        subValueType = "EMPL size";
                        break;
                    //case "Employer_size":
                    //    subValueType = "EMPL Size";
                    //    break;
                    default:
                        subValueType = "SubValue";
                        break;
                }
            }

            return subValueType;
        }

        public static IEnumerable<RS.ValidValue> GetSubValuesList(string systemName, string value, string valueType)
        {
            var values = new List<RS.ValidValue>();
            //values.Add(new RS.ValidValue { Label = "Select ...", Value = "Select ..." });
            values.Add(new RS.ValidValue { Label = "All", Value = "All" });

            if (!string.IsNullOrEmpty(systemName) && !string.IsNullOrEmpty(value) && !string.IsNullOrEmpty(valueType) && !value.Contains("Select ..."))
            {
                var repo = new PortfolioReportRepository();
                SystemValueType valueTypeEnum;
                if (ParseParameterNameToEnumValue(valueType, out valueTypeEnum))
                {
                    var subValuesList = repo.GetSystemSubValues(systemName, value, valueTypeEnum);
                    if (subValuesList != null)
                    {
                        subValuesList.Where(g => !g.Equals("Miscellaneous", StringComparison.InvariantCultureIgnoreCase))
                                     .ForEach(g => values.Add(new RS.ValidValue { Label = g, Value = g }));
                        // put Miscellaneous at the end
                        subValuesList.Where(g => g.Equals("Miscellaneous", StringComparison.InvariantCultureIgnoreCase))
                                     .ForEach(g => values.Add(new RS.ValidValue { Label = g, Value = g }));
                    }
                }
            }

            return values;
        }

        #endregion

        #region Claim officer parameter

        public static RS.ItemParameter CreateClaimOfficerParameter(IEnumerable<RS.ValidValue> claimOfficersList, string defaultValue)
        {
            var claimOfficerParameter = new RS.ItemParameter
            {
                Prompt = "Claim officer",
                Name = "Claim_Officer",
                ValidValues = claimOfficersList.ToArray(),
                Dependencies = new string[] { "SubValue" },
                DefaultValues = new string[] { defaultValue }
            };

            return claimOfficerParameter;
        }

        public static IEnumerable<RS.ValidValue> GetClaimOfficers(string team)
        {
            var values = new List<RS.ValidValue>();
            values.Add(new RS.ValidValue { Label = "Select ...", Value = "Select ..." });

            if (!string.IsNullOrEmpty(team) && !team.Contains("Select ..."))
            {
                var repo = new PortfolioReportRepository();

                var claimOfficers = repo.GetClaimOfficers(team);
                if (claimOfficers != null)
                    claimOfficers.ForEach(g => values.Add(new RS.ValidValue { Label = g, Value = g }));
            }

            return values;
        }

        #endregion

        #region Claim liability indicator parameter

        public static RS.ItemParameter CreateClaimLiabilityIndicatorParameter(IEnumerable<RS.ValidValue> cliamLiabilityIndicatorsList, string defaultValue)
        {
            var claimLiabilityIndicatorParameter = new RS.ItemParameter
            {
                Prompt = "Claim liability indicator",
                Name = "Claim_Liability_Indicator",
                ValidValues = cliamLiabilityIndicatorsList.ToArray(),
                Dependencies = new string[] { "System" },
                DefaultValues = new string[] { defaultValue }
            };

            return claimLiabilityIndicatorParameter;
        }

        public static IEnumerable<RS.ValidValue> GetClaimLiabilityIndicators(string systemName)
        {
            var values = new List<RS.ValidValue>();
            values.Add(new RS.ValidValue { Label = "All", Value = "All" });

            if (!string.IsNullOrEmpty(systemName))
            {
                var repo = new PortfolioReportRepository();

                var cliamLiabilityIndicators = repo.GetClaimLiabilityIndicators(systemName);
                if (cliamLiabilityIndicators != null)
                {
                    cliamLiabilityIndicators.ForEach(g => values.Add(new RS.ValidValue { Label = g, Value = g }));
                }
            }

            return values;
        }

        #endregion

        #region Other parameters

        public static void AddStartDateEndDateParameters(List<RS.ItemParameter> parameters, string startDate, string endDate)
        {
            if (string.IsNullOrEmpty(endDate))
            {
                var tempEndDate = DateTime.Now.AddDays(-1);
                var tempStartDate = tempEndDate.AddDays(-14);

                endDate = tempEndDate.ToString("dd/MM/yyyy");
                startDate = tempStartDate.ToString("dd/MM/yyyy");
            }

            parameters.Add(new RS.ItemParameter
            {
                Prompt = "Start date",
                Name = "Start_Date",
                ParameterTypeName = "DateTime",
                DefaultValues = new string[] { startDate }
            });
            parameters.Add(new RS.ItemParameter
            {
                Prompt = "End date",
                Name = "End_Date",
                ParameterTypeName = "DateTime",
                DefaultValues = new string[] { endDate }
            });
        }

        public static void AddYesNoParameter(string paramLabel, string paramName, List<RS.ItemParameter> parameters, string defaultValue)
        {
            var values = new List<RS.ValidValue>() 
            {
                new RS.ValidValue { Label = "All", Value = "All" },
                new RS.ValidValue { Label = "Yes", Value = "Yes" },
                new RS.ValidValue { Label = "No", Value = "No" },               
            };

            parameters.Add(new RS.ItemParameter
            {
                Prompt = paramLabel,
                Name = paramName,
                ValidValues = values.ToArray(),
                DefaultValues = new string[] { defaultValue }
            });
        }

        #endregion

        #region Helpers

        public static Dictionary<string, string> ParseReportParameterDataToDictionary(string reportParameterData)
        {
            var parameterDictionary = new Dictionary<string, string>();
            if (!string.IsNullOrEmpty(reportParameterData))
            {
                foreach (var param in reportParameterData.Split(';'))
                {
                    string[] text = param.Split('|');
                    string name = text[0];
                    string[] values = text.Length > 1 ? text[1].Split(',') : new string[] { };
                    foreach (string s in values)
                    {
                        if (!string.IsNullOrEmpty(name))
                        {
                            parameterDictionary.Add(name, s);
                        }
                    }
                }
            }

            return parameterDictionary;
        }

        private static string FormatParameterTitle(string paramName)
        {
            var result = "";

            if (!paramName.IsNullOrEmpty())
            {
                result = UppercaseFirstLetter(paramName.ToLower()).Replace('_', ' ');
            }

            return result;
        }

        private static bool ParseParameterNameToEnumValue(string paramName, out SystemValueType paramNameEnum)
        {
            if (Enum.TryParse(paramName.Replace(" ", string.Empty).Replace("_", string.Empty), true, out paramNameEnum))
                return true;

            return false;
        }

        private static string UppercaseFirstLetter(string s)
        {
            if (string.IsNullOrEmpty(s))
            {
                return string.Empty;
            }

            return char.ToUpper(s[0]) + s.Substring(1);
        }

        #endregion       
    }
}