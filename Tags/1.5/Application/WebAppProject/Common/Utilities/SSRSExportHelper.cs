using System;
using System.Collections.Generic;
using System.IO;
using System.Security.AccessControl;
using Microsoft.Reporting.WebForms;
using Ionic.Zip;
namespace EM_Report.Common.Utilities
{
    public class SSRSExportHelper
    {
        public static byte[] GetByteStream(string reportServerUrl, string reportPath, IEnumerable<ReportParameter> reportParameters, string format)
        {
            byte[] bytes = null;
            int trys = 2;
            while (trys > 0)
            {
                try
                {
                    ReportViewer rview = new ReportViewer();
                    rview.ServerReport.ReportServerCredentials = new ReportViewerCredentials();
                    rview.ServerReport.ReportServerUrl = new Uri(reportServerUrl);
                    rview.ServerReport.ReportPath = reportPath;
                    rview.ServerReport.Timeout = 1800000;
                    List<ReportParameter> paramss = new List<ReportParameter>(reportParameters);
                    rview.ServerReport.SetParameters(reportParameters);

                    string mimeType, encoding, extension, deviceInfo;
                    string[] streamids;
                    Warning[] warnings;

                    deviceInfo = "<DeviceInfo><SimplePageHeaders>True</SimplePageHeaders></DeviceInfo>";

                    bytes = rview.ServerReport.Render(format, deviceInfo, out mimeType, out encoding, out extension, out streamids, out warnings);
                    trys = 0;
                }
                catch (Exception ex)
                {
                    trys--;
                    if (trys == 0)
                        throw new Exception("Could not render file", ex);
                }
            }
            return bytes;
        }

        public static void ZipToStream(string zipFileName, string directorToZip, Stream stream)
        {
            ZipFile zip = new ZipFile(zipFileName);
            zip.AddDirectory(directorToZip);
            MemoryStream ms = new MemoryStream();
            // In some cases, saving a zip directly to Response.OutputStream can
            // present problems for the unzipper, especially on Macintosh.
            // To workaround that, you can save to a MemoryStream, then copy to
            // the Response.OutputStream.
            zip.Save(ms);
            ms.Position = 0;
            var b = new byte[1024];
            int n;
            while ((n = ms.Read(b, 0, b.Length)) > 0)
                stream.Write(b, 0, n);
        }

        public static void SaveFile(byte[] outputBytes, string absolutePath, string format)
        {
            FileStream raw  = null;
            try
            {
                raw  = new FileStream(@"" + absolutePath, FileMode.Create, FileAccess.ReadWrite, FileShare.ReadWrite, 9999999);
                raw.Write(outputBytes, 0, outputBytes.Length);
                raw.Close();
                raw.Dispose();
            }
            catch (Exception ex)
            {
                raw.Close();
                raw.Dispose();
                throw new Exception("Could not save file", ex);
            }
            
        }

        public static string ValidateFileName(string fileName)
        {
            var result = fileName;
            char[] unexpectedChar = { '/', '\\', '*', '?', ':', '"', '<', '>', '|' };
            foreach (char c in unexpectedChar)
            {
                result = result.Replace(c, '-');
            }
            return result;
        }

        public static string ValidatePath(string path)
        {
            var result = path;
            char[] unexpectedChar = { '/', '*', '?', ':', '"', '<', '>', '|' };
            foreach (char c in unexpectedChar)
            {
                result = result.Replace(c, '-');
            }
            return result;
        }
        
        // Adds an ACL entry on the specified directory for the specified account.
        public static void AddDirectorySecurity(string FileName, string Account, FileSystemRights Rights, AccessControlType ControlType)
        {
            // Create a new DirectoryInfo object.
            DirectoryInfo dInfo = new DirectoryInfo(FileName);

            // Get a DirectorySecurity object that represents the 
            // current security settings.
            DirectorySecurity dSecurity = dInfo.GetAccessControl();

            // Add the FileSystemAccessRule to the security settings. 
            dSecurity.AddAccessRule(new FileSystemAccessRule(Account,
                                                            Rights,
                                                            ControlType));

            // Set the new access settings.
            dInfo.SetAccessControl(dSecurity);

        }
    }
}