import SwiftUI

// Uygulamanın başladığı yer.
// @main ile işaretlenmiş struct, iOS'a "buradan başla" der.
// body içinde WindowGroup, uygulamanın ana penceresini tanımlar.



@main
struct TicketAppApp: App {
    var body: some Scene {
        WindowGroup {
          
            MainTabView()
        }
    }
}
