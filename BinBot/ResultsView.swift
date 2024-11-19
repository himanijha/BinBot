//
//  ResultsView.swift
//  BinBot
//
//  Created by Lian Elsa Linton on 11/17/24.
//

import SwiftUICore
import UIKit
import SwiftUI
import Charts

struct ResultsView: View {
    var selectedImage: UIImage // Image passed from ScannerView
    @State private var category: String = ""
    @State private var probabilities: [String: Double] = [:]
    //var category: String = predict(photo: selectedImage)
    @State private var showShareSheet = false // State to control the display of the ShareSheet

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Display the selected image
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 350)
                    .cornerRadius(10)
                    .padding()
                
                /*PieChartView(probabilities: probabilities)
                    .frame(height: 300)
                    .padding()*/

                // Category Section
                HStack {
                    Circle()
                        .fill(getColor(for: category))  // Call the helper function to get the color
                        .frame(width: 20, height: 20)
                        .padding(3.0)
                    Text("\(category)")
                        .foregroundColor(.black)
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(8.0)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(20)

                // Navigation Buttons Section
                HStack(spacing: 30) {
                    NavigationLink(destination: ContentView()) {
                        Text("Home")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }

                    NavigationLink(destination: ScannerView()) {
                        Text("Retake")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(8)
                    }

                    // Share Button
                    Button(action: {
                        // Trigger the ShareSheet when the Share button is tapped
                        showShareSheet.toggle()
                    }) {
                        Text("Share")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.orange)
                            .cornerRadius(8)
                    }
                    .sheet(isPresented: $showShareSheet) {
                        // Display ShareSheet with the selected image
                        ShareSheet(items: [selectedImage])
                    }
                }
            }
            .padding()
            .navigationTitle("Results")
            .onAppear {
                // Call the predict function when the view appears
                Task {
                    do {
                        let predictedCategory = try await predict(photo: selectedImage)
                        category = predictedCategory
                        
                        let predictedProbabilities = try await getProbabilities(photo: selectedImage)
                        probabilities = predictedProbabilities
                    } catch {
                        print("Prediction error: \(error)")
                    }
                }
            }
        }
    }
}

#Preview {
    ResultsView(/*category: "Recycling",*/ selectedImage: UIImage(named: "paper")!)
}

//Takes name of photo as input
func predict(photo: UIImage) throws -> String {
    let model = try RecyclingModel()  // Assuming you have a model named RecyclingModel
    var classificationLabel = ""
    
    // Image Preprocessing: Resize the image and convert it to a CVPixelBuffer
    guard let resizedImage = photo.resizeTo(size: CGSize(width: 360, height: 360)),
          let buffer = resizedImage.toBuffer() else {
        return ""  // Return empty string if resizing or buffer conversion fails
    }
    
    // Use the model to classify the image
    let output = try? model.prediction(image: buffer)
    if let output = output {
        classificationLabel = output.target
    }
    
    return classificationLabel
}

func getColor(for category: String) -> Color {
    switch category {
    case "Trash":
        return Color.gray  // Landfill is gray
    case "Compost":
        return Color.green  // Compost is green
    case "Recycling":
        return Color.blue  // Recycling is blue
    default:
        return Color.purple  // Default to gray if no match is found
    }
}

func getProbabilities(photo: UIImage) async throws -> [String: Double] {
    let model = try RecyclingModel()
    var probabilities: [String: Double] = [:]
    
    // Image Preprocessing: Resize the image and convert it to a CVPixelBuffer
    guard let resizedImage = photo.resizeTo(size: CGSize(width: 360, height: 360)),
          let buffer = resizedImage.toBuffer() else {
        return probabilities // Return empty dictionary if resizing or buffer conversion fails
    }
    
    // Use the model to classify the image
    let output = try? await model.prediction(image: buffer)
    if let output = output {
        probabilities = output.targetProbability // Assuming this returns a dictionary
    }
    
    return probabilities
}


