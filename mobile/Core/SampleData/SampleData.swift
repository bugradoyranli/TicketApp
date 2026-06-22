import SwiftUI


// MARK: - Kategoriler

// MARK: - Öne Çıkan Etkinlikler
let featuredEvents: [FeaturedEvent] = [
    
    FeaturedEvent(
        title: "Galatasaray - Fenerbahçe",
        subtitle: "Rams Park · Süper Lig",
        date: "26 Nisan 2025",
        gradientColors: [
            Color.bordo,
            Color.bordo.opacity(0.78)
        ]
    ),
    
    FeaturedEvent(
        title: "Meçhul Paşa",
        subtitle: "Bostanlı Suat Taşer Salonu",
        date: "20 Mayıs 2026",
        gradientColors: [
            Color(red: 0.40, green: 0.05, blue: 0.13),
            Color(red: 0.60, green: 0.10, blue: 0.22)
        ]
    ),
    FeaturedEvent(
        title: "Bir Baba Hamlet",
        subtitle: "Kadıköy Baba Sahne",
        date: "2 Mayıs 2026",
        gradientColors: [
            Color(red: 0.35, green: 0.04, blue: 0.10),
            Color(red: 0.55, green: 0.08, blue: 0.18)
        ]
    ),

]
