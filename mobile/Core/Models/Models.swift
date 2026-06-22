import SwiftUI

// MARK: - Category


struct Category: Codable, Identifiable {
    let id: Int
    let name: String
    let icon: String // SFSymbol ismi gelecek (örn: "film", "sportscourt")
    
    // JSON'daki büyük harf ID'yi Swift'teki küçük harf id'ye eşlemek için
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case icon = "icon"
    }
}


struct Event: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let date: String
    let venueName: String
    let price: Double?
    let imageUrl: String?
    let city: String?
}

// MARK: - FeaturedEvent
struct FeaturedEvent: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let date: String
    let gradientColors: [Color]
}

struct SportTickets: Identifiable {
   let id = UUID()
    let name: String
    let date:String
    
}


// MARK: - Auth Responses

struct LoginResponse: Codable {
    let message: String
    let token: String
    let user: UserData
}

struct UserData: Codable {
    let id: Int
        let name: String
        let surname: String
        let email: String
        let isAdmin: Bool?   // backend her zaman döner; eski yanıtlara karşı opsiyonel
}

struct UserResponse: Codable {
    let Id: Int
    let Name: String
    let Surname: String?
    let Email: String
}
