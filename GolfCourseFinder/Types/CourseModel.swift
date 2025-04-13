//
//  Item.swift
//  GolfCourseFinder
//
//  Created by Hans Heidmann on 4/10/25.
//

import Foundation
import SwiftData

@Model
final class CourseModel {
    var id: Int
    var clubName: String
    var courseName: String
    var address: String?
    var city: String?
    var state: String?
    var country: String?

    init(id: Int, clubName: String, courseName: String, address: String, city: String, state: String, country: String) {
        self.id = id
        self.clubName = clubName
        self.courseName = courseName
        self.address = address
        self.city = city
        self.state = state
        self.country = country
        
    }
}

extension CourseModel {
    var asCourse: Course {
        return Course(
            id: id,
            club_name: clubName,
            course_name: courseName,
            location: Location(address: address, city: city, state: state, country: country),
            tees: Tees(female: nil, male: nil)
        )
    }
}

extension CourseModel {
    convenience init(from course: Course) {
        self.init(
            id: course.id,
            clubName: course.club_name,
            courseName: course.course_name,
            address: course.location.address ?? "",
            city: course.location.city ?? "",
            state: course.location.state ?? "",
            country: course.location.country ?? ""
        )
    }
}

