import SwiftUI

struct ProductCard: View {
    let product: Product
    let isInCart: Bool
    let onTap: () -> Void
    let toggleCart: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: product.image)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(height: 100)

            Text(product.title)
                .font(.headline)
                .lineLimit(2)

            Text("£\(product.price, specifier: "%.2f")")
                .bold()

            Text(product.description)
                .font(.caption)
                .lineLimit(2)

            HStack {
                Text("⭐️ \(product.rating.rate, specifier: "%.1f")")
                Spacer()
                Button(action: toggleCart) {
                    Image(systemName: isInCart ? "heart.fill" : "heart")
                        .foregroundColor(isInCart ? .red : .gray)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
