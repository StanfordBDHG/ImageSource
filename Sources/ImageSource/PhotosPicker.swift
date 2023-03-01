//
// This source file is part of the ImageSource open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@_implementationOnly import PhotosUI
import SwiftUI


class PhotosPickerDelegate: NSObject, PHPickerViewControllerDelegate {
    private let phPickerViewControllerWrapper: PHPickerViewControllerWrapper
    
    
    fileprivate init(_ phPickerViewControllerWrapper: PHPickerViewControllerWrapper) {
        self.phPickerViewControllerWrapper = phPickerViewControllerWrapper
    }
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider else { return }
        
        guard provider.canLoadObject(ofClass: UIImage.self) else {
            self.phPickerViewControllerWrapper.saveImage(.failure(.importFailed))
            return
        }
        
        let progress = provider.loadObject(ofClass: UIImage.self) { image, _ in
            guard let image = image as? UIImage else {
                return
            }
            
            self.phPickerViewControllerWrapper.saveImage(.success(image))
        }
        self.phPickerViewControllerWrapper.saveImage(.loading(progress))
    }
}


struct PHPickerViewControllerWrapper: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    fileprivate let saveImage: (ImageState) -> ()
    
    
    init(
        image: Binding<ImageState>,
        pickerConfiguration: PHPickerConfiguration = PHPickerConfiguration()
    ) {
        saveImage = { imageState in
            image.wrappedValue = imageState
        }
    }
    
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    
    func makeCoordinator() -> PhotosPickerDelegate {
        PhotosPickerDelegate(self)
    }
}


/// <#Description#>
public struct PhotosPicker: View {
    @Binding private var image: ImageState
    
    
    public var body: some View {
        PHPickerViewControllerWrapper(image: $image)
    }
    
    
    /// <#Description#>
    /// - Parameter image: <#image description#>
    public init(image: Binding<ImageState>) {
        self._image = image
    }
}
