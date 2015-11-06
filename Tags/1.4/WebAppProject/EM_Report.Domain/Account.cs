namespace EM_Report.Domain
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;
    using System.Web.Mvc;
    using System.Web;

    [DataContract(Name = "ResetPassword", Namespace = "http://www.yourcompany.com/types/")]
    public class ResetPassword
    {
        [DataMember]
        [Required(ErrorMessage = "*")]        
        public string strUserNameOrEmail { get; set; }        
    }

    [DataContract(Name = "ChangePassword", Namespace = "http://www.yourcompany.com/types/")]
    public class ChangePassword
    {
        [DataMember]
        [Required(ErrorMessage = "*")]
        [DataType(DataType.Password)]        
        public string OldPassword { get; set; }

        [DataMember]
        [Required(ErrorMessage = "*")]
        [StringLength(100, ErrorMessage = "The new password must be at least {2} characters long.", MinimumLength = 6)]
        [DataType(DataType.Password)]        
        public string NewPassword { get; set; }

        [DataMember]
        [Required(ErrorMessage = "*")]
        [DataType(DataType.Password)]        
        [Compare("NewPassword", ErrorMessage = "The new password and confirmation password do not match.")]
        public string ConfirmPassword { get; set; }
    }

    [DataContract(Name = "LogIn", Namespace = "http://www.yourcompany.com/types/")]
    public class LogIn
    {
        [DataMember]
        [Required(ErrorMessage = "*")]
        [RegularExpression(@"[A-Za-z0-9.-]+", ErrorMessage = "*")]
        public string Username { get; set; }

        [DataMember]
        [Required(ErrorMessage = "*")]
        [RegularExpression(@"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}", ErrorMessage = "*")]
        [DataType(DataType.EmailAddress, ErrorMessage = "*")]
        public string Email { get; set; }

        [DataMember]
        [Required(ErrorMessage = "*")]
        [DataType(DataType.Password)]
        public string Password { get; set; }

        [DataMember]
        public bool Is_RememberMe { get; set; }
    }
}
