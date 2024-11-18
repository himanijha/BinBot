//
//  ScannerView.swift
//  BinBot
//
//  Created by Lian Elsa Linton on 11/17/24.
//

import SwiftUI

struct ScannerView: View {
    var category: String = "Landfill";
    var body: some View {
            HStack {
                Spacer() // Pushes content to the right
                NavigationLink(destination: ResultsView(category: category)) {
                    Text("Predict")
                        .padding()
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
            }
        CameraView()
    }
}

#Preview {
    ScannerView()
}
