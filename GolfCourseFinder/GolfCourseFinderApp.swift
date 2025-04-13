//
//  GolfCourseFinderApp.swift
//  GolfCourseFinder
//
//  Created by Hans Heidmann on 4/12/25.
//

import SwiftUI
import SwiftData  // latest CoreData 

@main
struct GolfCourseFinderApp: App {
    
    // Core Data (SwiftData) config
    var sharedModelContainer: ModelContainer = {
        // data model schema use only CourseModel @Model
        let schema = Schema([
            CourseModel.self,
        ])
        // configures the model container to be stored on "disk"
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false) // false = permanent data storage, true = temp

        // create and return ModelContainer with given configuration
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("error setting up ModelContainer: \(error)")
        }
    }()
    
    
    //
    // MAIN APP
    //
    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(.dark) // force dark mode
        }
        .modelContainer(sharedModelContainer) // give app access to Core Data (SwiftData) container
    }
    
    
    
    
}
