//
// ImageView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelAccessibility
  import BushelCore
  import BushelLibrary
  import BushelLocalization
  import SwiftUI

  internal struct ImageView: View, Sendable {
    @Environment(\.openWindow) private var openWindow
    @Bindable private var image: LibraryImageObject
    @State private var metadataLabel: MetadataLabel
    private let system: any LibrarySystem
    private var onSave: @Sendable () -> Void

    internal var body: some View {
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
              .accessibilityIdentifier(Library.nameField.identifier)

            Text(metadataLabel.operatingSystemLongName)
              .lineLimit(1)
              .font(.title)
              .accessibilityIdentifier(Library.operatingSystemName.identifier)
            Text(
              Int64(image.metadata.contentLength), format: .byteCount(style: .file)
            )
            .font(.title2)
            .accessibilityIdentifier(Library.contentLength.identifier)
            Text(image.metadata.lastModified, style: .date).font(.title2)
              .accessibilityIdentifier(Library.lastModified.identifier)
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
      .onDisappear(perform: self.beginSave)
    }

    internal init(
      image: Bindable<LibraryImageObject>,
      system: any LibrarySystem,
      onSave: @escaping @Sendable () -> Void
    ) {
      self._image = image
      self.system = system
      self.onSave = onSave

      let initialValue = system.label(fromMetadata: image.wrappedValue.metadata)
      self._metadataLabel = State(initialValue: initialValue)
    }

    private func save() async {
      guard !self.image.isDeleted else {
        return
      }
      await self.image.save()
      self.onSave()
    }

    internal func beginSave() {
      guard !self.image.isDeleted else {
        return
      }
      Task { @MainActor in
        await self.save()
      }
    }
  }
#endif
