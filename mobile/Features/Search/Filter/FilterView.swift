import SwiftUI

struct FilterView: View {
    let events: [Event]
    @Binding var filter: EventFilter
    @Environment(\.dismiss) private var dismiss

    @State private var draft: EventFilter

    @State private var priceEnabled: Bool
    @State private var priceLow: Double
    @State private var priceHigh: Double

    @State private var dateEnabled: Bool
    @State private var startDate: Date
    @State private var endDate: Date

    init(events: [Event], filter: Binding<EventFilter>) {
        self.events = events
        self._filter = filter
        let f = filter.wrappedValue
        _draft = State(initialValue: f)

        let prices = events.compactMap { $0.price }
        let lo = prices.min() ?? 0
        let hi = prices.max() ?? 0
        _priceEnabled = State(initialValue: f.minPrice != nil || f.maxPrice != nil)
        _priceLow = State(initialValue: f.minPrice ?? lo)
        _priceHigh = State(initialValue: f.maxPrice ?? hi)

        _dateEnabled = State(initialValue: f.startDate != nil || f.endDate != nil)
        _startDate = State(initialValue: f.startDate ?? Date())
        _endDate = State(initialValue: f.endDate ?? Date())
    }

    private var cities: [String] { Array(Set(events.compactMap { $0.city })).sorted() }
    private var venues: [String] { Array(Set(events.map { $0.venueName })).sorted() }
    private var priceBounds: (lo: Double, hi: Double) {
        let prices = events.compactMap { $0.price }
        return (prices.min() ?? 0, prices.max() ?? 0)
    }
    private var canFilterPrice: Bool { priceBounds.hi > priceBounds.lo }

    var body: some View {
        NavigationStack {
            Form {
                Section("Konum") {
                    Picker("İl", selection: $draft.city) {
                        Text("Tümü").tag(String?.none)
                        ForEach(cities, id: \.self) { Text($0).tag(Optional($0)) }
                    }
                    Picker("Mekan", selection: $draft.venue) {
                        Text("Tümü").tag(String?.none)
                        ForEach(venues, id: \.self) { Text($0).tag(Optional($0)) }
                    }
                }

                if canFilterPrice {
                    Section("Fiyat") {
                        Toggle("Fiyata göre filtrele", isOn: $priceEnabled.animation())
                        if priceEnabled {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("En az: \(Int(priceLow))₺")
                                    .font(.subheadline)
                                Slider(value: $priceLow, in: priceBounds.lo...priceBounds.hi, step: 1)
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                Text("En çok: \(Int(priceHigh))₺")
                                    .font(.subheadline)
                                Slider(value: $priceHigh, in: priceBounds.lo...priceBounds.hi, step: 1)
                            }
                        }
                    }
                }

                Section("Tarih") {
                    Toggle("Tarihe göre filtrele", isOn: $dateEnabled.animation())
                    if dateEnabled {
                        DatePicker("Başlangıç", selection: $startDate, displayedComponents: .date)
                        DatePicker("Bitiş", selection: $endDate, displayedComponents: .date)
                    }
                }

                Section {
                    Button("Filtreleri Temizle", role: .destructive) { resetAll() }
                        .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Filtrele")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Kapat") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Uygula") { apply() }
                        .fontWeight(.semibold)
                }
            }
        }
    }

    private func resetAll() {
        draft = EventFilter()
        priceEnabled = false
        dateEnabled = false
        priceLow = priceBounds.lo
        priceHigh = priceBounds.hi
        startDate = Date()
        endDate = Date()
    }

    private func apply() {
        var result = EventFilter()
        result.city = draft.city
        result.venue = draft.venue
        if priceEnabled {
            result.minPrice = min(priceLow, priceHigh)
            result.maxPrice = max(priceLow, priceHigh)
        }
        if dateEnabled {
            result.startDate = min(startDate, endDate)
            result.endDate = max(startDate, endDate)
        }
        filter = result
        dismiss()
    }
}

/// Filtre penceresini açan, aktif filtre sayısını rozetle gösteren küçük buton.
struct FilterButton: View {
    let activeCount: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "line.3.horizontal.decrease")
                    .font(.title3)
                    .padding(12)
                    .background(activeCount > 0 ? Color.bordo : Color(.systemGray6))
                    .foregroundStyle(activeCount > 0 ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                if activeCount > 0 {
                    Text("\(activeCount)")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.bordo)
                        .frame(width: 16, height: 16)
                        .background(Circle().fill(.white))
                        .offset(x: 5, y: -5)
                }
            }
        }
    }
}
