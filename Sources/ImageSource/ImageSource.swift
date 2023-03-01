//
// This source file is part of the ImageSource open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// <#Description#>
public struct ImageSource: View {
    @Binding private var image: UIImage?
    @State private var showCamera: Bool = false
    @State private var showPhotosPicker: Bool = false
    @State private var imageState: ImageState = .empty
    
    
    public var body: some View {
        imageView
            .fullScreenCover(isPresented: $showCamera) {
                Camera(image: $imageState)
            }
            .sheet(isPresented: $showPhotosPicker) {
                PhotosPicker(image: $imageState)
            }
            .onChange(of: imageState) { newImageState in
                image = newImageState.image
            }
    }
    
    
    @ViewBuilder
    private var imageView: some View {
        GeometryReader { proxy in
            ZStack {
                Rectangle()
                    .foregroundColor(Color(.secondarySystemBackground))
                switch imageState {
                case .empty:
                    Menu(
                        content: {
                            Button(
                                action: {
                                    showCamera.toggle()
                                },
                                label: {
                                    Label("Camera", systemImage: "camera.shutter.button")
                                }
                            )
                            Button(
                                action: {
                                    showPhotosPicker.toggle()
                                },
                                label: {
                                    Label("Photo Picker", systemImage: "photo.on.rectangle.angled")
                                }
                            )
                        }
                        , label: {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: proxy.size.width, height: proxy.size.height)
                                Image(systemName: "plus")
                            }
                        }
                    )
                case .loading:
                    ProgressView()
                case .success(let uIImage):
                    Image(uiImage: uIImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                    Menu(
                        content: {
                            Button(
                                role: .destructive,
                                action: {
                                    imageState = .empty
                                },
                                label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            )
                        }
                        , label: {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: proxy.size.width, height: proxy.size.height)
                            }
                        }
                    )
                case .failure(let imageError):
                    Text(imageError.localizedDescription)
                }
            }
        }
    }
    
    
    /// <#Description#>
    /// - Parameter image: <#image description#>
    public init(image: Binding<UIImage?> = Binding(get: { nil }, set: { _ in })) {
        self._image = image
    }
}


struct ImageSource_Previews: PreviewProvider {
    @State private static var image: UIImage?
    
    
    static var previews: some View {
        ImageSource(image: $image)
            .padding()
    }
}
