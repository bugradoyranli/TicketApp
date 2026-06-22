using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using TicketApp.Api.Data;
using TicketApp.Api.Extensions;
using TicketApp.Api.Models;

namespace TicketApp.Api.Controller;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class TicketsController : ControllerBase
{
    private readonly TicketAppDbContext _context;

    public TicketsController(TicketAppDbContext context)
    {
        _context = context;
    }

    /// <summary>
    /// Giriş yapan kullanıcının biletleri ("Biletlerim").
    /// Kullanıcı token'dan belirlenir; istemci userId göndermez.
    /// GET api/tickets/my
    /// </summary>
    [HttpGet("my")]
    public async Task<ActionResult<List<MyTicketDto>>> GetMyTickets()
    {
        var userId = User.GetUserId();
        if (userId is null)
            return Unauthorized();

        var tickets = await _context.Tickets
            .Where(t => t.UserId == userId.Value)
            .OrderByDescending(t => t.PurchaseDate)
            .Select(t => new MyTicketDto
            {
                TicketId = t.ID,
                EventId = t.EventId,
                EventName = t.Event!.Name,
                VenueName = t.Event.Venue != null ? t.Event.Venue.Name : null,
                SectionName = t.EventSection!.Section!.Name,
                SeatNumber = t.SeatNumber,
                PricePaid = t.PricePaid,
                PurchaseDate = t.PurchaseDate
            })
            .AsNoTracking()
            .ToListAsync();

        return Ok(tickets);
    }

    /// <summary>
    /// Bir bileti iptal eder (siler). Bilet silinince koltuk tekrar boşa düşer.
    /// Sadece biletin sahibi iptal edebilir (sahiplik token'dan kontrol edilir).
    /// DELETE api/tickets/5
    /// </summary>
    [HttpDelete("{ticketId}")]
    public async Task<IActionResult> CancelTicket(int ticketId)
    {
        var userId = User.GetUserId();
        if (userId is null)
            return Unauthorized();

        var ticket = await _context.Tickets
            .FirstOrDefaultAsync(t => t.ID == ticketId && t.UserId == userId.Value);

        if (ticket is null)
            return NotFound("Bilet bulunamadı.");

        _context.Tickets.Remove(ticket);
        await _context.SaveChangesAsync();

        return Ok(new { message = "Bilet iptal edildi.", ticketId });
    }
}
