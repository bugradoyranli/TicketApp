using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Text.Json;
using TicketApp.Api.Data;
using TicketApp.Api.Models;

namespace TicketApp.Api.Controller;

/// <summary>
/// Admin paneli uçları. TÜMÜ sadece IsAdmin=true kullanıcıya açıktır
/// (JWT'deki Role=Admin claim'i üzerinden). Sıradan kullanıcı 403 alır.
/// </summary>
[ApiController]
[Route("api/[controller]")]
[Authorize(Roles = "Admin")]
public class AdminController : ControllerBase
{
    private readonly TicketAppDbContext _context;

    public AdminController(TicketAppDbContext context)
    {
        _context = context;
    }

    // ================================================================
    // KATEGORİLER
    // ================================================================

    [HttpGet("categories")]
    public async Task<IActionResult> GetCategories()
    {
        var categories = await _context.Categories
            .OrderBy(c => c.Name)
            .Select(c => new { id = c.ID, name = c.Name, icon = c.Icon, isActive = c.IsActive })
            .ToListAsync();
        return Ok(categories);
    }

    [HttpPost("categories")]
    public async Task<IActionResult> CreateCategory([FromBody] CreateCategoryDto dto)
    {
        if (!ModelState.IsValid) return BadRequest(ModelState);

        var category = new Category
        {
            Name = dto.Name.Trim(),
            Icon = dto.Icon.Trim(),
            IsActive = dto.IsActive
        };

        _context.Categories.Add(category);
        await _context.SaveChangesAsync();

        return Ok(new { message = "Kategori eklendi.", id = category.ID });
    }

    // ================================================================
    // MEKANLAR (Venue)
    // ================================================================

    [HttpGet("venues")]
    public async Task<IActionResult> GetVenues()
    {
        var venues = await _context.Venues
            .OrderBy(v => v.Name)
            .Select(v => new { id = v.ID, name = v.Name, city = v.City })
            .ToListAsync();
        return Ok(venues);
    }

    [HttpPost("venues")]
    public async Task<IActionResult> CreateVenue([FromBody] CreateVenueDto dto)
    {
        if (!ModelState.IsValid) return BadRequest(ModelState);

        var venue = new Venue
        {
            Name = dto.Name.Trim(),
            Address = dto.Address.Trim(),
            City = dto.City.Trim(),
            Country = dto.Country.Trim(),
            Phone = dto.Phone.Trim(),
            Capacity = dto.Capacity,
            IsActive = dto.IsActive
        };

        _context.Venues.Add(venue);
        await _context.SaveChangesAsync();

        return Ok(new { message = "Mekan eklendi.", id = venue.ID });
    }

    // ================================================================
    // ETKİNLİKLER (Event)
    // ================================================================

    [HttpGet("events")]
    public async Task<IActionResult> GetEvents()
    {
        var events = await _context.Events
            .Include(e => e.Venue)
            .OrderByDescending(e => e.Date)
            .Select(e => new
            {
                id = e.ID,
                name = e.Name,
                date = e.Date,
                categoryId = e.CategoryId,
                venueName = e.Venue != null ? e.Venue.Name : null,
                isActive = e.IsActive,
                isFeatured = e.IsFeatured
            })
            .ToListAsync();
        return Ok(events);
    }

    [HttpPost("events")]
    public async Task<IActionResult> CreateEvent([FromBody] CreateEventDto dto)
    {
        if (!ModelState.IsValid) return BadRequest(ModelState);

        // Kategori gerçekten var mı?
        if (!await _context.Categories.AnyAsync(c => c.ID == dto.CategoryId))
            return BadRequest("Seçilen kategori bulunamadı.");

        // Mekan seçildiyse var mı?
        if (dto.VenueId is int vid && !await _context.Venues.AnyAsync(v => v.ID == vid))
            return BadRequest("Seçilen mekan bulunamadı.");

        var ev = new Event
        {
            Name = dto.Name.Trim(),
            Description = dto.Description.Trim(),
            Date = NormalizeUtc(dto.Date),
            CategoryId = dto.CategoryId,
            VenueId = dto.VenueId,
            Price = dto.Price,
            ImageUrl = string.IsNullOrWhiteSpace(dto.ImageUrl) ? null : dto.ImageUrl.Trim(),
            IsActive = dto.IsActive,
            IsFeatured = dto.IsFeatured
        };

        _context.Events.Add(ev);
        await _context.SaveChangesAsync();

        return Ok(new { message = "Etkinlik eklendi.", id = ev.ID });
    }

    // ================================================================
    // SESSION'LAR (Section = salon + koltuk düzeni)
    // ================================================================

