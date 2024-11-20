//
//  ContentView.swift
//  BinBot
//
//  Created by Himani Jha on 11/4/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
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
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
