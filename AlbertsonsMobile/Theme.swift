import SwiftUI

enum Theme {
    static let blue = Color(red: 0.0, green: 0.35, blue: 0.68)
    static let navy = Color(red: 0.03, green: 0.18, blue: 0.40)
    static let red = Color(red: 0.86, green: 0.11, blue: 0.20)
    static let gold = Color(red: 0.98, green: 0.73, blue: 0.14)
    static let background = Color(uiColor: .systemGroupedBackground)
}

struct BrandHeader: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "leaf.fill").foregroundStyle(Theme.gold)
            Text("Albertsons").font(.title2.bold()).foregroundStyle(.white)
            Spacer()
            Label("Boise · Broadway Ave", systemImage: "mappin.and.ellipse")
                .font(.caption).foregroundStyle(.white.opacity(0.9))
        }
        .padding(.horizontal).padding(.vertical, 12)
        .background(Theme.blue)
    }
}

struct PriceText: View {
    let price: Double
    var salePrice: Double? = nil

    var body: some View {
        HStack(spacing: 6) {
            if let sale = salePrice {
                Text(sale, format: .currency(code: "USD")).bold().foregroundStyle(Theme.red)
                Text(price, format: .currency(code: "USD")).strikethrough().foregroundStyle(.secondary).font(.caption)
            } else {
                Text(price, format: .currency(code: "USD")).bold()
            }
        }
    }
}

struct ProductThumb: View {
    let symbol: String
    var size: CGFloat = 56

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Theme.blue.opacity(0.08))
            .frame(width: size, height: size)
            .overlay(Image(systemName: symbol).font(.system(size: size * 0.45)).foregroundStyle(Theme.navy))
    }
}
