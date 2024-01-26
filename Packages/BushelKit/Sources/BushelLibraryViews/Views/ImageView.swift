//
// ImageView.swift
// Copyright (c) 2024 BrightDigit.
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
    var onSave: () -> Void

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
            TextField("Name", text: self.$image.name, onCommit: self.beginSave)
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
        .disabled(!self.image.metadata.isImageSupported)
        if !self.image.metadata.isImageSupported {
          Text(.libraryUnsupportedImage)
        }

        Spacer()
      }
      .padding(.vertical)
      .onChange(of: self.image.metadata) { _, newValue in
        self.metadataLabel = system.label(fromMetadata: newValue)
      }
      .onDisappear(perform: self.save)
    }

    internal init(
      image: Bindable<LibraryImageObject>,
      system: any LibrarySystem,
      onSave: @escaping () -> Void
    ) {
      self._image = image
      self.system = system
      self.onSave = onSave

      let initialValue = system.label(fromMetadata: image.wrappedValue.metadata)
      self._metadataLabel = State(initialValue: initialValue)
    }

    @MainActor
    func save() {
      guard !self.image.isDeleted else {
        return
      }
      self.image.save()
      self.onSave()
    }

    func beginSave() {
      Task { @MainActor in
        self.save()
      }
    }
  }
#endif
