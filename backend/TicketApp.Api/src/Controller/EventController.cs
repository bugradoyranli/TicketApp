using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using System.Text.Json;
using TicketApp.Api.Data;
using TicketApp.Api.Models;

namespace TicketApp.Api.Controller;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class EventController : ControllerBase
{
    private readonly TicketAppDbContext _context;

    public EventController(TicketAppDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public ActionResult<Event> GetEvents()
    {
        var events = _context.Events.Where(e => e.IsActive).ToList();
        return Ok(events);
    }

    [HttpGet("featured")]
    public IActionResult GetFeaturedEvents()
    {
        var events = _context.Events
            .Include(e => e.Venue)
            .Where(e => e.IsFeatured && e.IsActive)
            .OrderByDescending(e => e.Date)
            .Select(e => new {
                e.ID,
                e.Name,
                e.Description,
                e.Date,
                e.ImageUrl,
                VenueName = e.Venue != null ? e.Venue.Name : null,
                City = e.Venue != null ? e.Venue.City : null,
                e.Price
            })
            .ToList();

        return Ok(events);
    }

    [HttpGet("{id}")]
    public ActionResult<Event> GetEvent(int id)
    {
        var evnt = _context.Events.Find(id);
        if (evnt == null)
            return NotFound();
        return Ok(evnt);
    }

    [HttpGet("category/{id}")]
    public ActionResult<Event> GetEventByCategory(int id)
    {
        var events = _context.Events
            .Include(e => e.Venue)
            .Where(e => e.CategoryId == id && e.IsActive)
            .OrderByDescending(e => e.Date)
            .Select(e => new {
                e.ID,
                e.Name,
                e.Description,
                e.Date,
                e.ImageUrl,
                VenueName = e.Venue != null ? e.Venue.Name : null,
                City = e.Venue != null ? e.Venue.City : null,
                e.Price
            })
            .ToList();
        return Ok(events);
    }



    [HttpPost]
    public ActionResult<Event> CreateEvent([FromBody] Event newEvent)
    {
        if (newEvent == null)
            return BadRequest();

        _context.Events.Add(newEvent);
        _context.SaveChanges();
        return Ok(new { Message = "Event created successfully" });
    }
}
