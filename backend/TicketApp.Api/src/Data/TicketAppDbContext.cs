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
    public DbSet<Category> Categories { get; set; }
    public DbSet<Event> Events { get; set; }
    public DbSet<Venue> Venues { get; set; }
    public DbSet<Section> Sections { get; set; }
    public DbSet<EventSection> EventSections { get; set; }
    public DbSet<SeatReservation> SeatReservations { get; set; }
    public DbSet<Ticket> Tickets { get; set; }



}
