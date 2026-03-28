import SwiftUI


struct ProfileView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                // --- Avatar ---
                Circle()
                    .fill(Color.purple.opacity(0.15))
                    .frame(width: 90, height: 90)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.purple)
                    )

                Text("Kullanıcı Adı")
                    .font(.title2.bold())

                Text("kullanici@email.com")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Divider()

                
                List {
                    Label("Hesap Bilgileri", systemImage: "person.circle")
                    Label("Bildirimler",     systemImage: "bell")
                    Label("Gizlilik",        systemImage: "lock")
                    Label("Yardım",          systemImage: "questionmark.circle")

                    
                    Label("Çıkış Yap", systemImage: "arrow.right.circle")
                        .foregroundStyle(.red)
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Profil")
        }
    }
}

#Preview {
    ProfileView()
}
