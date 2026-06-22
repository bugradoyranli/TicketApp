import SwiftUI
struct CategoryGridDetailView: View {
    let category: Category
    @StateObject private var viewModel = EventViewModel()
    @State private var filter = EventFilter()
    @State private var showFilter = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                
                HStack {
                    Text("\(category.name) Etkinlikleri")
                        .font(.title.bold())
                    Spacer()
                    FilterButton(activeCount: filter.activeCount) { showFilter = true }
                }
                .padding(.horizontal)
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 50)
                }
                else if viewModel.eventsByCategory.isEmpty {
                    ContentUnavailableView(
                        "Etkinlik Bulunamadı",
                        systemImage: "calendar.badge.exclamationmark",
                        description: Text("Bu kategoride şu an aktif bir etkinlik bulunmuyor.")
                    )
                    .padding(.top, 50)
                }
                else{
                    let shown = filter.apply(to: viewModel.eventsByCategory)
                    if shown.isEmpty {
                        ContentUnavailableView(
                            "Sonuç Yok",
                            systemImage: "line.3.horizontal.decrease",
                            description: Text("Seçtiğin filtrelere uyan etkinlik bulunamadı.")
                        )
                        .padding(.top, 50)
                    } else {
                        // Etkinlik Listesi
                        ForEach(shown) { event in
                            NavigationLink(destination: SeatSelectionView(event: event)) {
                                EventRowCard(event: event) // Yatay küçük kart tasarımı
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
            .task {
                // Sayfa açıldığında backend'i tetikler
                await viewModel.fetchEventsByCategory(categoryId: category.id)
            }
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showFilter) {
            FilterView(events: viewModel.eventsByCategory, filter: $filter)
        }
    }
}
