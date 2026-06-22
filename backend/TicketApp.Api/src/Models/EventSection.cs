using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TicketApp.Api.Models;

/// <summary>
/// Bir etkinliğin hangi salonda (Section) gösterildiğini ve o gösterimin
/// taban fiyatını bağlayan ara tablo. Örn: "Interstellar" -> "Salon 1" -> 150 TL.
/// </summary>
public class EventSection
{
    [Key]
    public int Id { get; set; }

    [Required]
    public int EventId { get; set; }

    [ForeignKey(nameof(EventId))]
    public Event? Event { get; set; }

    [Required]
    public int SectionId { get; set; }

    [ForeignKey(nameof(SectionId))]
    public Section? Section { get; set; }

    public decimal BasePrice { get; set; }

    public List<Ticket> Tickets { get; set; } = [];
}
