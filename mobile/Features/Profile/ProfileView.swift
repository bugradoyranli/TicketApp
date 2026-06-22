import SwiftUI


struct ProfileView: View {
    
    @AppStorage("userName") var userName: String = "kullanici.adi"
    
    @AppStorage("userEmail") var userEmail: String = "email"
        
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 20) {
                
                // --- Avatar ---
                Circle()
                    .fill(Color.bordo.opacity(0.15))
                    .frame(width: 90, height: 90)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(Color.bordo)
                    )
                
                Text(userName)
                    .font(.title2.bold())
                
                Text(userName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Divider()
                
                
                List {
                    Label("Hesap Bilgileri", systemImage: "person.circle")
                    Label("Bildirimler",     systemImage: "bell")
                    Label("Gizlilik",        systemImage: "lock")
                    Label("Yardım",          systemImage: "questionmark.circle")
                    
                    
                    Button(role: .destructive) { // .destructive kırmızı tonu otomatik ayarlar
                        print("tıkladım")
                        isLoggedIn = false
                    } label: {
                        Label("Çıkış Yap", systemImage: "arrow.right.circle")
                    }
                    .listStyle(.insetGrouped)
                }
                .navigationTitle("Profil")
            }
        }
    }
    
    
}
#Preview {
    ProfileView()
}
