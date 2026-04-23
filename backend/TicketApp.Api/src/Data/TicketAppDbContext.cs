using System.Security.Cryptography.X509Certificates;
using Microsoft.EntityFrameworkCore;
using TicketApp.Api.Models;

namespace TicketApp.Api.Data;

public class TicketAppDbContext : DbContext
{
    public TicketAppDbContext(DbContextOptions<TicketAppDbContext> options)
        : base(options)
    {
    }
        public DbSet<User> Users { get; set; }

}