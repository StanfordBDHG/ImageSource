//
// This source file is part of the ImageSource open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ImageSource
import SwiftUI


struct ContentView: View {
    @State var image: UIImage?
    
    
    var body: some View {
        NavigationStack {
            ImageSource(image: $image)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding()
                .navigationTitle("Image Source Example")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
