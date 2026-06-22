import SwiftUI

struct AdminSessionView: View {
    @EnvironmentObject private var vm: AdminViewModel

    @State private var selectedVenueId: Int?
    @State private var name = "Salon 1"
    @State private var rows = 10
    @State private var cols = 10
    @State private var isActive = true
    @State private var submitting = false

    var body: some View {
        Form {
            if vm.successMessage != nil || vm.errorMessage != nil {
                Section { AdminResultBanner(success: vm.successMessage, error: vm.errorMessage) }
            }

            Section("Yeni Session (Salon)") {
                Picker("Mekan", selection: $selectedVenueId) {
                    Text("Seçiniz").tag(Int?.none)
                    ForEach(vm.venues) { v in
                        Text("\(v.name) — \(v.city)").tag(Int?.some(v.id))
                    }
                }

                TextField("Salon adı (örn: Salon 1)", text: $name)

                Stepper("Satır (A-Z): \(rows)", value: $rows, in: 1...26)
                Stepper("Sütun: \(cols)", value: $cols, in: 1...50)

                HStack {
                    Text("Toplam koltuk")
                    Spacer()
                    Text("\(rows * cols)")
                        .font(.headline)
                        .foregroundStyle(Color.bordo)
                }

                Toggle("Aktif", isOn: $isActive)

                Button {
                    Task { await submit() }
                } label: {
                    HStack {
                        if submitting { ProgressView() }
                        Text("Session Ekle")
                    }
                }
                .disabled(!canSubmit || submitting)
            }

            Section("Önizleme") {
                LayoutPreview(rows: rows, cols: cols)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
            }

            if vm.venues.isEmpty {
                Section {
                    Label("Önce en az bir mekan eklemelisin.", systemImage: "info.circle")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Section("Mevcut Session'lar (\(vm.sections.count))") {
                if vm.sections.isEmpty {
                    Text("Henüz session yok.").foregroundStyle(.secondary)
                } else {
                    ForEach(vm.sections) { s in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(s.name)
                            HStack(spacing: 6) {
                                if let v = s.venueName {
                                    Text(v)
                                }
                                Text("• \(s.totalCapacity) koltuk")
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Session'lar")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { vm.successMessage = nil; vm.errorMessage = nil }
    }

    private var canSubmit: Bool {
        selectedVenueId != nil && !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private func submit() async {
        guard let venueId = selectedVenueId else { return }
        submitting = true
        let ok = await vm.createSection(
            venueId: venueId,
            name: name.trimmingCharacters(in: .whitespaces),
            rows: rows,
            cols: cols,
            isActive: isActive
        )
        submitting = false
        _ = ok
    }
}

/// Salon düzeninin küçük görsel önizlemesi (perde + koltuk ızgarası).
private struct LayoutPreview: View {
    let rows: Int
    let cols: Int

    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.bordo.opacity(0.4))
                .frame(width: 140, height: 6)
            Text("PERDE").font(.system(size: 8, weight: .semibold)).tracking(3)
                .foregroundStyle(.secondary)

            VStack(spacing: 3) {
                ForEach(0..<min(rows, 12), id: \.self) { _ in
                    HStack(spacing: 3) {
                        ForEach(0..<min(cols, 16), id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.bordo.opacity(0.25))
                                .frame(width: 9, height: 9)
                        }
                        if cols > 16 { Text("…").font(.caption2).foregroundStyle(.secondary) }
                    }
                }
                if rows > 12 { Text("…").font(.caption2).foregroundStyle(.secondary) }
            }
        }
    }
}
