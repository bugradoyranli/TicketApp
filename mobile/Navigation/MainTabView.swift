import SwiftUI

// Uygulamanın ana navigasyon yapısı.
// TabView, alttaki 5 butonu ve her butona karşılık gelen ekranı yönetir.
// selectedTab hangi sekmenin açık olduğunu tutar (0=Ara, 1=Favoriler...)

struct MainTabView: View {
   @State private var selectedTab = 0  // Uygulama açılınca ilk sekme (Ara) aktif
   @AppStorage("isAdmin") private var isAdmin: Bool = false

   var body: some View {
       TabView(selection: $selectedTab) {
           
           // --- Sekme 1: Ara ---
           SearchView()
               .tabItem {
                   Label("Ara", systemImage: selectedTab == 0 ? "magnifyingglass.circle.fill" : "magnifyingglass")
               }
               .tag(0)
           
           // --- Sekme 2: Favoriler ---
           FavoritesView()
               .tabItem {
                   Label("Favoriler", systemImage: selectedTab == 1 ? "heart.fill" : "heart")
               }
               .tag(1)
           
           // --- Sekme 3: Biletlerim ---
           TicketsView()
               .tabItem {
                   Label("Biletlerim", systemImage: selectedTab == 2 ? "ticket.fill" : "ticket")
               }
               .tag(2)
           
           // --- Sekme 4: Yönetim (sadece admin) ---
           if isAdmin {
               AdminView()
                   .tabItem {
                       Label("Yönetim", systemImage: selectedTab == 3 ? "slider.horizontal.3" : "slider.horizontal.3")
                   }
                   .tag(3)
           }
           
           // --- Sekme 5: Profil ---
           ProfileView()
               .tabItem {
                   Label("Profil", systemImage: selectedTab == 4 ? "person.fill" : "person")
               }
               .tag(4)

       }
       
       .tint(Color.bordo) // Aktif sekmenin rengi
   }
}

#Preview {
   MainTabView()
}











