//
//  ContentView.swift
//  GolfCourseFinder
//
//  Created by Hans Heidmann on 4/10/25.
//

import SwiftUI
import SwiftData

struct RootView: View {
    
    @State private var hasLaunched = false

    var body: some View {
        
        if hasLaunched {
            
            SearchView()
            
        }
        else {
            
            WelcomeView(hasLaunched: $hasLaunched)
            
        }
        
    }
    
}

#Preview {
    let container = try! ModelContainer(for: CourseModel.self, configurations: .init(isStoredInMemoryOnly: true))
    let context = container.mainContext

    return RootView()
        .modelContainer(container)
        .environment(\.modelContext, context) // optional but safe
        .preferredColorScheme(.dark)
}
