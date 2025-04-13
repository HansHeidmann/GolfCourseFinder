# ⛳️ ⛳️ ⛳️ ⛳️ ⛳️ ⛳️ ⛳️ ⛳️ ⛳️ ⛳️ ⛳️ ⛳️ ⛳️ ⛳️ ⛳️ ⛳️ ⛳️ ⛳️
# Golf Course Finder

A SwiftUI-based iOS app that lets you search for golf courses using data from the [GolfCourseAPI](https://golfcourseapi.com/).

---

## Features

- Course search
- Location details  
- Tee breakdowns by gender
- Recently viewed courses persist in CoreData (using new SwiftData implementation)

---

## Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/HansHeidmann/GolfCourseFinder.git
2. **Open 'GolfCourseFinder.xcodeproj' with Xcode**
3. **Get an API Key** from [GolfCourseAPI](https://golfcourseapi.com/)
4. **Insert your API Key**
   find this line in the only ViewModel:
   ```swift
   request.setValue("Key YOUR_API_KEY", forHTTPHeaderField: "Authorization")
6. **Run the app**
   - Select a simulator or connected device
   - Press 'Cmd + R' to build and run

---
