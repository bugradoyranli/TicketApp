import SwiftUI
import Combine
@MainActor
class SeatSelectionViewModel: ObservableObject {
    @Published var section: SectionLayout?
    @Published var bookedSeats: Set<String> = []
    @Published var selectedSeats: Set<String> = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var didPurchase = false

    let eventId: Int

    init(eventId: Int) {
        self.eventId = eventId
    }

    /// Etkinliğin koltuk düzenini ve dolu koltuklarını çeker.
    func loadLayout() async {
        isLoading = true
        errorMessage = nil
        do {
            let response: EventLayoutResponse = try await NetworkManager.shared.request(
                endpoint: "/Seating/event/\(eventId)",
                method: "GET"
            )
            // Sinema senaryosunda etkinlik tek salonda; ilk salonu alıyoruz.
            if let first = response.sections.first {
                self.section = first
                self.bookedSeats = Set(first.bookedSeats)
            } else {
                self.errorMessage = "Bu etkinlik için koltuk düzeni tanımlı değil."
            }
        } catch let error as NetworkError {
            self.errorMessage = error.localizedDescription
        } catch {
            self.errorMessage = "Koltuklar yüklenirken bir hata oluştu."
        }
        isLoading = false
    }

    func state(for seatId: String) -> SeatState {
        if bookedSeats.contains(seatId) { return .booked }
        if selectedSeats.contains(seatId) { return .selected }
        return .available
    }

    func toggle(_ seatId: String) {
        guard !bookedSeats.contains(seatId) else { return }
        if selectedSeats.contains(seatId) {
            selectedSeats.remove(seatId)
        } else {
            selectedSeats.insert(seatId)
        }
    }

    var selectedCount: Int { selectedSeats.count }

    var totalPrice: Double { (section?.basePrice ?? 0) * Double(selectedSeats.count) }

    /// Seçili koltukları okunaklı şekilde sıralar (A1, A2, B3 ...).
    var selectedSeatsSorted: [String] {
        selectedSeats.sorted { lhs, rhs in
            let l = parse(lhs), r = parse(rhs)
            if l.row != r.row { return l.row < r.row }
            return l.col < r.col
        }
    }

    private func parse(_ id: String) -> (row: String, col: Int) {
        let row = id.prefix { $0.isLetter }
        let col = Int(id.dropFirst(row.count)) ?? 0
        return (String(row), col)
    }

    func purchase() async {
        guard let section, !selectedSeats.isEmpty else { return }

        isLoading = true
        errorMessage = nil

        let request = SeatPurchaseRequest(
            eventId: eventId,
            sectionId: section.sectionId,
            seatIds: Array(selectedSeats)
        )

        guard let body = try? JSONEncoder().encode(request) else {
            errorMessage = "İstek hazırlanamadı."
            isLoading = false
            return
        }

        do {
            let _: SeatPurchaseResponse = try await NetworkManager.shared.request(
                endpoint: "/Seating/purchase",
                method: "POST",
                body: body
            )
            // Başarılı: satın alınan koltukları dolu olarak işaretle, seçimi temizle.
            bookedSeats.formUnion(selectedSeats)
            selectedSeats.removeAll()
            didPurchase = true
        } catch let error as NetworkError {
            self.errorMessage = error.localizedDescription
            // Sunucu "bu sırada satıldı" derse düzeni tazele.
            await loadLayout()
        } catch {
            self.errorMessage = "Satın alma yapılamadı."
        }
        isLoading = false
    }
}

enum SeatState {
    case available
    case selected
    case booked
}
