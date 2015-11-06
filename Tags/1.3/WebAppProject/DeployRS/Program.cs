using System.Configuration;
using EM_Report.Models.RS2005;
using CommandLine;
using CommandLine.Text;
using System;
using System.Collections.Generic;

namespace DeployRS
{
    public class Options : CommandLineOptionsBase
    {
        [Option("r", "rs",
                Required = true,
                HelpText = "Input ReportingServer")]
        public string ReportingServer = String.Empty;

        [Option("d", "domain",
                Required = true,
                HelpText = "domain of account to access ReportingServer")]
        public string Domain = String.Empty;

        [Option("u", "username",
                Required = true,
                HelpText = "username of account to access ReportingServer")]
        public string Username = String.Empty;

        [Option("w", "password",
                Required = true,
                HelpText = "password of account to access ReportingServer")]
        public string Password = String.Empty;

        [Option("p", "path",
                Required = true,
                HelpText = "path to Reports Folder on ReportingServer")]
        public string Path = String.Empty;

        [Option("s", "sv",
               Required = false,
               HelpText = "reporting web service")]
        public string ServicePath = "/reportservice2005.asmx";
    }

    class Program
    {
        static void Main(string[] args)
        {
            var options = new Options();
            ICommandLineParser parser = new CommandLineParser();
            if (parser.ParseArguments(args, options))
            {
                try
                {
                    ReportingService2005 _rs = new ReportingService2005();
                    _rs.Url = options.ReportingServer + options.ServicePath;
                    _rs.Credentials = new ReportViewerCredentials(options.Username, options.Password, options.Domain).NetworkCredentials;
                    var reports = _rs.ListChildren(options.Path.TrimEnd('/'), true);
                    foreach (var item in reports)
                    {
                        if (item.Type == ItemTypeEnum.Report)
                        {
                            DataSource[] dataSources = _rs.GetItemDataSources(item.Path);
                            List<DataSource> updateDS = new List<DataSource>();
                            foreach (var ds in dataSources)
                            {
                                if (ds.Item is DataSourceDefinition && !(ds.Item is DataSourceReference))
                                {
                                    DataSourceDefinition dataSource = (DataSourceDefinition)ds.Item;
                                    if (dataSource.CredentialRetrieval == CredentialRetrievalEnum.Prompt)
                                    {
                                        dataSource.UserName = null;
                                        dataSource.Password = null;
                                        dataSource.CredentialRetrieval = CredentialRetrievalEnum.None;
                                        updateDS.Add(ds);
                                    }
                                }
                            }
                            _rs.SetItemDataSources(item.Path, updateDS.ToArray());
                            Console.WriteLine("Set DataSource for:" + item.Path);
                        }
                    }
                    Console.WriteLine("Finished success");
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                }
                Console.WriteLine("Press any key to close the window...");
                Console.Read();
            }
        }
    }
}
