using Microsoft.EntityFrameworkCore;

namespace TicketApp.Api.Data;

public class TicketAppDbContext : DbContext
{
    public TicketAppDbContext(DbContextOptions<TicketAppDbContext> options)
        : base(options)
    {
    }

   
}