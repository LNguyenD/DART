namespace EM_Report.Domain
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;
    using System.Web.Mvc;
    using System.Web;
    using System.Collections.Generic;
    
    public class SSRSCacheSetting
    {
        public string DashboardType { get; set; } 

        [Required(ErrorMessage = "Missing field")] 
        [Range(0, 23)]
        public int SSRSCacheAtHour { get; set; }

        [Required(ErrorMessage = "Missing field")]
        [Range(0, 59)]
        public int SSRSCacheAtMinute { get; set; }

        [Required(ErrorMessage = "Missing field")]
        [Range(0, 23)]
        public int RefreshSSRSCacheAtHour { get; set; }

        [Required(ErrorMessage = "Missing field")]
        [Range(0, 59)]
        public int RefreshSSRSCacheAtMinute { get; set; }

        [Required(ErrorMessage = "Missing field")]
        [Range(0, 23)]
        public int SSRSSnapshotAtHour { get; set; }

        [Required(ErrorMessage = "Missing field")]
        [Range(0, 59)]
        public int SSRSSnapshotAtMinute { get; set; }       
        
    }
}