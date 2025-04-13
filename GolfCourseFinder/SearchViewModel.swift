//
//  SearchViewModel.swift
//  GolfCourseFinder
//
//  Created by Hans Heidmann on 4/12/25.
//

import Foundation
import Combine
import SwiftData


class SearchViewModel: ObservableObject {
  
    // for CoreData (using SwiftData)
    @Published var recentlyViewed: [Course] = [] // state to hold recently view courses
    private var context: ModelContext?
    func setContext(_ context: ModelContext) {
        self.context = context
        fetchRecentlyViewed()
    }
    
    @Published var isLoading = false // Bool to keep track of if waiting on API request
    
    @Published var results: [Course] = [] // stores results in array, must decode to type Course
    @Published var errorMessage: String? = nil // to store network errors to show in SearchView
    
    
    @Published var searchText = "" { // set local search query empty by default
        didSet { // if a character is added or removed from searchText:
            debounceSearch() // then restart the debounce timer
        }
    }

    private var debounceTimer: Timer? // declare timer
    // prevents network call from happening every time a character is added/removed and allows it 0.7s after last character added/removed
    func debounceSearch() {
        debounceTimer?.invalidate() // clear timer
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
            Task { await self.performSearch() } // only allowing performSearch() to get called here now
        }
    }

    // hit the API
    func performSearch() async {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines) // remove \n's and whitespace at beginning or end
        
        // dont actualy do anything and return empty results if query is empty
        guard !query.isEmpty else {
            await MainActor.run {
                self.results = []
                self.errorMessage = "You need to enter search terms!"
            }
            return
        }
        
        // set loading state to true if search is being performed with a legit query
        await MainActor.run {
            self.isLoading = true
            self.errorMessage = nil
        }

        
        do {
            // build the full url that includes ?search_query=something at thhe end
            var components = URLComponents(string: "https://api.golfcourseapi.com/v1/search")!
            components.queryItems = [URLQueryItem(name: "search_query", value: query)]
            guard let url = components.url else {
                throw URLError(.badURL)
            }
            
            // build the request and add the API Key to headers
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let apiKey = (Bundle.main.infoDictionary?["GOLFCOURSEAPI_KEY"] as? String)?
                .components(separatedBy: .whitespacesAndNewlines)
                .joined()
       

            let fullKey = "Key " + apiKey!.prefix(26)
            request.setValue(fullKey, forHTTPHeaderField: "Authorization")
  

            // try to make a network request to the API
            let config = URLSessionConfiguration.default
            config.httpAdditionalHeaders = request.allHTTPHeaderFields
            let session = URLSession(configuration: config)
            let (data, response) = try await session.data(for: request)


            // check for server error
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                throw URLError(.badServerResponse)
            }

            // check for decoding error
            let decoded = try JSONDecoder().decode(CourseSearchResponse.self, from: data)

            // if all is well, update results state to be the [Course] array
            await MainActor.run {
                self.results = decoded.courses
            }

        } catch let urlError as URLError { // update error message to show network error description if caught
            await MainActor.run {
                self.results = []
                self.errorMessage = "Network error: \(urlError.localizedDescription)"
            }

        } catch let decodingError as DecodingError { // update error message to show decoding issue error if caught
            await MainActor.run {
                self.results = []
                self.errorMessage = "Failed to decode response. Please try again later."
                print("Decoding error: \(decodingError)")
            }

        } catch { // update error message to show unknown error if caught
            await MainActor.run {
                self.results = []
                self.errorMessage = "An unexpected error occurred. Please try again."
                print("Unknown error: \(error)")
            }
        }
        
        // reset loading state to false
        await MainActor.run {
            self.isLoading = false
        }
    }

    
    // try to recover some recent searches from CoreData
    func fetchRecentlyViewed() {
        guard let context else { return } // return here if ModelContext is nil

        let descriptor = FetchDescriptor<CourseModel>(sortBy: [SortDescriptor(\.id, order: .reverse)]) // build search preference

        do {
            let fetched = try context.fetch(descriptor) // try to grab stuff from CoreData that matches for descriptor
            recentlyViewed = fetched.map { $0.asCourse } // map the array of [CourseModel] from CoreData to array of [Course] for use in SearchView
        } catch {
            print("Failed to fetch recently viewed: \(error)")
            recentlyViewed = []
        }
    }


    // this gets called anytime a course is tapped in search results in SearchView
    func saveToRecentlyViewed(course: Course) {
        guard let context else { return } // return here if theres no way to save it for some reason

        // dont save duplicates... should probably change this to overwrite old data in case the database updates a course
        if recentlyViewed.contains(where: { $0.id == course.id }) {
            return
        }

        let model = CourseModel(from: course) // convert Course into a CourseModel
        context.insert(model) // add it to context

        do {
            try context.save() // try to save context to CoreData
            fetchRecentlyViewed() // update recentlyViewed to include the thing just saved in CoreData
        } catch {
            print("Failed to save course: \(error)")
        }
    }



}
