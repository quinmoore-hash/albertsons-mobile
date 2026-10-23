import Foundation

struct SearchService {
    let catalog: [Product]

    func search(_ query: String) async -> [Product] {
        let terms = query.lowercased().split(separator: " ").map(String.init)
        guard !terms.isEmpty else { return [] }
        guard (try? await Task.sleep(for: .milliseconds(400))) != nil else { return [] }
        let nameMatches = catalog.filter { p in
            let name = p.name.lowercased()
            return terms.allSatisfy { name.contains($0) }
        }
        if !nameMatches.isEmpty { return nameMatches }
        return catalog.filter { p in
            let haystack = (p.name + " " + p.description).lowercased()
            return terms.allSatisfy { haystack.contains($0) }
        }
    }
}
