//
// LibraryList.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLibrary
  import SwiftUI

  struct LibraryList: View {
    let accessibilityTitle: String
    let items: [LibraryImageFile]?
    @Binding var selectedItem: LibraryImageFile.ID?
    let librarySystemManager: any LibrarySystemManaging

    var body: some View {
      List(selection: self.$selectedItem) {
        if let items {
          ForEach(items) { libraryItem in
            HStack {
              let label = librarySystemManager.labelForSystem(
                libraryItem.metadata.vmSystemID,
                metadata: libraryItem.metadata
              )

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
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier(
              "library:" + accessibilityTitle + ":images:" + libraryItem.id.uuidString
            )
            .accessibilityLabel(libraryItem.name)
          }
        }
      }
    }
  }

#endif
