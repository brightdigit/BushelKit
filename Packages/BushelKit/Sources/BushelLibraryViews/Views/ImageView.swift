//
// ImageView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLibrary
  import BushelLocalization
  import SwiftUI

  struct ImageView: View {
    @Environment(\.openWindow) var openWindow
    @Bindable var image: LibraryImageObject
    let system: any LibrarySystem
    @State var metadataLabel: MetadataLabel

    var body: some View {
      VStack {
        HStack(alignment: .top) {
          Image.resource(metadataLabel.imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 80, height: 80)
            .mask { Circle() }
            .overlay { Circle().stroke() }
            .padding(.horizontal)
            .accessibilityHidden(true)
          VStack(alignment: .leading) {
            TextField("Name", text: self.$image.name)
              .font(.largeTitle)
              .accessibilityIdentifier("name-field")
            Text(metadataLabel.operatingSystemLongName)
              .lineLimit(1)
              .font(.title)
              .accessibilityIdentifier("operating-system-name")
            Text(
              Int64(image.metadata.contentLength), format: .byteCount(style: .file)
            )
            .font(.title2)
            .accessibilityIdentifier("content-length")
            Text(image.metadata.lastModified, style: .date).font(.title2)
              .accessibilityIdentifier("last-modified")
          }
        }
        .accessibilityElement(children: .contain)
        Button("Build") {
          openWindow(
            value: MachineBuildRequest(
              restoreImage: .init(
                imageID: image.entry.imageID,
                libraryID: .bookmarkID(image.library.entry.bookmarkDataID)
              )
            )
          )
        }
        .accessibilityHint("Configure a new virtual machine")
        Spacer()
      }
      .padding(.vertical)
      .onChange(of: self.image.metadata) { _, newValue in
        self.metadataLabel = system.label(fromMetadata: newValue)
      }
      .onDisappear {
        self.image.save()
      }
    }

    internal init(image: Bindable<LibraryImageObject>, system: LibrarySystem) {
      self._image = image
      self.system = system

      let initialValue = system.label(fromMetadata: image.wrappedValue.metadata)
      self._metadataLabel = State(initialValue: initialValue)
    }
  }
#endif
