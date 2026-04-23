import SwiftUI
@main
struct TicketAppApp: App {
    // AppStorage sayesinde uygulama kapansa da bu değer saklanır
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                // Giriş başarılıysa kullanıcıyı ana sayfaya gönder
                MainTabView()
            } else {
                // Giriş yapılmamışsa Login/Register ekranını göster
                LoginView()
            }
        }
    }
}
