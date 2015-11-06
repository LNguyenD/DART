using Microsoft.SqlServer.ReportingServices2010;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.Services.Protocols;

namespace Lib
{
    public class SSRSDeployHelper
    {
        private ReportingServiceProxy rs;

        private byte[] _definition;
        private byte[] _byteDefinition;
        private Warning[] _warnings;

        string _serverPath = "http://10.9.0.26/ReportServer/ReportService2010.asmx";
        string _username = "admin";
        string _password = "pa$$w0rd";
        string _connectionString = "Data Source=10.9.0.21;Initial Catalog=Dart;Persist Security Info=True;User ID=vnteam;Password=vnteam";
        string _parentFolderPath = "/EMReporting";
        string _reportFolderName = "Reports";
        string _reportFolderPath
        {
            get
            {
                return _parentFolderPath + "/" + _reportFolderName;
            }
        }

        string _datasetFolderName = "Dataset";
        string _datasetFolderPath
        {
            get
            {
                return _parentFolderPath + "/" + _datasetFolderName;
            }
        }

        string _dataSourceFolderName = "Data Sources";
        string _dataSourceFolderPath
        {
            get
            {
                return _parentFolderPath + "/" + _dataSourceFolderName;
            }
        }

        string _reportName = ""; // for specific report
        string _reportFilePath = @".\Reports";

        public SSRSDeployHelper(string serverPath, string username, string password, string connectionString, string parentFolderPath, string reportFolder, string dataSetFolder, string dataSourceFolder, string reportName, string reportFilePath)
        {
            _serverPath = serverPath;
            _username = username;
            _password = password;
            _connectionString = connectionString;
            _parentFolderPath = parentFolderPath;
            _reportFolderName = reportFolder;
            _datasetFolderName = dataSetFolder;
            _dataSourceFolderName = dataSourceFolder;
            _dataSourceFolderName = dataSourceFolder;
            _reportFilePath = reportFilePath;

            rs = new ReportingServiceProxy();
            rs.Url = _serverPath;
            rs.LogonUser(_username, EncryptionHelper.Encrypt(_password), EncryptionHelper.Encrypt(_connectionString));
        }

