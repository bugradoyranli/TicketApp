using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using System.Text.Json;
using TicketApp.Api.Data;
using TicketApp.Api.Extensions;
using TicketApp.Api.Models;

namespace TicketApp.Api.Controller;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class SeatingController : ControllerBase
{
    private readonly TicketAppDbContext _context;

    public SeatingController(TicketAppDbContext context)
    {
        _context = context;
    }

    /// <summary>
    /// Koltuk seçim ekranı için: salon(lar), koltuk düzeni (JSON), taban fiyat
    /// ve SATILMIŞ koltuklar (Tickets tablosundan).
    /// GET api/seating/event/5
    /// </summary>
    [HttpGet("event/{eventId}")]
    public async Task<ActionResult<EventLayoutDto>> GetEventLayout(int eventId)
    {
        var eventExists = await _context.Events.AnyAsync(e => e.ID == eventId);
        if (!eventExists)
            return NotFound("Etkinlik bulunamadı.");

        var eventSections = await _context.EventSections
            .Where(es => es.EventId == eventId)
            .Include(es => es.Section)
            .AsNoTracking()
            .ToListAsync();

        if (eventSections.Count == 0)
            return Ok(new EventLayoutDto { EventId = eventId, Sections = [] });

        // Satılmış koltuklar = bu etkinlik için kesilmiş biletler.
        var soldRaw = await _context.Tickets
            .Where(t => t.EventId == eventId)
            .Select(t => new { SectionId = t.EventSection!.SectionId, t.SeatNumber })
            .AsNoTracking()
            .ToListAsync();

        var soldBySection = soldRaw
            .GroupBy(x => x.SectionId)
            .ToDictionary(g => g.Key, g => g.Select(x => x.SeatNumber).ToList());

        var sections = eventSections
            .Where(es => es.Section is not null)
            .Select(es => new SectionLayoutDto
            {
                SectionId = es.SectionId,
                SectionName = es.Section!.Name,
                BasePrice = es.BasePrice,
                TotalCapacity = es.Section.TotalCapacity,
                Layout = ParseLayout(es.Section.SeatingLayoutJson),
                BookedSeats = soldBySection.TryGetValue(es.SectionId, out var seats)
                    ? seats
                    : []
            })
            .ToList();

        return Ok(new EventLayoutDto { EventId = eventId, Sections = sections });
    }

    /// <summary>
    /// Seçilen boş koltuklar için doğrudan bilet keser (satın alma).
    /// POST api/seating/purchase
    /// </summary>
    [HttpPost("purchase")]
    public async Task<IActionResult> Purchase([FromBody] SeatPurchaseRequestDto request)
    {
        if (request.SeatIds is null || request.SeatIds.Count == 0)
            return BadRequest("En az bir koltuk seçmelisiniz.");

        // userId'yi İSTEMCİDEN DEĞİL token'dan alıyoruz (güvenlik).
        var userId = User.GetUserId();
        if (userId is null)
            return Unauthorized();

        var userExists = await _context.Users.AnyAsync(u => u.Id == userId.Value);
        if (!userExists)
            return Unauthorized("Kullanıcı bulunamadı. Lütfen tekrar giriş yapın.");

        // Etkinlik <-> salon bağlantısı (ve o gösterimin fiyatı)
        var eventSection = await _context.EventSections
            .FirstOrDefaultAsync(es => es.EventId == request.EventId
                                    && es.SectionId == request.SectionId);

        if (eventSection is null)
            return NotFound("Bu etkinlik için bu salon bulunamadı.");

        var requestedSeats = request.SeatIds
            .Where(s => !string.IsNullOrWhiteSpace(s))
            .Distinct()
            .ToList();

        // Bu koltuklardan biri zaten satıldı mı?
        var alreadySold = await _context.Tickets
            .Where(t => t.EventSectionId == eventSection.Id
                     && requestedSeats.Contains(t.SeatNumber))
            .Select(t => t.SeatNumber)
            .ToListAsync();

        if (alreadySold.Count > 0)
            return Conflict(new
            {
                message = "Seçtiğiniz bazı koltuklar bu sırada satıldı.",
                seats = alreadySold
            });

        var now = DateTime.UtcNow;
        var tickets = requestedSeats.Select(seatId => new Ticket
        {
            EventId = request.EventId,
            EventSectionId = eventSection.Id,
            UserId = userId.Value,
            SeatNumber = seatId,
            PurchaseDate = now,
            PricePaid = eventSection.BasePrice
        }).ToList();

        _context.Tickets.AddRange(tickets);
        await _context.SaveChangesAsync();

        return Ok(new
        {
            message = "Biletler başarıyla satın alındı.",
            eventId = request.EventId,
            sectionId = request.SectionId,
            seats = requestedSeats,
            unitPrice = eventSection.BasePrice,
            total = eventSection.BasePrice * requestedSeats.Count
        });
    }

    private static JsonElement? ParseLayout(string? json)
    {
        if (string.IsNullOrWhiteSpace(json))
            return null;

        try
        {
            using var doc = JsonDocument.Parse(json);
            return doc.RootElement.Clone();
        }
        catch (JsonException)
        {
            return null;
        }
    }
}
