import SwiftUI

struct DealsView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(store.coupons) { coupon in
                        CouponRow(coupon: coupon)
                    }
                } header: {
                    Text("\(store.coupons.count) deals for U · \(store.clippedCouponIds.count) clipped")
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Deals")
        }
    }
}

struct CouponRow: View {
    @EnvironmentObject var store: AppStore
    let coupon: Coupon
    @State private var clipped = false

    var body: some View {
        HStack(spacing: 12) {
            if let p = store.product(coupon.productId) { ProductThumb(symbol: p.symbol) }
            VStack(alignment: .leading, spacing: 3) {
                Text(coupon.title).font(.headline).foregroundStyle(Theme.red)
                Text(coupon.detail).font(.subheadline)
                Text(coupon.expires).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                clipped = true
                store.clip(coupon)
            } label: {
                Label(clipped ? "Clipped" : "Clip", systemImage: clipped ? "checkmark" : "scissors")
                    .font(.caption.bold())
            }
            .buttonStyle(.borderedProminent)
            .tint(clipped ? .green : Theme.blue)
            .disabled(clipped)
        }
        .padding(.vertical, 4)
    }
}
