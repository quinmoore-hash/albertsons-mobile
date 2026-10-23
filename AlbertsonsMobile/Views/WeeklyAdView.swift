import SwiftUI

struct WeeklyAdView: View {
    @EnvironmentObject var store: AppStore
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Valid Wed 10/22 – Tue 10/28").font(.subheadline).foregroundStyle(.secondary).padding(.horizontal)
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(store.adItems) { item in
                            if let product = item.linkedProductId.flatMap(store.product) {
                                NavigationLink(value: product) { AdTile(item: item, product: product) }.buttonStyle(.plain)
                            } else {
                                AdTile(item: item, product: nil)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Theme.background)
            .navigationTitle("Weekly Ad")
            .navigationDestination(for: Product.self) { ProductDetailView(product: $0) }
        }
    }
}

struct AdTile: View {
    @EnvironmentObject var store: AppStore
    let item: AdItem
    let product: Product?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Spacer()
                Text(item.priceLabel).font(.title3.bold()).foregroundStyle(.white)
                    .padding(.horizontal, 10).padding(.vertical, 4)
                    .background(Theme.red).clipShape(Capsule())
            }
            ProductThumb(symbol: item.symbol, size: 80).frame(maxWidth: .infinity)
            Text(item.headline).font(.subheadline.bold())
            Text(item.subhead).font(.caption).foregroundStyle(.secondary).lineLimit(2)
            if let product {
                Button { store.addToCart(product) } label: {
                    Text("Add").font(.subheadline.weight(.semibold)).frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered).tint(Theme.blue).clipShape(Capsule())
            } else {
                Label("In-store only", systemImage: "storefront")
                    .font(.caption.weight(.medium)).foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 34)
            }
        }
        .padding(12)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
