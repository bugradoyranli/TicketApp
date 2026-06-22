import SwiftUI

struct AdminEventView: View {
    @EnvironmentObject private var vm: AdminViewModel

    @State private var name = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var selectedCategoryId: Int?
    @State private var selectedVenueId: Int?      // opsiyonel
    @State private var price = ""
    @State private var imageUrl = ""
    @State private var isActive = true
    @State private var isFeatured = false
    @State private var submitting = false

    var body: some View {
        Form {
            if vm.successMessage != nil || vm.errorMessage != nil {
                Section { AdminResultBanner(success: vm.successMessage, error: vm.errorMessage) }
            }

            Section("Yeni Etkinlik") {
                TextField("Ad", text: $name)
                TextField("Açıklama", text: $description, axis: .vertical)
                    .lineLimit(2...4)

                DatePicker("Tarih", selection: $date)

                Picker("Kategori", selection: $selectedCategoryId) {
                    Text("Seçiniz").tag(Int?.none)
                    ForEach(vm.categories) { c in
                        Text(c.name).tag(Int?.some(c.id))
                    }
                }

                Picker("Mekan (opsiyonel)", selection: $selectedVenueId) {
                    Text("Yok").tag(Int?.none)
                    ForEach(vm.venues) { v in
                        Text("\(v.name) — \(v.city)").tag(Int?.some(v.id))
                    }
                }

                TextField("Fiyat (opsiyonel)", text: $price)
                    .keyboardType(.decimalPad)
                TextField("Görsel URL (opsiyonel)", text: $imageUrl)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)

                Toggle("Aktif", isOn: $isActive)
                Toggle("Öne Çıkan", isOn: $isFeatured)

                Button {
                    Task { await submit() }
                } label: {
                    HStack {
                        if submitting { ProgressView() }
                        Text("Etkinlik Ekle")
                    }
                }
                .disabled(!canSubmit || submitting)
            }

            if vm.categories.isEmpty {
                Section {
                    Label("Önce en az bir kategori eklemelisin.", systemImage: "info.circle")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Section("Mevcut Etkinlikler (\(vm.events.count))") {
                if vm.events.isEmpty {
                    Text("Henüz etkinlik yok.").foregroundStyle(.secondary)
                } else {
                    ForEach(vm.events) { e in
                        VStack(alignment: .leading, spacing: 2) {
                            HStack {
                                Text(e.name)
                                if e.isFeatured {
                                    Image(systemName: "star.fill")
                                        .font(.caption2).foregroundStyle(.yellow)
                                }
                                if !e.isActive {
                                    Text("Pasif").font(.caption2).foregroundStyle(.secondary)
                                }
                            }
                            if let venue = e.venueName {
                                Text(venue).font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Etkinlikler")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { vm.successMessage = nil; vm.errorMessage = nil }
    }

    private var canSubmit: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !description.trimmingCharacters(in: .whitespaces).isEmpty &&
        selectedCategoryId != nil
    }

    private func submit() async {
        guard let categoryId = selectedCategoryId else { return }
        submitting = true
        let ok = await vm.createEvent(
            name: name.trimmingCharacters(in: .whitespaces),
            description: description.trimmingCharacters(in: .whitespaces),
            date: date,
            categoryId: categoryId,
            venueId: selectedVenueId,
            price: Double(price.replacingOccurrences(of: ",", with: ".")),
            imageUrl: imageUrl.trimmingCharacters(in: .whitespaces),
            isActive: isActive,
            isFeatured: isFeatured
        )
        if ok {
            name = ""; description = ""; price = ""; imageUrl = ""
            isFeatured = false
        }
        submitting = false
    }
}
