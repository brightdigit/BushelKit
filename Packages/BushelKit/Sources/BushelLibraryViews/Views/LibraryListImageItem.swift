//
// LibraryListImageItem.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelAccessibility
  import BushelCore
  import BushelLibrary
  import SwiftUI

  struct LibraryListImageItem: View {
    let libraryItem: LibraryImageFile
    let label: MetadataLabel
    let accessibilityTitle: String

    var body: some View {
      HStack {
        Image.resource(label.imageName)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 80)
          .mask {
            Circle()
          }
          .overlay {
            Circle().stroke()
          }
        VStack(alignment: .leading) {
          Text(libraryItem.name).font(.title)
          Text(label.operatingSystemLongName)
        }
      }
      .fixedSize()
      .accessibilityElement(children: .contain)
      .accessibilityIdentifier(
        Library.libraryImageItem(
          accessibilityTitle,
          libraryItem.id.uuidString
        ).identifier
      )
      .accessibilityLabel(libraryItem.name)
    }

    internal init(libraryItem: LibraryImageFile, label: MetadataLabel, accessibilityTitle: String) {
      self.libraryItem = libraryItem
      self.label = label
      self.accessibilityTitle = accessibilityTitle
    }

    internal init(
      libraryItem: LibraryImageFile,
      librarySystemManager: any LibrarySystemManaging,
      accessibilityTitle: String
    ) {
      let label = librarySystemManager.labelForSystem(
        libraryItem.metadata.vmSystemID,
        metadata: libraryItem.metadata
      )
      self.init(libraryItem: libraryItem, label: label, accessibilityTitle: accessibilityTitle)
    }
  }

#endif
