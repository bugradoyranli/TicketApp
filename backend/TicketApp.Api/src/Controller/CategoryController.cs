using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using TicketApp.Api.Data;
using TicketApp.Api.Models;
namespace TicketApp.Api.Controller;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class CategoryController : ControllerBase
{
    private readonly TicketAppDbContext dbContext;

    public CategoryController(TicketAppDbContext context)
    {
        dbContext = context;
    }

    [HttpGet]
    public IActionResult Get()
    {
        var categories = dbContext.Categories.
        Where(c => c.IsActive == true).
        Select(c => new { c.ID, c.Name, c.Icon }
        ).ToList();
        return Ok(categories);
    }



   [HttpPost("register")]
    public IActionResult Create([FromBody] Category category)
    {
        if (category == null)
        {
            return BadRequest();
        }

        dbContext.Categories.Add(category);
        dbContext.SaveChanges();

        return Ok();
    }
}