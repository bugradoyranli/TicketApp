import Foundation

extension String {
    ///  "2026-04-25T00:00:00Z" formatını "25 Nisan 2026" formatına çevirir.
    func toTurkishDate() -> String {
        let inputFormatter = DateFormatter()
  
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = inputFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            // İstediğin çıktı formatı: gün Ay(isim) yıl
            outputFormatter.dateFormat = "dd MMMM yyyy"
            outputFormatter.locale = Locale(identifier: "tr_TR")
            return outputFormatter.string(from: date)
        }
        
        // Eğer formatlama başarısız olursa orijinal metni dön
        return self
    }

    /// ISO 8601 (kesirli saniyeli/saniyesiz) tarih-saati "25 Nis 2026, 20:00" formatına çevirir.
    func toTurkishDateTime() -> String {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        var date = iso.date(from: self)
        if date == nil {
            iso.formatOptions = [.withInternetDateTime]
            date = iso.date(from: self)
        }
        guard let date else { return self }

        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "tr_TR")
        outputFormatter.dateFormat = "dd MMM yyyy, HH:mm"
        return outputFormatter.string(from: date)
    }
}
