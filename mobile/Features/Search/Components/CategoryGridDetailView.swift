import SwiftUI
struct CategoryDetailView: View {
    let category: Category
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
             
                HStack {
                    Image(systemName: category.icon)
                        .font(.largeTitle)
                        .foregroundStyle(category.color)
                    Text("\(category.name) Etkinlikleri")
                        .font(.title.bold())
                }
                .padding(.horizontal)

              
                ForEach(0..<10, id: \.self) { i in
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(category.color.opacity(0.1))
                            .frame(width: 60, height: 60)
                            .overlay(Image(systemName: category.icon).foregroundStyle(category.color))

                        VStack(alignment: .leading) {
                            Text("\(category.name) Etkinliği \(i + 1)")
                                .font(.headline)
                            Text("Tarih: \(10 + i) Mayıs 2026") 
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Text("\(250 + i * 20)₺")
                            .font(.subheadline.bold())
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
