using TicketApp.Api.Models;

public interface IJwtService 
{
    string GenerateToken(User user);
}