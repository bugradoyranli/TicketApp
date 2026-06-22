import SwiftUI

struct AdminCategoryView: View {
    @EnvironmentObject private var vm: AdminViewModel

    @State private var name = ""
    @State private var icon = "film"
    @State private var isActive = true
    @State private var submitting = false

    private let iconSuggestions = ["film", "sportscourt", "music.note", "theatermasks",
                                   "mic", "gamecontroller", "paintpalette", "star"]

    var body: some View {
        Form {
            if vm.successMessage != nil || vm.errorMessage != nil {
                Section { AdminResultBanner(success: vm.successMessage, error: vm.errorMessage) }
            }

            Section("Yeni Kategori") {
                TextField("Ad (örn: Sinema)", text: $name)

                TextField("SF Symbol adı (örn: film)", text: $icon)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(iconSuggestions, id: \.self) { symbol in
                            Button {
                                icon = symbol
                            } label: {
                                Image(systemName: symbol)
                                    .frame(width: 38, height: 38)
                                    .background(icon == symbol ? Color.bordo.opacity(0.2) : Color.secondary.opacity(0.1),
                                                in: RoundedRectangle(cornerRadius: 8))
                                    .foregroundStyle(icon == symbol ? Color.bordo : .primary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                }

                Toggle("Aktif", isOn: $isActive)

                Button {
                    Task { await submit() }
                } label: {
                    HStack {
                        if submitting { ProgressView() }
                        Text("Kategori Ekle")
                    }
                }
                .disabled(!canSubmit || submitting)
            }

            Section("Mevcut Kategoriler (\(vm.categories.count))") {
                if vm.categories.isEmpty {
                    Text("Henüz kategori yok.").foregroundStyle(.secondary)
                } else {
                    ForEach(vm.categories) { c in
                        HStack {
                            Image(systemName: c.icon)
                                .frame(width: 26)
                                .foregroundStyle(Color.bordo)
                            Text(c.name)
                            Spacer()
                            if !c.isActive {
                                Text("Pasif").font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Kategoriler")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { vm.successMessage = nil; vm.errorMessage = nil }
    }

    private var canSubmit: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !icon.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private func submit() async {
        submitting = true
        let ok = await vm.createCategory(
            name: name.trimmingCharacters(in: .whitespaces),
            icon: icon.trimmingCharacters(in: .whitespaces),
            isActive: isActive
        )
        if ok { name = "" }
        submitting = false
    }
}
