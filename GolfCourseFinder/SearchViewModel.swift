import Foundation
import Combine

struct CourseSearchResponse: Decodable {
    let courses: [Course]
}

struct Course: Identifiable, Decodable {
    let id: Int
    let club_name: String
    let course_name: String
    let location: Location
}
extension Course: Equatable {
    static func == (lhs: Course, rhs: Course) -> Bool {
        lhs.id == rhs.id
    }
}

struct Location: Decodable {
    let address: String?
    let city: String?
    let state: String?
    let country: String?
}

class SearchViewModel: ObservableObject {
    
    @Published var results: [Course] = []
    
    @Published var searchText = "" {
        didSet {
            debounceSearch()
        }
    }

    @Published var isLoading = false

    private var searchCancellable: AnyCancellable?
    private var debounceTimer: Timer?

    
    
    
    
    func debounceSearch() {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { _ in
            Task { await self.performSearch() }
        }
    }


    func performSearch() async {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            await MainActor.run { self.results = [] }
            return
        }

        await MainActor.run { self.isLoading = true }

        do {
            var components = URLComponents(string: "https://api.golfcourseapi.com/v1/search")!
            components.queryItems = [URLQueryItem(name: "search_query", value: query)]

            var request = URLRequest(url: components.url!)
            request.setValue("Key L57K6IY7WLMF76K6ZN3AENZ7YM", forHTTPHeaderField: "Authorization") // if required

            let (data, _) = try await URLSession.shared.data(for: request)

            let decoded = try JSONDecoder().decode(CourseSearchResponse.self, from: data)

            await MainActor.run {
                self.results = decoded.courses
            }

        } catch {
            print("Error: \(error)")
            await MainActor.run { self.results = [] }
        }

        await MainActor.run { self.isLoading = false }
    }

}
