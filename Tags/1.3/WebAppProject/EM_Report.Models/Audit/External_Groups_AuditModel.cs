﻿using System;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace EM_Report.Models
{
    public class External_Groups_AuditModel : External_GroupModel
    {
        public int Id { get; set; }
        public string Action_Type { get; set; }
        public DateTime? Action_Date { get; set; }
        public int? Action_Owner { get; set; }
    }   
}