import SwiftUI


struct FavoritesView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Spacer()

                Image(systemName: "heart.slash")
                    .font(.system(size: 56))
                    .foregroundStyle(.secondary)

                Text("Henüz favori yok")
                    .font(.title3.bold())

                Text("Beğendiğin etkinlikleri favorilere ekle.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Spacer()
            }
            .padding()
            .navigationTitle("Favoriler")
        }
    }
}

#Preview {
    FavoritesView()
}
