//
//  CourseInfoView.swift
//  GolfCourseFinder
//
//  Created by Hans Heidmann on 4/12/25.
//

import SwiftUI

struct CourseInfoView: View {
    let course: Course // require a Course to supplied when presenting this view
    @State private var selectedGender = 0 // state for tees being currently viewed: 0 = male, 1 = female
    
    var body: some View {
        VStack(spacing: 0) {
            
            // instgram comments sheet view style top grip
            Capsule()
                .fill(Color.secondary)
                .frame(width: 40, height: 5)
                .padding(.vertical, 10)
            
            // title on top of sheet by grip
            Text("Course Info")
                .font(.headline)
                .padding(.bottom, 10)
            
            //
            // HEADER
            //
            ZStack(alignment: .topLeading) {
                // course photo
                Image(course.course_name == "South" ? "SouthTorreyPines" : "GolfCourse")
                    .resizable() // needed for next line
                    .aspectRatio(5/3, contentMode: .fit) // make all photos same dimensions
                    .clipShape(RoundedRectangle(cornerRadius: 10)) // nice rounded corners
                    .overlay(RoundedRectangle(cornerRadius: 10).fill(Color.black.opacity(0.3))) // darken tint
                // course title and club name
                VStack(alignment: .leading, spacing: 4) {
                    Text(course.course_name)
                        .font(.title)
                        .bold()
                        .foregroundStyle(.white)
                    Text(course.club_name)
                        .font(.title2)
                        .foregroundStyle(.white)
                }
                .padding()
            }
            .padding(.bottom, 20)
            
            // Address section
            VStack(alignment: .leading, spacing: 8) {
                Text("Address")
                    .font(.title3)
                    .bold()
                
                if let address = course.location.address {
                    HStack {
                        Text(address)
                        Spacer()
                        
                    }
                    Button(action: {
                        // MARK: make maps button work
                    }) {
                        Image(systemName: "mappin.circle.fill")
                        Text("View on Map")
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    HStack {
                        Text("No address available.")
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
                
                
                Text("Tees")
                    .font(.title3)
                    .bold()
                    .padding(.top, 20)
                
                // Gender tab selector
                GeometryReader { geo in
                    let totalWidth = geo.size.width
                    let buttonWidth = totalWidth / 2

                    ZStack(alignment: selectedGender == 0 ? .leading : .trailing) {
                        // Sliding green outline RoundedRect
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(red: 0.0, green: 0.6, blue: 0.0), lineWidth: 3)
                            .frame(width: buttonWidth, height: 44)
                            .animation(.easeInOut(duration: 0.3), value: selectedGender)
                        
                        // Mens/Womens buttons
                        HStack(spacing: 0) {
                            ForEach(0..<2) { index in
                                Button(action: {
                                    withAnimation { // animate slider to selected gender
                                        selectedGender = index
                                    }
                                }) {
                                    Text(index == 0 ? "Mens" : "Womens")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .frame(width: buttonWidth, height: 44)
                                        .foregroundColor(selectedGender == index ? .green : .white) // make selected gender green
                                }
                                .background(Color.clear)
                            }
                        }
                    }
                    .frame(height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 12) // white outline around whole mens/womens buttons area
                            .stroke(Color.white, lineWidth: 2)
                    )
                }
                .frame(height: 44)
                
                // animates between mens/womens [Tee]'s with left right swiping
                TabView(selection: $selectedGender) {
                    TeeSummaryView(tees: course.tees.male ?? [], label: "Men’s Tees")
                        .tag(0)
                    TeeSummaryView(tees: course.tees.female ?? [], label: "Women’s Tees")
                        .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never)) // hide the dots/numbers not needed anymore
                .frame(height: 200)


            }
            
            Spacer() // keeps the whole view aligned to .top
        }
        .padding(10)
    }
}

// random
#Preview {
    CourseInfoView(course: Course(
        id: 0,
        club_name: "The Most Random Country Club Ever",
        course_name: "Best Golf Course Ever",
        location: Location(
            address: "111 Cool Street, San Diego, California, 12345",
            city: "San Diego",
            state: "CA",
            country: "USA"
        ),
        tees: Tees(female: [], male: [])
    ))
}
