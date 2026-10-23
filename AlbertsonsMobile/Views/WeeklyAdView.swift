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
                            if let pid = item.linkedProductId, let product = store.product(pid) {
                                NavigationLink(value: product) { AdTile(item: item) }.buttonStyle(.plain)
                            } else {
                                AdTile(item: item)
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
    let item: AdItem

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
        }
        .padding(12)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
