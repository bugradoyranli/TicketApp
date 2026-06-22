import SwiftUI
struct EventRowCard: View {
    let event: Event
    
    var body: some View {
        HStack(spacing: 15) {
            // Etkinlik Resmi (Varsa)
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 80, height: 80)
                .overlay(Image(systemName: "photo").foregroundStyle(.secondary))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(event.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(event.venueName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                HStack {
                    Text(event.date.toTurkishDate()) // Tarih formatlamayı unutma
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.bordo)
                    Spacer()
                    if let price = event.price {
                        Text("\(Int(price))₺")
                            .font(.subheadline.bold())
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}
