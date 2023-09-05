//
// LibraryImageDetailView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLibrary
  import BushelLocalization
  import SwiftUI

  struct LibraryImageDetailView: View {
    internal init(image: Bindable<LibraryImageObject>, system: LibrarySystem) {
      self._image = image
      self.system = system
    }

    @Environment(\.openWindow) var openWindow
    @Bindable var image: LibraryImageObject
    let system: any LibrarySystem
    var body: some View {
      VStack {
        HStack(alignment: .top) {
          Image.resource(system.imageName(for: image.metadata))
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 80, height: 80).mask {
              Circle()
            }.overlay {
              Circle().stroke()
            }.padding(.horizontal)
          VStack(alignment: .leading) {
            TextField("Name", text: self.$image.name).font(.largeTitle)
            Text(system.operatingSystemLongName(for: image.metadata)).lineLimit(1).font(.title)
            Text(
              Int64(image.metadata.contentLength), format: .byteCount(style: .file)
            ).font(.title2)
            Text(image.metadata.lastModified, style: .date).font(.title2)
          }
        }
        Button("Build") {
          openWindow(value: MachineBuildRequest(restoreImage: .init(libraryID: .bookmarkID(image.library.entry.bookmarkDataID), imageID: image.entry.imageID)))
        }
        Spacer()
      }.padding(.vertical)
    }
  }
#endif
