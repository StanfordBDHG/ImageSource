// swift-tools-version:5.7

//
// This source file is part of the ImageSource open source project
// 
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
// 
// SPDX-License-Identifier: MIT
//

import PackageDescription


let package = Package(
    name: "ImageSource",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "ImageSource", targets: ["ImageSource"])
    ],
    targets: [
        .target(
            name: "ImageSource"
        ),
        .testTarget(
            name: "ImageSourceTests",
            dependencies: [
                .target(name: "ImageSource")
            ]
        )
    ]
)
