//
//  ShareSheet.swift
//  BinBot
//
//  Created by Lian Elsa Linton on 11/17/24.
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return activityVC
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No updates needed for this example.
    }
}
