//
//  ResponseObjects.swift
//  GolfCourseFinder
//
//  Created by Hans Heidmann on 4/12/25.
//

struct CourseSearchResponse: Decodable {
    let courses: [Course]
}

struct Course: Identifiable, Decodable {
    let id: Int
    let club_name: String
    let course_name: String
    let location: Location
    let tees: Tees
}
extension Course: Equatable {
    static func == (lhs: Course, rhs: Course) -> Bool {
        lhs.id == rhs.id
    }
}

struct Location: Decodable {
    let address: String?
    let city: String?
    let state: String?
    let country: String?
}

struct Tees: Decodable {
    let female: [Tee]?
    let male: [Tee]?
}


struct Tee: Identifiable, Decodable {
    var id: String { tee_name } // unique enough for ForEach
    let tee_name: String
    let course_rating: Double?
    let slope_rating: Int?
    let bogey_rating: Double?
    let total_yards: Int?
    let total_meters: Int?
    let number_of_holes: Int?
    let par_total: Int?
    let front_course_rating: Double?
    let front_slope_rating: Int?
    let front_bogey_rating: Double?
    let back_course_rating: Double?
    let back_slope_rating: Int?
    let back_bogey_rating: Double?
}
