//
//  CourseInfoView.swift
//  GolfCourseFinder
//
//  Created by Hans Heidmann on 4/10/25.
//

import SwiftUI

struct CourseInfoView: View {
    let course: Course
    @State private var selectedGender = 0 // 0 = male, 1 = female
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Grabber
            Capsule()
                .fill(Color.secondary)
                .frame(width: 40, height: 5)
                .padding(.vertical, 10)
            
            Text("Course Info")
                .font(.headline)
            
            // course photo
            ZStack(alignment: .topLeading) {
                Image(course.course_name == "South" ? "SouthTorreyPines" : "GolfCourse")
                    .resizable()
                    .aspectRatio(5/3, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).fill(Color.black.opacity(0.3)))
                
                
                
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
            .padding(.vertical, 10)
            
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
                        if let address = course.location.address {
                            let urlString = "http://maps.apple.com/?q=\(address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
                            if let url = URL(string: urlString) {
                                UIApplication.shared.open(url)
                            }
                        }
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
                        // Sliding green background
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(red: 0.0, green: 0.6, blue: 0.0), lineWidth: 3)
                            .frame(width: buttonWidth, height: 44)
                            .animation(.easeInOut(duration: 0.3), value: selectedGender)

                        HStack(spacing: 0) {
                            ForEach(0..<2) { index in
                                Button(action: {
                                    withAnimation {
                                        selectedGender = index
                                    }
                                }) {
                                    Text(index == 0 ? "Mens" : "Womens")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .frame(width: buttonWidth, height: 44)
                                        .foregroundColor(selectedGender == index ? .green : .white)
                                }
                                .background(Color.clear)
                            }
                        }
                    }
                    .frame(height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white, lineWidth: 2)
                    )
                }
                .frame(height: 44)
                
                TabView(selection: $selectedGender) {
                    TeeSummaryView(tees: course.tees.male ?? [], label: "Men’s Tees")
                        .tag(0)
                    TeeSummaryView(tees: course.tees.female ?? [], label: "Women’s Tees")
                        .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 200)


            }
            
            Spacer()
        }
        .padding(10)
    }
}

struct GenderToggleButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color.green.opacity(0.2) : Color.clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.green : Color.white, lineWidth: 1.5)
                )
                .foregroundColor(isSelected ? Color.green : Color.white)
        }
        .contentShape(Rectangle()) // ensure entire area is tappable
    }
}


#Preview {
    CourseInfoView(course: Course(
        id: 0,
        club_name: "Club Name",
        course_name: "Region Best Course",
        location: Location(
            address: "111 Cool Street, San Diego, California, 92012",
            city: "San Diego",
            state: "CA",
            country: "USA"
        ),
        tees: Tees(female: [], male: [])
    ))
}
