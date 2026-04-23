using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TicketApp.Api.Data;
using TicketApp.Api.Models;
using BCrypt.Net;
namespace TicketApp.Api.Controller;

[ApiController]
[Route("api/[controller]")]
public class UserController : ControllerBase
{
    private readonly TicketAppDbContext dbContext;
    private readonly ILogger<UserController> logger;

    private readonly IJwtService JwtService;

    public UserController(TicketAppDbContext _context, ILogger<UserController> _logger, IJwtService _jwtService)
    {  
        dbContext = _context;
        logger = _logger;
        JwtService = _jwtService;

    }

    [HttpGet]
    public async Task<IActionResult> Get()
    {
        var users = await dbContext.Users.ToListAsync();
        return Ok(users);
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] UserLoginDto request)
    {
        var user = await dbContext.Users
            .FirstOrDefaultAsync(u => u.Email == request.Email);

        if (user == null || !BCrypt.Net.BCrypt.Verify(request.Password, user.PasswordHash))
        {
            return BadRequest("Invalid email or password");
        }
        var token = JwtService.GenerateToken(user);
        return Ok(new { message = "Login successful", token = token ,user = new {
            id= user.Id,
            name= user.Name,
            surname= user.Surname,
            email= user.Email
        }});
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] UserRegisterDto request)
    {
        if (await dbContext.Users.AnyAsync(u => u.Email == request.Email))
        {
            return BadRequest("Email already in use");
        }

        var hashedPassword = BCrypt.Net.BCrypt.HashPassword(request.PasswordHash);
        var user = new User()
        {
            Name = request.Name,
            Surname = request.Surname,
            Email = request.Email,
            PasswordHash = hashedPassword
        };

        dbContext.Users.Add(user);
        await dbContext.SaveChangesAsync();

        return Ok(new { message = "Registration successful" });
    }
}

