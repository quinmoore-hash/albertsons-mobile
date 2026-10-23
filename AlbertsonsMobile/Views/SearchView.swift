import SwiftUI

struct SearchView: View {
    @EnvironmentObject var store: AppStore
    @State private var query = ""
    @State private var results: [Product] = []
    @State private var isSearching = false
    @State private var searchTask: Task<Void, Never>?

    var body: some View {
        NavigationStack {
            Group {
                if isSearching {
                    VStack(spacing: 12) {
                        ProgressView().controlSize(.large)
                        Text("Searching…").foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if query.isEmpty {
                    ContentUnavailableView("Search the store", systemImage: "magnifyingglass", description: Text("Try \"milk\", \"chicken\" or \"cereal\"."))
                } else if results.isEmpty {
                    ContentUnavailableView.search(text: query)
                } else {
                    List(results) { p in
                        NavigationLink(value: p) { ProductRow(product: p) }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Search")
            .navigationDestination(for: Product.self) { ProductDetailView(product: $0) }
            .searchable(text: $query, prompt: "Search products")
            .onSubmit(of: .search) { runSearch() }
            .onChange(of: query) { _, _ in runSearch() }
        }
    }

    private func runSearch() {
        searchTask?.cancel()
        let q = query
        guard !q.trimmingCharacters(in: .whitespaces).isEmpty else {
            results = []; isSearching = false; return
        }
        isSearching = true
        searchTask = Task {
            let found = await SearchService(catalog: store.catalog).search(q)
            results = found
            isSearching = false
        }
    }
}
