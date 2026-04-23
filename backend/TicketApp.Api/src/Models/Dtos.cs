using System.ComponentModel.DataAnnotations;
namespace TicketApp.Api.Models;

public class UserLoginDto
{
    public string Email { get; set; }
    public string Password { get; set; }
}

public class UserRegisterDto
{
    [Required]
    public string Name { get; set; }
    [Required]
    public string Surname { get; set; }
    [Required]
    [EmailAddress(ErrorMessage = "Geçersiz e-posta formatı.")] 
    public string Email { get; set; }
    [Required]
    [StringLength(100, MinimumLength = 8, ErrorMessage = "Şifre en az 8 karakter olmalıdır.")]
    public string PasswordHash { get; set; }
}