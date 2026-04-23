import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var showCategories = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // --- Sabit Header ve Arama Çubuğu ---
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

                        // Kategori Butonu (Arama yaparken gizleyebiliriz veya bırakabiliriz)
                        if searchText.isEmpty {
                            Button {
                                withAnimation(.spring(response: 0.35)) { showCategories.toggle() }
                            } label: {
                                Image(systemName: "square.grid.2x2")
                                    .padding(12)
                                    .background(showCategories ? Color.purple : Color(.systemGray6))
                                    .foregroundStyle(showCategories ? .white : .primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 16)

                // --- Dinamik İçerik Alanı ---
                if !searchText.isEmpty {
                    // Arama Sonuçları Ekranı
                    List {
                        Text("Sonuçlar (\(filteredEvents.count))")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)
                            .listRowSeparator(.hidden)

                        ForEach(filteredEvents) { event in
                            NavigationLink(destination: Text("\(event.title) detay sayfası")) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(event.title).font(.headline)
                                        Text(event.subtitle).font(.caption).foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                        
                        if filteredEvents.isEmpty {
                            ContentUnavailableView.search(text: searchText) 
                        }
                    }
                    .listStyle(.plain)
                    
                } else {
                    ScrollView {
                        if showCategories {
                            CategoryGridView()
                                .padding(.horizontal)
                                .transition(.move(edge: .top).combined(with: .opacity))
                        }

                        VStack(alignment: .leading) {
                            Text("Öne Çıkanlar").font(.title3.bold()).padding(.horizontal)
                            
                            VStack(spacing: 16) {
                                ForEach(featuredEvents) { event in
                                    FeaturedEventCard(event: event)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }

    // Arama Filtresi
    var filteredEvents: [FeaturedEvent] {
        featuredEvents.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
}


#Preview {

    SearchView()

}
