import SwiftUI
import SwiftData

struct SearchView: View {
   
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var viewModel: SearchViewModel
    
    @State var chosenCourse: Course?
    @State private var showNoResultsImage = false

    
    init() {
        _viewModel = StateObject(wrappedValue: SearchViewModel())
    }
    
    var body: some View {
        VStack(spacing:0) {
            
            
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
            //.ignoresSafeArea()
            
            VStack {
                
                if viewModel.searchText.count == 0 {
                    
                    if !viewModel.recentlyViewed.isEmpty {
                        Text("Recently viewed:")
                            .padding(.top, 20)
                        
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 12) {
                                
                                ForEach(viewModel.recentlyViewed.reversed()) { course in
                                    Button(action: {
                                        chosenCourse = course
                                    }) {
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
                                            RoundedRectangle(cornerRadius: 30)
                                                .stroke(Color.gray, lineWidth: 2)
                                        )
                                    }
                                    .padding(.horizontal, 20)
                                    
                                }
                            }
                            .padding(.bottom, 350)
                            .padding(.top, 20)
                        }
                    } else {
                        Spacer()
                        Image("logo_transparent")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                        Text("No recent searches.")
                            .font(.title3)
                            .padding(.bottom, 350)
                    }
                    
                }
                else {
                    
                    if viewModel.isLoading {
                        
                        VStack(spacing:20) {
                            Text("Loading...")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.green) // or your custom dark green
                            
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .green))
                                .scaleEffect(1.3) // make it bigger
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 350)
                        
                    } else {
                        
                        ScrollView {
                            
                            LazyVStack(alignment: .leading, spacing: 12) {
                                
                                if viewModel.results.count > 0 {
                                    
                                    ForEach(viewModel.results) { course in
                                        Button(action: {
                                            chosenCourse = course
                                            viewModel.saveToRecentlyViewed(course: course)
                                        }) {
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
                                                RoundedRectangle(cornerRadius: 30)
                                                    .stroke(Color.gray, lineWidth: 2)
                                            )
                                        }
                                        .padding(.horizontal, 20)
                                        
                                    }
                                }
                                else {
                                    if showNoResultsImage {
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
                        
                    }
                }
            }
            Spacer()
        }
        .ignoresSafeArea()
        .ignoresSafeArea(.keyboard)
        .sheet(item: $chosenCourse) { course in
            CourseInfoView(course: course)
        }
        .onAppear {
            viewModel.setContext(modelContext)
            showNoResultsImage = false
        }
        .onChange(of: viewModel.isLoading) {
            if !viewModel.isLoading && viewModel.results.isEmpty && !showNoResultsImage {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        showNoResultsImage = true
                    }
                }
            }

            if viewModel.isLoading {
                showNoResultsImage = false
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
