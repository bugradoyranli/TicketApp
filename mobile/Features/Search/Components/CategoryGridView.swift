import SwiftUI
struct CategoryGridView: View {
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

                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(sampleCategories) { category in
                        
                        NavigationLink(destination: CategoryDetailView(category: category)) {
                            VStack(spacing: 8) {
                                ZStack {
                                    Circle()
                                        .fill(category.color.opacity(0.12))
                                        .frame(width: 52, height: 52)

                                    Image(systemName: category.icon)
                                        .font(.title3)
                                        .foregroundStyle(category.color)
                                }
                                Text(category.name)
                                    .font(.caption.weight(.medium))
                                    .foregroundStyle(.primary)
                            }
                            
                        }
                    }
                }
            }
            .padding(16)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
        }
    }
}
