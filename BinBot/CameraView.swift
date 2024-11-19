//
//  CameraView.swift
//  BinBot
//
//  Created by Himani Jha on 11/5/24.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    var onImagePicked: (UIImage) -> Void
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let onImagePicked: (UIImage) -> Void
        
        init(onImagePicked: @escaping (UIImage) -> Void) {
            self.onImagePicked = onImagePicked
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else { return }
            onImagePicked(image)
        }
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            
            imagePicker.delegate = context.coordinator
            
            return imagePicker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
            
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(onImagePicked: onImagePicked)
        }
    }

