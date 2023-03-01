//
// This source file is part of the ImageSource open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ImageSource
import XCTest


final class ImageSource: XCTestCase {
    func testImageSource() throws {
        let emptyImageState = ImageState.empty
        XCTAssertNil(emptyImageState.image)
        
        let successImageState = try ImageState.success(XCTUnwrap(UIImage(systemName: "hand.wave.fill")))
        XCTAssertNotNil(successImageState.image)
    }
}