    [HttpGet("sections")]
    public async Task<IActionResult> GetSections()
    {
        var sections = await _context.Sections
            .Include(s => s.Venue)
            .OrderBy(s => s.Name)
            .Select(s => new
            {
                id = s.Id,
                name = s.Name,
                venueId = s.VenueId,
                venueName = s.Venue != null ? s.Venue.Name : null,
                totalCapacity = s.TotalCapacity,
                isActive = s.IsActive
            })
            .ToListAsync();
        return Ok(sections);
    }

    [HttpPost("sections")]
    public async Task<IActionResult> CreateSection([FromBody] CreateSectionDto dto)
    {
        if (!ModelState.IsValid) return BadRequest(ModelState);

        if (!await _context.Venues.AnyAsync(v => v.ID == dto.VenueId))
            return BadRequest("Seçilen mekan bulunamadı.");

        // Koltuk düzeni JSON'unu burada üretiyoruz (Swift SeatLayout ile birebir).
        var layoutJson = BuildSeatingLayoutJson(dto.Name.Trim(), dto.Rows, dto.Cols);

        var section = new Section
        {
            VenueId = dto.VenueId,
            Name = dto.Name.Trim(),
            SeatingLayoutJson = layoutJson,
            TotalCapacity = dto.Rows * dto.Cols,
            IsActive = dto.IsActive
        };

        _context.Sections.Add(section);
        await _context.SaveChangesAsync();

        return Ok(new
        {
            message = "Session (salon) eklendi.",
            id = section.Id,
            totalCapacity = section.TotalCapacity
        });
    }

    // ================================================================
    // BAĞLAMA (EventSection = etkinlik ↔ session + taban fiyat)
    // ================================================================

    [HttpGet("event-sections")]
    public async Task<IActionResult> GetEventSections()
    {
        var links = await _context.EventSections
            .Include(es => es.Event)
            .Include(es => es.Section)
            .OrderByDescending(es => es.Id)
            .Select(es => new
            {
                id = es.Id,
                eventId = es.EventId,
                eventName = es.Event != null ? es.Event.Name : null,
                sectionId = es.SectionId,
                sectionName = es.Section != null ? es.Section.Name : null,
                basePrice = es.BasePrice
            })
            .ToListAsync();
        return Ok(links);
    }

    [HttpPost("event-sections")]
    public async Task<IActionResult> LinkEventSection([FromBody] CreateEventSectionDto dto)
    {
        if (!ModelState.IsValid) return BadRequest(ModelState);

        if (!await _context.Events.AnyAsync(e => e.ID == dto.EventId))
            return BadRequest("Etkinlik bulunamadı.");

        if (!await _context.Sections.AnyAsync(s => s.Id == dto.SectionId))
            return BadRequest("Session bulunamadı.");

        // Aynı etkinlik + session ikilisi zaten bağlı mı?
        var exists = await _context.EventSections
            .AnyAsync(es => es.EventId == dto.EventId && es.SectionId == dto.SectionId);
        if (exists)
            return Conflict("Bu etkinlik bu session'a zaten bağlı.");

        var link = new EventSection
        {
            EventId = dto.EventId,
            SectionId = dto.SectionId,
            BasePrice = dto.BasePrice
        };

        _context.EventSections.Add(link);
        await _context.SaveChangesAsync();

        return Ok(new { message = "Etkinlik session'a bağlandı.", id = link.Id });
    }

    // ================================================================
    // Yardımcılar
    // ================================================================

    /// <summary>
    /// rows×cols koltuk düzenini, mobil tarafın beklediği JSON şemasında üretir:
    /// { version, name, rows, cols, seats:[{ id:"A1", row:"A", rowIndex:0, col:1 }, ...] }
    /// Satırlar A,B,C... (0-indexli), sütunlar 1..cols.
    /// </summary>
    private static string BuildSeatingLayoutJson(string name, int rows, int cols)
    {
        var seats = new List<object>(rows * cols);
        for (int r = 0; r < rows; r++)
        {
            var rowLetter = ((char)('A' + r)).ToString();
            for (int c = 1; c <= cols; c++)
            {
                seats.Add(new
                {
                    id = $"{rowLetter}{c}",
                    row = rowLetter,
                    rowIndex = r,
                    col = c
                });
            }
        }

        var layout = new { version = 1, name, rows, cols, seats };
        return JsonSerializer.Serialize(layout);
    }

    /// <summary>
    /// Npgsql, "timestamp with time zone" sütununa yalnızca Kind=Utc DateTime kabul eder.
    /// İstemci ISO8601 (Z) gönderdiğinde Kind=Utc gelir; aksi halde UTC'ye normalize ederiz.
    /// </summary>
    private static DateTime NormalizeUtc(DateTime dt) => dt.Kind switch
    {
        DateTimeKind.Utc => dt,
        DateTimeKind.Local => dt.ToUniversalTime(),
        _ => DateTime.SpecifyKind(dt, DateTimeKind.Utc)
    };
}
