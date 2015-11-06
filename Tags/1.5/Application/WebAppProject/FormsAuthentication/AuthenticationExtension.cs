#region Copyright © Microsoft Corporation. All rights reserved.
/*============================================================================
  File:      AuthenticationExtension.cs

  Summary:  Demonstrates an implementation of an authentication 
            extension.
--------------------------------------------------------------------
  This file is part of Microsoft SQL Server Code Samples.
    
 This source code is intended only as a supplement to Microsoft
 Development Tools and/or on-line documentation. See these other
 materials for detailed information regarding Microsoft code 
 samples.

 THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
 ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
 THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
 PARTICULAR PURPOSE.
===========================================================================*/
#endregion

using System;
using System.Data;
using System.Data.SqlClient;
using System.Reflection;
using System.Security.Principal;
using System.Web;
using Microsoft.ReportingServices.Interfaces;
using System.Globalization;
using System.Xml;
using System.IO;
using System.Collections;

namespace Microsoft.Samples.ReportingServices.CustomSecurity
{
    public class AuthenticationExtension : IAuthenticationExtension
    {
        private static string _StrConnectionString = "";

        public static string StrConnectionString
        {
            get
            {
                if (string.IsNullOrEmpty(_StrConnectionString))
                    return GetDynamicConnectionString();
                else
                    return _StrConnectionString;
            }
            set
            {
                _StrConnectionString = value;
            }
        }

