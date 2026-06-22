import SwiftUI
import Combine

/// Admin panelinin tamamı için tek paylaşılan ViewModel.
/// Tüm listeleri ve oluşturma işlemlerini yönetir; alt ekranlar bunu
/// @EnvironmentObject ile paylaşır (etkinlik formundaki kategori/mekan,
/// bağlama ekranındaki etkinlik/session dropdown'ları aynı kaynaktan beslenir).
@MainActor
final class AdminViewModel: ObservableObject {

    @Published var categories: [AdminCategory] = []
    @Published var venues: [AdminVenue] = []
    @Published var events: [AdminEventItem] = []
    @Published var sections: [AdminSectionItem] = []
    @Published var links: [AdminEventSectionItem] = []

    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?

    private let net = NetworkManager.shared

    private let isoFormatter: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        f.timeZone = TimeZone(identifier: "UTC")
        return f
    }()

    // MARK: - Yükleyiciler

    func loadAll() async {
        isLoading = true
        await loadCategories()
        await loadVenues()
        await loadEvents()
        await loadSections()
        await loadLinks()
        isLoading = false
    }

    func loadCategories() async {
        do { categories = try await net.request(endpoint: "/Admin/categories", method: "GET") }
        catch { setError(error) }
    }

    func loadVenues() async {
        do { venues = try await net.request(endpoint: "/Admin/venues", method: "GET") }
        catch { setError(error) }
    }

    func loadEvents() async {
        do { events = try await net.request(endpoint: "/Admin/events", method: "GET") }
        catch { setError(error) }
    }

    func loadSections() async {
        do { sections = try await net.request(endpoint: "/Admin/sections", method: "GET") }
        catch { setError(error) }
    }

    func loadLinks() async {
        do { links = try await net.request(endpoint: "/Admin/event-sections", method: "GET") }
        catch { setError(error) }
    }

    // MARK: - Oluşturma

    @discardableResult
    func createCategory(name: String, icon: String, isActive: Bool) async -> Bool {
        let body = CreateCategoryRequest(name: name, icon: icon, isActive: isActive)
        let ok = await post(endpoint: "/Admin/categories", body: body)
        if ok { await loadCategories() }
        return ok
    }

    @discardableResult
    func createVenue(name: String, address: String, city: String,
                     country: String, phone: String, capacity: Int, isActive: Bool) async -> Bool {
        let body = CreateVenueRequest(name: name, address: address, city: city,
                                      country: country, phone: phone,
                                      capacity: capacity, isActive: isActive)
        let ok = await post(endpoint: "/Admin/venues", body: body)
        if ok { await loadVenues() }
        return ok
    }

    @discardableResult
    func createEvent(name: String, description: String, date: Date,
                     categoryId: Int, venueId: Int?, price: Double?,
                     imageUrl: String?, isActive: Bool, isFeatured: Bool) async -> Bool {
        let body = CreateEventRequest(
            name: name,
            description: description,
            date: isoFormatter.string(from: date),
            categoryId: categoryId,
            venueId: venueId,
            price: price,
            imageUrl: (imageUrl?.isEmpty == false) ? imageUrl : nil,
            isActive: isActive,
            isFeatured: isFeatured
        )
        let ok = await post(endpoint: "/Admin/events", body: body)
        if ok { await loadEvents() }
        return ok
    }

    @discardableResult
    func createSection(venueId: Int, name: String, rows: Int, cols: Int, isActive: Bool) async -> Bool {
        let body = CreateSectionRequest(venueId: venueId, name: name, rows: rows, cols: cols, isActive: isActive)
        let ok = await post(endpoint: "/Admin/sections", body: body)
        if ok { await loadSections() }
        return ok
    }

    @discardableResult
    func linkEventSection(eventId: Int, sectionId: Int, basePrice: Double) async -> Bool {
        let body = CreateEventSectionRequest(eventId: eventId, sectionId: sectionId, basePrice: basePrice)
        let ok = await post(endpoint: "/Admin/event-sections", body: body)
        if ok { await loadLinks() }
        return ok
    }

    // MARK: - Ortak POST yardımcısı

    private func post<Body: Codable>(endpoint: String, body: Body) async -> Bool {
        errorMessage = nil
        successMessage = nil
        guard let data = try? JSONEncoder().encode(body) else {
            errorMessage = "İstek hazırlanamadı."
            return false
        }
        do {
            let res: AdminCreateResponse = try await net.request(endpoint: endpoint, method: "POST", body: data)
            successMessage = res.message
            return true
        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
            return false
        } catch {
            errorMessage = "Beklenmedik bir hata oluştu."
            return false
        }
    }

    private func setError(_ error: Error) {
        if let e = error as? NetworkError { errorMessage = e.localizedDescription }
        else { errorMessage = "Veriler yüklenemedi." }
    }
}
