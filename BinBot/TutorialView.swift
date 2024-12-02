//
//  TutorialView.swift
//  BinBot
//
//  Created by Lian Elsa Linton on 12/2/24.
//

import SwiftUI

struct TutorialView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            TabView {
                // Step 1: Take a Picture
                VStack {
                    Text("Step 1: Take a Picture")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    Image(systemName: "camera.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding()
                    Text("Tap the camera button to take a picture of the object you want to classify.")
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                // Step 2: Use or Retake the Photo
                VStack {
                    Text("Step 2: Review Your Photo")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    Image(systemName: "photo.fill.on.rectangle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding()
                    VStack(alignment: .leading, spacing: 10) {
                        Text("1. **Use Photo**: If you're happy with the picture, tap 'Use Photo' to classify it.")
                        Text("2. **Retake Photo**: If you'd like to take a better picture, tap 'Retake' to try again.")
                    }
                    .padding()
                    .multilineTextAlignment(.leading)
                }
                
                // Step 3: View Your Classification
                VStack {
                    Text("Step 3: View Your Classification")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    Image(systemName: "list.bullet.rectangle.portrait.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding()
                    VStack(alignment: .leading, spacing: 10) {
                        Text("1. **View Classification**: After using the photo, the app will show the classification result.")
                        Text("2. **Retake Photo**: If you'd like to take a better picture, tap 'Retake'.")
                        Text("3. **Home**: If you want to start over, tap 'Home' to reset the process.")
                    }
                    .padding()
                    .multilineTextAlignment(.leading)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))

            Button("Got it!") {
                dismiss()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(10)
        }
        .padding()
    }
}
