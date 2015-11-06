using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.Office.Interop.Excel;
using System.Text.RegularExpressions;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.IO;

namespace EM_Report.Helpers
{
    public class ExcelHelper
    {
        private static Microsoft.Office.Interop.Excel.Application appExcel;
        private static Workbook newWorkbook = null;
        private static _Worksheet objActiveSheet = null;

        public static List<ExcelResult> GetItems2(string csvFilePath, FieldValue[] fields)
        {
            var excelResults = new List<ExcelResult>();

            if (csvFilePath.Substring(csvFilePath.LastIndexOf('.')).ToLower() == ".csv")
            {
                var masterTable = System.IO.File.ReadAllLines(csvFilePath).Where(s => s.Trim() != string.Empty).ToList();
                if (masterTable.Count > 0)
                {
                    // retrieve header fields
                    var headerFields = masterTable[0].Split(',');

                    for (int i = 1; i < masterTable.Count; i++)
                    {
                        var isRecordValid = true;
                        var fieldValues = new List<FieldValue>();
                        var errorFields = new List<string>();

                        var rowValues = masterTable[i].Split(',');
                        if (rowValues.Length > headerFields.Length)
                        {
                            rowValues = CombineRowItemParts(rowValues);
                        }
                        
                        for (int j = 0; j < headerFields.Length; j++)
                        {
                            var rowHeader = headerFields[j];

                            var foundField = fields.FirstOrDefault(a => a.FieldName.ToLower().Trim() == rowHeader.ToLower().Trim());
                            if (foundField != null)
                            {
                                // try to fetch for all of contents
                                var rowValueAtIndex = rowValues[j];
                                
                                while (rowValueAtIndex.StartsWith("\"") && !rowValueAtIndex.EndsWith("\""))
                                {
                                    i++;
                                    rowValues = masterTable[i].Split(',');
                                    rowValueAtIndex += "<br />" + string.Join(", ", rowValues);
                                }

                                if (rowValueAtIndex.StartsWith("\"") && rowValueAtIndex.EndsWith("\"")
                                    && rowValues.Length < headerFields.Length)
                                {
                                    var rowValueList = rowValues.ToList();
                                    while (rowValueList.Count < headerFields.Length)
                                    {
                                        rowValueList.Insert(0, string.Empty);
                                    }

                                    rowValues = rowValueList.ToArray();
                                }

                                var fieldValue = new FieldValue
                                {
                                    FieldName = rowHeader.ToLower().Trim(),
                                    DataType = foundField.DataType,
                                    Value = rowValueAtIndex,
                                    DomainValues = foundField.DomainValues,
                                    IsRequired = foundField.IsRequired
                                };

                                fieldValues.Add(fieldValue);

                                if (!IsFieldValid(fieldValue))
                                {
                                    errorFields.Add(fieldValue.FieldName);
                                    isRecordValid = false;
                                }
                            }
                        }

                        var excelResult = new ExcelResult();
                        excelResult.IsError = !isRecordValid;
                        excelResult.ErrorFields = errorFields.ToArray();
                        excelResult.Items = fieldValues.ToArray();

                        excelResults.Add(excelResult);
                    }
                }
            }

            return excelResults;
        }

        private static string[] CombineRowItemParts(string[] rowValues)
        {
            var rowValueList = new List<string>();
            var rowValue = string.Empty;

            for (int i = 0; i < rowValues.Length; i++)
            {
                if (rowValues[i].StartsWith("\""))
                {
                    rowValue = rowValues[i];
                }
                else if (rowValue != string.Empty)
                {
                    rowValue += ", " + rowValues[i];
                    if (rowValues[i].EndsWith("\""))
                    {
                        rowValueList.Add(rowValue);
                        rowValue = string.Empty;
                    }
                }
                else
                {
                    rowValueList.Add(rowValues[i]);
                }
            }

            return rowValueList.ToArray();
        }

        // Initialize opening Excel
        public static void Initialize(String path)
        {
            appExcel = new Microsoft.Office.Interop.Excel.Application();

            if (System.IO.File.Exists(path))
            {
                // then go and load this into excel
                newWorkbook = appExcel.Workbooks.Open(path, true, true);
                objActiveSheet = (_Worksheet)appExcel.ActiveWorkbook.ActiveSheet;
            }
            else
            {
                System.Runtime.InteropServices.Marshal.ReleaseComObject(appExcel);
                appExcel = null;
            }
        }

        public static List<ExcelResult> GetItems(FieldValue[] fields)
        {
            var excelResults = new List<ExcelResult>();

            // find start of header
            var cellHeaderStart = FindCellHeaderStart(fields);

            if (cellHeaderStart != null)
            {
                var workingRange = GetWorkingRange(cellHeaderStart);
                object[,] values = (object[,])workingRange.Value2;

                for (int i = 2; i <= values.GetLength(0); i++)
                {
                    var isRecordValid = true;

                    var fieldValues = new List<FieldValue>();
                    for (int j = 1; j <= values.GetLength(1); j++)
                    {
                        var fieldName = values[1, j];
                        var foundField = fields.FirstOrDefault(a => a.FieldName.ToString() == fieldName.ToString());

                        if (foundField != null)
                        {
                            var fieldValue = new FieldValue
                            {
                                FieldName = fieldName.ToString(),
                                DataType = foundField.DataType,
                                Value = values[i, j],
                                DomainValues = foundField.DomainValues,
                                IsRequired = foundField.IsRequired
                            };

                            fieldValues.Add(fieldValue);

                            if (!IsFieldValid(fieldValue))
                            {
                                isRecordValid = false;
                            }
                        }
                    }

                    var excelResult = new ExcelResult();
                    excelResult.IsError = !isRecordValid;
                    excelResult.Items = fieldValues.ToArray();
                    excelResults.Add(excelResult);
                }
            }

            return excelResults;
        }

