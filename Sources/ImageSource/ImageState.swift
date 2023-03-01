//
// This source file is part of the ImageSource open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import UIKit


/// <#Description#>
public enum ImageState: Equatable {
    /// <#Description#>
    case empty
    /// <#Description#>
    case loading(Progress)
    /// <#Description#>
    case success(UIImage)
    /// <#Description#>
    case failure(ImageError)
    
    
    /// <#Description#>
    public var image: UIImage? {
        switch self {
        case .empty, .loading, .failure:
            return nil
        case let .success(image):
            return image
        }
    }
}
