# ⛳️ ⛳️ ⛳️ ⛳️ ⛳️ ⛳️ ⛳️ ⛳️ ⛳️ ⛳️ ⛳️ ⛳️ ⛳️ ⛳️ ⛳️ ⛳️ ⛳️ ⛳️
# Golf Course Finder

A SwiftUI-based iOS app that lets you search for golf courses using data from the [GolfCourseAPI](https://golfcourseapi.com/).

---

## Demo
[Watch on YouTube](https://youtu.be/S6Pxat3eYSw)

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
3. **I didn't add a gitignore for the Secrets.xcconfig (has API Key) can use as is and skip steps 4 and 5**
4.  **Get an API Key** from [GolfCourseAPI](https://golfcourseapi.com/)
5. **Insert your API Key**
   find this line in the only ViewModel:
   ```swift
   request.setValue("Key YOUR_API_KEY", forHTTPHeaderField: "Authorization")
6. **Run the app**
   - Select a simulator or connected device
   - Press 'Cmd + R' to build and run

---
