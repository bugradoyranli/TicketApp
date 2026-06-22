
import SwiftUI
import Combine

@MainActor
class EventViewModel: ObservableObject {
    @Published var featuredEvents: [Event] = []
    @Published var eventsByCategory: [Event] = [] // Kategoriye özel etkinlikler
    @Published var isLoading = false
    
    func fetchFeaturedEvents() async {
        isLoading = true
        do {
            // Backend rotan: api/Event/featured
            let result: [Event] = try await NetworkManager.shared.request(endpoint: "/Event/featured", method: "GET")
            self.featuredEvents = result
        } catch {
            print("Öne çıkan etkinlikler çekilemedi: \(error.localizedDescription)")
        }
        isLoading = false
    }
    
    func fetchEventsByCategory(categoryId: Int) async {
            isLoading = true
          print(categoryId)
            do {
                // Backend rotan: api/Event/category/{id}
                let result: [Event] = try await NetworkManager.shared.request(
                    endpoint: "/Event/category/\(categoryId)",
                    method: "GET"
                )
                self.eventsByCategory = result
            } catch {
                print("Kategori etkinlikleri çekilemedi: \(error.localizedDescription)")
            }
            isLoading = false
        }
    
    
    
    
   
}
