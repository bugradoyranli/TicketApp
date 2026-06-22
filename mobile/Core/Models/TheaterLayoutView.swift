import Foundation

// MARK: - Koltuk Seçimi Modelleri
// Backend: GET  api/seating/event/{eventId}  -> EventLayoutResponse
//          POST api/seating/purchase         -> SeatPurchaseResponse
//          GET  api/tickets/user/{userId}    -> [MyTicket]
// Backend ASP.NET Core varsayılan olarak camelCase ürettiği için
// alan isimleri JSON ile birebir eşleşiyor; CodingKeys'e gerek yok.

/// Bir etkinliğin koltuk seçim ekranı için dönen yanıt.
struct EventLayoutResponse: Codable {
    let eventId: Int
    let sections: [SectionLayout]
}

/// Tek bir salon: düzeni, fiyatı ve dolu koltukları.
struct SectionLayout: Codable, Identifiable {
    let sectionId: Int
    let sectionName: String
    let basePrice: Double
    let totalCapacity: Int
    let layout: SeatLayout?
    let bookedSeats: [String]

    var id: Int { sectionId }
}

/// Salonun statik koltuk düzeni (DB'de text olarak saklanan JSON).
struct SeatLayout: Codable {
    let version: Int
    let name: String
    let rows: Int
    let cols: Int
    let seats: [LayoutSeat]
}

/// Tek bir koltuğun geometrisi. Durum (dolu/seçili) burada tutulmaz;
/// dolu koltuklar SectionLayout.bookedSeats'ten, seçim ise ViewModel'den gelir.
struct LayoutSeat: Codable, Identifiable {
    let id: String       // örn: "A1", "J10"
    let row: String      // satır harfi: "A".."J"
    let rowIndex: Int    // 0..n (sıralama için)
    let col: Int         // 1..n
}

// MARK: - Satın Alma
// UserId GÖNDERİLMEZ; sunucu kullanıcıyı JWT token'dan belirler.
struct SeatPurchaseRequest: Codable {
    let eventId: Int
    let sectionId: Int
    let seatIds: [String]
}

struct SeatPurchaseResponse: Codable {
    let message: String
    let eventId: Int
    let sectionId: Int
    let seats: [String]
    let unitPrice: Double
    let total: Double
}

// MARK: - Biletlerim
struct MyTicket: Codable, Identifiable {
    let ticketId: Int
    let eventId: Int
    let eventName: String
    let venueName: String?
    let sectionName: String
    let seatNumber: String
    let pricePaid: Double
    let purchaseDate: String

    var id: Int { ticketId }
}
