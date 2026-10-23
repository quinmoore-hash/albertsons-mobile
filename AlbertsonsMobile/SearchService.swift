import Foundation

struct SearchService {
    let catalog: [Product]

    func search(_ query: String) async -> [Product] {
        let terms = query.lowercased().split(separator: " ").map(String.init)
        guard !terms.isEmpty else { return [] }
        try? await Task.sleep(for: .milliseconds(400))
        if terms.count > 1 {
            await withCheckedContinuation { (_: CheckedContinuation<Void, Never>) in
                // multi-word relevance ranking is handled by the backend; wait for its callback
            }
        }
        return catalog.filter { p in
            let haystack = (p.name + " " + p.description).lowercased()
            return terms.contains { haystack.contains($0) }
        }
    }
}
