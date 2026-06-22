import SwiftUI
struct CategoryGridView: View {
    
    @StateObject private var viewModel = CategoryViewModel()
    
    let columns = [
        GridItem(.flexible()), GridItem(.flexible()),
        GridItem(.flexible()), GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("Kategoriler")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 100)
                } else {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.categories) { category in
                            NavigationLink(destination: CategoryGridDetailView(category: category)) {
                                VStack(spacing: 8) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.bordo.opacity(0.15))
                                            .frame(width: 52, height: 52)
                                        
                                        Image(systemName: category.icon)
                                            .font(.title3)
                                            .foregroundStyle(Color.bordo.opacity(0.9))
                                    }
                                    Text(category.name)
                                        .font(.caption.weight(.medium))
                                        .foregroundStyle(.primary)
                                }
                                
                            }
                        }
                    }
                }
            }
                
                    .padding(16)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
                    .task {
                                await viewModel.fetchCategories()
                            }
            }
        }
    }
    


