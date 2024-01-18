//
// ImageListItem.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelViewsCore
  import SwiftUI

  struct ImageListItem: View {
    let image: ConfigurationImage

    var body: some View {
      PreferredLayoutView { value in
        HStack {
          Image.resource(image.metadata.imageResourceName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: value.get())

          Text(image.metadata.longName).apply(\.size.height, with: value)
        }
      }
    }
  }
#endif

// #Preview {
//  List{
//    ImageListItem(image: .random())
//    ImageListItem(image: .random())
//  }
// }
