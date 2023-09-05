//
// LibraryList.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLibrary
  import SwiftUI

  struct LibraryList: View {
    let items: [LibraryImageFile]?
    @Binding var selectedItem: LibraryImageFile.ID?
    let librarySystemManager: any LibrarySystemManaging

    var body: some View {
      List(selection: self.$selectedItem) {
        if let items {
          ForEach(items) { libraryItem in
            HStack {
              let system = librarySystemManager.resolve(libraryItem.metadata.vmSystem)
              Image.resource(system.imageName(for: libraryItem.metadata))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80).mask {
                  Circle()
                }
                .overlay {
                  Circle().stroke()
                }
              VStack(alignment: .leading) {
                Text(libraryItem.name).font(.title)
                Text(system.operatingSystemLongName(for: libraryItem.metadata))
              }
            }
          }
        }
      }
    }
  }

#endif
