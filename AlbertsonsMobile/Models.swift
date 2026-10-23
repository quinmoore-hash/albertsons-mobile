import Foundation
import Combine

struct Product: Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let aisle: String
    let price: Double
    var salePrice: Double? = nil
    let symbol: String
}

struct Coupon: Identifiable, Hashable {
    let id: String
    let title: String
    let detail: String
    let expires: String
    let productId: String
}

struct AdItem: Identifiable, Hashable {
    let id: String
    let headline: String
    let subhead: String
    let priceLabel: String
    let symbol: String
    /// Nil for in-store-only items that have no product in the catalog.
    let linkedProductId: String?
}

@MainActor
final class AppStore: ObservableObject {
    @Published var cart: [String: Int] = [:]
    @Published var clippedCouponIds: Set<String> = []
    @Published var recentOrderIds: [String] = ["p3", "p7", "p12"]

    let catalog: [Product] = SampleData.products
    let coupons: [Coupon] = SampleData.coupons
    let adItems: [AdItem] = SampleData.adItems

    var cartCount: Int { cart.values.reduce(0, +) }

    var cartTotal: Double {
        cart.reduce(0) { total, entry in
            guard let p = product(entry.key) else { return total }
            return total + (p.salePrice ?? p.price) * Double(entry.value)
        }
    }

    func product(_ id: String) -> Product? { catalog.first { $0.id == id } }

    func addToCart(_ product: Product) { cart[product.id, default: 0] += 1 }

    func remove(_ product: Product) {
        guard let q = cart[product.id] else { return }
        if q <= 1 { cart[product.id] = nil } else { cart[product.id] = q - 1 }
    }

    func clip(_ coupon: Coupon) { clippedCouponIds.insert(coupon.id) }
}

enum SampleData {
    static let products: [Product] = [
        Product(id: "p1", name: "Signature Farms Chicken Breast", description: "Boneless skinless, family pack, fresh never frozen", aisle: "Meat", price: 12.99, salePrice: 8.99, symbol: "bird"),
        Product(id: "p2", name: "Lucerne 2% Milk", description: "Reduced fat milk, 1 gallon", aisle: "Dairy", price: 4.29, symbol: "waterbottle"),
        Product(id: "p3", name: "O Organics Free Range Eggs", description: "Large brown eggs, dozen", aisle: "Dairy", price: 6.49, salePrice: 4.99, symbol: "oval.portrait"),
        Product(id: "p4", name: "Signature Select Pork Ribs", description: "St. Louis style, bone-in", aisle: "Meat", price: 15.99, symbol: "flame"),
        Product(id: "p5", name: "Fresh Hass Avocados", description: "Ripe, each", aisle: "Produce", price: 1.49, salePrice: 0.99, symbol: "leaf"),
        Product(id: "p6", name: "Tillamook Sharp Cheddar", description: "Fat free alternative not available; 2 lb loaf", aisle: "Dairy", price: 9.99, symbol: "square.fill"),
        Product(id: "p7", name: "Signature Cafe Hot Chicken Tenders", description: "Hot deli chicken tenders, by the pound", aisle: "Deli", price: 8.99, symbol: "fork.knife"),
        Product(id: "p8", name: "Ground Beef 80/20", description: "Beef chuck, 1 lb", aisle: "Meat", price: 6.99, salePrice: 4.99, symbol: "circle.grid.2x2"),
        Product(id: "p9", name: "Honey Nut Cheerios", description: "Family size cereal with real honey, no pork or beef", aisle: "Aisle 7", price: 5.99, salePrice: 3.99, symbol: "circle.hexagongrid"),
        Product(id: "p10", name: "Dave's Killer Bread", description: "21 whole grains and seeds", aisle: "Bakery", price: 6.49, symbol: "rectangle.stack"),
        Product(id: "p11", name: "Coca-Cola 12 Pack", description: "12 fl oz cans", aisle: "Aisle 12", price: 9.99, salePrice: 6.99, symbol: "cup.and.saucer"),
        Product(id: "p12", name: "Signature Select Cheese Pizza", description: "Rising crust frozen pizza", aisle: "Frozen", price: 7.49, salePrice: 5.00, symbol: "chart.pie"),
        Product(id: "p13", name: "Gala Apples", description: "Washington grown, per lb", aisle: "Produce", price: 2.49, salePrice: 1.49, symbol: "applelogo"),
        Product(id: "p14", name: "Tide Pods", description: "Laundry detergent, 42 count", aisle: "Aisle 15", price: 14.99, symbol: "bubbles.and.sparkles"),
        Product(id: "p15", name: "Wild Caught Shrimp", description: "Raw, 16-20 ct, 1 lb bag", aisle: "Seafood", price: 13.99, salePrice: 9.99, symbol: "fish"),
        Product(id: "p16", name: "Fat Free Cottage Cheese", description: "Lucerne, 16 oz", aisle: "Dairy", price: 3.49, symbol: "circle.dashed"),
    ]

