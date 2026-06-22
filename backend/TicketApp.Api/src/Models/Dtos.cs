using System.ComponentModel.DataAnnotations;
using System.Text.Json;
namespace TicketApp.Api.Models;

public class UserLoginDto
{
    public string Email { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
}

public class UserRegisterDto
{
    [Required]
    public string Name { get; set; } = string.Empty;
    [Required]
    public string Surname { get; set; } = string.Empty;
    [Required]
    [EmailAddress(ErrorMessage = "Geçersiz e-posta formatı.")]
    public string Email { get; set; } = string.Empty;
    [Required]
    [StringLength(100, MinimumLength = 8, ErrorMessage = "Şifre en az 8 karakter olmalıdır.")]
    public string PasswordHash { get; set; } = string.Empty;
}

public class SeatReservationDto
{
    [Required]
    public int EventId { get; set; }
    [Required]
    public int SectionId { get; set; }
    [Required]
    public string SeatId { get; set; } = string.Empty;
    [Required]
    public int UserId { get; set; }
}

/// <summary>
/// Birden fazla koltuğu tek istekte satın almak için.
/// UserId artık burada YOK; sunucu token'dan okur.
/// </summary>
public class SeatPurchaseRequestDto
{
    [Required]
    public int EventId { get; set; }
    [Required]
    public int SectionId { get; set; }
    [Required]
    public List<string> SeatIds { get; set; } = [];
}

/// <summary>
/// "Biletlerim" ekranı için tek bir satın alınmış bilet.
/// </summary>
public class MyTicketDto
{
    public int TicketId { get; set; }
    public int EventId { get; set; }
    public string EventName { get; set; } = string.Empty;
    public string? VenueName { get; set; }
    public string SectionName { get; set; } = string.Empty;
    public string SeatNumber { get; set; } = string.Empty;
    public decimal PricePaid { get; set; }
    public DateTime PurchaseDate { get; set; }
}

public class SectionLayoutDto
{
    public int SectionId { get; set; }
    public string SectionName { get; set; } = string.Empty;
    public decimal BasePrice { get; set; }
    public int TotalCapacity { get; set; }
    public JsonElement? Layout { get; set; }
    public List<string> BookedSeats { get; set; } = [];
}

public class EventLayoutDto
{
    public int EventId { get; set; }
    public List<SectionLayoutDto> Sections { get; set; } = [];
}
