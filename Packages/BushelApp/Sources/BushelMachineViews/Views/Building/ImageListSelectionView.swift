//
// ImageListSelectionView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  internal struct ImageListSelectionView: View {
    let images: [ConfigurationImage]?

    @State var promptForLibrary = false
    @State var currentSelectedImageID: UUID?
    @Binding var resultingSelectedImageID: UUID?
    @Environment(\.openWindow) var openWindow
    #if os(macOS)
      @Environment(\.newLibrary) var newLibrary
      @Environment(\.openLibrary) var openLibrary
    #endif
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
        Button(role: .cancel, .cancel) {
          dismiss()
        }.keyboardShortcut(.cancelAction)
        Button(.machineImagesChoose) {
          self.resultingSelectedImageID = currentSelectedImageID
          dismiss()
        }
        .disabled(self.currentSelectedImageID == nil)
        .keyboardShortcut(.defaultAction)
      })
      .onAppear {
        self.promptForLibrary = (images?.isEmpty == true)
      }
      .alert(
        Text(.machineImagesEmptyTitle),
        isPresented: self.$promptForLibrary,
        actions: {
          #if os(macOS)
            Button {
              self.newLibrary(with: openWindow)
              self.dismiss()
            } label: {
              Text(.machineImagesEmptyNewLibrary)
            }
            Button {
              self.openLibrary(with: openWindow)
              self.dismiss()
            } label: {
              Text(.machineImagesEmptyAddLibrary)
            }
          #endif
          Button(
            role: .cancel
          ) {
            self.dismiss()
          } label: {
            Text(.cancel)
          }
        }, message: {
          Text(.machineImagesEmptyMessage)
        }
      )
    }

    internal init(
      selectedImageID: Binding<UUID?>,

      images: [ConfigurationImage]? = nil
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
