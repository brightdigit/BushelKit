//
// ImageHeader.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelAccessibility
  import BushelCore
  import SwiftUI

  internal struct ImageHeader: View {
    @Bindable private var image: LibraryImageObject
    private let metadataLabel: MetadataLabel
    private let beginSave: @MainActor @Sendable () -> Void

    var body: some View {
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
    }

    internal init(
      image: Bindable<LibraryImageObject>,
      metadataLabel: MetadataLabel,
      beginSave: @escaping @Sendable @MainActor () -> Void
    ) {
      self._image = image
      self.metadataLabel = metadataLabel
      self.beginSave = beginSave
    }
  }
#endif
