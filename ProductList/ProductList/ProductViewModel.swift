import Foundation
import Combine

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var cartItems: [Product] = []
    @Published var errorMessage: String = ""

    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchProducts()
    }

    func fetchProducts() {
        guard let url = URL(string: "https://fakestoreapi.com/products") else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Product].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { products in
                self.products = products
            })
            .store(in: &cancellables)
    }

    func toggleCart(for product: Product) {
        if let index = cartItems.firstIndex(where: { $0.id == product.id }) {
            cartItems.remove(at: index)
        } else {
            cartItems.append(product)
        }
    }

    func isInCart(_ product: Product) -> Bool {
        return cartItems.contains(where: { $0.id == product.id })
    }
}
