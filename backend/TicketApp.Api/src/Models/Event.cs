using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace TicketApp.Api.Models;

public class Event
{
    [Key]
    public int ID { get; set; }

    [Required]
    public string Name { get; set; } = string.Empty;

    [Required]
    public string Description { get; set; } = string.Empty;

    [Required]
    public DateTime Date { get; set; }

    [Required]
    public int CategoryId { get; set; }

    [Required]
    public bool IsActive { get; set; }

    public bool IsFeatured { get; set; } = false;

    public int? VenueId { get; set; }

    [ForeignKey("VenueId")]
    public Venue? Venue { get; set; }

    public double? Price { get; set; }

    public string? ImageUrl { get; set; }

    public List<EventSection> EventSections { get; set; } = [];

}
