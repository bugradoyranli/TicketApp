import SwiftUI

// MARK: - Category


struct Category: Identifiable {
    let id = UUID()
    let name: String   
    let icon: String    // SF Symbols icon name
    let color: Color
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
}

struct UserResponse: Codable {
    let Id: Int
    let Name: String
    let Surname: String?
    let Email: String
}
