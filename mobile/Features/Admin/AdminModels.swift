import Foundation

// =====================================================================
// Admin paneli modelleri.
// Backend camelCase ürettiği için CodingKeys'e gerek yok.
// Uçlar (hepsi [Authorize(Roles="Admin")]):
//   GET/POST  /api/Admin/categories
//   GET/POST  /api/Admin/venues
//   GET/POST  /api/Admin/events
//   GET/POST  /api/Admin/sections          (rows/cols -> layout sunucuda üretilir)
//   GET/POST  /api/Admin/event-sections     (etkinlik <-> session bağlama)
// =====================================================================

// MARK: - İstekler (POST gövdeleri)

struct CreateCategoryRequest: Codable {
    let name: String
    let icon: String
    let isActive: Bool
}

struct CreateVenueRequest: Codable {
    let name: String
    let address: String
    let city: String
    let country: String
    let phone: String
    let capacity: Int
    let isActive: Bool
}

struct CreateEventRequest: Codable {
    let name: String
    let description: String
    let date: String          // ISO8601 (UTC, "...Z")
    let categoryId: Int
    let venueId: Int?
    let price: Double?
    let imageUrl: String?
    let isActive: Bool
    let isFeatured: Bool
}

struct CreateSectionRequest: Codable {
    let venueId: Int
    let name: String
    let rows: Int
    let cols: Int
    let isActive: Bool
}

struct CreateEventSectionRequest: Codable {
    let eventId: Int
    let sectionId: Int
    let basePrice: Double
}

// MARK: - Liste yanıtları (dropdown + mevcut kayıtlar)

struct AdminCategory: Codable, Identifiable {
    let id: Int
    let name: String
    let icon: String
    let isActive: Bool
}

struct AdminVenue: Codable, Identifiable {
    let id: Int
    let name: String
    let city: String
}

struct AdminEventItem: Codable, Identifiable {
    let id: Int
    let name: String
    let venueName: String?
    let isActive: Bool
    let isFeatured: Bool
}

struct AdminSectionItem: Codable, Identifiable {
    let id: Int
    let name: String
    let venueName: String?
    let totalCapacity: Int
    let isActive: Bool
}

struct AdminEventSectionItem: Codable, Identifiable {
    let id: Int
    let eventName: String?
    let sectionName: String?
    let basePrice: Double
}

// MARK: - Genel oluşturma yanıtı

struct AdminCreateResponse: Codable {
    let message: String
    let id: Int?
}
