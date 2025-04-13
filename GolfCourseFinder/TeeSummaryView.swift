//
//  TeeSummaryView.swift
//  GolfCourseFinder
//
//  Created by Hans Heidmann on 4/12/25.
//

import SwiftUI

struct TeeSummaryView: View {
    let tees: [Tee] // state to hold array of [Tee] data
    let label: String // visual label for this view
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // if no data for this course:
            if tees.isEmpty {
                Text("No \(label.lowercased()) data available.") // let users know if no tee data for this course
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Spacer() // align text to .top
            } 
            // if there is data for this course:
            else {
                Text(label)
                    .font(.headline)

                ScrollView(.horizontal, showsIndicators: false) { // side scroll view
                    HStack(spacing: 12) {
                        ForEach(tees, id: \.tee_name) { tee in // for each tee there is data about:
                            VStack(alignment: .leading) { // build a section to display the data
                                Text(tee.tee_name)
                                    .font(.title3)
                                    .bold()
                                Text("Rating: \(tee.course_rating != nil ? String(format: "%.1f", tee.course_rating!) : "Unknown")")
                                Text("Slope: \(tee.slope_rating != nil ? "\(tee.slope_rating!)" : "Unknown")")
                                Text("Yards: \(tee.total_yards != nil ? "\(tee.total_yards!)" : "Unknown")")
                                Text("Par: \(tee.par_total != nil ? "\(tee.par_total!)" : "Unknown")")

                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.trailing, 10)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading) // align text left
    }
}


#Preview {
    TeeSummaryView(tees: [], label: "male")
}
