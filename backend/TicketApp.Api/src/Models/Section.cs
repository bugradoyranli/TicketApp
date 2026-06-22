using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TicketApp.Api.Models;

/// <summary>
/// Bir mekânın (Venue) içindeki tekil salon. Örn: "Capacity AVM Sinema Merkezi" -> "Salon 1".
/// Koltuk oturma düzeni JSON olarak SeatingLayoutJson sütununda (PostgreSQL text) tutulur.
/// </summary>
public class Section
{
    [Key]
    public int Id { get; set; }

    [Required]
    public int VenueId { get; set; }

    [ForeignKey(nameof(VenueId))]
    public Venue? Venue { get; set; }

    [Required]
    public string Name { get; set; } = string.Empty;

    /// <summary>
    /// Koltuk düzeninin tamamını tutan JSON. PostgreSQL'de "text" (sınırsız uzunluk).
    /// </summary>
    [Required]
    public string SeatingLayoutJson { get; set; } = string.Empty;

    public int TotalCapacity { get; set; }

    public bool IsActive { get; set; } = true;

    public List<EventSection> EventSections { get; set; } = [];
}
