import SwiftUI



struct FeaturedEventCard: View {
    let event: Event
    var body: some View {
        ZStack(alignment: .bottomLeading) {

            LinearGradient(
                colors: [Color.bordo, Color.bordo.opacity(0.78)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // --- Dekoratif Daireler ---
            Circle()
                .fill(.white.opacity(0.18))
                .frame(width: 200, height: 200)
                .offset(x: 220, y: -60)

            Circle()
                .fill(.white.opacity(0.07))
                .frame(width: 130, height: 130)
                .offset(x: 280, y: 20)

            // --- İçerik: Tarih, Başlık, Alt Başlık, Buton ---
            VStack(alignment: .leading, spacing: 8) {
                Spacer()

                // Tarih badge'i
                Text(event.date.toTurkishDate())
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.white)
                    .clipShape(Capsule())
                    .foregroundStyle(Color.bordo)

                Text(event.name)
                    .font(.title2.bold())
                    .foregroundStyle(.white)

                Text(event.venueName)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))

                // Bilet Al butonu sağa yaslanmış
                HStack {
                    if let price = event.price {
                        Text("\(Int(price))₺").bold().foregroundStyle(.white)
                    }
                    Spacer()
                    NavigationLink {
                        SeatSelectionView(event: event)
                    } label: {
                        Text("Bilet Al")
                            .font(.subheadline.bold())
                            .foregroundStyle(Color.bordo)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(.white)
                            .clipShape(Capsule())
                    }
                }
                .padding(.top, 4)
            }
            .padding(20)
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.bordo.opacity(0.25), radius: 12, y: 6)
    }
}



