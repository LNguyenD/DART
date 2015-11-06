using System;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace EM_Report.Models
{
    public class System_Role_Permissions_AuditModel : System_Role_PermissionsModel
    {
        public int Id { get; set; }
        public string Action_Type { get; set; }
        public DateTime? Action_Date { get; set; }
        public int? Action_Owner { get; set; }
    }   
}