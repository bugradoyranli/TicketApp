import SwiftUI

struct AdminLinkView: View {
    @EnvironmentObject private var vm: AdminViewModel

    @State private var selectedEventId: Int?
    @State private var selectedSectionId: Int?
    @State private var basePrice = ""
    @State private var submitting = false

    var body: some View {
        Form {
            if vm.successMessage != nil || vm.errorMessage != nil {
                Section { AdminResultBanner(success: vm.successMessage, error: vm.errorMessage) }
            }

            Section("Etkinliği Session'a Bağla") {
                Picker("Etkinlik", selection: $selectedEventId) {
                    Text("Seçiniz").tag(Int?.none)
                    ForEach(vm.events) { e in
                        Text(e.name).tag(Int?.some(e.id))
                    }
                }

                Picker("Session (Salon)", selection: $selectedSectionId) {
                    Text("Seçiniz").tag(Int?.none)
                    ForEach(vm.sections) { s in
                        Text("\(s.name) (\(s.totalCapacity) koltuk)").tag(Int?.some(s.id))
                    }
                }

                TextField("Taban fiyat (örn: 150)", text: $basePrice)
                    .keyboardType(.decimalPad)

                Button {
                    Task { await submit() }
                } label: {
                    HStack {
                        if submitting { ProgressView() }
                        Text("Bağla")
                    }
                }
                .disabled(!canSubmit || submitting)
            }

            if vm.events.isEmpty || vm.sections.isEmpty {
                Section {
                    Label("Bağlama için en az bir etkinlik ve bir session gerekli.",
                          systemImage: "info.circle")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Section("Mevcut Bağlantılar (\(vm.links.count))") {
                if vm.links.isEmpty {
                    Text("Henüz bağlantı yok.").foregroundStyle(.secondary)
                } else {
                    ForEach(vm.links) { link in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(link.eventName ?? "Etkinlik #\(link.id)")
                                .font(.subheadline.weight(.medium))
                            HStack {
                                Image(systemName: "arrow.turn.down.right")
                                    .font(.caption2).foregroundStyle(.secondary)
                                Text(link.sectionName ?? "-")
                                Spacer()
                                Text("\(link.basePrice, specifier: "%.0f") ₺")
                                    .foregroundStyle(Color.bordo)
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Bağlama")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { vm.successMessage = nil; vm.errorMessage = nil }
    }

    private var canSubmit: Bool {
        selectedEventId != nil &&
        selectedSectionId != nil &&
        Double(basePrice.replacingOccurrences(of: ",", with: ".")) != nil
    }

    private func submit() async {
        guard let eventId = selectedEventId,
              let sectionId = selectedSectionId,
              let price = Double(basePrice.replacingOccurrences(of: ",", with: ".")) else { return }
        submitting = true
        let ok = await vm.linkEventSection(eventId: eventId, sectionId: sectionId, basePrice: price)
        if ok {
            basePrice = ""
            selectedSectionId = nil
        }
        submitting = false
    }
}
