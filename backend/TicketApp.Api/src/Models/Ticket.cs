using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TicketApp.Api.Models;

/// <summary>
/// Satın alınmış bileti temsil eder. Rezervasyon ödeme ile bilete dönüşür.
/// </summary>
public class Ticket
{
    [Key]
    public int ID { get; set; }

    [Required]
    public int EventId { get; set; }

    [ForeignKey(nameof(EventId))]
    public Event? Event { get; set; }

    [Required]
    public int EventSectionId { get; set; }

    [ForeignKey(nameof(EventSectionId))]
    public EventSection? EventSection { get; set; }

    [Required]
    public int UserId { get; set; }

    [ForeignKey(nameof(UserId))]
    public User? User { get; set; }

    [Required]
    public string SeatNumber { get; set; } = string.Empty;

    public DateTime PurchaseDate { get; set; }

    public decimal PricePaid { get; set; }
}
