//
//  WelcomeView.swift
//  GolfCourseFinder
//
//  Created by Hans Heidmann on 4/12/25.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var hasLaunched: Bool // bound to its counterpart in RootView, use: this screen stops showing after continue button is pressed

    //
    // simple welcome view
    //
    var body: some View {
        ZStack {
            Image("welcome_screen_bg") // grass fullscreen background
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // gradient darkening tint over background, lighter at top darker at bottom
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.5), .clear]),
                startPoint: .bottom,
                endPoint: .top
            )
            .ignoresSafeArea()
            
            VStack {
                Image("Logo_Large") // Green Tees Golf logo
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .padding(.horizontal, 50)
                    .shadow(color: Color.green.opacity(0.9), radius: 10, x: 0, y: 5)
                
                
                Button(action: {
                    hasLaunched = true // allows RootView to hide this welcome screen and show the app
                }) {
                    Text("Let's go!")
                        .fontWeight(.semibold)
                        .font(.title3)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.0))
                        .cornerRadius(25)
                        .shadow(color: Color.green.opacity(0.5), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 90)
                
            }
        }
    }
}
