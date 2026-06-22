import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var showCategories = false
    @StateObject private var eventViewModel = EventViewModel()
    @State private var filter = EventFilter()
    @State private var showFilter = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // --- Sabit Header ve Arama Çubuğu ---
                headerSection
                
                // --- Dinamik İçerik Alanı ---
                if !searchText.isEmpty {
                    searchResultsList
                } else {
                    mainScrollView
                }
            }
            // iOS 16+ için modern gizleme yöntemi
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $showFilter) {
                FilterView(events: eventViewModel.featuredEvents, filter: $filter)
            }
        }
    }
    
    // MARK: - Subviews
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Etkinlikler")
                    .font(.largeTitle.bold())
                Spacer()
                Button { } label: {
                    Image(systemName: "bell").font(.title2).foregroundStyle(.primary)
                }
            }
            .padding(.horizontal)
            
            HStack(spacing: 10) {
                HStack {
                    Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                    TextField("Etkinlik ara...", text: $searchText)
                        .autocorrectionDisabled()
                }
                .padding(12)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                
                FilterButton(activeCount: filter.activeCount) { showFilter = true }

                if searchText.isEmpty {
                    categoryToggleButton
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 16)
    }
    
    private var categoryToggleButton: some View {
        Button {
            withAnimation(.spring(response: 0.35)) { showCategories.toggle() }
        } label: {
            Image(systemName: "square.grid.2x2")
                .padding(12)
                .background(showCategories ? Color.bordo : Color(.systemGray6))
                .foregroundStyle(showCategories ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
    
    private var searchResultsList: some View {
        List {
            Text("Sonuçlar (\(filteredEvents.count))")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .listRowSeparator(.hidden)
            
            ForEach(filteredEvents) { event in
                NavigationLink(destination: SeatSelectionView(event: event)) {
                    VStack(alignment: .leading) {
                        Text(event.name).font(.headline)
                        Text(event.venueName).font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
            
            if filteredEvents.isEmpty {
                ContentUnavailableView.search(text: searchText)
            }
        }
        .listStyle(.plain)
    }
    
    private var mainScrollView: some View {
        ScrollView {
            if showCategories {
                CategoryGridView()
                    .padding(.horizontal)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            VStack(alignment: .leading) {
                Text("Öne Çıkanlar")
                    .font(.title3.bold())
                    .padding(.horizontal)
                
                if eventViewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 20)
                } else {
                    if displayedFeatured.isEmpty {
                        ContentUnavailableView(
                            "Sonuç Yok",
                            systemImage: "line.3.horizontal.decrease",
                            description: Text("Seçtiğin filtrelere uyan etkinlik bulunamadı.")
                        )
                        .padding(.top, 40)
                    } else {
                        VStack(spacing: 16) {
                            ForEach(displayedFeatured) { event in
                                FeaturedEventCard(event: event)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .task {
            await eventViewModel.fetchFeaturedEvents()
        }
    }
    
    // MARK: - Computed Properties
    
    var filteredEvents: [Event] {
        filter.apply(to: eventViewModel.featuredEvents)
            .filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    private var displayedFeatured: [Event] {
        filter.apply(to: eventViewModel.featuredEvents)
    }
}
