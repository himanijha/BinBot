//
//  ResultsView.swift
//  BinBot
//
//  Created by Lian Elsa Linton on 11/17/24.
//

import SwiftUI

struct ResultsView: View {
    var category: String
    @State private var showShareSheet = false // State to control the display of the ShareSheet
    @State private var selectedImage: UIImage? = UIImage(named: "paper") // Replace with your image
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image("paper") // Replace with your actual image
                    .resizable()
                    .frame(width: 300, height: 350)
                    .padding(4.0)
                
                Text("Paper Packaging")
                    .font(.title)
                    .fontWeight(.bold)
                
                // Category Section
                HStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 20, height: 20)
                        .padding(3.0)
                    Text("\(category)")
                        .foregroundColor(.black)
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
                        ShareSheet(items: [selectedImage!])
                    }
                }
            }
            .padding()
            .navigationTitle("Results")
        }
    }
}

#Preview {
    ResultsView(category: "Recycling")
}


