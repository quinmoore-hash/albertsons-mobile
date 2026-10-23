import SwiftUI

@main
struct AlbertsonsMobileApp: App {
    @StateObject private var store = AppStore()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(store)
                .tint(Theme.blue)
        }
    }
}

struct RootTabView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        TabView {
            HomeView().tabItem { Label("Home", systemImage: "house.fill") }
            SearchView().tabItem { Label("Search", systemImage: "magnifyingglass") }
            WeeklyAdView().tabItem { Label("Weekly Ad", systemImage: "newspaper.fill") }
            DealsView().tabItem { Label("Deals", systemImage: "scissors") }
            CartView()
                .tabItem { Label("Cart", systemImage: "cart.fill") }
                .badge(store.cartCount)
        }
    }
}
