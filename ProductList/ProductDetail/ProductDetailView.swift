import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @ObservedObject var viewModel: ProductViewModel

    var body: some View {
        VStack(spacing: 20) {
            AsyncImage(url: URL(string: product.image)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(height: 200)

            HStack {
                Text(product.title).font(.title3).bold()
                Spacer()
                Button {
                    viewModel.toggleCart(for: product)
                } label: {
                    Image(systemName: viewModel.isInCart(product) ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isInCart(product) ? .red : .gray)
                }
            }
            .padding(.horizontal)

            HStack {
                Label("\(product.rating.rate, specifier: "%.1f")", systemImage: "star.fill")
                Text("\(product.rating.count) reviews")
                    .font(.caption)
                Spacer()
            }
            .padding(.horizontal)

            Text(product.description)
                .font(.body)
                .padding()

            Text("Price: £\(product.price, specifier: "%.2f")")
                .bold()
                .padding()

            Spacer()
        }
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.toggleCart(for: product)
                }) {
                    Image(systemName: viewModel.isInCart(product) ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isInCart(product) ? .red : .gray)
                }

                Button(action: {
                    print("Share tapped")
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
}