        public static string GetDynamicConnectionString()
        {
            string connName = "DartConnectionString";

            string assemblyFolder = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            string[] splitItems = assemblyFolder.Split(Path.DirectorySeparatorChar);
            string newPath = string.Empty;

            for (int i = 0; i < splitItems.Length; i++)
            {
                if (splitItems[i] == "Reporting Services")
                {
                    for (int j = 0; j <= i; j++)
                        newPath = newPath + Path.DirectorySeparatorChar + splitItems[j];
                }
            }
            newPath = newPath.TrimStart(Path.DirectorySeparatorChar);
            newPath = newPath + Path.DirectorySeparatorChar + "ReportServer" + Path.DirectorySeparatorChar;

            XmlDocument doc = new XmlDocument();           
            doc.Load(newPath + "web.config");                    

            //if (string.IsNullOrEmpty(authority))
            //{
            //    authority = "EML";
            //}
            //switch (authority)
            //{
            //    case "EML":
            //        connName = "EM_ReportConnectionString";
            //        break;
            //    case "HEM":
            //        connName = "HEM_ReportConnectionString";
            //        break;
            //    case "TMF":
            //        connName = "TMF_ReportConnectionString";
            //        break;
            //}


            if (doc.DocumentElement.Name == "configuration")
            {
                foreach (XmlNode child in doc.DocumentElement.ChildNodes)
                {
                    if (child.Name == "connectionStrings")
                    {
                        foreach (XmlNode subChild in child.ChildNodes)
                        {
                            if (subChild.Name == "add")
                            {
                                if (subChild.Attributes["name"].Value == connName)
                                {
                                    return subChild.Attributes["connectionString"].Value;
                                }
                            }

                        }
                    }
                }
            }
            return "";
        }
        /// <summary>
        /// You must implement SetConfiguration as required by IExtension
        /// </summary>
        /// <param name="configuration">Configuration data as an XML
        /// string that is stored along with the Extension element in
        /// the configuration file.</param>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security",
            "CA2123:OverrideLinkDemandsShouldBeIdenticalToBase")]
        public void SetConfiguration(String configuration)
        {
            // No configuration data is needed for this extension
        }

        /// <summary>
        /// You must implement LocalizedName as required by IExtension
        /// </summary>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security",
            "CA2123:OverrideLinkDemandsShouldBeIdenticalToBase")]
        public string LocalizedName
        {
            get
            {
                return null;
            }
        }

        /// <summary>
        /// Indicates whether a supplied username and password are valid.
        /// </summary>
        /// <param name="userName">The supplied username</param>
        /// <param name="password">The supplied password</param>
        /// <param name="authority">Optional. The specific authority to use to
        /// authenticate a user. For example, in Windows it would be a Windows 
        /// Domain</param>
        /// <returns>true when the username and password are valid</returns>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security",
            "CA2123:OverrideLinkDemandsShouldBeIdenticalToBase")]
        public bool LogonUser(string userName, string password, string authority)
        {
            EnCryption.EncryptConnectionStrings();

            var checkSystemUser = bool.Parse(authority);
            StrConnectionString = EnCryption.Decrypt(GetDynamicConnectionString());

            //if (string.IsNullOrEmpty(authority) || authority.Length <= 3)
            //{
            //    StrConnectionString = EnCryption.Decrypt(GetDynamicConnectionString(authority));
            //}
            //else
            //{
            //    StrConnectionString = EnCryption.Decrypt(authority);
            //}

            return AuthenticationUtilities.VerifyPassword(userName, password, StrConnectionString, checkSystemUser);
        }      

        /// <summary>
        /// Required by IAuthenticationExtension. The report server calls the 
        /// GetUserInfo methodfor each request to retrieve the current user 
        /// identity.
        /// </summary>
        /// <param name="userIdentity">represents the identity of the current 
        /// user. The value of IIdentity may appear in a user interface and 
        /// should be human readable</param>
        /// <param name="userId">represents a pointer to a unique user identity
        /// </param>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security",
            "CA2123:OverrideLinkDemandsShouldBeIdenticalToBase")]
        public void GetUserInfo(out IIdentity userIdentity, out IntPtr userId)
        {
            // If the current user identity is not null,
            // set the userIdentity parameter to that of the current user 
            if (HttpContext.Current != null && HttpContext.Current.User != null)
            {
                userIdentity = HttpContext.Current.User.Identity;
            }
            else
                // The current user identity is null. This happens when the user attempts an anonymous logon.
                // Although it is ok to return userIdentity as a null reference, it is best to throw an appropriate
                // exception for debugging purposes.
                // To configure for anonymous logon, return a Gener
            {
                System.Diagnostics.Debug.Assert(
                    false, "Warning: userIdentity is null! Modify your code if you wish to support anonymous logon.");
                throw new NullReferenceException("Anonymous logon is not configured. userIdentity should not be null!");
            }

            // initialize a pointer to the current user id to zero
            userId = IntPtr.Zero;
        }

        /// <summary>
        /// The IsValidPrincipalName method is called by the report server when 
        /// the report server sets security on an item. This method validates 
        /// that the user name is valid for Windows.The principal name needs to 
        /// be a user, group, or builtin account name.
        /// </summary>
        /// <param name="principalName">A user, group, or built-in account name
        /// </param>
        /// <returns>true when the principle name is valid</returns>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security",
            "CA2123:OverrideLinkDemandsShouldBeIdenticalToBase")]
        public bool IsValidPrincipalName(string principalName)
        {
            return VerifyUser(principalName);
        }

        // 
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2201:DoNotRaiseReservedExceptionTypes")]
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Reliability",
            "CA2000:DisposeObjectsBeforeLosingScope")]
        public static bool VerifyUser(string userName)
        {
            bool isValid = false;
            string connStr = StrConnectionString;
            using (SqlConnection conn =
                    new SqlConnection(
                        connStr))
            {
                SqlCommand command = new SqlCommand("PRO_GetUser", conn);
                command.CommandType = CommandType.StoredProcedure;

                SqlParameter sqlParam = null;
                sqlParam = command.Parameters.Add("@UserName", SqlDbType.VarChar, 150);
                sqlParam.Value = userName;

                try
                {
                    conn.Open();
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        // If a row exists for the user, then the user is valid.
                        if (reader.Read())
                        {
                            isValid = true;
                        }
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception(
                        string.Format(CultureInfo.InvariantCulture, CustomSecurity.VerifyError + ex.Message));
                }
                finally
                {
                    conn.Close();
                }
            }

            return isValid;
        }
    }
}
