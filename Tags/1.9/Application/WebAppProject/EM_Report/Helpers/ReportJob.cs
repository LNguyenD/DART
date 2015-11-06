using EM_Report.SSRS;
using Microsoft.Reporting.WebForms;
using Quartz;
using Quartz.Impl;
using System;
using System.Net;
using EM_Report.Repositories;
using Microsoft.Samples.ReportingServices.CustomSecurity;
using EM_Report.Helpers;
using EM_Report;
using System.Web;
using System.Data.SqlClient;
using System.Diagnostics;

namespace CronJob
{
    // This function will be called immediately after IIS recycles
    // instead of waiting for first request to trigger normally
    // IIS changes requiered:
    //      <serviceAutoStartProviders>
    //          <add name="PreWarmCache" type="CronJob.PreWarmCache, EM_Report" />
    //      </serviceAutoStartProviders>
    public class PreWarmCache : System.Web.Hosting.IProcessHostPreloadClient
    {
        public void Preload(string[] parameters)
        {
            EM_Report.Helpers.Base.ByPassCertificate();
            JobScheduler.Start();
        }
    }


    // Create scheduler used to trigger LoginPerformanceImprovementJob
    public class JobScheduler
    {
        public static void Start()
        {
            IScheduler scheduler = StdSchedulerFactory.GetDefaultScheduler();
            scheduler.Start();

            IJobDetail job = JobBuilder.Create<LoginPerformanceImprovementJob>()
                .WithIdentity("job1", "group1")
                .Build();

            ITrigger trigger = TriggerBuilder.Create()
                .WithIdentity("trigger1", "group1")
                .StartNow()
                .WithSimpleSchedule(x => x
                    .WithIntervalInMinutes(5)
                    .RepeatForever())
                .Build();

            scheduler.ScheduleJob(job, trigger);
        }
    }   

    public class LoginPerformanceImprovementJob : IJob
    {
        public void Execute(IJobExecutionContext context)
        {
            string userName = "";
            string passWord = "";
            string webUrl = "";
            string rsHostName = Base.GetConfig("ReportServerDomain");
            string loginType = Base.GetConfig("LoginType");
            var UserRepository = new UserRepository();

            

            if (loginType == "External")
            {
                var user = UserRepository.GetUserbyCronJob(false);
                if (user == null)
                    // logging or send email to administrator
                    return;
                else
                {
                    userName = user.Email;
                    passWord = user.Password;
                    webUrl = "https://syddmzweb001/DART/account/login";
                }
            }
            else if (loginType == "Internal")
            {
                var user = UserRepository.GetUserbyCronJob(true);
                if (user == null)
                    // logging or send email to administrator
                    return;
                else
                {
                    userName = user.UserName;
                    passWord = "";
                    webUrl = "https://sydiis001/dart/account/login";
                }
            }

            RunReportJob(userName, passWord, rsHostName, webUrl);
        }

        private static void RunReportJob(string username, string password, string RShostname, string webUrl)
        {
            //string reportPath = "/emreporting/reports/WOW_level1";
            string reportPath = "/emreporting/reports/level0";
            byte[] bytes = null;
            int trys = 3;

            while (trys > 0)
            {
                try
                {
                    string mimeType;
                    string encoding;
                    string extension;
                    string deviceInfo;
                    string[] streamids;
                    Warning[] warnings;

                    // Log into Reporting Server
                    ReportServerProxy server = new ReportServerProxy();
                    server.Url = Base.GetConfig("ReportServerUrl") + Base.GetConfig("ReportServicePath2010");
                    server.LogonUser(username, password, "false");
                    server.Timeout = 3600000;
                    server.AuthCookie.Expires.AddDays(365);

                    // Load Reporting Server's configuation
                    ReportViewer rview = new ReportViewer();
                    rview.Reset();
                    rview.ServerReport.ReportServerCredentials = new ReportViewerCredentials();
                    rview.ServerReport.ReportServerUrl = new Uri(Base.GetConfig("ReportServerUrl"));
                    rview.ServerReport.ReportPath = reportPath;
                    rview.ServerReport.Timeout = 1800000;
                    Cookie authCookie = new Cookie(server.AuthCookie.Name, server.AuthCookie.Value);
                    authCookie.Domain = Base.GetConfig("ReportServerDomain");
                    rview.ServerReport.ReportServerCredentials = new MyReportServerCredentials(authCookie);
                    deviceInfo = "<DeviceInfo><SimplePageHeaders>True</SimplePageHeaders></DeviceInfo>";
                    rview.LocalReport.Refresh();
                    bytes = rview.ServerReport.Render("Excel", deviceInfo, out mimeType, out encoding, out extension, out streamids, out warnings);

                    // Wake up WCF
                    var helper = new HelperRepository();
                    helper.EncryptConnectionStrings();

                    // Wake up Web
                    using (WebClient client = new WebClient())
                    {
                        // Set gzip.
                        client.Headers["Accept-Encoding"] = "gzip";

                        // Download.
                        // ... Do an initial run to prime the cache.
                        client.DownloadString(webUrl);
                        byte[] data = client.DownloadData(webUrl);

                        // Start timing.
                        Stopwatch stopwatch = Stopwatch.StartNew();

                        // Iterate.
                        for (int i = 0; i < Math.Min(100, trys); i++)
                        {
                            data = client.DownloadData(webUrl);
                        }

                        // Stop timing.
                        stopwatch.Stop();

                    }

                    // Complete successfully
                    trys = 0;
                    //sendmail.SendmailCronJob(RShostname, "Run successfully," + username + password + DateTime.Now);
                }
                catch (Exception ex)
                {
                    trys--;
                    if (trys == 0)
                    {
                        // logging or send email to administrator
                        //sendmail.SendmailCronJob(RShostname, "Exception: " + ex.Message + DateTime.Now);
                        return;
                    }
                }
            }
        }
    }
}

public class sendmail
{
    public static void SendmailCronJob(string hostname, string body)
    {
        try
        {
            System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
            message.From = new System.Net.Mail.MailAddress("no-reply@administrator.com");
            message.To.Add("l.nguyend@aswigsolutions.com");
            message.Subject = hostname.ToUpper() + " - Load Report Scheduler";
            message.Body = body;
            message.IsBodyHtml = true;
            System.Net.Mail.SmtpClient mSmtpClient = new System.Net.Mail.SmtpClient("10.9.0.22");
            mSmtpClient.Send(message);
        }
        catch (Exception ex) { }
    }
}