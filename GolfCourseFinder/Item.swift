//
//  Item.swift
//  GolfCourseFinder
//
//  Created by Hans Heidmann on 4/10/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