        static bool IsFieldValid(FieldValue fieldValue)
        {
            if (fieldValue.IsRequired)
            {
                if (fieldValue.Value == null || fieldValue.Value.ToString().Trim() == string.Empty
                    || fieldValue.Value.ToString().Trim().ToUpper() == "NULL")
                {
                    return false;
                }
                else
                {
                    return IsDataValid(fieldValue);
                }
            }
            else
            {
                if (fieldValue.Value == null || fieldValue.Value.ToString().Trim() == string.Empty
                    || fieldValue.Value.ToString().Trim().ToUpper() == "NULL")
                {
                    return true;
                }
                else
                {
                    return IsDataValid(fieldValue);
                }
            }
        }

        static bool IsDataValid(FieldValue fieldValue)
        {
            var isValid = true;
            if (fieldValue.DataType == DataType.Decimal)
            {
                double result = 0;
                if (!double.TryParse(fieldValue.Value.ToString().Trim(), out result))
                {
                    isValid = false;
                }
            }
            else if (fieldValue.DataType == DataType.Integer)
            {
                int result = 0;
                if (!int.TryParse(fieldValue.Value.ToString().Trim(), out result))
                {
                    isValid = false;
                }
            }
            else if (fieldValue.DataType == DataType.Date)
            {
                DateTime result;
                if (!DateTime.TryParse(fieldValue.Value.ToString().Trim(), out result))
                {
                    // try to build the result from year only
                    var year = 0;
                    if (fieldValue.Value.ToString().Length == 4 && int.TryParse(fieldValue.Value.ToString().Trim(), out year))
                    {
                        // adjust
                        fieldValue.Value = fieldValue.Value + "-01-01";
                    }
                    else
                    {
                        isValid = false;
                    }
                }
            }
            else
            {
                // field value is string type: check domain values
                if (fieldValue.DomainValues != null && fieldValue.DomainValues.Length > 0)
                {
                    if (!fieldValue.DomainValues.Contains(fieldValue.Value.ToString().Trim()))
                    {
                        isValid = false;
                    }
                }
            }

            return isValid;
        }

        public static string FindCellHeaderStart(FieldValue[] fields)
        {
            // start to find from A1
            var workingRange = GetWorkingRange("A1");

            var foundRanges = new List<Range>();
            foreach (var field in fields)
            {
                var foundRange = workingRange.Find(field.FieldName, Type.Missing, XlFindLookIn.xlValues,
                    Type.Missing, Type.Missing, XlSearchDirection.xlNext, false, false, Type.Missing);
                if (foundRange != null)
                {
                    foundRanges.Add(foundRange);
                }
            }

            // check validation
            if (foundRanges.Count == fields.Length)
            {
                var isValid = true;
                var minColumn = foundRanges[0].Column;

                var row = foundRanges[0].Row;
                foreach (var range in foundRanges)
                {
                    if (range.Row != row)
                    {
                        isValid = false;
                    }

                    if (range.Column < minColumn)
                    {
                        minColumn = range.Column;
                    }
                }

                if (isValid)
                    return GetColumnName(minColumn) + row;
            }

            return null;
        }

        static string GetColumnName(int index)
        {
            string columnName = objActiveSheet.Columns[index].Address;

            Regex reg = new Regex(@"(\$)(\w*):");
            if (reg.IsMatch(columnName))
            {
                Match match = reg.Match(columnName);
                return match.Groups[2].Value;
            }

            return string.Empty;
        }

        static Range GetWorkingRange(string cellName)
        {
            // get a range to work with
            var range = objActiveSheet.get_Range(cellName, Type.Missing);

            // get the end of values to the right (will stop at the first empty cell)
            range = range.get_End(XlDirection.xlToRight);

            // get the end of values toward the bottom, looking in the last column (will stop at first empty cell)
            range = range.get_End(XlDirection.xlDown);

            // get the address of the bottom, right cell
            string downAddress = range.get_Address(
                false, false, XlReferenceStyle.xlA1,
                Type.Missing, Type.Missing);

            // Get the range
            return objActiveSheet.get_Range(cellName, downAddress);
        }

        // Close excel connection
        public static void Close()
        {
            if (appExcel != null)
            {
                try
                {
                    newWorkbook.Close(false);
                    appExcel.Quit();
                    System.Runtime.InteropServices.Marshal.ReleaseComObject(appExcel);
                    appExcel = null;
                    objActiveSheet = null;
                }
                catch (Exception ex)
                {
                    appExcel = null;
                }
                finally
                {
                    GC.Collect();
                }
            }
        }
    }

    public enum DataType
    {
        String,
        Integer,
        Decimal,
        Date
    }

    public class FieldValue
    {
        public string FieldName { get; set; }

        public object Value { get; set; }

        public DataType DataType { get; set; }

        public string[] DomainValues { get; set; }

        public bool IsRequired { get; set; }
    }

    public class ExcelResult
    {
        public FieldValue[] Items { get; set; }

        public bool IsError { get; set; }

        public string[] ErrorFields { get; set; }
    }
}