//
//  ContentView.swift
//  BinBot
//
//  Created by Himani Jha on 11/4/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        //CameraView()
        NavigationSplitView {
            NavigationLink(destination: ScannerView()) {
                VStack {
                    Text("Welcome to BinBot!")
                        .font(.subheadline)
                    
                }.navigationTitle("Home Page")
            }
        } detail: {
            Text("Click the text")
        }
    }
}

#Preview {
    ContentView()
}
