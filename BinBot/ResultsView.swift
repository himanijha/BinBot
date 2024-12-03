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
    @State private var showShareSheet = false
    @State private var showPopup = false
    //@State private var showOverlay = true  // Track if overlay should be shown
    @Binding var showOverlay: Bool

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
                    .onTapGesture {
                        showPopup = true  // Show popup when the image is tapped
                        showOverlay = false  // Hide the overlay when tapped
                    }
                
                HStack {
                    Circle()
                        .fill(getColor(for: category))
                        .frame(width: 20, height: 20)
                    Text("\(category)")
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(12)
                .background(getColor(for: category).opacity(0.8))
                .cornerRadius(20)
                .onTapGesture {
                    showPopup = true  // Show popup when the category label is tapped
                    showOverlay = false  // Hide the overlay when tapped
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
                
                // Share Button
                Button(action: {
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
                    ShareSheet(items: [selectedImage])
                }
            }.tint(getColor(for: category))
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: EmptyView()) // Optionally remove the back button by adding an empty view
        .blur(radius: showPopup ? 10 : 0)
        .sheet(isPresented: $showPopup) {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
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
                Text("What is \(category)?")
                    .font(.title)
                    .padding()
                getDescription(for: category)
                    .padding()
                Button(action: {
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
        .overlay(
            // Show overlay only if it's the first time the view appears
            Group {
                if showOverlay {
                    VStack {
                        Text("Tap the image for more info!")
                            .font(.headline)
                            .foregroundColor(getColor(for: category))
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(20)
                        
                        Spacer()
                        
                        Button(action: {
                            showOverlay = false // Hide the overlay when "Got it!" is tapped
                        }) {
                            Text("Got it!")
                                .font(.headline)
                                .foregroundColor(getColor(for: category))
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .padding(.bottom, 20)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.4))
                    .edgesIgnoringSafeArea(.all)
                }
            }
        )
    }
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
    // Get the current color scheme (light or dark mode)
    //@Environment(\.colorScheme) var colorScheme

    // Determine the foreground color based on the color scheme
    //let foregroundColor: Color = colorScheme == .dark ? .white : .black
    let foregroundColor: Color = .white
    
    return VStack(alignment: .leading, spacing: 10) {
        switch category {
        case "Trash":
            VStack(alignment: .leading, spacing: 10) {
                Text("• A ").foregroundColor(foregroundColor) +
                Text("landfill item ").foregroundColor(foregroundColor).bold() +
                Text("is any object that cannot be effectively recycled or composted and is therefore disposed of in a landfill.")
                    .foregroundColor(foregroundColor)
                Text("• These items include non-recyclable plastics, certain textiles, and contaminated materials.").foregroundColor(foregroundColor)
                Text("• They accumulate in landfills where they can persist for long periods, contributing to environmental pollution and space consumption.").foregroundColor(foregroundColor)
                Text("Similar Objects")
                    .font(.subheadline)
                    .foregroundColor(foregroundColor)
                    .fontWeight(.bold)
                    .padding(.top)
                HStack {
                    Text("#PlasticBottles")
                        .foregroundColor(foregroundColor)
                        .font(.subheadline)
                        .padding(10.0)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    Text("#PaperTowels")
                        .foregroundColor(foregroundColor)
                        .font(.subheadline)
                        .padding(10.0)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    Text("#Electronics")
                        .foregroundColor(foregroundColor)
                        .font(.subheadline)
                        .padding(10.0)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }.foregroundColor(foregroundColor)
            }.fixedSize(horizontal: false, vertical: true)
            
        case "Compost":
            VStack(alignment: .leading, spacing: 10) {
                Text("• A ").foregroundColor(foregroundColor) +
                Text("compostable object ").foregroundColor(foregroundColor).bold() +
                Text("is any item that can decompose naturally into nutrient-rich soil under controlled conditions.")
                    .foregroundColor(foregroundColor)
                Text("• This typically involves organic materials like ").foregroundColor(foregroundColor) +
                Text("food scraps, yard waste, and certain biodegradable products.").foregroundColor(foregroundColor).bold()
                Text("• Composting these items helps reduce waste, enrich soil, and decrease methane emissions from landfills.").foregroundColor(foregroundColor)
                Text("Similar Objects")
                    .font(.subheadline)
                    .foregroundColor(foregroundColor)
                    .fontWeight(.bold)
                    .padding(.top)
                HStack {
                    Text("#FruitPeels")
                        .foregroundColor(foregroundColor)
                        .font(.subheadline)
                        .padding(10.0)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(10)
                    Text("#VegetableScraps")
                        .foregroundColor(foregroundColor)
                        .font(.subheadline)
                        .padding(10.0)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(10)
                    Text("#CoffeeGrounds")
                        .foregroundColor(foregroundColor)
                        .font(.subheadline)
                        .padding(10.0)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(10)
                }.foregroundColor(foregroundColor)
            }.fixedSize(horizontal: false, vertical: true)
            
        case "Recyclable":
            VStack(alignment: .leading, spacing: 10) {
                Text("• A ").foregroundColor(foregroundColor) +
                Text("recyclable object ").foregroundColor(foregroundColor).bold() +
                Text("is any item that can be reprocessed into new materials or products, reducing raw resource consumption and waste.")
                    .foregroundColor(foregroundColor)
                Text("• This includes materials like ").foregroundColor(foregroundColor) +
                Text("paper, glass, metals, and certain plastics.").foregroundColor(foregroundColor).bold()
                Text("• These materials can be broken down and reconstituted through industrial processes.").foregroundColor(foregroundColor)
                Text("Similar Objects")
                    .font(.subheadline)
                    .foregroundColor(foregroundColor)
                    .fontWeight(.bold)
                    .padding(.top)
                HStack {
                    Text("#Paper")
                        .foregroundColor(foregroundColor)
                        .font(.subheadline)
                        .padding(10.0)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                    Text("#GlassBottles")
                        .foregroundColor(foregroundColor)
                        .font(.subheadline)
                        .padding(10.0)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                    Text("#MetalCans")
                        .foregroundColor(foregroundColor)
                        .font(.subheadline)
                        .padding(10.0)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                }.foregroundColor(foregroundColor)
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
        return "https://www.cawrecycles.org/alternative-daily-cover"
    case "Compost":
        return "https://www.cawrecycles.org/composting/"
    case "Recycling":
        return "https://www.cawrecycles.org/californias-recycling-industry"
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

#Preview {
    //ResultsView(/*category: "Recycling",*/ selectedImage: UIImage(named: "paper")!, onHome: {}, onRetake: {})
}
