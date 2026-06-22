using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TicketApp.Api.Models;

public enum SeatReservationStatus
{
    Reserved = 0,
    Sold = 1,
    Cancelled = 2
}

/// <summary>
/// Belirli bir etkinlik + salon için tek bir koltuğun rezervasyon kaydı.
/// SeatId, layout JSON'undaki koltuk id'sidir (örn: "A1", "J10").
/// </summary>
public class SeatReservation
{
    [Key]
    public int ID { get; set; }

    [Required]
    public int EventId { get; set; }

    [ForeignKey(nameof(EventId))]
    public Event? Event { get; set; }

    [Required]
    public int SectionId { get; set; }

    [ForeignKey(nameof(SectionId))]
    public Section? Section { get; set; }

    [Required]
    public string SeatId { get; set; } = string.Empty;

    [Required]
    public int UserId { get; set; }

    [ForeignKey(nameof(UserId))]
    public User? User { get; set; }

    public SeatReservationStatus Status { get; set; } = SeatReservationStatus.Reserved;

    public DateTime CreatedAt { get; set; }
}
