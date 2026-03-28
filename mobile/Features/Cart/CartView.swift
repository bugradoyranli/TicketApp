import SwiftUI


struct CartView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Spacer()

                Image(systemName: "cart")
                    .font(.system(size: 56))
                    .foregroundStyle(.secondary)

                Text("Sepet boş")
                    .font(.title3.bold())

                Text("Eklediğin biletler burada görünecek.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Spacer()
            }
            .padding()
            .navigationTitle("Sepet")
        }
    }
}

#Preview {
    CartView()
}
