//
//  ResultsView.swift
//  BinBot
//
//  Created by Lian Elsa Linton on 11/17/24.
//

import SwiftUI

struct ResultsView: View {
    var selectedImage: UIImage // Image passed from ScannerView
    var onHome: () -> Void
    var onRetake: () -> Void
    @State private var category: String = ""
    @State private var probabilities: [String: Double] = [:]
    @State private var showShareSheet = false // State to control the display of the ShareSheet
    @State private var showPopup = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Display the selected image
            ZStack(alignment: .bottom) {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(16)
                    .padding(8)
                    .background(getColor(for: category))
                    .cornerRadius(16)
                    .frame(width: 350, height: 500)
                    .padding()
                
                HStack {
                    Circle()
                        .fill(getColor(for: category))  // Call the helper function to get the color
                        .frame(width: 20, height: 20)
                    Text("\(category)")
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(12)
                //.background(Color.white.opacity(0.2))
                .background(getColor(for: category).opacity(0.8))
                .cornerRadius(20)
                .onTapGesture {
                    // Set showPopup to true when the HStack is tapped
                    showPopup = true
                }
                .alignmentGuide(.bottom) { _ in
                    100
                }
            }
            
            // Navigation Buttons Section
            HStack(spacing: 55) {
                Button(action: {
                    onHome()
                }) {
                    VStack {
                        Image(systemName: "house")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50)
                        Text("Home")
                    }
                }
                .sheet(isPresented: $showShareSheet) {
                    // Display ShareSheet with the selected image
                    ShareSheet(items: [selectedImage])
                }
                
                Button(action: {
                    onRetake()
                }) {
                    VStack {
                        Image(systemName: "arrow.counterclockwise")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50)
                        Text("Retake")
                    }
                }
                .sheet(isPresented: $showShareSheet) {
                    // Display ShareSheet with the selected image
                    ShareSheet(items: [selectedImage])
                }
                
                // Share Button
                Button(action: {
                    // Trigger the ShareSheet when the Share button is tapped
                    showShareSheet.toggle()
                }) {
                    VStack {
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50)
                        Text("Share")
                    }
                }
                .sheet(isPresented: $showShareSheet) {
                    // Display ShareSheet with the selected image
                    ShareSheet(items: [selectedImage])
                }
            }.tint(getColor(for: category))
        }
        .padding()
        .navigationBarBackButtonHidden(true) // Explicitly hide back button
        .navigationBarItems(leading: EmptyView()) // Optionally remove the back button by adding an empty view
        .blur(radius: showPopup ? 10 : 0) // Blur the background when popup is shown
        .sheet(isPresented: $showPopup) {
            // Popup overlay
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
                Spacer()
                
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
                Button(action: {
                    // Action to perform when the button is tapped
                    openExternalLink(urlString: getLink(for: category))
                }) {
                    Text("Learn More")
                        .padding()
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white, lineWidth: 2)
                                .fill(getColor(for: category))
                        )
                }
                Spacer()
            }
            .padding()
        }
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


#Preview {
    ResultsView(/*category: "Recycling",*/ selectedImage: UIImage(named: "paper")!, onHome: {}, onRetake: {})
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
            }.fixedSize(horizontal: false, vertical: true)
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
            }.fixedSize(horizontal: false, vertical: true)
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
            }.fixedSize(horizontal: false, vertical: true)
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


