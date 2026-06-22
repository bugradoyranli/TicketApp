import SwiftUI
import Combine
@MainActor
class TicketsViewModel: ObservableObject {
    @Published var tickets: [MyTicket] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            // Kullanıcı sunucuda token'dan belirleniyor; userId göndermiyoruz.
            let result: [MyTicket] = try await NetworkManager.shared.request(
                endpoint: "/Tickets/my",
                method: "GET"
            )
            self.tickets = result
        } catch let error as NetworkError {
            self.errorMessage = error.localizedDescription
        } catch {
            self.errorMessage = "Biletler yüklenemedi."
        }
        isLoading = false
    }

    func cancel(_ ticket: MyTicket) async {
        isLoading = true
        errorMessage = nil
        do {
            // Sahiplik kontrolü sunucuda token üzerinden yapılıyor.
            let _: CancelTicketResponse = try await NetworkManager.shared.request(
                endpoint: "/Tickets/\(ticket.ticketId)",
                method: "DELETE"
            )
            // Başarılı: listeden çıkar (koltuk backend'de otomatik boşa düşer).
            tickets.removeAll { $0.ticketId == ticket.ticketId }
        } catch let error as NetworkError {
            self.errorMessage = error.localizedDescription
        } catch {
            self.errorMessage = "Bilet iptal edilemedi."
        }
        isLoading = false
    }
}

struct CancelTicketResponse: Codable {
    let message: String
    let ticketId: Int
}
