# ⛳️ ⛳️ ⛳️
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
2. **Open `GolfCourseFinder.xcodeproj` with Xcode**
3. Get an API Key from [GolfCourseAPI](https://golfcourseapi.com/)
4. Insert your API Key into this line in the ViewModel file: request.setValue("Key YOUR_API_KEY", forHTTPHeaderField: "Authorization")
5. **Press run**
   - Select a simulator or connected device
   - Press `Cmd + R` or click ▶️ to build and run

---
