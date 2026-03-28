import SwiftUI



struct FeaturedEventCard: View {
    let event: FeaturedEvent     

    var body: some View {
        ZStack(alignment: .bottomLeading) {

         
            LinearGradient(
                colors: event.gradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // --- Dekoratif Daireler ---
            Circle()
                .fill(.white.opacity(0.05))
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
                Text(event.date)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.white.opacity(0.2))
                    .clipShape(Capsule())
                    .foregroundStyle(.white)

                Text(event.title)
                    .font(.title2.bold())
                    .foregroundStyle(.white)

                Text(event.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))

                // Bilet Al butonu sağa yaslanmış
                HStack {
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("Bilet Al")
                            .font(.subheadline.bold())
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(.white)
                            .foregroundStyle(event.gradientColors[0])
                            .clipShape(Capsule())
                    }
                }
                .padding(.top, 4)
            }
            .padding(20)
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        // Kartın kendi renginde gölge — daha canlı görünüm için
        .shadow(color: event.gradientColors[0].opacity(0.4), radius: 16, y: 8)
    }
}

#Preview {
    FeaturedEventCard(event: featuredEv ents[0])
        .padding()
}



