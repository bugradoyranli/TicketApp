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
        title: "Galatasaray - Fenerbahçe",
        subtitle: "Rams Park · Süper Lig",
        date: "26 Nisan 2025",
        gradientColors: [
            Color(red: 0.8, green: 0.5, blue: 0.0),
            Color(red: 0.2, green: 0.5, blue: 0.1)
        ]
    ),
    
    FeaturedEvent(
        title: "Meçhul Paşa",
        subtitle: "Bostanlı Suat Taşer Salonu",
        date: "20 Mayıs 2026",
        gradientColors: [
            Color(red: 0.1, green: 0.1, blue: 0.4),
            Color(red: 0.5, green: 0.1, blue: 0.6)
        ]
    ),
    FeaturedEvent(
        title: "Bir Baba Hamlet",
        subtitle: "Kadıköy Baba Sahne",
        date: "2 Mayıs 2026",
        gradientColors: [
            Color(red: 0.6, green: 0.1, blue: 0.1),
            Color(red: 0.2, green: 0.05, blue: 0.05)
        ]
    ),

]
