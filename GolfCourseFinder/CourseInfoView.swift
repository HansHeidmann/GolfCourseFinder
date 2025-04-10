//
//  CourseInfoView.swift
//  GolfCourseFinder
//
//  Created by Hans Heidmann on 4/10/25.
//

import SwiftUI

struct CourseInfoView: View {
    let course: Course

    var body: some View {
        VStack(spacing: 0) {
            
            // Grabber
            Capsule()
                .fill(Color.secondary)
                .frame(width: 40, height: 5)
                .padding(.vertical, 10)
            
            Text("Course Info")
                .font(.headline)
            
            // Image + Overlay
            ZStack(alignment: .topLeading) {
                Image("GolfCourse")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
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
                        Button(action: {
                            // e.g. open Maps or copy address
                        }) {
                            Image(systemName: "map")
                            Text("Map")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    Text("No address available.")
                        .foregroundColor(.secondary)
                }
            }

            Spacer()
        }
        .padding(10)
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
        )
    ))
}
