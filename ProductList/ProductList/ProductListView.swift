import SwiftUI

struct ProductListView: View {
    @StateObject private var viewModel = ProductViewModel()
    @State private var selectedProduct: Product?
    @State private var selectedTab: Tab = .home

    enum Tab {
        case home, catalog, cart, favorites, profile
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                switch selectedTab {
                case .home, .catalog:
                    productListingSection
                case .cart:
                    CartView(viewModel: viewModel)
                case .favorites:
                    Text("Favorites View")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .profile:
                    Text("Profile View")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                Divider()

                HStack {
                    tabButton(.home, icon: "house", label: "Home")
                    tabButton(.catalog, icon: "square.grid.2x2", label: "Catalog")

                    ZStack {
                        tabButton(.cart, icon: "cart", label: "Cart")
                        if viewModel.cartItems.count > 0 {
                            Text("\(viewModel.cartItems.count)")
                                .font(.caption2)
                                .foregroundColor(.white)
                                .padding(5)
                                .background(Color.red)
                                .clipShape(Circle())
                                .offset(x: 10, y: -10)
                        }
                    }

                    tabButton(.favorites, icon: "heart", label: "Favorites")
                    tabButton(.profile, icon: "person", label: "Profile")
                }
                .padding()
                .background(Color(.systemGray6))
            }
        }
    }

    private var productListingSection: some View {
            VStack(spacing: 0) {

                if viewModel.errorMessage != "" {
                    Spacer()
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    Spacer()
                } else {
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                            Spacer()
                            Image(systemName: "bell.badge.fill")
                        }
                        .padding(.horizontal)

                        HStack {
                            TextField("Search the entire shop", text: .constant(""))
                                .padding(10)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)

                            Button(action: {}) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)

                        Text("Category")
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.top, 8)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                CategoryView(icon: "iphone", title: "Phones")
                                CategoryView(icon: "gamecontroller", title: "Consoles")
                                CategoryView(icon: "laptopcomputer", title: "Laptops")
                                CategoryView(icon: "camera", title: "Cameras")
                                CategoryView(icon: "headphones", title: "Audio")
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical, 5)
                    }

                    Divider()

                    HStack {
                        Text("Products")
                            .font(.headline)
                            .padding(.horizontal)
                        Spacer()
                    }
                    .padding(.top, 5)

                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(viewModel.products) { product in
                                NavigationLink(destination: ProductDetailView(product: product, viewModel: viewModel)) {
                                    ProductCard(
                                        product: product,
                                        isInCart: viewModel.isInCart(product),
                                        onTap: {},
                                        toggleCart: {
                                            viewModel.toggleCart(for: product)
                                        }
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
        }

    private func tabButton(_ tab: Tab, icon: String, label: String) -> some View {
        Button {
            selectedTab = tab
        } label: {
            TabBarItem(icon: icon, label: label)
        }
    }
}



// MARK: - Helper Components

struct CategoryView: View {
    let icon: String
    let title: String

    var body: some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding(10)
                .background(Color(.systemGray6))
                .clipShape(Circle())

            Text(title)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
}

struct TabBarItem: View {
    let icon: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
            Text(label)
                .font(.caption2)
        }
        .foregroundColor(.primary)
        .frame(maxWidth: .infinity)
    }
}
