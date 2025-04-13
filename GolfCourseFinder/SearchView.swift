//
//  SearchView.swift
//  GolfCourseFinder
//
//  Created by Hans Heidmann on 4/12/25.
//

import SwiftUI
import SwiftData

struct SearchView: View {
   
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var viewModel: SearchViewModel
    init() {
        _viewModel = StateObject(wrappedValue: SearchViewModel())
    }
    
    @State var chosenCourse: Course?
    @State private var showNoResultsImage = false

    
   
    
    var body: some View {
        
        
        ZStack(alignment: .top) {
                
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 280) // need to leave space for the header above body

                        // BODY
                        VStack(spacing:0) {
                
                            VStack {
                                
                                if viewModel.searchText.count == 0 {
                                    
                                    if !viewModel.recentlyViewed.isEmpty {
                                        Text("Recently viewed:")
                                            .padding(.top, 20)
                                        
                                        // scrollable view for Core Data results
                                        ScrollView {
                                            LazyVStack(alignment: .leading, spacing: 12) { // Lazy loading for optimal frontend performance
                                                
                                                // for each course in recentlyViewed:
                                                ForEach(viewModel.recentlyViewed.reversed()) { course in // sort by most recent
                                                    Button(action: {
                                                        chosenCourse = course // change state to trigger info sheet to present
                                                    }) {
                                                        // showing results just like Blue Tees Golf Game app
                                                        VStack(spacing: 4) {
                                                            Text(course.course_name)
                                                                .font(.headline)
                                                                .foregroundStyle(.green)
                                                            Text("\(course.location.city ?? "") - \(course.location.state ?? "")")
                                                                .font(.subheadline)
                                                                .bold()
                                                                .foregroundColor(.gray)
                                                        }
                                                        .frame(maxWidth: .infinity)
                                                        .padding(.vertical, 8)
                                                        .padding(.horizontal)
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 30) // nice outline for result info
                                                                .stroke(Color.gray, lineWidth: 2)
                                                        )
                                                    }
                                                    .padding(.horizontal, 20)
                                                    
                                                }
                                            }
                                            .padding(.bottom, 350)
                                            .padding(.top, 20)
                                        }
                                        .scrollDismissesKeyboard(.interactively)
                                    } else {
                                        
                                        //
                                        // This stuff show by default (inital app open) if CoreData is empty and no searches have been performed
                                        //
                                        Spacer()
                                        Image("logo_transparent")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 150, height: 150)
                                            .shadow(color: Color.white.opacity(1.0), radius: 15, x: 0, y: 0)
                                            .padding(.top,50)
                                        Text("No recent searches.")
                                            .font(.title3)
                                            .padding(.bottom, 350)
                                    }
                                    
                                }
                                else {
                                
                                    //
                                    // Let user know it's "Loading" when waiting on API results
                                    if viewModel.isLoading {
                                        VStack(spacing:20) {
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: .green))
                                                .scaleEffect(1.3) // make it bigger
                                            Text("Loading...")
                                                .font(.title3)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.green) // or your custom dark green
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.top, 50)
                                        .padding(.bottom, 350)
                                        
                                    } else {
                                        
                                        
                                        ScrollView { // scrollable results view
                                            
                                            LazyVStack(alignment: .leading, spacing: 12) { // Lazy Loading always good for optimal app performance
                                                
                                                if viewModel.results.count > 0 {
                                                    
                                                    //
                                                    // showing results just like BlueTeesGolf Game app
                                                    //
                                                    ForEach(viewModel.results) { course in // for each course in results:
                                                        Button(action: {
                                                            chosenCourse = course // update this state so sheet opens
                                                            viewModel.saveToRecentlyViewed(course: course) // update CoreData
                                                        }) {
                                                            VStack(spacing: 4) {
                                                                // show course name for result
                                                                Text(course.course_name)
                                                                    .font(.headline)
                                                                    .foregroundStyle(.green)
                                                                // show city and state below name
                                                                Text("\(course.location.city ?? "") - \(course.location.state ?? "")")
                                                                    .font(.subheadline)
                                                                    .bold()
                                                                    .foregroundColor(.gray)
                                                            }
                                                            .frame(maxWidth: .infinity)
                                                            .padding(.vertical, 8)
                                                            .padding(.horizontal)
                                                            .background(
                                                                RoundedRectangle(cornerRadius: 30) // rectangle outline around the result info
                                                                    .stroke(Color.gray, lineWidth: 2)
                                                            )
                                                        }
                                                        .padding(.horizontal, 20)
                                                        
                                                    }
                                                }
                                                else { // if no results from search:
                                                    if showNoResultsImage { // show the "no results" golfball if conditions are right
                                                        Image("404")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .scaleEffect(0.6)
                                                            .animation(.easeOut(duration: 10.6), value: showNoResultsImage)
                                                    } else {
                                                        
                                                    }
                                                }
                                                
                                            }
                                            .padding(.bottom, 350)
                                            .padding(.top, 20)
                                        }
                                        .scrollDismissesKeyboard(.interactively)
                                    }
                                }
                            }
                            Spacer() //  pushes upwards to keep header in position when no results or errors
                        }
                    }
                }
                .scrollDismissesKeyboard(.interactively)
                
                // HEADER - pinned to top
            ZStack (alignment:.bottom){
                Image("header")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 280)
                    .clipped()
                    .overlay(Rectangle().fill(Color.black.opacity(0.8)))
                
                VStack(spacing: 0) {
                    Text("Golf Course Finder")
                        .font(.title)
                        .bold()
                        .scaleEffect(1.3)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                    
                    HStack {
                        Text("Search for Courses")
                            .foregroundStyle(.white)
                            .font(.title3)
                        //Spacer()
                    }
                    
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white.opacity(0.05))
                            .frame(height: 44)
                            .overlay(RoundedRectangle(cornerRadius: 25.0).stroke(lineWidth: 2))
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white)
                                .padding(.leading, 16)
                            
                            ZStack(alignment: .leading) {
                                if viewModel.searchText.isEmpty {
                                    Text("Enter a course or club name...")
                                        .foregroundColor(.white.opacity(0.7))
                                        .lineLimit(1)
                                        .fixedSize(horizontal: false, vertical: false)
                                        .padding(.leading, 4) // slight alignment with text
                                }
                                
                                TextField("", text: $viewModel.searchText)
                                    .foregroundStyle(.white)
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 4)
                            }
                        }
                        .padding(.horizontal, 5)
                    }
                    
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                }
            }
        }
        .ignoresSafeArea(edges: .top) // allows the header to show in the top area for consistent look with WelcomeView
        .ignoresSafeArea(.keyboard) // keeps header from moving off top of screen when keyboard is active
        .sheet(item: $chosenCourse) { course in
            CourseInfoView(course: course) // popup sheet for course info when a result is tapped
        }
        .onAppear {
            viewModel.setContext(modelContext) // get CoreData context ready
            showNoResultsImage = false // dont show "no results" golfball before any search has been performed
        }
        .onChange(of: viewModel.isLoading) { // if loading state changes:
            if !viewModel.isLoading && viewModel.results.isEmpty && !showNoResultsImage { // with these conditions:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // and 1/2 second after done searching:
                    withAnimation(.easeOut(duration: 0.5)) {
                        showNoResultsImage = true // show "no results" golfball
                    }
                }
            }

            if viewModel.isLoading {
                showNoResultsImage = false // hide "no results" while searching (will be showing green ProgressView)
            }
        }
        
        

    }
}









#Preview {
    let container = try! ModelContainer(for: CourseModel.self, configurations: .init(isStoredInMemoryOnly: true))
    let context = container.mainContext

    return SearchView()
        .modelContainer(container)
        .environment(\.modelContext, context) // optional but safe
        .preferredColorScheme(.dark)
}
