
import SwiftUI
import Combine

class CategoryViewModel: ObservableObject {
    
    @Published var categories: [Category] = []
    @Published var isLoading = false
        
        @MainActor
        func fetchCategories() async {
            isLoading = true
            do {
                // NetworkManager.shared.request kullanarak merkezi baseURL üzerinden çeker
                let fetchedCategories: [Category] = try await NetworkManager.shared.request(endpoint: "/Category", method: "GET")
                print(fetchedCategories)
                self.categories = fetchedCategories
                self.isLoading = false
            } catch {
                print("Kategori yükleme hatası: \(error.localizedDescription)")
                self.isLoading = false
            }
        }
}
