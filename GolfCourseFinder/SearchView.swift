import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State var showCourseInfo: Bool = false
    @State var chosenCourse: Course?

    var body: some View {
        NavigationView {
            List {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    ForEach(viewModel.results) { course in
                        Button(action: {
                            chosenCourse = course
                            showCourseInfo = true
                        }, label: {
                            VStack(alignment: .leading) {
                                Text(course.course_name)
                                    .font(.headline)
                                Text(course.club_name)
                                    .font(.subheadline)
                                Text(course.location.address ?? "Address not found.")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        })
                        
                    }

                }
            }
            .navigationTitle("Search")
            .searchable(text: $viewModel.searchText, prompt: "Search...")
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
        }
        .sheet(item: $chosenCourse) { course in
            CourseInfoView(course: course)
        }

    }
}

#Preview {
    SearchView()
}
