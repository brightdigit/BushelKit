//
// LibraryList.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLibrary
  import SwiftUI

  internal struct LibraryList: View {
    typealias Item = LibraryListImageItem

    let accessibilityTitle: String
    let items: [LibraryImageFile]?
    @Binding var selectedItem: LibraryImageFile.ID?
    let librarySystemManager: any LibrarySystemManaging

    var body: some View {
      List(selection: self.$selectedItem) {
        if let items {
          ForEach(items) { libraryItem in
            Item(
              libraryItem: libraryItem,
              librarySystemManager: self.librarySystemManager,
              accessibilityTitle: self.accessibilityTitle
            )
          }
        }
      }
    }
  }

#endif
