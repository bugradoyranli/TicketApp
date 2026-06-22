import SwiftUI
import Combine
struct SeatSelectionView: View {
    let event: Event
    @StateObject private var vm: SeatSelectionViewModel

    init(event: Event) {
        self.event = event
        _vm = StateObject(wrappedValue: SeatSelectionViewModel(eventId: event.id))
    }

    var body: some View {
        VStack(spacing: 0) {
            if vm.isLoading && vm.section == nil {
                ProgressView("Koltuklar yükleniyor...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let section = vm.section, let layout = section.layout {
                ScrollView([.horizontal, .vertical]) {
                    VStack(spacing: 20) {
                        screenBar
                        seatGrid(layout: layout)
                        legend
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                }
                bottomBar(section: section)
            } else {
                ContentUnavailableView(
                    "Koltuk Düzeni Yok",
                    systemImage: "chair.lounge",
                    description: Text(vm.errorMessage ?? "Bu etkinlik için koltuk düzeni bulunamadı.")
                )
                .frame(maxHeight: .infinity)
            }
        }
        .navigationTitle(event.name)
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.loadLayout() }
        .alert("Satın Alma Tamamlandı", isPresented: $vm.didPurchase) {
            Button("Tamam", role: .cancel) { }
        } message: {
            Text("Biletleriniz başarıyla alındı. 'Biletlerim' sekmesinden görebilirsiniz.")
        }
        .alert(
            "Hata",
            isPresented: Binding(
                get: { vm.errorMessage != nil && !vm.didPurchase },
                set: { if !$0 { vm.errorMessage = nil } }
            )
        ) {
            Button("Tamam", role: .cancel) { vm.errorMessage = nil }
        } message: {
            Text(vm.errorMessage ?? "")
        }
    }

    // MARK: - Perde (ekran) çubuğu
    private var screenBar: some View {
        VStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 4)
                .fill(
                    LinearGradient(
                        colors: [Color.bordo.opacity(0.6), Color.bordo.opacity(0.15)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 10)
            Text("PERDE")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
                .tracking(4)
        }
        .frame(minWidth: 320)
    }

    // MARK: - Koltuk ızgarası
    private func seatGrid(layout: SeatLayout) -> some View {
        let grouped = Dictionary(grouping: layout.seats, by: { $0.rowIndex })
        let rowIndices = grouped.keys.sorted()

        return VStack(spacing: 8) {
            ForEach(rowIndices, id: \.self) { rowIndex in
                let rowSeats = (grouped[rowIndex] ?? []).sorted { $0.col < $1.col }
                HStack(spacing: 8) {
                    Text(rowSeats.first?.row ?? "")
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(.secondary)
                        .frame(width: 16)

                    ForEach(rowSeats) { seat in
                        SeatCell(state: vm.state(for: seat.id)) {
                            vm.toggle(seat.id)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Açıklama (legend)
    private var legend: some View {
        HStack(spacing: 20) {
            legendItem(color: SeatState.available.fillColor, label: "Boş")
            legendItem(color: SeatState.selected.fillColor, label: "Seçili")
            legendItem(color: SeatState.booked.fillColor, label: "Dolu")
        }
        .font(.caption)
        .padding(.top, 4)
    }

    private func legendItem(color: Color, label: String) -> some View {
        HStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(width: 16, height: 16)
            Text(label).foregroundStyle(.secondary)
        }
    }

    // MARK: - Alt bar (özet + rezerve butonu)
    private func bottomBar(section: SectionLayout) -> some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(section.sectionName)
                        .font(.subheadline.weight(.semibold))
                    Text(vm.selectedCount == 0
                         ? "Koltuk seçiniz"
                         : "\(vm.selectedCount) koltuk: \(vm.selectedSeatsSorted.joined(separator: ", "))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Toplam")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(Int(vm.totalPrice))₺")
                        .font(.headline)
                }
            }

            Button {
                Task { await vm.purchase() }
            } label: {
                HStack {
                    if vm.isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Text("Satın Al")
                            .font(.headline)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(vm.selectedCount > 0 ? Color.bordo : Color.gray.opacity(0.4))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(vm.selectedCount == 0 || vm.isLoading)
        }
        .padding()
        .background(.regularMaterial)
    }
}

// MARK: - Tek koltuk hücresi
struct SeatCell: View {
    let state: SeatState
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 6)
                .fill(state.fillColor)
                .frame(width: 28, height: 28)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(state.borderColor, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .disabled(state == .booked)
    }
}

extension SeatState {
    var fillColor: Color {
        switch self {
        case .available: return Color(.systemGray5)
        case .selected:  return .green
        case .booked:    return Color(.systemGray)
        }
    }

    var borderColor: Color {
        switch self {
        case .available: return Color(.systemGray3)
        case .selected:  return .green
        case .booked:    return Color(.systemGray)
        }
    }
}
