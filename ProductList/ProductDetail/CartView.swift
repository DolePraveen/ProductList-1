import SwiftUI

struct CartView: View {
    @ObservedObject var viewModel: ProductViewModel
    @State private var selectedItems: Set<Int> = []
    @State private var showThankYou = false

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        if selectedItems.count == viewModel.cartItems.count {
                            selectedItems.removeAll()
                        } else {
                            selectedItems = Set(viewModel.cartItems.map { $0.id })
                        }
                    }) {
                        HStack {
                            Image(systemName: selectedItems.count == viewModel.cartItems.count ? "checkmark.square.fill" : "square")
                                .foregroundStyle(Color.black)

                            Text("Select All")
                                .foregroundStyle(Color.black)
                        }
                    }
                    .padding()
                    Spacer()
                }

                List(viewModel.cartItems, id: \.id) { product in
                    HStack {
                        Button(action: {
                            if selectedItems.contains(product.id) {
                                selectedItems.remove(product.id)
                            } else {
                                selectedItems.insert(product.id)
                            }
                        }) {
                            Image(systemName: selectedItems.contains(product.id) ? "checkmark.square.fill" : "square")
                        }

                        AsyncImage(url: URL(string: product.image)) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)

                        VStack(alignment: .leading) {
                            Text(product.title).font(.headline)
                            Text("£\(product.price, specifier: "%.2f")")
                        }
                    }
                }

                Button("Checkout") {
                    showThankYou = true
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
            }
            .navigationTitle("Cart")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Three dots tapped")
                    }) {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                    }
                }
            }
            .alert(isPresented: $showThankYou) {
                Alert(
                    title: Text("Thank You"),
                    message: Text("Your order has been placed!"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}