        public void Deploy()
        {
            try
            {
                //try
                //{
                    //rs.DeleteItem(_reportFolderPath);
                    //rs.DeleteItem(_datasetFolderPath);
                    //rs.DeleteItem(_dataSourceFolderPath);
                //}
                //catch (Exception ex)
                //{
                    //Console.WriteLine("Folder does not exist");
                //}

                //Create the shared data source
                CreateFolders(_dataSourceFolderName, _parentFolderPath, "Data Sources", "Visible");

                //Create the folder that will contain the shared data sets
                CreateFolders(_datasetFolderName, _parentFolderPath, "Data Set Folder", "Visible");

                //Create the folder that will contain the deployed reports
                CreateFolders(_reportFolderName, _parentFolderPath, "Report Folder", "Visible");

                ReadFiles(_reportFilePath, "*.rds");
                ReadFiles(_reportFilePath, "*.rsd");
                ReadFiles(_reportFilePath, "*.rdl");
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

        public void CreateFolders(string folderName, string parentPath, string description, string visible)
        {
            Console.WriteLine();
            Console.WriteLine("Checking for Target Folders");

            var descriptionProp = new Property { Name = "Description", Value = description };
            var visibleProp = new Property { Name = "Visible", Value = visible };

            var props = new Property[] { descriptionProp, visibleProp };

            try
            {
                rs.CreateFolder(folderName, parentPath, props);

                Console.WriteLine("Folder {0} successfully created", folderName);
            }
            catch (SoapException ex)
            {
                if (ex.Message.IndexOf("AlreadyExists") > 0)
                {
                    Console.WriteLine("Folder {0} already exists", folderName);
                }
            }
        }

        public void ReadFiles(string filePath, string fileExtension)
        {
            Console.WriteLine();

            Console.WriteLine("Reading Files from Report Services Project");

            var rptdirinfo = new DirectoryInfo(filePath);

            var filedoc = rptdirinfo.GetFiles(fileExtension);
            try
            {
                foreach (var file in filedoc)
                {
                    if (!file.Name.Trim().ToUpper().Contains("BACKUP"))
                    {
                        switch (fileExtension)
                        {
                            case "*.rds":
                                CreateDataSource(file.ToString().Trim());
                                break;
                            case "*.rsd":
                                CreateDataSet(file.ToString().Trim());
                                break;
                            case "*.rdl":
                                PublishReport(file.ToString().Trim());
                                break;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("In ReadFiles " + ex.Message);
            }
        }

        public void CreateDataSet(string fileName)
        {
            int valstart;
            int valend;
            string DSDefinitionStr = "";
            string DataSourceName = "";

            try
            {
                var stream = File.OpenRead(_reportFilePath + '\\' + fileName);
                _definition = new Byte[stream.Length];
                stream.Read(_definition, 0, (int)stream.Length);
                stream.Close();

                for (int i = 0; i < _definition.Length - 1; i++)
                {
                    DSDefinitionStr = DSDefinitionStr + Convert.ToString(Convert.ToChar(Convert.ToInt16(_definition[i].ToString())));
                }

                valstart = DSDefinitionStr.ToString().IndexOf("<DataSourceReference>");
                if (valstart > 0)
                {
                    valstart = DSDefinitionStr.ToString().IndexOf("<DataSourceReference>") + 21;
                    valend = DSDefinitionStr.ToString().IndexOf("</DataSourceReference>");
                    DataSourceName = DSDefinitionStr.ToString().Substring(valstart, valend - valstart);
                    Console.WriteLine(DataSourceName);
                }
            }
            catch (IOException ex)
            {
                Console.WriteLine(ex.Message);
            }

            fileName = fileName.Replace(".rsd", "");

            Console.WriteLine("Attempting to Deploy DataSet {0}", fileName);

            try
            {
                var item = rs.CreateCatalogItem("DataSet", fileName, _datasetFolderPath, true, _definition, null, out _warnings);
                if (_warnings != null)
                {
                    foreach (var warning in _warnings)
                    {
                        if (warning.Message.ToLower().Contains("refers to the shared data source"))
                        {
                            Console.WriteLine("Connecting DataSet {0} to Data Source {1}", fileName, DataSourceName);

                            var referenceData = rs.GetItemReferences(_datasetFolderPath + "/" + fileName, "DataSet");
                            var reference = new ItemReference();
                            var datasourceURL = _dataSourceFolderPath + "/" + DataSourceName;
                            reference.Name = referenceData[0].Name;
                            Console.WriteLine("Reference name = " + reference.Name);
                            reference.Reference = datasourceURL;
                            var references = new ItemReference[] { reference };
                            rs.SetItemReferences(_datasetFolderPath + "/" + fileName, references);
                        }
                        else
                        {
                            Console.WriteLine(warning.Message);

                        }

                    }
                }
                else
                    Console.WriteLine("DataSet: {0} published successfully with no warnings", fileName);

            }

            catch (SoapException ex)
            {
                if (ex.Message.IndexOf("AlreadyExists") > 0)
                {
                    Console.WriteLine("The DataSet {0} already exists", fileName);
                }
                else
                {
                    if (ex.Message.IndexOf("published") == -1)
                    {
                        Console.WriteLine(ex.Message);
                    }
                }

                //UpdateDataSetSources(filename,DataSetFolder, DataSourceFolder,DataSourceName)

            }
        }

        public void CreateDataSource(string filename)
        {
            //Define the data source definition.

            var dsDefinition = new DataSourceDefinition();
            var DataSourceName = "";
            int valstart;
            int valend;
            var ConnectionString = "";
            var Extension = "";
            var IntegratedSec = "";
            var DataSourceID = "";
            var PromptStr = "";
            PromptStr = "";
            var DSDefinitionStr = "";
            DSDefinitionStr = "";
            DataSourceName = filename.Trim().Substring(0, filename.Trim().Length - 4);

            Console.WriteLine("Attempting to Deploy Data Source {0}", DataSourceName);

            try
            {
                var stream = File.OpenRead(_reportFilePath + "\\" + filename);
                _byteDefinition = new Byte[stream.Length];
                stream.Read(_byteDefinition, 0, (int)stream.Length);
                stream.Close();

                for (int i = 0; i < _byteDefinition.Length - 1; i++)
                {
                    DSDefinitionStr = DSDefinitionStr + Convert.ToString(Convert.ToChar(Convert.ToInt16(_byteDefinition[i].ToString())));
                }
            }
            catch (IOException ex)
            {
                Console.WriteLine(ex.Message);
            }

            if (DSDefinitionStr.Contains("<ConnectString>") && DSDefinitionStr.Contains("</ConnectString>"))
            {
                valstart = DSDefinitionStr.IndexOf("<ConnectString>") + 15;
                valend = DSDefinitionStr.IndexOf("</ConnectString>");
                ConnectionString = DSDefinitionStr.Substring(valstart, valend - valstart);
            }

            if (DSDefinitionStr.Contains("<Extension>") && DSDefinitionStr.Contains("</Extension>"))
            {
                valstart = DSDefinitionStr.IndexOf("<Extension>") + 11;
                valend = DSDefinitionStr.IndexOf("</Extension>");
                Extension = DSDefinitionStr.Substring(valstart, valend - valstart);

            }

            if (DSDefinitionStr.Contains("<IntegratedSecurity>") && DSDefinitionStr.Contains("</IntegratedSecurity>"))
            {
                valstart = DSDefinitionStr.IndexOf("<IntegratedSecurity>") + 20;
                valend = DSDefinitionStr.IndexOf("</IntegratedSecurity>");
                IntegratedSec = DSDefinitionStr.Substring(valstart, valend - valstart);
            }

            if (DSDefinitionStr.Contains("<DataSourceID>") && DSDefinitionStr.Contains("</DataSourceID>"))
            {
                valstart = DSDefinitionStr.IndexOf("<DataSourceID>") + 14;
                valend = DSDefinitionStr.IndexOf("</DataSourceID>");
                DataSourceID = DSDefinitionStr.Substring(valstart, valend - valstart);
            }

            if (DSDefinitionStr.Contains("<Prompt>") && DSDefinitionStr.Contains("</Prompt>"))
            {
                valstart = DSDefinitionStr.IndexOf("<Prompt>") + 8;
                valend = DSDefinitionStr.IndexOf("</Prompt>");
                PromptStr = DSDefinitionStr.Substring(valstart, valend - valstart);
            }

            dsDefinition.CredentialRetrieval = CredentialRetrievalEnum.None;
            dsDefinition.ConnectString = ConnectionString;
            dsDefinition.Enabled = true;
            dsDefinition.EnabledSpecified = true;
            dsDefinition.Extension = Extension;
            dsDefinition.ImpersonateUser = false;
            dsDefinition.ImpersonateUserSpecified = true;

            //Use the default prompt string.

            if (PromptStr.Length == 0)
            {
                dsDefinition.Prompt = null;
            }
            else
            {
                dsDefinition.Prompt = PromptStr;
            }

            dsDefinition.WindowsCredentials = false;

            try
            {
                rs.CreateDataSource(DataSourceName, _dataSourceFolderPath, false, dsDefinition, null);
                Console.WriteLine("Data source {0} created successfully", DataSourceName);
            }
            catch (SoapException ex)
            {
                if (ex.Message.IndexOf("AlreadyExists") > 0)
                {
                    Console.WriteLine("The Data Source name {0} already exists", DataSourceName);
                }
            }

        }

        public void PublishReport(string reportName)
        {
            try
            {
                var stream = File.OpenRead(_reportFilePath + "\\" + reportName);
                _definition = new Byte[stream.Length];
                stream.Read(_definition, 0, (int)stream.Length);
                stream.Close();
            }
            catch (IOException ex)
            {
                Console.WriteLine(ex.Message);
            }

            reportName = reportName.Replace(".rdl", "");

            Console.WriteLine("Attempting to Deploy Report Name {0}", reportName);

            CatalogItem item;

            try
            {
                item = rs.CreateCatalogItem("Report", reportName, _reportFolderPath, true, _definition, null, out _warnings);

                //warnings = rs.CreateCatalogItem(reportName, "/" + ReportFolder, False, definition, Nothing)

                if (_warnings != null)
                {
                    if (item.Name != "")
                    {
                        Console.WriteLine("Report: {0} published successfully with warnings", reportName);
                        UpdateDataSources_report(reportName);
                        UpdateDataSet_report(reportName);
                    }
                    else
                    {
                        foreach (var warning in _warnings)
                        {
                            Console.WriteLine(warning.Message);
                        }
                    }
                }
                else
                {
                    Console.WriteLine("Report: {0} published successfully with no warnings", reportName);
                    UpdateDataSources_report(reportName);
                    UpdateDataSet_report(reportName);
                }
            }
            catch (SoapException ex)
            {
                if (ex.Message.IndexOf("AlreadyExists") > 0)
                {
                    Console.WriteLine("The Report Name {0} already exists", reportName);
                }
                else
                {
                    if (ex.Message.IndexOf("published") == -1)
                    {
                        Console.WriteLine(ex.Message);
                    }

                }

            }

        }

        public void UpdateDataSources(string ReportFolder, string DataSourcePath)
        {
            rs.Credentials = System.Net.CredentialCache.DefaultCredentials;

            var items = new CatalogItem[] { };
            try
            {
                items = rs.ListChildren("/" + ReportFolder, false);

                foreach (var item in items)
                {
                    //Console.WriteLine("          update date source called     --------"+ item.Path + " -----------")

                    if (item.Path.IndexOf("rdl") > 0 && _reportName == "")
                    {
                        //Console.WriteLine("          update date source called     --------"+ item.path.Indexof("rdl").tostring() + " -----------")

                        var dataSources = rs.GetItemDataSources(item.Path);

                        foreach (var ds in dataSources)
                        {
                            var sharedDs = GetDataSource(DataSourcePath, ds.Name);

                            rs.SetItemDataSources(item.Path, new DataSource[] { sharedDs });

                            Console.WriteLine("Set " + ds.Name + " datasource for " + item.Path + " report");
                        }

                    }
                }

                if (_reportName == "")
                {
                    Console.WriteLine("Shared data source reference set for reports in the {0} folder.", ReportFolder);
                }


                if (_reportName != "")
                {
                    //	Console.WriteLine("               " + "/" + ReportFolder + "/" + ReportName + "  -------------      second  update called        ---------------------- ")

                    var dataSources = rs.GetItemDataSources("/" + ReportFolder + "/" + _reportName);

                    foreach (var ds in dataSources)
                    {
                        var sharedDs = GetDataSource(DataSourcePath, ds.Name);

                        rs.SetItemDataSources(_reportFolderPath + "/" + _reportName, new DataSource[] { sharedDs });

                        Console.WriteLine("Set " + ds.Name + " datasource for " + "/" + ReportFolder + "/" + _reportName + " report");
                    }

                    Console.WriteLine("All the shared data source reference set for report {0} ", "/" + ReportFolder + "/" + _reportName);

                }
            }
            catch (SoapException ex)
            {
                Console.WriteLine(ex.Detail.InnerXml);

            }

        }

        public void UpdateDataSources_report(string ReportName)
        {
            rs.Credentials = System.Net.CredentialCache.DefaultCredentials;

            try
            {
                //If ReportName <> "" then

                //	Console.WriteLine("               " + "/" + ReportFolder + "/" + ReportName + "  -------------      second  update called        ---------------------- ")

                var dataSources = rs.GetItemDataSources(_reportFolderPath + "/" + ReportName);

                foreach (var ds in dataSources)
                {
                    var sharedDs = GetDataSource(_dataSourceFolderPath, ds.Name);

                    rs.SetItemDataSources(_reportFolderPath + "/" + ReportName, new DataSource[]{ sharedDs });

                    Console.WriteLine("Set " + ds.Name + " datasource for " + _reportFolderPath + "/" + ReportName + " report");
                }

                Console.WriteLine("All the shared data source reference set for report {0} ", _reportFolderPath + "/" + ReportName);

            }
            catch (SoapException ex)
            {
                Console.WriteLine(ex.Detail.InnerXml);
            }
        }

        public void UpdateDataSet_report(string ReportName)
        {
            rs.Credentials = System.Net.CredentialCache.DefaultCredentials;

            try
            {
                var reportDefinitionHelper = new ReportDefinitionHelper(_reportFilePath + "\\" + ReportName + ".rdl");
                var dataSets = reportDefinitionHelper.GetSharedDataset();
                //Dim dataSets As ItemReferenceData() = rs.GetItemReferences("/" + varReportFolder + "/" + ReportName, "DataSet")

                if (dataSets != null && dataSets.Count > 0 && !String.IsNullOrEmpty(dataSets[0].Name))
                {
                    for (int i = 0; i < dataSets.Count; i++)
                    {
                        var sharedDataSet = new ItemReference();
                        sharedDataSet.Name = dataSets[i].Name;
                        Console.WriteLine("Attempting to Link Dataset {0}", dataSets[i].Name);
                        sharedDataSet.Reference = _datasetFolderPath + "/" + dataSets[i].Reference;
                        var references = new ItemReference[] { sharedDataSet };
                        rs.SetItemReferences(_reportFolderPath + "/" + ReportName, references);
                        Console.WriteLine("Report " + ReportName + " Linked to data set " + _datasetFolderPath + "/" + Convert.ToString(sharedDataSet.Name));
                    }
                }
            }
            catch (SoapException ex)
            {
                Console.WriteLine(ex.Detail.InnerXml);
            }
        }

        public DataSource GetDataSource(string sharedDataSourcePath, string dataSourceName)
        {
            var reference = new DataSourceReference();

            var ds = new DataSource();

            reference.Reference = sharedDataSourcePath + "/" + dataSourceName;

            ds.Item = (DataSourceDefinitionOrReference)reference;

            ds.Name = dataSourceName;

            Console.WriteLine("Attempting to Link Data Source {0}", ds.Name);

            return ds;

        }
    }
}
