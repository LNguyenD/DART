using System;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;
using System.Web;

namespace EM_Report.Models
{
    public class UserModel : I_Status
    {
        [Required(ErrorMessage = "*")]
        public int UserId { get; set; }

        [Required(ErrorMessage = "*")]
        [StringLength(256, ErrorMessage = "The username must be under {1} characters long.")]
        public string UserName { get; set; }        

        [Required(ErrorMessage = "*")]
        [StringLength(256, ErrorMessage = "The password must be at least {2} and under {1} characters long.", MinimumLength = 6)]
        [DataType(DataType.Password)]
        public string Password { get; set; }

        [Required(ErrorMessage = "*")]
        [Compare("Password", ErrorMessage = "The password and confirmation password do not match.")]
        public string ConfirmPassword { get; set; }

        [Required(ErrorMessage = "*")]
        [RegularExpression(@"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}", ErrorMessage = "Invalid the email address.")]
        [StringLength(256, ErrorMessage = "The email must be under {1} characters long.")]
        [DataType(DataType.EmailAddress, ErrorMessage = "Invalid the email address.")]
        public string Email { get; set; }        
        
        [StringLength(30, ErrorMessage = "The phone number must be under {1} characters long.")]
        [DataType(DataType.PhoneNumber, ErrorMessage = "Invalid the phone number.")]
        public string Phone { get; set; }

        [Required(ErrorMessage = "*")]
        [StringLength(256, ErrorMessage = "The first name must be under {1} characters long.")]
        public string FirstName { get; set; }

        [Required(ErrorMessage = "*")]
        [StringLength(256, ErrorMessage = "The last name must be under {1} characters long.")]
        public string LastName { get; set; }
        
        [StringLength(256, ErrorMessage = "The address must be under {1} characters long.")]
        public string Address { get; set; }

        public short Status { get; set; }
        public DateTime? Online_Locked_Until_Datetime { get; set; }
        public short? Online_No_Of_Login_Attempts { get; set; }
        public DateTime? Last_Online_Login_Date { get; set; }
        public DateTime? Create_Date { get; set; }
        public int? Owner { get; set; }
        public string StatusName { get; set; }
        public string OwnerName { get; set; }
        public int? UpdatedBy { get; set; }
        public bool Is_System_User { get; set; }
        
        // ReportUserModel //
        public bool Is_External_User { get; set; }
        public int? TeamId { get; set; }
        public int? Organisation_RoleId { get; set; }
        public int? External_GroupId { get; set; }

        // SystemUserModel //
        public int? System_RoleId { get; set; }
    }    
}
