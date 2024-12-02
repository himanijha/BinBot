//
//  ContentView.swift
//  BinBot
//
//  Created by Himani Jha on 11/4/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedImage: UIImage?
    @State private var isPresented = false
    
    var body: some View {
        VStack {
            if let selectedImage {
                ResultsView(selectedImage: selectedImage, onHome: {
                    self.selectedImage = nil
                }, onRetake: {
                    self.selectedImage = nil
                    isPresented = true
                })
            } else {
                VStack {
                    Spacer().frame(height: 50)
                    Text("Welcome to BinBot!")
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                        .padding()
                    Button(action: {
                        isPresented = true
                    }) {
                        ZStack {
                            Circle().fill(Color.black.opacity(0.25)).frame(width: 150)
                            Image(systemName: "camera")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100)
                                .tint(.white)
                        }
                    }
                    Spacer().frame(height: 50)
                }
                .frame(maxWidth: .infinity)
                .background(.green)
                
                HomeTabsView()
                    .background(.green)
                    .foregroundStyle(.white)
                    .padding()
            }
        }.sheet(isPresented: $isPresented) {
            CameraView { image in
                selectedImage = image
                isPresented = false
            }
            /*
             Text("Take Photo")
             .padding()
             .foregroundColor(.white)
             .background(Color.purple)
             .cornerRadius(8)
             }
             .padding()
             */
        }
    }
}
        /*NavigationStack {
            VStack {
                Text("Welcome to BinBot!")
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .padding()

                NavigationLink(destination: ScannerView()) {
                    Text("Take Photo")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.purple)
                        .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("Home Page")
            /*.toolbar {
                // Custom toolbar item to center the title
                ToolbarItem(placement: .principal) {
                    Text("Home Page")
                        .font(.headline)
                        .foregroundColor(.black)
                }
            }*/
            .navigationBarBackButtonHidden(true)*/

#Preview {
    ContentView()
}
