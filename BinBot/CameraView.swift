//
//  CameraView.swift
//  BinBot
//
//  Created by Himani Jha on 11/5/24.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }
}

