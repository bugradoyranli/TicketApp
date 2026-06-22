using System.Security.Claims;

namespace TicketApp.Api.Extensions;

public static class ClaimsPrincipalExtensions
{
    /// <summary>
    /// Token'daki NameIdentifier claim'inden giriş yapan kullanıcının id'sini okur.
    /// İstemciden gelen değere GÜVENMEYİZ; her zaman token'dan alırız.
    /// </summary>
    public static int? GetUserId(this ClaimsPrincipal principal)
    {
        var raw = principal.FindFirst(ClaimTypes.NameIdentifier)?.Value
                  ?? principal.FindFirst("nameid")?.Value
                  ?? principal.FindFirst("sub")?.Value;

        return int.TryParse(raw, out var id) ? id : null;
    }
}
