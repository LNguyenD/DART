﻿using System.Collections.Generic;
using System.Runtime.Serialization;
using EM_Report.Service.MessageBase;
using EM_Report.Domain;

namespace EM_Report.Service.Messages
{
      [DataContract(Namespace = "http://www.yourcompany.com/types/")]
     public class ReportPermissionResponse : ResponseBase
    {
                                 /// <summary>
        /// Constructor for ReportPermissionResponse
        /// </summary>
        public ReportPermissionResponse() { }        

        /// <summary>
        /// List of Report Permission. 
        /// </summary>
        [DataMember]
        public IList<ReportPermission> ReportPermissions;

        /// <summary>
        /// Single report permission
        /// </summary>
        [DataMember]
        public ReportPermission ReportPermission;
    }
}
