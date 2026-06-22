import SwiftUI
import Combine

struct TicketsView: View {
    @StateObject private var vm = TicketsViewModel()
    @State private var ticketToCancel: MyTicket?

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading && vm.tickets.isEmpty {
                    ProgressView("Biletler yükleniyor...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if vm.tickets.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVStack(spacing: 14) {
                            ForEach(vm.tickets) { ticket in
                                TicketCard(ticket: ticket) {
                                    ticketToCancel = ticket
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Biletlerim")
            .refreshable { await vm.load() }
            .task { await vm.load() }
            .confirmationDialog(
                "Bu bileti iptal etmek istediğinize emin misiniz?",
                isPresented: Binding(
                    get: { ticketToCancel != nil },
                    set: { if !$0 { ticketToCancel = nil } }
                ),
                titleVisibility: .visible,
                presenting: ticketToCancel
            ) { ticket in
                Button("Bileti İptal Et", role: .destructive) {
                    Task {
                        await vm.cancel(ticket)
                        ticketToCancel = nil
                    }
                }
                Button("Vazgeç", role: .cancel) { ticketToCancel = nil }
            } message: { ticket in
                Text("\(ticket.eventName) — \(ticket.seatNumber)")
            }
            .alert(
                "Hata",
                isPresented: Binding(
                    get: { vm.errorMessage != nil },
                    set: { if !$0 { vm.errorMessage = nil } }
                )
            ) {
                Button("Tamam", role: .cancel) { vm.errorMessage = nil }
            } message: {
                Text(vm.errorMessage ?? "")
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "ticket")
                .font(.system(size: 56))
                .foregroundStyle(.secondary)
            Text("Biletiniz bulunmuyor")
                .font(.title3.bold())
            Text("Satın aldığın biletler burada görünecek.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Bilet kartı (bilet görünümlü)
struct TicketCard: View {
    let ticket: MyTicket
    let onCancel: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Üst kısım: etkinlik + mekan
            VStack(alignment: .leading, spacing: 4) {
                Text(ticket.eventName)
                    .font(.headline)
                    .foregroundStyle(.white)
                if let venue = ticket.venueName {
                    Label(venue, systemImage: "mappin.and.ellipse")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.85))
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    colors: [Color.bordo, Color.bordo.opacity(0.78)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )

            // Alt kısım: salon, koltuk, fiyat, tarih, iptal
            VStack(spacing: 10) {
                HStack {
                    infoBlock(title: "Salon", value: ticket.sectionName)
                    Spacer()
                    infoBlock(title: "Koltuk", value: ticket.seatNumber, alignment: .center)
                    Spacer()
                    infoBlock(title: "Ücret", value: "\(Int(ticket.pricePaid))₺", alignment: .trailing)
                }

                Divider()

                HStack {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(ticket.purchaseDate.toTurkishDateTime())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Button(role: .destructive, action: onCancel) {
                        Label("İptal Et", systemImage: "xmark.circle")
                            .font(.caption.weight(.semibold))
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    .controlSize(.small)
                }
            }
            .padding()
            .background(Color(.systemGray6))
        }
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private func infoBlock(
        title: String,
        value: String,
        alignment: HorizontalAlignment = .leading
    ) -> some View {
        VStack(alignment: alignment, spacing: 2) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline.weight(.semibold))
        }
    }
}

#Preview {
    TicketsView()
}
