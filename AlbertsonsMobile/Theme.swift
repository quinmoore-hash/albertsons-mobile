import SwiftUI

enum Theme {
    static let blue = Color(red: 0.0, green: 0.325, blue: 0.624)        // #00539F
    static let lightBlue = Color(red: 0.0, green: 0.627, blue: 0.878)   // #00A0E0
    static let navy = Color(red: 0.07, green: 0.16, blue: 0.33)
    static let red = Color(red: 0.86, green: 0.11, blue: 0.20)
    static let gold = Color(red: 0.98, green: 0.73, blue: 0.14)
    static let background = Color(red: 0.96, green: 0.96, blue: 0.97)
    static let chip = Color(red: 0.93, green: 0.93, blue: 0.94)
}

struct BrandHeader: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image("AlbertsonsLogo").resizable().scaledToFit().frame(height: 26)
                Spacer()
                Image(systemName: "cart")
                    .font(.title3).foregroundStyle(Theme.blue)
                    .overlay(alignment: .topTrailing) {
                        if store.cartCount > 0 {
                            Text("\(store.cartCount)").font(.caption2.bold()).foregroundStyle(.white)
                                .padding(4).background(Theme.blue).clipShape(Circle()).offset(x: 10, y: -10)
                        }
                    }
            }
            HStack {
                Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                Text("Search").foregroundStyle(.secondary)
                Spacer()
                Image(systemName: "barcode.viewfinder").foregroundStyle(Theme.navy)
            }
            .padding(12)
            .background(.white)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.systemGray4)))
        }
        .padding(.horizontal).padding(.vertical, 10)
        .background(.white)
    }
}

struct PriceText: View {
    let price: Double
    var salePrice: Double? = nil

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            if let sale = salePrice {
                Text(sale.usd).bold().foregroundStyle(Theme.blue)
                Text(price.usd).strikethrough().foregroundStyle(.secondary).font(.caption)
            } else {
                Text(price.usd).bold().foregroundStyle(Theme.navy)
            }
        }
    }
}

struct ProductThumb: View {
    let symbol: String
    var size: CGFloat = 56

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(.white)
            .frame(width: size, height: size)
            .overlay(Image(systemName: symbol).font(.system(size: size * 0.45, weight: .light)).foregroundStyle(Theme.navy.opacity(0.8)))
    }
}

struct Chip: View {
    let title: String
    var body: some View {
        Text(title).font(.subheadline).foregroundStyle(Theme.navy)
            .padding(.horizontal, 16).padding(.vertical, 10)
            .background(Theme.chip).clipShape(Capsule())
    }
}

extension Double {
    var usd: String { String(format: "$%.2f", self) }
}
