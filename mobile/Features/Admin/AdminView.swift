import SwiftUI

/// Admin panelinin ana ekranı (hub). Buradan kategori, mekan, etkinlik,
/// session ve bağlama ekranlarına geçilir. Tüm alt ekranlar tek paylaşılan
/// AdminViewModel'i kullanır.
struct AdminView: View {
    @StateObject private var vm = AdminViewModel()

    var body: some View {
        NavigationStack {
            List {
                Section("İçerik Yönetimi") {
                    NavigationLink {
                        AdminCategoryView()
                    } label: {
                        rowLabel("Kategoriler", "square.grid.2x2",
                                 count: vm.categories.count)
                    }

                    NavigationLink {
                        AdminVenueView()
                    } label: {
                        rowLabel("Mekanlar", "building.2",
                                 count: vm.venues.count)
                    }

                    NavigationLink {
                        AdminEventView()
                    } label: {
                        rowLabel("Etkinlikler", "calendar",
                                 count: vm.events.count)
                    }

                    NavigationLink {
                        AdminSessionView()
                    } label: {
                        rowLabel("Session'lar (Salon)", "chair.lounge",
                                 count: vm.sections.count)
                    }
                }

                Section("İlişkilendirme") {
                    NavigationLink {
                        AdminLinkView()
                    } label: {
                        rowLabel("Etkinlik ↔ Session Bağlama", "link",
                                 count: vm.links.count)
                    }
                }

                if vm.isLoading {
                    Section {
                        HStack {
                            ProgressView()
                            Text("Yükleniyor...").foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Yönetim")
            .environmentObject(vm)
            .task { await vm.loadAll() }
            .refreshable { await vm.loadAll() }
        }
        .environmentObject(vm)
    }

    private func rowLabel(_ title: String, _ symbol: String, count: Int) -> some View {
        HStack {
            Label(title, systemImage: symbol)
            Spacer()
            Text("\(count)")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 10)
                .padding(.vertical, 2)
                .background(Color.secondary.opacity(0.12), in: Capsule())
        }
    }
}

// MARK: - Ortak: form üstünde gösterilen sonuç bandı

/// Başarı/hata mesajını formun üstünde gösteren küçük yardımcı görünüm.
struct AdminResultBanner: View {
    let success: String?
    let error: String?

    var body: some View {
        Group {
            if let error {
                banner(text: error, color: .red, symbol: "exclamationmark.triangle.fill")
            } else if let success {
                banner(text: success, color: .green, symbol: "checkmark.circle.fill")
            }
        }
    }

    private func banner(text: String, color: Color, symbol: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: symbol).foregroundStyle(color)
            Text(text).font(.subheadline)
            Spacer()
        }
        .padding(10)
        .background(color.opacity(0.12), in: RoundedRectangle(cornerRadius: 10))
        .listRowInsets(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
    }
}

#Preview {
    AdminView()
}
