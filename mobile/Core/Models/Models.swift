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



// MARK: - Auth Responses

struct LoginResponse: Codable {
    let message: String
    let id: Int
    let name: String
    let email: String
}

struct UserResponse: Codable {
    let id: Int
    let name: String
    let surname: String?
    let email: String
}
