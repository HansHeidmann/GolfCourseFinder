//
//  TeeSummaryView.swift
//  GolfCourseFinder
//
//  Created by Hans Heidmann on 4/12/25.
//

import SwiftUI

struct TeeSummaryView: View {
    let tees: [Tee]
    let label: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if tees.isEmpty {
                Text("No \(label.lowercased()) data available.")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Spacer()
            } else {
                Text(label)
                    .font(.headline)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(tees, id: \.tee_name) { tee in
                            VStack(alignment: .leading) {
                                Text(tee.tee_name)
                                    .font(.title3)
                                    .bold()
                                Text("Rating: \(tee.course_rating ?? 0, specifier: "%.1f")")
                                Text("Slope: \(tee.slope_rating ?? 0)")
                                Text("Yards: \(tee.total_yards ?? 0)")
                                Text("Par: \(tee.par_total ?? 0)")
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
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


#Preview {
    TeeSummaryView(tees: [], label: "male")
}
