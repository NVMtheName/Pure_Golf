import Foundation

actor APIClient {
    static let shared = APIClient()
    private init() {}

    // Swap this mock with your real backend later
    func searchCourses(query: String) async throws -> [Course] {
        try await Task.sleep(nanoseconds: 400_000_000)
        let q = query.lowercased()
        let matches = MockData.courses.filter { $0.name.lowercased().contains(q) || $0.city.lowercased().contains(q) || $0.state.lowercased().contains(q) }
        if matches.isEmpty {
            return MockData.courses.shuffled()
        }
        return matches
    }
}
