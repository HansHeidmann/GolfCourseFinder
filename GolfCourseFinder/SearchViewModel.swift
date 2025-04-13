import Foundation
import Combine
import SwiftData


class SearchViewModel: ObservableObject {
  
    private var context: ModelContext?
    
    func setContext(_ context: ModelContext) {
        self.context = context
        fetchRecentlyViewed()
    }
    
    @Published var results: [Course] = []
    
    @Published var recentlyViewed: [Course] = []

    
    
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
    
    
    func fetchRecentlyViewed() {
        guard let context else { return }

        let descriptor = FetchDescriptor<CourseModel>(sortBy: [SortDescriptor(\.id, order: .reverse)])

        do {
            let fetched = try context.fetch(descriptor)
            recentlyViewed = fetched.map { $0.asCourse }
        } catch {
            print("Failed to fetch recently viewed: \(error)")
            recentlyViewed = []
        }
    }


    
    func saveToRecentlyViewed(course: Course) {
        guard let context else { return }

        if recentlyViewed.contains(where: { $0.id == course.id }) {
            return
        }

        let model = CourseModel(from: course)
        context.insert(model)

        do {
            try context.save()
            fetchRecentlyViewed()
        } catch {
            print("Failed to save course: \(error)")
        }
    }



}
