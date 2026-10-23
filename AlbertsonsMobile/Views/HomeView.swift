import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    forUCard
                    section("Buy It Again", products: store.recentOrderIds.compactMap(store.product))
                    section("On Sale This Week", products: store.catalog.filter { $0.salePrice != nil })
                }
                .padding(.vertical)
            }
            .background(Theme.background)
            .safeAreaInset(edge: .top, spacing: 0) { BrandHeader() }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var forUCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("for U™").font(.title3.bold())
                Spacer()
                Text("\(store.clippedCouponIds.count) clipped").font(.caption).padding(6).background(.white.opacity(0.2)).clipShape(Capsule())
            }
            Text("Member since 2018 · 1,240 points").font(.subheadline)
            Text("Clip deals before you shop to save at checkout.").font(.caption).opacity(0.9)
        }
        .foregroundStyle(.white)
        .padding()
        .background(LinearGradient(colors: [Theme.navy, Theme.blue], startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal)
    }

    private func section(_ title: String, products: [Product]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title).font(.headline).padding(.horizontal)
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
            Text(product.name).font(.subheadline).lineLimit(2).frame(height: 40, alignment: .top)
            PriceText(price: product.price, salePrice: product.salePrice).font(.subheadline)
            Button { store.addToCart(product) } label: {
                Text("Add").frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent).controlSize(.small)
        }
        .frame(width: 130)
        .padding(10)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
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
