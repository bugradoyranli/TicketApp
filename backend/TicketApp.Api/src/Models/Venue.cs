using System.ComponentModel.DataAnnotations;
namespace TicketApp.Api.Models;
public class Venue
{
    [Key]
    public int ID { get; set; }

    [Required]
    public string Name { get; set; } = string.Empty;

    [Required]
    public string Address { get; set; } = string.Empty;

    [Required]
    public string City { get; set; } = string.Empty;

    [Required]
    public string Country { get; set; } = string.Empty;

    [Required]
    public string Phone { get; set; } = string.Empty;
    [Required]
    public bool IsActive { get; set; } = true;


    public int Capacity { get; set; }
    

}