import Foundation

/// Etkinlik listelerine uygulanan filtre. Hem "Öne Çıkanlar" hem de
/// kategori ekranında aynı mantık kullanılır (client-side filtreleme).
struct EventFilter: Equatable {
    var city: String? = nil          // nil = tümü
    var venue: String? = nil         // nil = tümü
    var minPrice: Double? = nil
    var maxPrice: Double? = nil
    var startDate: Date? = nil
    var endDate: Date? = nil

    var isActive: Bool {
        city != nil || venue != nil || minPrice != nil
            || maxPrice != nil || startDate != nil || endDate != nil
    }

    /// Aktif filtre grubu sayısı (butondaki rozet için).
    var activeCount: Int {
        var count = 0
        if city != nil { count += 1 }
        if venue != nil { count += 1 }
        if minPrice != nil || maxPrice != nil { count += 1 }
        if startDate != nil || endDate != nil { count += 1 }
        return count
    }

    func apply(to events: [Event]) -> [Event] {
        events.filter { event in
            if let city, event.city != city { return false }
            if let venue, event.venueName != venue { return false }
            if let minPrice, (event.price ?? 0) < minPrice { return false }
            if let maxPrice, (event.price ?? .greatestFiniteMagnitude) > maxPrice { return false }
            if let startDate {
                guard let d = event.dateValue, d >= startDate.startOfDay else { return false }
            }
            if let endDate {
                guard let d = event.dateValue, d <= endDate.endOfDay else { return false }
            }
            return true
        }
    }
}

extension Event {
    /// date string'ini Date'e çevirir (ISO 8601, kesirli saniyeli/saniyesiz).
    var dateValue: Date? {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let d = iso.date(from: date) { return d }
        iso.formatOptions = [.withInternetDateTime]
        if let d = iso.date(from: date) { return d }

        // Yedek: "yyyy-MM-dd'T'HH:mm:ssZ"
        let fallback = DateFormatter()
        fallback.locale = Locale(identifier: "en_US_POSIX")
        fallback.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return fallback.date(from: date)
    }
}

extension Date {
    var startOfDay: Date { Calendar.current.startOfDay(for: self) }
    var endOfDay: Date {
        Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self) ?? self
    }
}
