using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EM_Report.Domain;
using System.Globalization;

namespace EM_Report.Service.Helpers
{
    public class ProjectionDataHelper
    {
        private static string[] PROJECTION_TYPE_DOMAIN_VALUES = new string[] {
            "1-2", "3-5", "5-plus", "Whole-TMF", "TMF", "Whole-EML", "EML", "Whole-HEM", "HEM" };

        public static IEnumerable<Dashboard_Projection> Process(string csvFilePath)
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
                modelList = UpdateModel(csvResults);
            }

            return modelList;
        }

        private static List<Dashboard_Projection> UpdateModel(List<ExcelResult> excelResults)
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
                    if (double.TryParse(projectionValue.Value.ToString(), NumberStyles.Float, CultureInfo.InvariantCulture, out _projection))
                    {                       
                        projection.Projection = _projection;
                    }
                    
                }            

                projectionList.Add(projection);
            }

            return projectionList;
        }
    }
}
