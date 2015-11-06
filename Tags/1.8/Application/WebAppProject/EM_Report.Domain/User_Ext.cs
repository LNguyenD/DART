﻿namespace EM_Report.Domain
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;
    using System.Web.Mvc;

    [DataContract(Name = "User_Ext", Namespace = "http://www.yourcompany.com/types/")]
    public class User_Ext
    {
        [DataMember]
        [Required(ErrorMessage = "*")]
        public int UserId { get; set; }

        [DataMember]
        [Required(ErrorMessage = "*")]
        [StringLength(256, ErrorMessage = "The username must be under {1} characters long.")]
        public string UserName { get; set; }

        [DataMember]
        [Required(ErrorMessage = "*")]
        [StringLength(256, ErrorMessage = "The password must be at least {2} and under {1} characters long.", MinimumLength = 6)]
        [DataType(DataType.Password)]
        public string Password { get; set; }
       

        [DataMember]
        [Required(ErrorMessage = "*")]
        [RegularExpression(@"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}", ErrorMessage = "Invalid email address.")]
        [StringLength(256, ErrorMessage = "The email must be under {1} characters long.")]
        [DataType(DataType.EmailAddress, ErrorMessage = "Invalid email address.")]
        public string Email { get; set; }

        [DataMember]
        [StringLength(30, ErrorMessage = "The phone number must be under {1} characters long.")]
        [DataType(DataType.PhoneNumber, ErrorMessage = "Invalid the phone number.")]
        public string Phone { get; set; }

        [DataMember]
        [Required(ErrorMessage = "*")]
        [StringLength(256, ErrorMessage = "The first name must be under {1} characters long.")]
        public string FirstName { get; set; }

        [DataMember]
        [Required(ErrorMessage = "*")]
        [StringLength(256, ErrorMessage = "The last name must be under {1} characters long.")]
        public string LastName { get; set; }

        [DataMember]
        [StringLength(256, ErrorMessage = "The address must be under {1} characters long.")]
        public string Address { get; set; }

        [DataMember]
        public short Status { get; set; }

        [DataMember]
        public DateTime? Online_Locked_Until_Datetime { get; set; }

        [DataMember]
        public short? Online_No_Of_Login_Attempts { get; set; }

        [DataMember]
        public DateTime? Last_Online_Login_Date { get; set; }

        [DataMember]
        public DateTime? Create_Date { get; set; }

        [DataMember]
        public int? Owner { get; set; }       

        [DataMember]
        public int? UpdatedBy { get; set; }

        [DataMember]
        public bool Is_System_User { get; set; }

        // ReportUserModel //
        [DataMember]
        public bool Is_External_User { get; set; }

        [DataMember]
        public IList<int> Organisation_RoleIdList { get; set; }     

        
        [DataMember]
        public IList<int> Organisation_LevelIdList { get; set; }
        

        [DataMember]       
        public IList<int> External_GroupIdList { get; set; }        

        [DataMember]
        public IList<System_Role_Permissions> System_Role_PermissionList { get; set; }

        // SystemUserModel //
        [DataMember]
        public int? System_RoleId { get; set; }

        /// <summary>
        /// List Systems.
        /// </summary>
        [DataMember]
        public IList<Systems> SystemList;        

        [DataMember]
        public int? Default_System_Id { get; set; }
        [DataMember]
        public string Default_System_Name { get; set; }       

        [DataMember]
        public string LandingPage_Url { get; set; }       
    }
}