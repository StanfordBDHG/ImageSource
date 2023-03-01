//
// This source file is part of the ImageSource open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import UIKit
import SwiftUI


class ImagePickerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let saveImage: (ImageState) -> ()
    private let presentationMode: Binding<PresentationMode>
    
    
    fileprivate init(saveImage: @escaping (ImageState) -> (), presentationMode: Binding<PresentationMode>) {
        self.saveImage = saveImage
        self.presentationMode = presentationMode
        
        super.init()
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        defer {
            presentationMode.wrappedValue.dismiss()
        }
        
        guard let newImage = info[.originalImage] as? UIImage else {
            saveImage(.failure(ImageError.importFailed))
            return
        }
        
        saveImage(.success(newImage))
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        presentationMode.wrappedValue.dismiss()
    }
}


fileprivate struct UIImagePickerControllerWrapper: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    private let saveImage: (ImageState) -> ()
    
    
    fileprivate init(image: Binding<ImageState>) {
        saveImage = { imageState in
            image.wrappedValue = imageState
        }
    }
    
    
    fileprivate func makeCoordinator() -> ImagePickerDelegate {
        ImagePickerDelegate(
            saveImage: saveImage,
            presentationMode: presentationMode
        )
    }
    
    fileprivate func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = context.coordinator
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
        }
        return imagePickerController
    }
    
    fileprivate func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}


/// <#Description#>
public struct Camera: View {
    @Binding private var image: ImageState
    
    
    public var body: some View {
        UIImagePickerControllerWrapper(image: $image)
            .background {
                Color.black
                    .edgesIgnoringSafeArea(.all)
            }
    }
    
    
    /// <#Description#>
    /// - Parameter image: <#image description#>
    public init(image: Binding<ImageState>) {
        self._image = image
    }
}
