//
//  ScannerView.swift
//  BinBot
//
//  Created by Lian Elsa Linton on 11/17/24.
//

import UIKit
import SwiftUICore
import SwiftUI

struct ScannerView: View {
    @State private var selectedImage: UIImage? // Store the captured image
    //var category: String = "Landfill" // Default category
    @State private var isImagePicked = false

    var body: some View {
        VStack {
            // Camera View
            CameraView { image in
                selectedImage = image // Save the captured image
                isImagePicked = true
            }
            //.frame(height: 400) // Adjust the camera view height

            // Navigation Button
            HStack {
                Spacer()
                if let image = selectedImage { // Show "Predict" only if an image is captured
                    NavigationLink(destination: ResultsView(/*category: category,*/ selectedImage: image)) {
                        Text("Predict")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.purple)
                            .cornerRadius(8)
                    }
                    /*NavigationLink(destination: ResultsView(selectedImage: image), isActive: $isImagePicked) {
                        EmptyView()  // This invisible NavigationLink is triggered when image is picked
                    }*/
                } else {
                    Text("Capture an Image First")
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ScannerView(/*category: "Recycling"*/)
}

