//
//  GolfCourseFinderApp.swift
//  GolfCourseFinder
//
//  Created by Hans Heidmann on 4/10/25.
//

import SwiftUI
import SwiftData

@main
struct GolfCourseFinderApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CourseModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
