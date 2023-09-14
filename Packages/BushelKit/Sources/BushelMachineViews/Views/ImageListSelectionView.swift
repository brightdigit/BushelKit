//
// ImageListSelectionView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  struct ImageListSelectionView: View {
    let images: [ConfigurationObject.Image]?

    @State var currentSelectedImageID: UUID?
    @Binding var resultingSelectedImageID: UUID?
    @Environment(\.dismiss) var dismiss

    var listStyle: some ListStyle {
      #if os(macOS)
        .bordered
      #else
        .automatic
      #endif
    }

    var body: some View {
      VStack {
        if let images {
          List(selection: self.$currentSelectedImageID) {
            ForEach(images) { image in
              ImageListItem(image: image)
            }
          }.listStyle(listStyle).padding()
        } else {
          ProgressView()
        }
      }.toolbar(content: {
        Button("Cancel") {
          dismiss()
        }
        Button("Choose") {
          self.resultingSelectedImageID = currentSelectedImageID
          dismiss()
        }
      })
    }

    internal init(
      selectedImageID: Binding<UUID?>,

      images: [ConfigurationObject.Image]? = nil
    ) {
      self.images = images
      self._resultingSelectedImageID = selectedImageID

      self._currentSelectedImageID = .init(initialValue: selectedImageID.wrappedValue)
    }
  }
#endif
//
// #Preview {
//  ImageListSelectionView(images: .random(), selectedImageID: .init(get: {nil}, set: {_ in }))
// }
