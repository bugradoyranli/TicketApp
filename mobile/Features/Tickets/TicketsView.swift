import SwiftUI


struct TicketsView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Spacer()

                Image(systemName: "ticket")
                    .font(.system(size: 56))
                    .foregroundStyle(.secondary)

                Text("Biletiniz bulunmuyor")
                    .font(.title3.bold())

                Text("Satın aldığın biletler burada görünecek.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Spacer()
            }
            .padding()
            .navigationTitle("Biletlerim")
        }
    }
}

#Preview {
    TicketsView()
}
