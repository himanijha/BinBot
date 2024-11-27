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
            Text("Welcome to BinBot!")
                .font(.largeTitle)
                .padding()
            if let selectedImage {
                ResultsView(selectedImage: selectedImage)
            } else {
                Button(action: {
                    isPresented = true
                }) {
                    ZStack {
                        Circle().fill(Color.yellow).frame(width: 150)
                        Image(systemName: "camera")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                    }
                }
                Spacer().frame(height: 30)
                HomeTabsView()
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
