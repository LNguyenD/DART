using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace EM_Report.Models
{
    public class ResetPasswordModel
    {
        [Required(ErrorMessage = "*")]        
        public string strUserNameOrEmail { get; set; }        
    }
    
    public class ChangePasswordModel
    {
        [Required(ErrorMessage = "*")]
        [DataType(DataType.Password)]        
        public string OldPassword { get; set; }

        [Required(ErrorMessage = "*")]
        [StringLength(100, ErrorMessage = "The new password must be at least {2} characters long.", MinimumLength = 6)]
        [DataType(DataType.Password)]        
        public string NewPassword { get; set; }

        [Required(ErrorMessage = "*")]
        [DataType(DataType.Password)]        
        [Compare("NewPassword", ErrorMessage = "The new password and confirmation password do not match.")]
        public string ConfirmPassword { get; set; }
    }

    public class LogInModel
    {
        [Required(ErrorMessage = "*")]
        public string UserName { get; set; }

        [Required(ErrorMessage = "*")]
        //[StringLength(100, ErrorMessage = "The password must be at least {2} characters long.", MinimumLength = 6)]
        [DataType(DataType.Password)]
        public string Password { get; set; }

        public bool Is_RememberMe { get; set; } 
    }   
}
