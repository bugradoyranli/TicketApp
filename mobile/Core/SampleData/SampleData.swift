import SwiftUI


// MARK: - Kategoriler
let sampleCategories: [Category] = [
    Category(name: "Konser",   icon: "music.mic.circle.fill",       color: .purple),
    Category(name: "Tiyatro",  icon: "theatermasks",    color: .red),
    Category(name: "Spor",     icon: "sportscourt",     color: .green),
    Category(name: "Festival", icon: "party.popper",    color: .orange),
    Category(name: "Stand-up", icon: "face.smiling",    color: .yellow),
    Category(name: "Sergi",    icon: "photo.artframe",  color: .cyan),
    Category(name: "Sinema",   icon: "film",            color: .pink),
    Category(name: "Dans",     icon: "figure.dance",    color: .indigo),
]

// MARK: - Öne Çıkan Etkinlikler
let featuredEvents: [FeaturedEvent] = [
    FeaturedEvent(
        title: "Coldplay World Tour",
        subtitle: "İstanbul Atatürk Havalimanı Sahnesi",
        date: "15 Haziran 2025",
        gradientColors: [
            Color(red: 0.1, green: 0.1, blue: 0.4),
            Color(red: 0.5, green: 0.1, blue: 0.6)
        ]
    ),
    FeaturedEvent(
        title: "Hamlet",
        subtitle: "Devlet Tiyatrosu · Kadıköy Sahnesi",
        date: "22 Mart 2025",
        gradientColors: [
            Color(red: 0.6, green: 0.1, blue: 0.1),
            Color(red: 0.2, green: 0.05, blue: 0.05)
        ]
    ),
    FeaturedEvent(
        title: "Galatasaray vs Fenerbahçe",
        subtitle: "Rams Park · Süper Lig",
        date: "5 Nisan 2025",
        gradientColors: [
            Color(red: 0.8, green: 0.5, blue: 0.0),
            Color(red: 0.2, green: 0.5, blue: 0.1)
        ]
    ),
]
