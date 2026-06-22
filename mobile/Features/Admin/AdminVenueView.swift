import SwiftUI

struct AdminVenueView: View {
    @EnvironmentObject private var vm: AdminViewModel

    @State private var name = ""
    @State private var address = ""
    @State private var city = ""
    @State private var country = "Türkiye"
    @State private var phone = ""
    @State private var capacity = ""
    @State private var isActive = true
    @State private var submitting = false

    var body: some View {
        Form {
            if vm.successMessage != nil || vm.errorMessage != nil {
                Section { AdminResultBanner(success: vm.successMessage, error: vm.errorMessage) }
            }

            Section("Yeni Mekan") {
                TextField("Ad (örn: Capacity AVM Sinema)", text: $name)
                TextField("Adres", text: $address)
                TextField("Şehir", text: $city)
                TextField("Ülke", text: $country)
                TextField("Telefon", text: $phone)
                    .keyboardType(.phonePad)
                TextField("Kapasite", text: $capacity)
                    .keyboardType(.numberPad)
                Toggle("Aktif", isOn: $isActive)

                Button {
                    Task { await submit() }
                } label: {
                    HStack {
                        if submitting { ProgressView() }
                        Text("Mekan Ekle")
                    }
                }
                .disabled(!canSubmit || submitting)
            }

            Section("Mevcut Mekanlar (\(vm.venues.count))") {
                if vm.venues.isEmpty {
                    Text("Henüz mekan yok.").foregroundStyle(.secondary)
                } else {
                    ForEach(vm.venues) { v in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(v.name)
                            Text(v.city).font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Mekanlar")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { vm.successMessage = nil; vm.errorMessage = nil }
    }

    private var canSubmit: Bool {
        ![name, address, city, country, phone].contains(where: {
            $0.trimmingCharacters(in: .whitespaces).isEmpty
        })
    }

    private func submit() async {
        submitting = true
        let ok = await vm.createVenue(
            name: name.trimmingCharacters(in: .whitespaces),
            address: address.trimmingCharacters(in: .whitespaces),
            city: city.trimmingCharacters(in: .whitespaces),
            country: country.trimmingCharacters(in: .whitespaces),
            phone: phone.trimmingCharacters(in: .whitespaces),
            capacity: Int(capacity) ?? 0,
            isActive: isActive
        )
        if ok {
            name = ""; address = ""; city = ""; phone = ""; capacity = ""
        }
        submitting = false
    }
}