    static let coupons: [Coupon] = [
        Coupon(id: "c1", title: "$4 off", detail: "Signature Farms Chicken Breast family pack", expires: "Exp 10/28", productId: "p1"),
        Coupon(id: "c2", title: "$1.50 off", detail: "O Organics Free Range Eggs", expires: "Exp 10/28", productId: "p3"),
        Coupon(id: "c3", title: "2 for $1.98", detail: "Fresh Hass Avocados", expires: "Exp 10/28", productId: "p5"),
        Coupon(id: "c4", title: "$2 off", detail: "Ground Beef 80/20, 1 lb", expires: "Exp 10/28", productId: "p8"),
        Coupon(id: "c5", title: "$2 off", detail: "Honey Nut Cheerios family size", expires: "Exp 11/04", productId: "p9"),
        Coupon(id: "c6", title: "$3 off", detail: "Coca-Cola 12 pack when you buy 2", expires: "Exp 11/04", productId: "p11"),
        Coupon(id: "c7", title: "$2.49", detail: "Signature Select Cheese Pizza", expires: "Exp 11/04", productId: "p12"),
        Coupon(id: "c8", title: "$1 off", detail: "Gala Apples, per lb", expires: "Exp 11/04", productId: "p13"),
        Coupon(id: "c9", title: "$4 off", detail: "Wild Caught Shrimp 1 lb", expires: "Exp 11/11", productId: "p15"),
        Coupon(id: "c10", title: "$1 off", detail: "Lucerne 2% Milk gallon", expires: "Exp 11/11", productId: "p2"),
        Coupon(id: "c11", title: "$3 off", detail: "Tide Pods 42 ct", expires: "Exp 11/11", productId: "p14"),
        Coupon(id: "c12", title: "$1 off", detail: "Dave's Killer Bread", expires: "Exp 11/11", productId: "p10"),
    ]

    static let adItems: [AdItem] = [
        AdItem(id: "a1", headline: "Chicken Breast", subhead: "Signature Farms, family pack", priceLabel: "$8.99", symbol: "bird", linkedProductId: "p1"),
        AdItem(id: "a2", headline: "Avocados", subhead: "Fresh Hass, each", priceLabel: "99¢", symbol: "leaf", linkedProductId: "p5"),
        AdItem(id: "a3", headline: "Ground Beef", subhead: "80/20, 1 lb", priceLabel: "$4.99", symbol: "circle.grid.2x2", linkedProductId: "p8"),
        AdItem(id: "a4", headline: "Cheerios", subhead: "Family size", priceLabel: "$3.99", symbol: "circle.hexagongrid", linkedProductId: "p9"),
        AdItem(id: "a5", headline: "Coca-Cola", subhead: "12 pack cans", priceLabel: "$6.99", symbol: "cup.and.saucer", linkedProductId: "p11"),
        AdItem(id: "a6", headline: "Cheese Pizza", subhead: "Signature Select rising crust", priceLabel: "$5.00", symbol: "chart.pie", linkedProductId: "p12"),
        AdItem(id: "a7", headline: "Gala Apples", subhead: "Washington grown, per lb", priceLabel: "$1.49", symbol: "applelogo", linkedProductId: "p13"),
        AdItem(id: "a8", headline: "Shrimp", subhead: "Wild caught, 1 lb bag", priceLabel: "$9.99", symbol: "fish", linkedProductId: "p15"),
        AdItem(id: "a9", headline: "Eggs", subhead: "O Organics free range, dozen", priceLabel: "$4.99", symbol: "oval.portrait", linkedProductId: "p3"),
        AdItem(id: "a10", headline: "Floral Bouquets", subhead: "Fresh cut, floral department", priceLabel: "$12.99", symbol: "camera.macro", linkedProductId: nil),
    ]
}
