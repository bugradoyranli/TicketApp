using System.ComponentModel.DataAnnotations;

namespace TicketApp.Api.Models;

public class Category
{
    [Key]
    public int ID { get; set; }

    [Required]
    public string Name { get; set; } =string.Empty;

    [Required]
    public string Icon { get; set; } = string.Empty;

    [Required]
    public bool IsActive { get; set; }


}