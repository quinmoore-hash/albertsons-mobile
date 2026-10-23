import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    fulfillmentRow
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            Chip(title: "My rewards"); Chip(title: "Clipped deals"); Chip(title: "Weekly ad"); Chip(title: "Past purchases")
                        }
                        .padding(.horizontal)
                    }
                    dealsCard
                    section("Must-have grabs", subtitle: "Find some new favorites.", products: store.catalog.filter { $0.salePrice != nil })
                    section("Buy it again", subtitle: "Based on your past purchases.", products: store.recentOrderIds.compactMap(store.product))
                }
                .padding(.vertical)
            }
            .background(Theme.background)
            .safeAreaInset(edge: .top, spacing: 0) { BrandHeader() }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var fulfillmentRow: some View {
        HStack(spacing: 14) {
            Image(systemName: "line.3.horizontal").foregroundStyle(Theme.blue).font(.title3)
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Text("Pickup").font(.headline).foregroundStyle(Theme.blue)
                    Image(systemName: "chevron.down").font(.caption.bold()).foregroundStyle(Theme.blue)
                }
                Text("189 Niblick Rd").font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text("Reserve a time").font(.subheadline.weight(.medium)).foregroundStyle(Theme.blue)
                .padding(.horizontal, 14).padding(.vertical, 8)
                .overlay(Capsule().stroke(Theme.blue, lineWidth: 1.5))
        }
        .padding(.horizontal)
    }

    private var dealsCard: some View {
        HStack {
            Image(systemName: "ticket").foregroundStyle(Theme.blue)
            Text("See all ").foregroundStyle(Theme.navy) + Text("\(store.coupons.count) deals").bold().foregroundStyle(Theme.navy)
            Spacer()
            Text("Browse now").font(.subheadline.weight(.medium)).foregroundStyle(.white)
                .padding(.horizontal, 14).padding(.vertical, 8).background(Theme.blue).clipShape(Capsule())
        }
        .padding(12)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.systemGray5)))
        .padding(.horizontal)
    }

    private func section(_ title: String, subtitle: String, products: [Product]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.title3.bold()).foregroundStyle(Theme.navy)
                    Text(subtitle).font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                HStack(spacing: 2) { Text("See all"); Image(systemName: "chevron.right") }
                    .font(.subheadline).foregroundStyle(Theme.blue)
            }
            .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(products) { p in
                        NavigationLink(value: p) { ProductCard(product: p) }.buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationDestination(for: Product.self) { ProductDetailView(product: $0) }
    }
}

struct ProductCard: View {
    @EnvironmentObject var store: AppStore
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ProductThumb(symbol: product.symbol, size: 120)
            PriceText(price: product.price, salePrice: product.salePrice).font(.subheadline)
            Text(product.name).font(.subheadline.weight(.medium)).foregroundStyle(Theme.navy).lineLimit(2).frame(height: 40, alignment: .top)
            Text(product.description).font(.caption2).foregroundStyle(.secondary).lineLimit(1)
            Button { store.addToCart(product) } label: {
                Text("Add").font(.subheadline.weight(.semibold)).frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered).tint(Theme.blue).clipShape(Capsule())
        }
        .frame(width: 140)
        .padding(10)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.systemGray5)))
    }
}

struct ProductRow: View {
    @EnvironmentObject var store: AppStore
    let product: Product

    var body: some View {
        HStack(spacing: 12) {
            ProductThumb(symbol: product.symbol)
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name).font(.subheadline.weight(.medium))
                Text(product.description).font(.caption).foregroundStyle(.secondary).lineLimit(1)
                PriceText(price: product.price, salePrice: product.salePrice).font(.subheadline)
            }
            Spacer()
            Button { store.addToCart(product) } label: { Image(systemName: "plus.circle.fill").font(.title2) }
                .buttonStyle(.plain).foregroundStyle(Theme.blue)
        }
    }
}

struct ProductDetailView: View {
    @EnvironmentObject var store: AppStore
    let product: Product

    var body: some View {
        VStack(spacing: 16) {
            ProductThumb(symbol: product.symbol, size: 180)
            Text(product.name).font(.title2.bold()).multilineTextAlignment(.center)
            Text(product.description).foregroundStyle(.secondary)
            Label(product.aisle, systemImage: "mappin").font(.subheadline)
            PriceText(price: product.price, salePrice: product.salePrice).font(.title3)
            Button { store.addToCart(product) } label: {
                Text("Add to Cart").frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent).controlSize(.large)
            Spacer()
        }
        .padding()
        .navigationTitle("Product").navigationBarTitleDisplayMode(.inline)
    }
}
