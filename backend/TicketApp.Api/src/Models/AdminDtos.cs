using System.ComponentModel.DataAnnotations;

namespace TicketApp.Api.Models;

// =====================================================================
// Admin paneli — oluşturma (create) istek DTO'ları.
// Model sınıflarını doğrudan [FromBody] olarak almak yerine DTO kullanıyoruz:
//  - over-posting'i engeller (örn. istemci Id/IsAdmin gönderemez),
//  - Section'da satır/sütun alıp SeatingLayoutJson'u SUNUCUDA üretiriz.
// =====================================================================

public class CreateCategoryDto
{
    [Required]
    public string Name { get; set; } = string.Empty;

    /// <summary>SF Symbol adı (örn: "film", "sportscourt").</summary>
    [Required]
    public string Icon { get; set; } = string.Empty;

    public bool IsActive { get; set; } = true;
}

public class CreateVenueDto
{
    [Required] public string Name { get; set; } = string.Empty;
    [Required] public string Address { get; set; } = string.Empty;
    [Required] public string City { get; set; } = string.Empty;
    [Required] public string Country { get; set; } = string.Empty;
    [Required] public string Phone { get; set; } = string.Empty;
    public int Capacity { get; set; }
    public bool IsActive { get; set; } = true;
}

public class CreateEventDto
{
    [Required] public string Name { get; set; } = string.Empty;
    [Required] public string Description { get; set; } = string.Empty;
    [Required] public DateTime Date { get; set; }
    [Required] public int CategoryId { get; set; }
    public int? VenueId { get; set; }
    public double? Price { get; set; }
    public string? ImageUrl { get; set; }
    public bool IsActive { get; set; } = true;
    public bool IsFeatured { get; set; } = false;
}

/// <summary>
/// Session = bir mekândaki salon (koltuk düzeni). Admin sadece satır/sütun girer;
/// koltuk JSON'u (A1..) ve TotalCapacity sunucuda üretilir.
/// </summary>
public class CreateSectionDto
{
    [Required] public int VenueId { get; set; }
    [Required] public string Name { get; set; } = string.Empty;

    [Range(1, 26, ErrorMessage = "Satır sayısı 1-26 arası olmalı (A-Z).")]
    public int Rows { get; set; }

    [Range(1, 50, ErrorMessage = "Sütun sayısı 1-50 arası olmalı.")]
    public int Cols { get; set; }

    public bool IsActive { get; set; } = true;
}

/// <summary>Etkinlik ↔ Session bağlama + o gösterimin taban fiyatı.</summary>
public class CreateEventSectionDto
{
    [Required] public int EventId { get; set; }
    [Required] public int SectionId { get; set; }
    public decimal BasePrice { get; set; }
}
