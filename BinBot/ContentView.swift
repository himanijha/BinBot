//
//  ContentView.swift
//  BinBot
//
//  Created by Himani Jha on 11/4/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedImage: UIImage?
    @State private var cameraIsPresented = false
    @State private var tutorialIsPresented = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if let selectedImage {
                    ResultsView(selectedImage: selectedImage, onHome: {
                        self.selectedImage = nil
                    }, onRetake: {
                        self.selectedImage = nil
                        cameraIsPresented = true
                    })
                } else {
                    VStack {
                        Text("Welcome to BinBot!")
                            .foregroundStyle(.white)
                            .font(.largeTitle)
                            .padding()
                        Button(action: {
                            cameraIsPresented = true
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
            }.sheet(isPresented: $cameraIsPresented) {
                CameraView { image in
                    selectedImage = image
                    cameraIsPresented = false
                }
            }.sheet(isPresented: $tutorialIsPresented) {
                Text("Tutorial goes here!") // TODO: Lian, please add the tutorial view here!
            }
            .toolbar {
                Button(action: {
                    tutorialIsPresented = true
                }, label: {
                    ZStack {
                        Circle().fill(Color.black.opacity(0.25))
                        Image(systemName: "questionmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .tint(.white)
                            .padding(5)
                    }
                })
            }
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
