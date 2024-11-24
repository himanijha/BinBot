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
    @State private var showPopup = false

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
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(8.0)
                .background(Color.white.opacity(0.2))
                .cornerRadius(20)
                .onTapGesture {
                    // Set showPopup to true when the HStack is tapped
                    showPopup = true
                }

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
            /*.toolbar {
                // Custom toolbar item to center the title
                ToolbarItem(placement: .principal) {
                    Text("Results")
                        .font(.headline)
                        .foregroundColor(.black)
                }
            }*/
            .navigationBarBackButtonHidden(true)
            .blur(radius: showPopup ? 10 : 0) // Blur the background when popup is shown
            .overlay(
                // Popup overlay
                ZStack {
                    if showPopup {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                // Hide the popup when tapping outside of it
                                showPopup.toggle()
                            }
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    // Close the popup
                                    showPopup.toggle()
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.black)
                                        .padding(8)
                                }
                            }

                            HStack {
                                Text("What is")
                                    .font(.title)
                                    .foregroundColor(.black)
                                HStack {
                                    Circle()
                                        .fill(getColor(for: category))  // Call the helper function to get the color
                                        .frame(width: 20, height: 20)
                                        .padding(2.0)
                                    Text("\(category)")
                                        .foregroundColor(.black)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .padding(5.0)
                                }
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(20)
                                
                                Text("?")
                                    .font(.title)
                                    .foregroundColor(.black)
                            }
                            getDescription(for: category)
                                .padding()
                            /*Text("Similar Objects")
                                .font(.subheadline)
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            HStack {
                                //Spacer()
                                Text("#Hashtag")
                                    .foregroundColor(.black)
                                    .font(.subheadline)
                                    .padding(10.0)
                                    .background(Color.gray)
                                    .cornerRadius(10)
                                Text("#Hashtag")
                                    .foregroundColor(.black)
                                    .font(.subheadline)
                                    .padding(10.0)
                                    .background(Color.gray)
                                    .cornerRadius(10)
                                Text("#Hashtag")
                                    .foregroundColor(.black)
                                    .font(.subheadline)
                                    .padding(10.0)
                                    .background(Color.gray)
                                    .cornerRadius(10)
                            }
                            .padding()*/
                            
                            Button(action: {
                                // Action to perform when the button is tapped
                                openExternalLink(urlString: getLink(for: category))
                            }) {
                                // Define the button's label
                                Text("Learn More")
                                    .padding()
                                    .background(getColor(for: category))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                }
            )
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
            //.background(Color.white)
            //.ignoresSafeArea()
        }
    }
}

#Preview {
    ResultsView(/*category: "Recycling",*/ selectedImage: UIImage(named: "paper")!)
}

//Takes name of photo as input
func predict(photo: UIImage) throws -> String {
    let model = try BinBot()  // Assuming you have a model named RecyclingModel
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
    print("Predicted category: \(classificationLabel)")
    print(output?.targetProbability)
    return classificationLabel
}

func getColor(for category: String) -> Color {
    switch category {
    case "Trash":
        return Color.gray  // Landfill is gray
    case "Compost":
        return Color.green  // Compost is green
    case "Recyclable":
        return Color.blue  // Recycling is blue
    default:
        return Color.purple  // Default to gray if no match is found
    }
}

func getDescription(for category: String) -> some View {
    VStack(alignment: .leading, spacing: 10) {
        switch category {
        case "Trash":
            VStack(alignment: .leading, spacing: 10) {
                Text("• A ").foregroundColor(.black) +
                Text("landfill item ").foregroundColor(.black).bold() +
                Text("is any object that cannot be effectively recycled or composted and is therefore disposed of in a landfill.")
                    .foregroundColor(.black)
                Text("• These items include non-recyclable plastics, certain textiles, and contaminated materials.").foregroundColor(.black)
                Text("• They accumulate in landfills where they can persist for long periods, contributing to environmental pollution and space consumption.").foregroundColor(.black)
                Text("Similar Objects")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding(.top)
                HStack {
                    Text("#PlasticBottles")
                        .foregroundColor(.black)
                        .font(.subheadline)
                        .padding(10.0)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    Text("#PaperTowels")
                        .foregroundColor(.black)
                        .font(.subheadline)
                        .padding(10.0)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    Text("#Electronics")
                        .foregroundColor(.black)
                        .font(.subheadline)
                        .padding(10.0)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }.foregroundColor(.black)
            }
        case "Compost":
            VStack(alignment: .leading, spacing: 10) {
                Text("• A ").foregroundColor(.black) +
                Text("compostable object ").foregroundColor(.black).bold() +
                Text("is any item that can decompose naturally into nutrient-rich soil under controlled conditions.")
                    .foregroundColor(.black)
                Text("• This typically involves organic materials like ").foregroundColor(.black) +
                Text("food scraps, yard waste, and certain biodegradable products.").foregroundColor(.black).bold()
                Text("• Composting these items helps reduce waste, enrich soil, and decrease methane emissions from landfills.").foregroundColor(.black)
                Text("Similar Objects")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding(.top)
                HStack {
                    Text("#FruitPeels")
                        .foregroundColor(.black)
                        .font(.subheadline)
                        .padding(10.0)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(10)
                    Text("#VegetableScraps")
                        .foregroundColor(.black)
                        .font(.subheadline)
                        .padding(10.0)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(10)
                    Text("#CoffeeGrounds")
                        .foregroundColor(.black)
                        .font(.subheadline)
                        .padding(10.0)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(10)
                }.foregroundColor(.black)
            }
        case "Recyclable":
            VStack(alignment: .leading, spacing: 10) {
                Text("• A ").foregroundColor(.black) +
                Text("recyclable object ").foregroundColor(.black).bold() +
                Text("is any item that can be reprocessed into new materials or products, reducing raw resource consumption and waste.")
                    .foregroundColor(.black)
                Text("• This includes materials like ").foregroundColor(.black) +
                Text("paper, glass, metals, and certain plastics.").foregroundColor(.black).bold()
                Text("• These materials can be broken down and reconstituted through industrial processes.").foregroundColor(.black)
                Text("Similar Objects")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding(.top)
                HStack {
                    Text("#Paper")
                        .foregroundColor(.black)
                        .font(.subheadline)
                        .padding(10.0)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                    Text("#GlassBottles")
                        .foregroundColor(.black)
                        .font(.subheadline)
                        .padding(10.0)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                    Text("#MetalCans")
                        .foregroundColor(.black)
                        .font(.subheadline)
                        .padding(10.0)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                }.foregroundColor(.black)
            }
        default:
            Text("Please retake the photo.")
        }
    }
}


func openExternalLink(urlString: String) {
    if let url = URL(string: urlString) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

//Fix Links
func getLink(for category: String) -> String {
    switch category {
    case "Trash":
        return "https://lacity.gov/residents/trash-recycling"
    case "Compost":
        return "https://www.nrdc.org/stories/composting-101"
    case "Recycling":
        return "https://how2recycle.info/"
    default:
        return ""
    }
}

func getProbabilities(photo: UIImage) async throws -> [String: Double] {
    let model = try BinBot()
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


