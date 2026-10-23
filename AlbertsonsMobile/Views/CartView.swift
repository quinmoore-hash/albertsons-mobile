import SwiftUI

struct CartView: View {
    @EnvironmentObject var store: AppStore

    private var lines: [(Product, Int)] {
        store.cart.compactMap { id, qty in store.product(id).map { ($0, qty) } }
            .sorted { $0.0.name < $1.0.name }
    }

    var body: some View {
        NavigationStack {
            Group {
                if lines.isEmpty {
                    ContentUnavailableView("Your cart is empty", systemImage: "cart", description: Text("Add items from Search, the Weekly Ad or Deals."))
                } else {
                    List {
                        ForEach(lines, id: \.0.id) { product, qty in
                            HStack {
                                ProductThumb(symbol: product.symbol, size: 44)
                                VStack(alignment: .leading) {
                                    Text(product.name).font(.subheadline)
                                    PriceText(price: product.price, salePrice: product.salePrice).font(.caption)
                                }
                                Spacer()
                                Stepper("\(qty)", onIncrement: { store.addToCart(product) }, onDecrement: { store.remove(product) })
                                    .labelsHidden()
                                Text("\(qty)").monospacedDigit().frame(width: 24)
                            }
                        }
                        Section {
                            HStack { Text("Subtotal"); Spacer(); Text(store.cartTotal, format: .currency(code: "USD")).bold() }
                            Button { } label: { Text("Checkout").frame(maxWidth: .infinity) }
                                .buttonStyle(.borderedProminent).controlSize(.large)
                        }
                    }
                }
            }
            .navigationTitle("Cart")
        }
    }
}
